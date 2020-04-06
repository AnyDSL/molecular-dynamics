#include <cstdint>
#include <iostream>
#include <fstream>
#include <functional>
#include <string>
#include <utility>
#include <getopt.h>
//---
#include "anydsl_includes.h"
#include "initialize.h"
#include "time.h"
#include "vtk.h"
#ifdef LIKWID_PERFMON
#include <likwid.h>
#else
#define LIKWID_MARKER_INIT
#define LIKWID_MARKER_THREADINIT
#define LIKWID_MARKER_SWITCH
#define LIKWID_MARKER_REGISTER(regionTag)
#define LIKWID_MARKER_START(regionTag)
#define LIKWID_MARKER_STOP(regionTag)
#define LIKWID_MARKER_CLOSE
#define LIKWID_MARKER_GET(regionTag, nevents, events, time, count)
#endif

#define time_diff(begin, end)   static_cast<double>(calculate_time_difference<chrono::nanoseconds>(begin, end))

#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
#include <x86intrin.h>
#endif

using namespace std;

void print_usage(char *name) {
    cout << "Usage: " << name << " [OPTION]..." << endl;
    cout << "A fast, scalable and portable application for pair-wise interactions implemented in AnyDSL." << endl << endl;
    cout << "Mandatory arguments to long options are also mandatory for short options." << endl;
    cout << "\t-x, --nx=SIZE             number of unit cells in x dimension (default 32)." << endl;
    cout << "\t-y, --ny=SIZE             number of unit cells in y dimension (default 32)." << endl;
    cout << "\t-z, --nz=SIZE             number of unit cells in z dimension (default 32)." << endl;
    cout << "\t-s, --timesteps=NUMBER    number of timesteps in the simulation (default 100)." << endl;
    cout << "\t-r, --runs=NUMBER         number of test runs (default 1)." << endl;
    cout << "\t-t, --threads=NUMBER      number of threads to run (default 1)." << endl;
    cout << "\t-a, --algorithm=STRING    load balancing algorithm to use." << endl;
    cout << "\t-v, --vtk=DIRECTORY       VTK output directory (for MPI simulations, the rank number is concatenated" << endl;
    cout << "\t                          at the end of this name, i.e. output[0-3] when using --vtk=output and 4 ranks)." << endl;
    cout << "\t                          VTK directories are NOT automatically created and therefore must exist." << endl;
    cout << "\t    --reneigh=NUMBER      timesteps to simulate before reneighboring (default 20)." << endl;
    cout << "\t    --rebalance=NUMBER    timesteps to simulate before load balancing (default 100)." << endl;
    cout << "\t    --dt=REAL             timestep size (default 0.001)." << endl;
    cout << "\t    --cutoff=REAL         cutoff radius (default 2.5)." << endl;
    cout << "\t    --verlet=REAL         verlet buffer (default 0.3)." << endl;
    cout << "\t    --epsilon=REAL        epsilon value for Lennard-Jones equation (default 1.0)." << endl;
    cout << "\t    --sigma=REAL          sigma value for Lennard-Jones equation (default 1.0)." << endl;
    cout << "\t    --potmin=REAL         potential minimum (default 1.6796)." << endl;
    cout << "\t-h, --help                display this help message." << endl;
}

pair<double,double> get_time_statistics(vector<double> time) {
    double const mean = compute_mean(time);
    double const stdev = compute_standard_deviation(time, mean);
    return make_pair(mean, stdev);
}

