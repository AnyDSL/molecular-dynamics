#include <iostream>
#include <fstream>
#include <string>
#include "anydsl_includes.h"
#include "initialize.h"
#include "vtk.h"

void print_usage(char *name) {
    std::cout << "Usage: " << name << " gridsize steps [-vtk directory]" << std::endl;
}

int main(int argc, char **argv) {
    if(argc != 3 && argc != 5) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }
    bool vtk = false;
    if(argc == 5) {
        std::string argument(argv[3]);
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
    std::string output_directory;
    double dt = 1e-3;
    double const cutoff_radius = 5.0;
    double const epsilon = 1.0;
    double const sigma = 5.0;
    double const maximum_velocity = 1.0;

    AABB aabb;
    double spacing[3];
    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = 0;
        aabb.max[i] = gridsize *cutoff_radius;
        spacing[i] = cutoff_radius;
    }
    int size = init_rectangular_grid(aabb, spacing, maximum_velocity, 5.0, 2048);
    std::cout << "Number of particles: " << size << std::endl;
    if(size == 0) {
        std::cout << "Zero particles created. Aborting." << std::endl;
        return EXIT_FAILURE;
    }
    std::vector<double> masses(size);
    std::vector<Vector3D> positions(size);
    std::vector<Vector3D> velocities(size);
    if(vtk) {
        output_directory = std::string(argv[4]) + "/";
        cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
        write_vtk_to_file(output_directory + "particles_0.vtk", masses, positions, velocities);
    }
    for(int i = 0; i < steps; ++i) {
        std::cout << "Time step: " << i+1 << "\r" << std::flush;
//        std::cout << "Integrate position" << std::endl;
        cpu_integrate_position(dt);
        //cpu_print_grid();
//        std::cout << "Redistribute particles" << std::endl;
        cpu_redistribute_particles();
//        std::cout << "Initialize clusters" << std::endl;
        cpu_initialize_clusters(512);
//        std::cout << "Assemble neighbor list" << std::endl;
        cpu_assemble_neighbor_lists(5.0);
//        std::cout << "Set forces to zero" << std::endl;
        cpu_set_forces_to_zero();
        //std::cout << "------------------------------------------" << std::endl;
//        std::cout << "Compute forces" << std::endl;
        cpu_compute_forces(cutoff_radius, epsilon, sigma);
//        std::cout << "Integrate velocity" << std::endl;
        cpu_integrate_velocity(dt);
        //cpu_print_grid();
//        std::cout << "vtk output" << std::endl;
        if(vtk) {
            int nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
            if(nparticles > 0) {
                masses.resize(nparticles);
                positions.resize(nparticles);
                velocities.resize(nparticles);
                std::string filename(output_directory + "particles_");
                filename += std::to_string(i+1);
                filename += ".vtk";
                write_vtk_to_file(filename, masses, positions, velocities);
            }
        }
    }
    cpu_deallocate_grid();
    std::cout << std::endl;
    return EXIT_SUCCESS;
}
