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
/*
#ifdef USE_WALBERLA_LOAD_BALANCING
#include <blockforest/BlockForest.h>
#include <blockforest/Initialization.h>
#include <blockforest/loadbalancing/DynamicCurve.h>
#include <blockforest/loadbalancing/DynamicParMetis.h>
#include <blockforest/loadbalancing/InfoCollection.h>
#include <blockforest/loadbalancing/PODPhantomData.h>
#endif
*/
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

#define time_diff(begin, end)   static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))

#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
#include <x86intrin.h>
#endif

void print_usage(char *name) {
    std::cout << "Usage: " << name << " [OPTION]..." << std::endl;
    std::cout << "A fast, scalable and portable application for pair-wise interactions implemented in AnyDSL." << std::endl << std::endl;
    std::cout << "Mandatory arguments to long options are also mandatory for short options." << std::endl;
    std::cout << "\t-x, --nx=SIZE             number of unit cells in x dimension (default 32)." << std::endl;
    std::cout << "\t-y, --ny=SIZE             number of unit cells in y dimension (default 32)." << std::endl;
    std::cout << "\t-z, --nz=SIZE             number of unit cells in z dimension (default 32)." << std::endl;
    std::cout << "\t-s, --timesteps=NUMBER    number of timesteps in the simulation (default 100)." << std::endl;
    std::cout << "\t-r, --runs=NUMBER         number of test runs (default 1)." << std::endl;
    std::cout << "\t-t, --threads=NUMBER      number of threads to run (default 1)." << std::endl;
    std::cout << "\t-c, --config=FILE         walberla configuration file (must be set when walberla load balancing is used)." << std::endl;
    std::cout << "\t-v, --vtk=DIRECTORY       VTK output directory (for MPI simulations, the rank number is concatenated" << std::endl;
    std::cout << "\t                          in the end of this name, i.e. output[0-3] when using --vtk=output and 4 ranks)." << std::endl;
    std::cout << "\t                          VTK directories are NOT automatically created and therefore must exist." << std::endl;
    std::cout << "\t-h                        display this help message." << std::endl;
}

std::pair<double,double> get_time_statistics(std::vector<double> time) {
    double const mean = compute_mean(time);
    double const stdev = compute_standard_deviation(time, mean);
    return std::make_pair(mean, stdev);
}

