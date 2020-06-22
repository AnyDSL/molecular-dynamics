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
#include "vtk.h"
//---
#include "MultiTimer.h"
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

#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
#include <x86intrin.h>
#endif

using namespace std;

void print_usage(char *name) {
    cout << "Usage: " << name << " [OPTION]..." << endl;
    cout << "A fast, scalable and portable application for pair-wise interactions implemented in AnyDSL." << endl << endl;
    cout << "Mandatory arguments to long options are also mandatory for short options." << endl;
    cout << "\t-f, --force_field=STRING  force field to use (options are lj and dem, default is lj)." << endl;
    cout << "\t-b, --benchmark=STRING    benchmark to use (options are default, half, body_collision and granular_gas)." << endl;
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
    cout << "\t    --dt=REAL             timestep size (default 0.005)." << endl;
    cout << "\t    --temp=REAL           initial temperature (default 1.44)." << endl;
    cout << "\t    --cutoff=REAL         cutoff radius (default 2.5)." << endl;
    cout << "\t    --verlet=REAL         verlet buffer (default 0.3)." << endl;
    cout << "\t    --epsilon=REAL        epsilon value for Lennard-Jones force-field(default 1.0)." << endl;
    cout << "\t    --sigma=REAL          sigma value for Lennard-Jones force-field (default 1.0)." << endl;
    cout << "\t    --damping_n=REAL      Normal damping for DEM force-field (default 0.0)." << endl;
    cout << "\t    --damping_t=REAL      Tangential damping for DEM force-field (default 0.0)." << endl;
    cout << "\t    --stiffness=REAL      Stiffness for DEM force-field (default 0.0)." << endl;
    cout << "\t    --friction=REAL       Friction for DEM force-field (default 0.0)." << endl;
    cout << "\t    --potmin=REAL         potential minimum (default 1.6796)." << endl;
    cout << "\t    --half_nb             compute with half neighbor list." << endl;
    cout << "\t    --prebalance          perform static load balancing before execution." << endl;
    cout << "\t-h, --help                display this help message." << endl;
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

void vtk_write_forest_data(shared_ptr<BlockForest> forest, string filename) {
    vector<double> masses;
    vector<Vector3D> positions;
    vector<Vector3D> velocities;
    vector<Vector3D> forces;
    Vector3D pos_vec, zero_vec;

    zero_vec.x = 0.0;
    zero_vec.y = 0.0;
    zero_vec.z = 0.0;

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto aabb = block->getAABB();

        for(int i = 0; i < 2; ++i) {
            for(int j = 0; j < 2; ++j) {
                for(int k = 0; k < 2; ++k) {
                    pos_vec.x = (i == 0) ? aabb.xMin() : aabb.xMax();
                    pos_vec.y = (j == 0) ? aabb.yMin() : aabb.yMax();
                    pos_vec.z = (k == 0) ? aabb.zMin() : aabb.zMax();

                    masses.push_back(0.0);
                    positions.push_back(pos_vec);
                    velocities.push_back(zero_vec);
                    forces.push_back(zero_vec);
                }
            }
        }
    }

    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

void updateNeighborhood(shared_ptr<BlockForest> forest, blockforest::InfoCollection& info, bool load_balance) {
    map<uint_t, vector<math::AABB>> neighborhood;
    map<uint_t, vector<BlockID>> blocks_pushed;
    vector<int> ranks;
    vector<int> naabbs;
    vector<double> aabbs;
    auto me = mpi::MPIManager::instance()->rank();
    int total_aabbs = 0;

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto& block_info = info[block->getId()];

        if(!load_balance || block_info.computationalWeight > 0) {
            for(uint neigh = 0; neigh < block->getNeighborhoodSize(); ++neigh) {
                auto neighbor_rank = int_c(block->getNeighborProcess(neigh));

                if(neighbor_rank != me) {
                    const BlockID& neighbor_block = block->getNeighborId(neigh);
                    math::AABB neighbor_aabb = block->getNeighborAABB(neigh);
                    auto neighbor_info = info[neighbor_block];
                    auto begin = blocks_pushed[neighbor_rank].begin();
                    auto end = blocks_pushed[neighbor_rank].end();

                    if( (!load_balance || neighbor_info.computationalWeight > 0) &&
                        find_if(begin, end, [neighbor_block](const auto &nbh) { return nbh == neighbor_block; }) == end) {
                        neighborhood[neighbor_rank].push_back(neighbor_aabb);
                        blocks_pushed[neighbor_rank].push_back(neighbor_block);
                    }
                }
            }
        }
    }

    for(auto& nbh: neighborhood) {
        auto rank = nbh.first;
        auto aabb_list = nbh.second;
        ranks.push_back((int) rank);
        naabbs.push_back((int) aabb_list.size());

        for(auto &aabb: aabb_list) {
            aabbs.push_back(aabb.xMin());
            aabbs.push_back(aabb.xMax());
            aabbs.push_back(aabb.yMin());
            aabbs.push_back(aabb.yMax());
            aabbs.push_back(aabb.zMin());
            aabbs.push_back(aabb.zMax());
            total_aabbs++;
        }
    }

    md_update_neighborhood((int) ranks.size(), total_aabbs, ranks.data(), naabbs.data(), aabbs.data());
}

