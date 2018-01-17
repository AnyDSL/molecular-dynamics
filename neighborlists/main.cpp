#include <iostream>
#include <fstream>
#include <string>
#include <cstdint>
#include "anydsl_includes.h"
#include "initialize.h"
#include "time.h"
#include "vtk.h"

void print_usage(char *name) {
    std::cout << "Usage: " << name << " gridsize steps runs [-vtk directory]" << std::endl;
}

void print_time_statistics(std::vector<double> time, std::string name) {
    double const mean = compute_mean(time);
    double const stdev = compute_standard_deviation(time, mean);
    std::cout << name << "\t" << mean << "\tms " << stdev << " ms" << std::endl;
}

int main(int argc, char **argv) {
    if(argc != 4 && argc != 6) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }
    bool vtk = false;
    if(argc == 6) {
        std::string argument(argv[4]);
        if(argument != "-vtk") {
            print_usage(argv[0]);
            return EXIT_FAILURE;
        }
        else {
            vtk = true;
        }
    }
    int const gridsize = atoi(argv[1]);
    int const steps = atoi(argv[2]);
    int const runs = atoi(argv[3]);
    std::string output_directory;
    double dt = 1e-3;
    double const cutoff_radius = 2.0;
    double const epsilon = 1.0;
    double const sigma = 1.0;
    double const maximum_velocity = 1.0;

    AABB aabb;
    double spacing[3];
    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = 0;
        aabb.max[i] = gridsize *1;
        spacing[i] = 1;
    }

    std::vector<double> grid_initialization_time(runs, 0);
    std::vector<double> position_integration_time(runs, 0);
    std::vector<double> redistribution_time(runs, 0);
    std::vector<double> cluster_initialization_time(runs, 0);
    std::vector<double> neighborlist_creation_time(runs, 0);
    std::vector<double> force_resetting_time(runs, 0);
    std::vector<double> force_computation_time(runs, 0);
    std::vector<double> velocity_integration_time(runs, 0);
    std::vector<double> deallocation_time(runs, 0);
    double const factor = 1e-6;


    for(int i = 0; i < runs; ++i) {
        auto begin = measure_time();
        int size = init_rectangular_grid(aabb, spacing, maximum_velocity, 5.0, 2048);
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
        std::vector<double> masses(size);
        std::vector<Vector3D> positions(size);
        std::vector<Vector3D> velocities(size);
        if(vtk) {
            output_directory = std::string(argv[5]) + "/";
            cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
            write_vtk_to_file(output_directory + "particles_0.vtk", masses, positions, velocities);
        }
        for(int j = 0; j < steps; ++j) {
            std::cout << "Time step: " << j+1 << "\r" << std::flush;

            begin = measure_time();
            cpu_integrate_position(dt);
            end = measure_time();
            position_integration_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_redistribute_particles();
            end = measure_time();
            redistribution_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_initialize_clusters(512);
            end = measure_time();
            cluster_initialization_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_assemble_neighbor_lists(5.0);
            end = measure_time();
            neighborlist_creation_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_reset_forces();
            end = measure_time();
            force_resetting_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_compute_forces(cutoff_radius, epsilon, sigma);
            end = measure_time();
            force_computation_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            begin = measure_time();
            cpu_integrate_velocity(dt);
            end = measure_time();
            velocity_integration_time[i] += static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;

            if(vtk && i == 0) {
                int nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
                if(nparticles > 0) {
                    masses.resize(nparticles);
                    positions.resize(nparticles);
                    velocities.resize(nparticles);
                    std::string filename(output_directory + "particles_");
                    filename += std::to_string(j+1);
                    filename += ".vtk";
                    write_vtk_to_file(filename, masses, positions, velocities);
                }
            }
        }
        begin = measure_time();
        cpu_deallocate_grid();
        end = measure_time();
        deallocation_time[i] = static_cast<double>(calculate_time_difference<std::chrono::nanoseconds>(begin, end))*factor;
    }
    std::cout << std::endl;

    print_time_statistics(grid_initialization_time, "grid_initialization ");
    print_time_statistics(position_integration_time, "position_integration");
    print_time_statistics(redistribution_time, "redistribution");
    print_time_statistics(cluster_initialization_time, "cluster_initialization");
    print_time_statistics(neighborlist_creation_time, "neighborlist_creation");
    print_time_statistics(force_resetting_time, "force_resetting");
    print_time_statistics(force_computation_time, "force_computation");
    print_time_statistics(velocity_integration_time, "velocity_integration");
    print_time_statistics(deallocation_time, "deallocation");

    return EXIT_SUCCESS;
}