void vtk_write_local_data(string filename) {
    const int size = md_get_number_of_particles();
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

void vtk_write_ghost_data(string filename) {
    const int size = md_get_number_of_ghost_particles();
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_ghost_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

void vtk_write_aabb_data(string filename) {
    const int size = 8;
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_aabb_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

#ifdef USE_WALBERLA_LOAD_BALANCING

using namespace walberla;

map<uint_t, vector<pair<const BlockID&, math::AABB>>> *gNeighborhood;

auto get_neighborhood_from_block_forest(shared_ptr<BlockForest> forest) {
    map<uint_t, vector<pair<const BlockID&, math::AABB>>> neighborhood;
    auto me = mpi::MPIManager::instance()->rank();

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);

        for(uint neigh = 0; neigh < block->getNeighborhoodSize(); ++neigh) {
            auto neighbor_rank = int_c(block->getNeighborProcess(neigh));

            if(neighbor_rank != me) {
                const BlockID& neighbor_block = block->getNeighborId(neigh);
                math::AABB neighbor_aabb = block->getNeighborAABB(neigh);
                auto begin = neighborhood[neighbor_rank].begin();
                auto end = neighborhood[neighbor_rank].end();

                if(find_if(begin, end, [neighbor_block](const auto &nbh) { return nbh.first == neighbor_block; }) == end) {
                    neighborhood[neighbor_rank].push_back(make_pair(neighbor_block, neighbor_aabb));
                }
            }
        }
    }

    return neighborhood;
}

void updateWeights(shared_ptr<BlockForest> forest, blockforest::InfoCollection& info) {
    mpi::BufferSystem bs(mpi::MPIManager::instance()->comm(), 756);

    info.clear();

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto aabb = block->getAABB();
        auto block_info = info[block->getId()];

        md_compute_boundary_weights(
            aabb.xMin(), aabb.xMax(), aabb.yMin(), aabb.yMax(), aabb.zMin(), aabb.zMax(),
            &(block_info.computationalWeight), &(block_info.communicationWeight));

        for(uint_t branch = 0; branch < 8; ++branch) {
            const auto child_id = BlockID(block->getId(), branch);
            const auto child_aabb = forest->getAABBFromBlockId(child_id);
            auto child_info = info[child_id];

            md_compute_boundary_weights(
                child_aabb.xMin(), child_aabb.xMax(), child_aabb.yMin(), child_aabb.yMax(), child_aabb.zMin(), child_aabb.zMax(),
                &(child_info.computationalWeight), &(child_info.communicationWeight));
        }
    }

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto block_info = info[block->getId()];

        for(uint_t neigh = 0; neigh < block->getNeighborhoodSize(); ++neigh) {
            bs.sendBuffer(block->getNeighborProcess(neigh)) <<
                blockforest::InfoCollection::value_type(block->getId(), block_info);
        }

        for(uint_t branch = 0; branch < 8; ++branch) {
            const auto child_id = BlockID(block->getId(), branch);
            auto child_info = info[child_id];

            for(uint_t neigh = 0; neigh < block->getNeighborhoodSize(); ++neigh) {
                bs.sendBuffer(block->getNeighborProcess(neigh)) <<
                    blockforest::InfoCollection::value_type(child_id, child_info);
            }
        }
    }

    bs.setReceiverInfoFromSendBufferState(false, true);
    bs.sendAll();

    for(auto recv = bs.begin(); recv != bs.end(); ++recv) {
        while(!recv.buffer().isEmpty()) {
            blockforest::InfoCollectionPair val;
            recv.buffer() >> val;
            info.insert(val);
        }
    }
}

Vector3<uint_t> getBlockConfig(uint_t num_processes, uint_t nx, uint_t ny, uint_t nz) {
    const uint_t bx_factor = 2;
    const uint_t by_factor = 2;
    const uint_t bz_factor = 2;
    const uint_t ax = nx * ny;
    const uint_t ay = nx * nz;
    const uint_t az = ny * nz;

    uint_t bestsurf = 2 * (ax + ay + az);
    uint_t x = 1;
    uint_t y = 1;
    uint_t z = 1;

    for(uint_t i = 1; i < num_processes; ++i) {
        if(num_processes % i == 0) {
            const uint_t rem_yz = num_processes / i;

            for(uint_t j = 1; j < rem_yz; ++j) {
                if(rem_yz % j == 0) {
                    const uint_t k = rem_yz / j;
                    const uint_t surf = (ax / i / j) + (ay / i / k) + (az / j / k);

                    if(surf < bestsurf) {
                        x = i, y = j, z = k;
                        bestsurf = surf;
                    }
                }
            }
        }
    }

    return Vector3<uint_t>(x * bx_factor, y * by_factor, z * bz_factor);
}


