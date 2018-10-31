#include <iostream>
#include <fstream>
#include <string>
#include <cstdint>
#include <utility>
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

void print_usage(char *name) {
    std::cout << "Usage: " << name << " x y z steps runs threads [-vtk directory]" << std::endl;
}

std::pair<double,double> print_time_statistics(std::vector<double> time, std::string name) {
    double const mean = compute_mean(time);
    double const stdev = compute_standard_deviation(time, mean);
    std::cout << name << "\t" << mean << "\tms " << stdev << " ms" << std::endl;
    return std::make_pair(mean, stdev);
}

int main(int argc, char **argv) {
    if(argc != 7 && argc != 9) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }
    bool vtk = false;
    if(argc == 9) {
        std::string argument(argv[7]);
        if(argument != "-vtk") {
            print_usage(argv[0]);
            return EXIT_FAILURE;
        }
        else {
            vtk = true;
        }
    }
    
    
    int gridsize[3];
    gridsize[0] = atoi(argv[1]);
    gridsize[1] = atoi(argv[2]);
    gridsize[2] = atoi(argv[3]);
    int const steps = atoi(argv[4]);
    int const runs = atoi(argv[5]);
    int const nthreads = atoi(argv[6]);
    std::string output_directory;
    double dt = 1e-3;
    double const cutoff_radius = 2.5;
    double const epsilon = 1.0;
    double const sigma = 1.0;
    double const maximum_velocity = 1.0;
    double potential_minimum = std::pow(2.0, 1.0/6.0) * sigma;
    std::cout << "Potential minimum at: " << potential_minimum << std::endl;
    AABB aabb1;
    AABB aabb2;
    double spacing1[3];
    double spacing2[3];
    AABB aabb;
    double spacing[3];

    // Body Collision Test
    for(int i = 0; i < 3; ++i) {
        aabb1.min[i] = 50;
        aabb1.max[i] = 50 + gridsize[i] * potential_minimum;
        spacing1[i] = potential_minimum;
    }
    for(int i = 0; i < 3; ++i) {
        aabb2.min[i] = 50;
        aabb2.max[i] = 50 + gridsize[i] * potential_minimum;
        spacing2[i] = potential_minimum;
    }
    double shift = potential_minimum + (aabb2.max[1] - aabb2.min[1]);
    aabb2.min[1] -= shift;
    aabb2.max[1] -= shift;
    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = 0;
        aabb.max[i] = gridsize[i] * potential_minimum;
        spacing[i] = potential_minimum;
    }

    std::vector<double> grid_initialization_time(runs, 0);
    std::vector<double> copy_data_to_accelerator_time(runs, 0);
    std::vector<double> copy_data_from_accelerator_time(runs, 0);
    std::vector<double> integration_time(runs, 0);
    std::vector<double> redistribution_time(runs, 0);
    std::vector<double> cluster_initialization_time(runs, 0);
    std::vector<double> neighborlist_creation_time(runs, 0);
    std::vector<double> force_computation_time(runs, 0);
    std::vector<double> deallocation_time(runs, 0);
    double const factor = 1e-6;
    md_set_thread_count(nthreads);
    double const verlet_buffer = 0.3;
    
    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    for(int i = 0; i < runs; ++i) {
        auto begin = measure_time();

#ifdef BODY_COLLISION_TEST
        int size = init_body_collision(0, aabb1, aabb2, spacing1, spacing2, 1, 1, 100, cutoff_radius+verlet_buffer, 2048);
    #else
        int size = init_rectangular_grid(static_cast<unsigned>(i), aabb, spacing, maximum_velocity, cutoff_radius+verlet_buffer, 2048);
    #endif
        auto end = measure_time();
        grid_initialization_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

        if(i == 0) {
            std::cout << "Number of particles: " << size << std::endl;
        }
        std::cout << "Starting run " << i+1 << std::endl;
        if(size == 0) {
            std::cout << "Zero particles created. Aborting." << std::endl;
            return EXIT_FAILURE;
        }

        begin = measure_time();
        md_initialize_clusters(512);
        end = measure_time();
        cluster_initialization_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

        begin = measure_time();
        md_assemble_neighbor_lists(cutoff_radius+verlet_buffer);
        end = measure_time();
        neighborlist_creation_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

        begin = measure_time();
        md_copy_data_to_accelerator();
        end = measure_time();
        copy_data_to_accelerator_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

        std::vector<double> masses(size);
        std::vector<Vector3D> positions(size);
        std::vector<Vector3D> velocities(size);
        std::vector<Vector3D> forces(size);
        if(vtk) {
            output_directory = std::string(argv[8]) + "/";
            md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data(), size);
            write_vtk_to_file(output_directory + "particles_0.vtk", masses, positions, velocities, forces);
        }
        for(int j = 0; j < steps; ++j) {
            std::cout << "Time step: " << j+1 << "\r" << std::flush;

            LIKWID_MARKER_START("Force");
            begin = measure_time();
            md_compute_forces(cutoff_radius, epsilon, sigma);
            end = measure_time();
            LIKWID_MARKER_STOP("Force");
            force_computation_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            md_integration(dt);
            end = measure_time();
            integration_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            if(vtk || (j > 0 && j % 20 == 0)) {

                begin = measure_time();
                md_copy_data_from_accelerator();
                end = measure_time();
                copy_data_from_accelerator_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

                begin = measure_time();
                md_redistribute_particles();
                end = measure_time();
                redistribution_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

                begin = measure_time();
                md_initialize_clusters(512);
                end = measure_time();
                cluster_initialization_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

                begin = measure_time();
                md_assemble_neighbor_lists(cutoff_radius+verlet_buffer);
                end = measure_time();
                neighborlist_creation_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

                begin = measure_time();
                md_copy_data_to_accelerator();
                end = measure_time();
                copy_data_to_accelerator_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;
            }


            if(vtk && i == 0) {
                int nparticles = md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data(), size);
                if(nparticles > 0) {
                    masses.resize(nparticles);
                    positions.resize(nparticles);
                    velocities.resize(nparticles);
                    forces.resize(nparticles);
                    std::string filename(output_directory + "particles_");
                    filename += std::to_string(j+1);
                    filename += ".vtk";
                    write_vtk_to_file(filename, masses, positions, velocities, forces);
                }
            }
            //std::cout << "Kinetic energy: " << md_compute_total_kinetic_energy() << std::endl;
        }

        begin = measure_time();
        md_deallocate_grid();
        end = measure_time();
        deallocation_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;
        std::cout << std::flush << std::endl;
    }
    std::cout << std::flush << std::endl;
    LIKWID_MARKER_CLOSE;

    std::vector<std::pair<double,double>> time_results(9);
    std::cout << "Code Region\tAverage\tStandard Deviation" << std::endl;
    time_results[0] = print_time_statistics(grid_initialization_time, "grid_initialization ");
    time_results[1] = print_time_statistics(integration_time, "integration");
    time_results[2] = print_time_statistics(redistribution_time, "redistribution");
    time_results[3] = print_time_statistics(cluster_initialization_time, "cluster_initialization");
    time_results[4] = print_time_statistics(neighborlist_creation_time, "neighborlist_creation");
    time_results[5] = print_time_statistics(force_computation_time, "force_computation");
    time_results[6] = print_time_statistics(deallocation_time, "deallocation");
    time_results[7] = print_time_statistics(copy_data_to_accelerator_time, "copy_data_to_accelerator");
    time_results[8] = print_time_statistics(copy_data_from_accelerator_time, "copy_data_from_accelerator");
    double mean_sum = 0, stdev_sum = 0;
    for(size_t i = 0; i < time_results.size(); ++i) {
        mean_sum += time_results[i].first;
        stdev_sum += time_results[i].second;
    }
    std::cout << "Total" << "\t" << mean_sum << "\tms " << stdev_sum << " ms" << std::endl;

    std::cout << "Counted number of FLOPS within the force computation: " << get_number_of_flops() << std::endl;


    return EXIT_SUCCESS;
}