void updateWeights(shared_ptr<BlockForest> forest, blockforest::InfoCollection& info) {
    mpi::BufferSystem bs(mpi::MPIManager::instance()->comm(), 756);

    info.clear();

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto aabb = block->getAABB();
        auto& block_info = info[block->getId()];

        md_compute_boundary_weights(
            aabb.xMin(), aabb.xMax(), aabb.yMin(), aabb.yMax(), aabb.zMin(), aabb.zMax(),
            &(block_info.computationalWeight), &(block_info.communicationWeight));

        for(uint_t branch = 0; branch < 8; ++branch) {
            const auto child_id = BlockID(block->getId(), branch);
            const auto child_aabb = forest->getAABBFromBlockId(child_id);
            auto& child_info = info[child_id];

            md_compute_boundary_weights(
                child_aabb.xMin(), child_aabb.xMax(), child_aabb.yMin(), child_aabb.yMax(), child_aabb.zMin(), child_aabb.zMax(),
                &(child_info.computationalWeight), &(child_info.communicationWeight));
        }
    }

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        auto& block_info = info[block->getId()];

        for(uint_t neigh = 0; neigh < block->getNeighborhoodSize(); ++neigh) {
            bs.sendBuffer(block->getNeighborProcess(neigh)) <<
                blockforest::InfoCollection::value_type(block->getId(), block_info);
        }

        for(uint_t branch = 0; branch < 8; ++branch) {
            const auto child_id = BlockID(block->getId(), branch);
            auto& child_info = info[child_id];

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
    const uint_t bx_factor = 1;
    const uint_t by_factor = 1;
    const uint_t bz_factor = 1;
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

uint_t getInitialRefinementLevel(uint_t num_processes) {
    uint_t splitFactor = 8;
    uint_t blocks = splitFactor;
    uint_t refinementLevel = 1;

    while(blocks < num_processes) {
        refinementLevel++;
        blocks *= splitFactor;
    }

    return refinementLevel;
}

#endif

int main(int argc, char **argv) {
    using namespace placeholders;

    // Force flush to zero mode for denormals
    #if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
    _mm_setcsr(_mm_getcsr() | (_MM_FLUSH_ZERO_ON | _MM_DENORMALS_ZERO_ON));
    #endif

    string benchmark = "default";
    string force_field = "lj";
    string algorithm;
    string vtk_directory;
    int gridsize[3] = {32, 32, 32};
    int steps = 100;
    int runs = 1;
    int nthreads = 1;
    int reneigh_every = 20;
    int rebalance_every = 100;
    double dt = 0.005;
    double cutoff_radius = 2.5;
    double verlet_buffer = 0.3;
    double epsilon = 1.0;
    double sigma = 1.0;
    double potential_minimum = 1.6796;
    double init_temp = 1.44;
    double damping_n = 0.0;
    double damping_t = 0.0;
    double stiffness = 0.0;
    double friction = 0.0;
    bool half = false;
    bool half_nb = false;
    bool use_walberla = false;
    bool prebalance = false;

    int opt = 0;
    struct option long_opts[] = {
        {"force_field", required_argument,    nullptr,    'f'},
        {"benchmark",   required_argument,    nullptr,    'b'},
        {"nx",          required_argument,    nullptr,    'x'},
        {"ny",          required_argument,    nullptr,    'y'},
        {"nz",          required_argument,    nullptr,    'z'},
        {"timesteps",   required_argument,    nullptr,    's'},
        {"runs",        required_argument,    nullptr,    'r'},
        {"threads",     required_argument,    nullptr,    't'},
        {"algorithm",   required_argument,    nullptr,    'a'},
        {"vtk",         required_argument,    nullptr,    'v'},
        {"help",        no_argument,          nullptr,    'h'},
        {"reneigh",     required_argument,    nullptr,    0},
        {"rebalance",   required_argument,    nullptr,    1},
        {"dt",          required_argument,    nullptr,    2},
        {"temp",        required_argument,    nullptr,    3},
        {"cutoff",      required_argument,    nullptr,    4},
        {"verlet",      required_argument,    nullptr,    5},
        {"epsilon",     required_argument,    nullptr,    6},
        {"sigma",       required_argument,    nullptr,    7},
        {"damping_n",   required_argument,    nullptr,    8},
        {"damping_t",   required_argument,    nullptr,    9},
        {"stiffness",   required_argument,    nullptr,    10},
        {"friction",    required_argument,    nullptr,    11},
        {"potmin",      required_argument,    nullptr,    12},
        {"half_nb",     no_argument,          nullptr,    13},
        {"prebalance",  no_argument,          nullptr,    14}
    };

    while((opt = getopt_long(argc, argv, "f:b:x:y:z:s:r:t:a:v:h", long_opts, nullptr)) != -1) {
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
                init_temp = atof(optarg);
                break;

            case 4:
                cutoff_radius = atof(optarg);
                break;

            case 5:
                verlet_buffer = atof(optarg);
                break;

            case 6:
                epsilon = atof(optarg);
                break;

            case 7:
                sigma = atof(optarg);
                break;

            case 8:
                damping_n = atof(optarg);
                break;

            case 9:
                damping_t = atof(optarg);
                break;

            case 10:
                stiffness = atof(optarg);
                break;

            case 11:
                friction = atof(optarg);
                break;

            case 12:
                potential_minimum = atof(optarg);
                break;

            case 13:
                half_nb = true;
                break;

            case 14:
                prebalance = true;
                break;

            case 'f':
                force_field = string(optarg);
                break;

            case 'b':
                benchmark = string(optarg);
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

    enum timers {
        TIME_FORCE,
        TIME_NEIGHBORLISTS,
        TIME_COMM,
        TIME_LOAD_BALANCING,
        TIME_OTHER,
        NTIMERS
    };

    double world_aabb[6], rank_aabb[6], aabb1[6], aabb2[6], new_aabb[6];
    MultiTimer<double> timer(NTIMERS, runs, 1e-6);
    double spacing[3];
    bool vtk = !vtk_directory.empty();
    bool use_load_balancing = false;

    if(benchmark == "body_collision") {
        double shift = potential_minimum * (gridsize[1] + 1);

        for(int d = 0; d < 3; ++d) {
            aabb1[d * 2 + 0] = 50;
            aabb1[d * 2 + 1] = 50 + gridsize[d] * potential_minimum;
            aabb2[d * 2 + 0] = 50;
            aabb2[d * 2 + 1] = 50 + gridsize[d] * potential_minimum;
        }

        aabb2[2] -= shift;
        aabb2[3] -= shift;

        for(int d = 0; d < 3; ++d) {
            world_aabb[d * 2 + 0] = min(aabb1[d * 2 + 0], aabb2[d * 2 + 0]) - 20;
            world_aabb[d * 2 + 1] = max(aabb1[d * 2 + 1], aabb2[d * 2 + 1]) + 20;
            spacing[d] = potential_minimum;
        }
    } else {
        if(benchmark != "default" && benchmark != "half" && benchmark != "granular_gas") {
            cerr << "Invalid benchmark specified: \"" << benchmark << "\"" << endl;
            cerr << "Available options are default, half and body_collision" << endl;
            return EXIT_FAILURE;
        }

        for(int d = 0; d < 3; ++d) {
            world_aabb[d * 2 + 0] = 0;
            world_aabb[d * 2 + 1] = gridsize[d] * potential_minimum;
            spacing[d] = potential_minimum * 0.5;
        }

        half = benchmark == "half";
    }

    md_set_thread_count(nthreads);

    #ifdef USE_WALBERLA_LOAD_BALANCING

    use_walberla = true;

    auto mpiManager = mpi::MPIManager::instance();
    mpiManager->initializeMPI(&argc, &argv);
    mpiManager->useWorldComm();
    math::AABB domain(world_aabb[0], world_aabb[2], world_aabb[4], world_aabb[1], world_aabb[3], world_aabb[5]);
    auto forest = blockforest::createBlockForest(
        domain, Vector3<uint_t>(1, 1, 1), Vector3<bool>(true, true, true),
        mpiManager->numProcesses(), getInitialRefinementLevel(mpiManager->numProcesses()));

    auto is_within_domain = bind(isWithinBlockForest, _1, _2, _3, forest);
    auto info = make_shared<blockforest::InfoCollection>();
    getBlockForestAABB(forest, rank_aabb);

    // Properties
    map<string, int64_t> integerProperties;
    map<string, double> realProperties;
    map<string, string> stringProperties;

    // Load balancing parameters
    real_t baseWeight = 1.0;
    real_t metisipc2redist = 1.0;
    size_t regridMin = 10;
    size_t regridMax = 100;
    int maxBlocksPerProcess = 100;
    string metisAlgorithm = "none";
    string metisWeightsToUse = "none";
    string metisEdgeSource = "none";

    forest->recalculateBlockLevelsInRefresh(true);
    forest->alwaysRebalanceInRefresh(true);
    forest->reevaluateMinTargetLevelsAfterForcedRefinement(true);
    forest->allowRefreshChangingDepth(true);

    forest->allowMultipleRefreshCycles(false);
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

    #else

    md_mpi_initialize();
    md_get_node_bounding_box(world_aabb, &rank_aabb);
    auto is_within_domain = bind(is_within_aabb, _1, _2, _3, rank_aabb);

    #endif

    if(md_get_world_rank() == 0) {
        cout << "Simulation settings:" << endl;
        cout << "- Force field: " << force_field << endl;

        if(force_field == "dem") {
            cout << "- Normal damping: " << damping_n << endl;
            cout << "- Tangential damping: " << damping_t << endl;
            cout << "- Stiffness: " << stiffness << endl;
            cout << "- Friction: " << friction << endl;
        } else {
            cout << "- Epsilon: " << epsilon << endl;
            cout << "- Sigma: " << sigma << endl;
        }

        cout << "- Benchmark: " << benchmark << endl;
        cout << "- Unit cells (x, y, z): " << gridsize[0] << ", " << gridsize[1] << ", " << gridsize[2] << endl;
        cout << "- Number of timesteps: " << steps << endl;
        cout << "- Number of runs: " << runs << endl;
        cout << "- Number of threads: " << nthreads << endl;
        cout << "- Reneighboring timesteps: " << reneigh_every << endl;
        cout << "- Rebalancing timesteps: " << rebalance_every << endl;
        cout << "- Timestep size: " << dt << endl;
        cout << "- Initial temperature: " << init_temp << endl;
        cout << "- Cutoff radius: " << cutoff_radius << endl;
        cout << "- Verlet buffer: " << verlet_buffer << endl;
        cout << "- Potential minimum: " << potential_minimum << endl;
        cout << "- Half neighbor lists: " << (half_nb? "yes" : "no") << endl;
        cout << "- Walberla domain partitioning: " << (use_walberla ? "yes" : "no") << endl;
        cout << "- Prebalance: " << (prebalance ? "yes" : "no") << endl;
        cout << "- Dynamic load balancing algorithm: " << ((use_load_balancing) ? algorithm : "none") << endl;
        cout << "- VTK output directory: " << ((vtk) ? vtk_directory : "none") << endl << endl;
    }

    if(vtk) {
        if(md_get_world_size() > 1) {
            vtk_directory += to_string(md_get_world_rank());
        }

        vtk_directory += "/";
    }

    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    for(int i = 0; i < runs; ++i) {
        if(benchmark == "body_collision") {
            init_body_collision(world_aabb, aabb1, aabb2, rank_aabb, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
        } else if(benchmark == "granular_gas") {
            init_granular_gas(world_aabb, rank_aabb, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
        } else {
            init_rectangular_grid(world_aabb, rank_aabb, half, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
        }

        #ifdef USE_WALBERLA_LOAD_BALANCING
        if(use_load_balancing && prebalance) {
            updateWeights(forest, *info);
            forest->refresh();
            getBlockForestAABB(forest, new_aabb);
            md_rescale_grid(new_aabb);
        }

        updateWeights(forest, *info);
        updateNeighborhood(forest, *info, use_load_balancing);
        #endif

        if(benchmark != "body_collision" && benchmark != "granular_gas") {
            md_create_velocity(init_temp);
        }

        md_copy_data_to_accelerator();
        md_exchange_particles();
        md_borders();
        md_distribute_particles();
        md_assemble_neighborlists(half_nb, cutoff_radius + verlet_buffer);

        if(force_field == "dem") {
            md_compute_dem(half_nb, cutoff_radius, damping_n, damping_t, stiffness, friction);
        } else {
            md_compute_lennard_jones(half_nb, cutoff_radius, epsilon, sigma);
        }

        if(vtk && i == 0) {
            vtk_write_local_data(vtk_directory + "particles_0.vtk");
            vtk_write_ghost_data(vtk_directory + "ghost_0.vtk");
            vtk_write_aabb_data(vtk_directory + "aabb_0.vtk");

            #ifdef USE_WALBERLA_LOAD_BALANCING
            vtk_write_forest_data(forest, vtk_directory + "forest_0.vtk");
            #endif
        }

        md_barrier();
        timer.startRun();

        for(int j = 0; j < steps; ++j) {
            md_initial_integration(dt);
            timer.accum(TIME_FORCE);

            if((j + 1) % reneigh_every == 0) {
                md_exchange_particles();
                timer.accum(TIME_COMM);

                #ifdef USE_WALBERLA_LOAD_BALANCING
                if(use_load_balancing && (j + 1) % rebalance_every == 0) {
                    updateWeights(forest, *info);
                    forest->refresh();
                    getBlockForestAABB(forest, new_aabb);
                    md_rescale_grid(new_aabb);
                    updateWeights(forest, *info);
                    updateNeighborhood(forest, *info, true);
                }

                timer.accum(TIME_LOAD_BALANCING);
                #endif

                md_borders();
                timer.accum(TIME_COMM);

                md_distribute_particles();
                timer.accum(TIME_OTHER);

                md_assemble_neighborlists(half_nb, cutoff_radius + verlet_buffer);
                timer.accum(TIME_NEIGHBORLISTS);
            } else {
                md_synchronize_ghost_layer();
                timer.accum(TIME_COMM);
            }

            if(force_field == "dem") {
                md_compute_dem(half_nb, cutoff_radius, damping_n, damping_t, stiffness, friction);
            } else {
                md_compute_lennard_jones(half_nb, cutoff_radius, epsilon, sigma);
            }

            md_final_integration(dt);
            timer.accum(TIME_FORCE);

            if(vtk && i == 0) {
                md_copy_data_from_accelerator();
                vtk_write_local_data(vtk_directory + "particles_" + to_string(j + 1) + ".vtk");
                vtk_write_ghost_data(vtk_directory + "ghost_" + to_string(j + 1) + ".vtk");
                vtk_write_aabb_data(vtk_directory + "aabb_" + to_string(j + 1) + ".vtk");

                #ifdef USE_WALBERLA_LOAD_BALANCING
                vtk_write_forest_data(forest, vtk_directory + "forest_" + to_string(j + 1) + ".vtk");
                #endif

                timer.accum(TIME_OTHER);
            }
        }

        timer.finishRun();

        md_enforce_pbc();
        md_copy_data_from_accelerator();
        md_report_iterations();
        md_report_particles();
        md_deallocate_grid();
    }

    LIKWID_MARKER_CLOSE;

    md_report_time(
        timer.getRunsTotalAverage(),
        timer.getRunsAverage(TIME_FORCE),
        timer.getRunsAverage(TIME_NEIGHBORLISTS),
        timer.getRunsAverage(TIME_COMM),
        timer.getRunsAverage(TIME_LOAD_BALANCING),
        timer.getRunsAverage(TIME_OTHER)
    );

    #ifndef USE_WALBERLA_LOAD_BALANCING
    md_mpi_finalize();
    #endif

    return EXIT_SUCCESS;
}