inline double sqDistanceLineToPoint(const double& pt, const double& min, const double& max) {
   return (pt < min) ? (min - pt) * (min - pt) :
          (pt > max) ? (pt - max) * (pt - max) : 0.0;
}

inline double sqDistancePointToAABB(double x, double y, double z, const math::AABB& aabb) {
   return sqDistanceLineToPoint(x, aabb.xMin(), aabb.xMax()) +
          sqDistanceLineToPoint(y, aabb.yMin(), aabb.yMax()) +
          sqDistanceLineToPoint(z, aabb.zMin(), aabb.zMax());
}

extern "C" {
    bool use_walberla() { return true; }
    unsigned long int get_number_of_neighbor_ranks() { return gNeighborhood->size(); }

    int get_neighborhood_rank(int index) {
        if(index >= (int) gNeighborhood->size()) {
            return -1;
        }

        auto iter = gNeighborhood->begin();
        advance(iter, index);
        return (int) iter->first;
    }

    bool in_rank_border(int rank, double x, double y, double z, double cutoff_radius) {
        auto rank_neighborhood = (*gNeighborhood)[rank];

        for(auto& neighbor_info: rank_neighborhood) {
            auto aabb = neighbor_info.second;
            auto distance = sqDistancePointToAABB(x, y, z, aabb);

            if(distance < cutoff_radius * cutoff_radius) {
                return true;
            }
        }

        return false;
    }

    bool in_rank_subdomain(int rank, double x, double y, double z) {
        auto rank_neighborhood = (*gNeighborhood)[rank];

        for(auto& neighbor_info: rank_neighborhood) {
            auto aabb = neighbor_info.second;

            if(aabb.contains(x, y, z)) {
                return true;
            }
        }

        return false;
    }
}

#else

extern "C" {
    bool use_walberla() { return false; }
    unsigned long int get_number_of_neighbor_ranks() { return 0; }
    int get_neighborhood_rank(__attribute__((unused)) int index) { return 0; }

    bool in_rank_border(
        __attribute__((unused)) int rank,
        __attribute__((unused)) double x,
        __attribute__((unused)) double y,
        __attribute__((unused)) double z,
        __attribute__((unused)) double cutoff_radius) {
        return false;
    }

    bool in_rank_subdomain(
        __attribute__((unused)) int rank,
        __attribute__((unused)) double x,
        __attribute__((unused)) double y,
        __attribute__((unused)) double z) {
        return false;
    }
}

#endif