int main(int argc, char **argv) {
    using namespace std::placeholders;

    // Force flush to zero mode for denormals
#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
    _mm_setcsr(_mm_getcsr() | (_MM_FLUSH_ZERO_ON | _MM_DENORMALS_ZERO_ON));
#endif

    int gridsize[3] = {32, 32, 32};
    int steps = 100;
    int runs = 1;
    int nthreads = 1;
    std::string config_file;
    std::string vtk_directory;

    int opt = 0;
    struct option long_opts[] = {
        {"nx",        required_argument,    nullptr,    'x'},
        {"ny",        required_argument,    nullptr,    'y'},
        {"nz",        required_argument,    nullptr,    'z'},
        {"timesteps", required_argument,    nullptr,    's'},
        {"runs",      required_argument,    nullptr,    'r'},
        {"threads",   required_argument,    nullptr,    't'},
        {"config",    required_argument,    nullptr,    'c'},
        {"vtk",       required_argument,    nullptr,    'v'},
    };

    while((opt = getopt_long(argc, argv, "x:y:z:s:r:t:c:v:h", long_opts, nullptr)) != -1) {
        switch(opt) {
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

            case 'c':
                config_file = std::string(optarg);
                break;

            case 'v':
                vtk_directory = std::string(optarg);
                break;

            case 'h':
            case '?':
            default:
                print_usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    double dt = 1e-3;
    double const cutoff_radius = 2.5;
    double const epsilon = 1.0;
    double const sigma = 1.0;
    //double potential_minimum = std::pow(2.0, 1.0/6.0) * sigma;
    double potential_minimum = 1.6796;
    AABB aabb;
    double spacing[3];
    bool vtk = !vtk_directory.empty();

#ifdef BODY_COLLISION_TEST
    AABB aabb1, aabb2;

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
        aabb.min[i] = std::min(aabb1.min[i], aabb2.min[i]) - 20;
        aabb.max[i] = std::max(aabb1.max[i], aabb2.max[i]) + 20;
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

    std::vector<double> grid_initialization_time(runs, 0);
    std::vector<double> copy_data_to_accelerator_time(runs, 0);
    std::vector<double> copy_data_from_accelerator_time(runs, 0);
    std::vector<double> integration_time(runs, 0);
    std::vector<double> redistribution_time(runs, 0);
    std::vector<double> cluster_initialization_time(runs, 0);
    std::vector<double> neighborlist_creation_time(runs, 0);
    std::vector<double> force_computation_time(runs, 0);
    std::vector<double> deallocation_time(runs, 0);
    std::vector<double> synchronization_time(runs, 0);
    std::vector<double> exchange_time(runs, 0);
    std::vector<double> barrier_time(runs, 0);
    double const factor = 1e-6;
    double const verlet_buffer = 0.3;
    int size;

    md_set_thread_count(nthreads);

#ifdef USE_WALBERLA_LOAD_BALANCING
    auto mpiManager = walberla::mpi::MPIManager::instance();
    mpiManager->initializeMPI(&argc, &argv);
    mpiManager->useWorldComm();

    walberla::math::AABB domain(
        walberla::real_t(aabb.min[0]), walberla::real_t(aabb.min[1]), walberla::real_t(aabb.min[2]),
        walberla::real_t(aabb.max[0]), walberla::real_t(aabb.max[1]), walberla::real_t(aabb.max[2]));

    auto forest = walberla::blockforest::createBlockForest(
        domain, walberla::Vector3<walberla::uint_t>(1, 1, 1), walberla::Vector3<bool>(true, true, true),
        mpiManager->numProcesses(), walberla::uint_t(0));

    auto rank_aabb = get_rank_aabb_from_block_forest(forest);
    auto is_within_domain = std::bind(is_within_block_forest, _1, _2, _3, forest);
#else
    md_mpi_initialize();

    auto rank_aabb = get_rank_aabb(aabb);
    auto is_within_domain = std::bind(is_within_aabb, _1, _2, _3, rank_aabb);
#endif

    if(md_get_world_rank() == 0) {
        std::cout << "Simulation settings:" << std::endl;
        std::cout << "- Unit cells (x, y, z): " << gridsize[0] << ", " << gridsize[1] << ", " << gridsize[2] << std::endl;
        std::cout << "- Number of timesteps: " << steps << std::endl;
        std::cout << "- Number of runs: " << runs << std::endl;
        std::cout << "- Number of threads: " << nthreads << std::endl;
        std::cout << "- Walberla configuration file: " << (config_file.empty() ? "none" : config_file) << std::endl;
        std::cout << "- VTK output directory: " << ((vtk) ? vtk_directory : "none") << std::endl << std::endl;
    }

    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    for(int i = 0; i < runs; ++i) {
        auto begin = measure_time();
#ifdef BODY_COLLISION_TEST
        size = init_body_collision(aabb, aabb1, aabb2, rank_aabb, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
#else
        size = init_rectangular_grid(aabb, rank_aabb, spacing, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
#endif
        auto end = measure_time();
        grid_initialization_time[i] = time_diff(begin, end) * factor;

        if(size == 0) {
            std::cout << "Zero particles created. Aborting." << std::endl;
            return EXIT_FAILURE;
        }

        md_exchange_ghost_layer();
        md_distribute_particles();
        md_barrier();

        begin = measure_time();
        md_copy_data_to_accelerator();
        end = measure_time();
        copy_data_to_accelerator_time[i] = time_diff(begin, end) * factor;

        begin = measure_time();
        md_assemble_neighborlists(cutoff_radius+verlet_buffer);
        end = measure_time();
        neighborlist_creation_time[i] += time_diff(begin, end) * factor;

        std::vector<double> masses(size);
        std::vector<Vector3D> positions(size);
        std::vector<Vector3D> velocities(size);
        std::vector<Vector3D> forces(size);

        if(vtk) {
            vtk_directory += std::to_string(md_get_world_rank()) + "/";
            md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
            write_vtk_to_file(vtk_directory + "particles_0.vtk", masses, positions, velocities, forces);
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

            if(!vtk && j % 20 != 0) {
                begin = measure_time();
                md_synchronize_ghost_layer();
                end = measure_time();
                synchronization_time[i] += time_diff(begin, end) * factor;
            }

            if(vtk || (j > 0 && j % 20 == 0)) {
                begin = measure_time();
                md_copy_data_from_accelerator();
                end = measure_time();
                copy_data_from_accelerator_time[i] += time_diff(begin, end) * factor;

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
                md_assemble_neighborlists(cutoff_radius+verlet_buffer);
                end = measure_time();
                neighborlist_creation_time[i] += time_diff(begin, end) * factor;
            }

            if(vtk && i == 0) {
                int nparticles = md_get_number_of_particles();

                if(nparticles > 0) {
                    masses.resize(nparticles);
                    positions.resize(nparticles);
                    velocities.resize(nparticles);
                    forces.resize(nparticles);

                    md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());

                    std::string filename(vtk_directory + "particles_");
                    filename += std::to_string(j+1);
                    filename += ".vtk";
                    write_vtk_to_file(filename, masses, positions, velocities, forces);
                }
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

    std::vector<std::pair<double,double>> time_results(12);

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
    time_results[11] = get_time_statistics(barrier_time);

    double mean_sum = 0, stdev_sum = 0;

    for(size_t i = 1; i < time_results.size() - 1; ++i) {
        mean_sum += time_results[i].first;
        stdev_sum += time_results[i].second;
    }

    md_report_time(
        mean_sum,
        time_results[1].first + time_results[5].first,
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