int main(int argc, char **argv) {
    using namespace placeholders;

    // Force flush to zero mode for denormals
#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
    _mm_setcsr(_mm_getcsr() | (_MM_FLUSH_ZERO_ON | _MM_DENORMALS_ZERO_ON));
#endif

    int gridsize[3] = {32, 32, 32};
    int steps = 100;
    int runs = 1;
    int nthreads = 1;
    int reneigh_every = 20;
    int rebalance_every = 100;
    double dt = 1e-3;
    double cutoff_radius = 2.5;
    double verlet_buffer = 0.3;
    double epsilon = 1.0;
    double sigma = 1.0;
    //double potential_minimum = pow(2.0, 1.0/6.0) * sigma;
    double potential_minimum = 1.6796;
    string algorithm;
    string vtk_directory;

    int opt = 0;
    struct option long_opts[] = {
        {"nx",        required_argument,    nullptr,    'x'},
        {"ny",        required_argument,    nullptr,    'y'},
        {"nz",        required_argument,    nullptr,    'z'},
        {"timesteps", required_argument,    nullptr,    's'},
        {"runs",      required_argument,    nullptr,    'r'},
        {"threads",   required_argument,    nullptr,    't'},
        {"algorithm", required_argument,    nullptr,    'a'},
        {"vtk",       required_argument,    nullptr,    'v'},
        {"help",      no_argument,          nullptr,    'h'},
        {"reneigh",   required_argument,    nullptr,    0},
        {"rebalance", required_argument,    nullptr,    1},
        {"dt",        required_argument,    nullptr,    2},
        {"cutoff",    required_argument,    nullptr,    3},
        {"verlet",    required_argument,    nullptr,    4},
        {"epsilon",   required_argument,    nullptr,    5},
        {"sigma",     required_argument,    nullptr,    6},
        {"potmin",    required_argument,    nullptr,    7}
    };

    while((opt = getopt_long(argc, argv, "x:y:z:s:r:t:a:v:h", long_opts, nullptr)) != -1) {
        switch(opt) {
            case 0:
                reneigh_every = atoi(optarg);
                break;

            case 1:
                rebalance_every = atoi(optarg);
                break;

            case 2:
                dt = atof(optarg);
                break;

            case 3:
                cutoff_radius = atof(optarg);
                break;

            case 4:
                verlet_buffer = atof(optarg);
                break;

            case 5:
                epsilon = atof(optarg);
                break;

            case 6:
                sigma = atof(optarg);
                break;

            case 7:
                potential_minimum = atof(optarg);
                break;

            case 'x':
                gridsize[0] = atoi(optarg);
                break;

            case 'y':
                gridsize[1] = atoi(optarg);
                break;

            case 'z':
                gridsize[2] = atoi(optarg);
                break;

            case 's':
                steps = atoi(optarg);
                break;

            case 'r':
                runs = atoi(optarg);
                break;

            case 't':
                nthreads = atoi(optarg);
                break;

            case 'a':
                algorithm = string(optarg);
                break;

            case 'v':
                vtk_directory = string(optarg);
                break;

            case 'h':
            case '?':
            default:
                print_usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    if(rebalance_every % reneigh_every != 0) {
        cerr << "Error: rebalancing timesteps must be multiple of reneighboring timesteps!" << endl;
        return EXIT_FAILURE;
    }

    ::AABB aabb;
    double spacing[3];
    bool vtk = !vtk_directory.empty();
    bool use_load_balancing = false;

    #ifdef BODY_COLLISION_TEST

    ::AABB aabb1, aabb2;

    for(int i = 0; i < 3; ++i) {
        aabb1.min[i] = 50;
        aabb1.max[i] = 50 + gridsize[i] * potential_minimum;
    }

    for(int i = 0; i < 3; ++i) {
        aabb2.min[i] = 50;
        aabb2.max[i] = 50 + gridsize[i] * potential_minimum;
    }

    double shift = potential_minimum + (aabb2.max[1] - aabb2.min[1]);
    aabb2.min[1] -= shift;
    aabb2.max[1] -= shift;

    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = min(aabb1.min[i], aabb2.min[i]) - 20;
        aabb.max[i] = max(aabb1.max[i], aabb2.max[i]) + 20;
        spacing[i] = potential_minimum;
    }

    #else

    double const spacing_div_factor[3] = {2.0, 2.0, 2.0};

    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = 0;
        aabb.max[i] = gridsize[i] * potential_minimum;
        spacing[i] = potential_minimum / spacing_div_factor[i];
    }

    #endif

    vector<double> grid_initialization_time(runs, 0);
    vector<double> copy_data_to_accelerator_time(runs, 0);
    vector<double> copy_data_from_accelerator_time(runs, 0);
    vector<double> integration_time(runs, 0);
    vector<double> redistribution_time(runs, 0);
    vector<double> cluster_initialization_time(runs, 0);
    vector<double> neighborlist_creation_time(runs, 0);
    vector<double> force_computation_time(runs, 0);
    vector<double> deallocation_time(runs, 0);
    vector<double> synchronization_time(runs, 0);
    vector<double> exchange_time(runs, 0);
    vector<double> pbc_time(runs, 0);
    vector<double> barrier_time(runs, 0);
    double const factor = 1e-6;

    md_set_thread_count(nthreads);

    #ifdef USE_WALBERLA_LOAD_BALANCING

    auto mpiManager = mpi::MPIManager::instance();
    mpiManager->initializeMPI(&argc, &argv);
    mpiManager->useWorldComm();

    math::AABB domain(
        real_t(aabb.min[0]), real_t(aabb.min[1]), real_t(aabb.min[2]),
        real_t(aabb.max[0]), real_t(aabb.max[1]), real_t(aabb.max[2]));

    auto forest = blockforest::createBlockForest(
        domain, getBlockConfig(mpiManager->numProcesses(), gridsize[0], gridsize[1], gridsize[2]),
        Vector3<bool>(true, true, true), mpiManager->numProcesses(), uint_t(0));

    auto rank_aabb = get_rank_aabb_from_block_forest(forest);
    auto is_within_domain = bind(is_within_block_forest, _1, _2, _3, forest);
    auto neighborhood = get_neighborhood_from_block_forest(forest);
    auto info = make_shared<blockforest::InfoCollection>();

    // Properties
    map<string, int64_t> integerProperties;
    map<string, double> realProperties;
    map<string, string> stringProperties;

    // Load balancing parameters
    real_t baseWeight = 10.0;
    real_t metisipc2redist = 1.0;
    size_t regridMin = 0;
    size_t regridMax = 10;
    int maxBlocksPerProcess = 100;
    string metisAlgorithm = "none";
    string metisWeightsToUse = "none";
    string metisEdgeSource = "none";

    forest->recalculateBlockLevelsInRefresh(true);
    forest->alwaysRebalanceInRefresh(true);
    forest->reevaluateMinTargetLevelsAfterForcedRefinement(true);
    forest->allowRefreshChangingDepth(true);

    forest->allowMultipleRefreshCycles(true);
    forest->checkForEarlyOutInRefresh(false);
    forest->checkForLateOutInRefresh(false);
    forest->setRefreshMinTargetLevelDeterminationFunction(pe::amr::MinMaxLevelDetermination(info, regridMin, regridMax));

    for_each(algorithm.begin(), algorithm.end(), [](char& c) { c = (char) ::tolower(c); });

    if(algorithm == "morton") {
        forest->setRefreshPhantomBlockDataAssignmentFunction(pe::amr::WeightAssignmentFunctor(info, baseWeight));
        forest->setRefreshPhantomBlockDataPackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());
        forest->setRefreshPhantomBlockDataUnpackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());

        auto prepFunc = blockforest::DynamicCurveBalance<pe::amr::WeightAssignmentFunctor::PhantomBlockWeight>(false, true, false);

        prepFunc.setMaxBlocksPerProcess(maxBlocksPerProcess);
        forest->setRefreshPhantomBlockMigrationPreparationFunction(prepFunc);
        use_load_balancing = true;

    } else if(algorithm == "hilbert") {
        forest->setRefreshPhantomBlockDataAssignmentFunction(pe::amr::WeightAssignmentFunctor(info, baseWeight));
        forest->setRefreshPhantomBlockDataPackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());
        forest->setRefreshPhantomBlockDataUnpackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());

        auto prepFunc = blockforest::DynamicCurveBalance<pe::amr::WeightAssignmentFunctor::PhantomBlockWeight>(true, true, false);

        prepFunc.setMaxBlocksPerProcess(maxBlocksPerProcess);
        forest->setRefreshPhantomBlockMigrationPreparationFunction(prepFunc);
        use_load_balancing = true;

    } else if(algorithm == "metis") {
        forest->setRefreshPhantomBlockDataAssignmentFunction(pe::amr::MetisAssignmentFunctor(info, baseWeight));
        forest->setRefreshPhantomBlockDataPackFunction(pe::amr::MetisAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());
        forest->setRefreshPhantomBlockDataUnpackFunction(pe::amr::MetisAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());

        auto alg = blockforest::DynamicParMetis::stringToAlgorithm(metisAlgorithm);
        auto vWeight = blockforest::DynamicParMetis::stringToWeightsToUse(metisWeightsToUse);
        auto eWeight = blockforest::DynamicParMetis::stringToEdgeSource(metisEdgeSource);
        auto prepFunc = blockforest::DynamicParMetis(alg, vWeight, eWeight);

        prepFunc.setipc2redist(metisipc2redist);
        forest->setRefreshPhantomBlockMigrationPreparationFunction(prepFunc);
        use_load_balancing = true;

    } else if(algorithm == "diffusive") {
        forest->setRefreshPhantomBlockDataAssignmentFunction(pe::amr::WeightAssignmentFunctor(info, baseWeight));
        forest->setRefreshPhantomBlockDataPackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());
        forest->setRefreshPhantomBlockDataUnpackFunction(pe::amr::WeightAssignmentFunctor::PhantomBlockWeightPackUnpackFunctor());

        auto prepFunc = blockforest::DynamicDiffusionBalance<pe::amr::WeightAssignmentFunctor::PhantomBlockWeight>(1, 1, false);

        forest->setRefreshPhantomBlockMigrationPreparationFunction(prepFunc);
        use_load_balancing = true;
    }

    forest->addBlockData(make_shared<MDDataHandling>(), "Interface");
    gNeighborhood = &neighborhood;

    #else

    md_mpi_initialize();

    auto rank_aabb = get_rank_aabb(aabb);
    auto is_within_domain = bind(is_within_aabb, _1, _2, _3, rank_aabb);

    #endif

    if(md_get_world_rank() == 0) {
        cout << "Simulation settings:" << endl;
        cout << "- Unit cells (x, y, z): " << gridsize[0] << ", " << gridsize[1] << ", " << gridsize[2] << endl;
        cout << "- Number of timesteps: " << steps << endl;
        cout << "- Number of runs: " << runs << endl;
        cout << "- Number of threads: " << nthreads << endl;
        cout << "- Reneighboring timesteps: " << reneigh_every << endl;
        cout << "- Rebalancing timesteps: " << rebalance_every << endl;
        cout << "- Timestep size: " << dt << endl;
        cout << "- Cutoff radius: " << cutoff_radius << endl;
        cout << "- Verlet buffer: " << verlet_buffer << endl;
        cout << "- Epsilon: " << epsilon << endl;
        cout << "- Sigma: " << sigma << endl;
        cout << "- Potential minimum: " << potential_minimum << endl;
        cout << "- Dynamic load balancing algorithm: " << ((use_load_balancing) ? algorithm : "none") << endl;
        cout << "- VTK output directory: " << ((vtk) ? vtk_directory : "none") << endl << endl;
    }

    if(vtk) {
        vtk_directory += to_string(md_get_world_rank()) + "/";
    }

    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    for(int i = 0; i < runs; ++i) {
        auto begin = measure_time();
        #ifdef BODY_COLLISION_TEST
        init_body_collision(aabb, aabb1, aabb2, rank_aabb, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
        #else
        init_rectangular_grid(aabb, rank_aabb, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
        #endif
        auto end = measure_time();
        grid_initialization_time[i] = time_diff(begin, end) * factor;

        md_exchange_ghost_layer();
        md_distribute_particles();
        md_barrier();

        begin = measure_time();
        md_copy_data_to_accelerator();
        end = measure_time();
        copy_data_to_accelerator_time[i] = time_diff(begin, end) * factor;

        begin = measure_time();
        md_assemble_neighborlists(cutoff_radius + verlet_buffer);
        end = measure_time();
        neighborlist_creation_time[i] += time_diff(begin, end) * factor;

        if(vtk && i == 0) {
            vtk_write_local_data(vtk_directory + "particles_0.vtk");
            vtk_write_ghost_data(vtk_directory + "ghost_0.vtk");
            vtk_write_aabb_data(vtk_directory + "aabb_0.vtk");
        }

        for(int j = 0; j < steps; ++j) {
            LIKWID_MARKER_START("Force");
            begin = measure_time();
            md_compute_forces(cutoff_radius, epsilon, sigma);
            end = measure_time();
            LIKWID_MARKER_STOP("Force");
            force_computation_time[i] += time_diff(begin, end) * factor;

            begin = measure_time();
            md_integration(dt);
            end = measure_time();
            integration_time[i] += time_diff(begin, end) * factor;

            begin = measure_time();
            //md_barrier();
            end = measure_time();
            barrier_time[i] += time_diff(begin, end) * factor;

            if(j > 0 && j % reneigh_every == 0) {
                begin = measure_time();
                md_pbc();
                end = measure_time();
                pbc_time[i] += time_diff(begin, end) * factor;

                begin = measure_time();
                md_copy_data_from_accelerator();
                end = measure_time();
                copy_data_from_accelerator_time[i] += time_diff(begin, end) * factor;

                #ifdef USE_WALBERLA_LOAD_BALANCING

                if(use_load_balancing && j % rebalance_every == 0) {
                    updateWeights(forest, *info);
                    forest->refresh();

                    auto new_aabb = get_rank_aabb_from_block_forest(forest);
                    neighborhood = get_neighborhood_from_block_forest(forest);
                    md_rescale_grid(new_aabb.min, new_aabb.max);
                    gNeighborhood = &neighborhood;
                }

                #endif

                begin = measure_time();
                md_exchange_ghost_layer();
                end = measure_time();
                exchange_time[i] += time_diff(begin, end) * factor;

                begin = measure_time();
                md_distribute_particles();
                end = measure_time();
                redistribution_time[i] += time_diff(begin, end) * factor;

                begin = measure_time();
                md_copy_data_to_accelerator();
                end = measure_time();
                copy_data_to_accelerator_time[i] += time_diff(begin, end) * factor;

                begin = measure_time();
                md_assemble_neighborlists(cutoff_radius + verlet_buffer);
                end = measure_time();
                neighborlist_creation_time[i] += time_diff(begin, end) * factor;
            } else {
                begin = measure_time();
                md_synchronize_ghost_layer();
                end = measure_time();
                synchronization_time[i] += time_diff(begin, end) * factor;
            }

            if(vtk && i == 0) {
                vtk_write_local_data(vtk_directory + "particles_" + to_string(j + 1) + ".vtk");
                vtk_write_ghost_data(vtk_directory + "ghost_" + to_string(j + 1) + ".vtk");
                vtk_write_aabb_data(vtk_directory + "aabb_" + to_string(j + 1) + ".vtk");
            }
        }

        begin = measure_time();
        md_copy_data_from_accelerator();
        end = measure_time();
        copy_data_from_accelerator_time[i] += time_diff(begin, end) * factor;

        md_report_iterations();
        md_report_particles();

        begin = measure_time();
        md_deallocate_grid();
        end = measure_time();

        deallocation_time[i] = time_diff(begin, end) * factor;
    }

    LIKWID_MARKER_CLOSE;

    vector<pair<double, double>> time_results(13);

    time_results[0] = get_time_statistics(grid_initialization_time);
    time_results[1] = get_time_statistics(integration_time);
    time_results[2] = get_time_statistics(redistribution_time);
    time_results[3] = get_time_statistics(cluster_initialization_time);
    time_results[4] = get_time_statistics(neighborlist_creation_time);
    time_results[5] = get_time_statistics(force_computation_time);
    time_results[6] = get_time_statistics(deallocation_time);
    time_results[7] = get_time_statistics(copy_data_to_accelerator_time);
    time_results[8] = get_time_statistics(copy_data_from_accelerator_time);
    time_results[9] = get_time_statistics(synchronization_time);
    time_results[10] = get_time_statistics(exchange_time);
    time_results[11] = get_time_statistics(pbc_time);
    time_results[12] = get_time_statistics(barrier_time);

    double mean_sum = 0, stdev_sum = 0;

    for(size_t i = 1; i < time_results.size() - 1; ++i) {
        mean_sum += time_results[i].first;
        stdev_sum += time_results[i].second;
    }

    md_report_time(
        mean_sum,
        time_results[1].first + time_results[5].first + time_results[11].first,
        time_results[3].first + time_results[4].first,
        time_results[9].first,
        time_results[10].first,
        time_results[2].first + time_results[6].first + time_results[7].first + time_results[8].first,
        time_results[11].first
    );

    #ifndef USE_WALBERLA_LOAD_BALANCING
    md_mpi_finalize();
    #endif

    return EXIT_SUCCESS;
}
