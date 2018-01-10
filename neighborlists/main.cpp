#include <iostream>
#include <fstream>
#include <array>
#include <vector>
#include <string>
#include <cmath>
#include <tuple>

extern "C" {
    struct Vector3D {
        double x;
        double y;
        double z;
    };
    void cpu_initialize_grid(double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double, int);
    void cpu_integrate_position(double);
    void cpu_integrate_velocity(double);
    int cpu_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, int);
    void cpu_redistribute_particles();
    void cpu_initialize_clusters(int);
    void cpu_assemble_neighbor_lists(double);
    void cpu_deallocate_grid();
    void cpu_print_grid();
    void cpu_set_forces_to_zero();
    void cpu_compute_forces(double, double, double);
}

struct AABB {
    double min[3];
    double max[3];
};

std::tuple<std::vector<double>, std::vector<Vector3D>, std::vector<Vector3D>> generate_rectangular_grid(AABB aabb, double spacing[3], double const mass, double velocity[3]) {
    int nvertices[3];
    int size = 1;
    for(int i = 0; i < 3; ++i) {
        nvertices[i] = (aabb.max[i] - aabb.min[i]) / spacing[i];
        size *= nvertices[i];
    }
    std::vector<double> masses(size, mass);
    Vector3D velocity_vector;
    velocity_vector.x = velocity[0];
    velocity_vector.y = velocity[1];
    velocity_vector.z = velocity[2];
    std::vector<Vector3D> velocities(size, velocity_vector);
    std::vector<Vector3D> positions(size);
    int index = 0;
    for(int i = 0; i < nvertices[0]; ++i) {
        for(int j = 0; j < nvertices[1]; ++j) {
            for(int k = 0; k < nvertices[2]; ++k) {
                positions[index].x = aabb.min[0] + i * spacing[0];
                positions[index].y = aabb.min[1] + j * spacing[1];
                positions[index].z = aabb.min[2] + k * spacing[2];
                //std::cout << "Position: " << positions[index].x << " " << positions[index].y << " " << positions[index].z << "\n";
                ++index;
            }
        }
    }
    if(index != size) {
        std::cout << "Count: " << index << "Size: " << size << std::endl;
    }
    /*for(int i = 0; i < size; i++) {
        std::cout << "Position: " << positions[i].x << " " << positions[i].y << " " << positions[i].z << "\n";
    }*/
    return std::make_tuple(masses, positions, velocities);
}

int init_rectangular_grid(AABB aabb, double spacing[3], double cell_spacing, int cell_capacity) {
    double velocity[3];
    velocity[0] = 0;
    velocity[1] = -100;
    velocity[2] = 0;
    auto tuple = generate_rectangular_grid(aabb, spacing, 1.0, velocity);
    for(int i = 0; i < 3; ++i) {
        aabb.min[i] -= 10;
        aabb.max[i] += 10;
    }
    /*for(int i = 0; i < size; i++) {
        std::cout << "Position: " << positions[i].x << " " << positions[i].y << " " << positions[i].z << "\n";
    }*/
    auto size = std::get<0>(tuple).size();
    cpu_initialize_grid(std::get<0>(tuple).data(), std::get<1>(tuple).data(), std::get<2>(tuple).data(), size, aabb.min, aabb.max, cell_spacing, cell_capacity);
    return size;
}


void write_vtk_to_file(std::string filename, std::vector<double> const& masses, std::vector<Vector3D>const & positions, std::vector<Vector3D>const & velocities) {
    std::ofstream file(filename);
    file << "# vtk DataFile Version 2.0\n";
    file << "Particle data" << std::endl;
    file << "ASCII" << std::endl;
    file << "DATASET UNSTRUCTURED_GRID\n";
    file << "POINTS " << positions.size() << " double\n";
    for(auto it = positions.begin(); it != positions.end(); ++it) {
        file << std::fixed << it->x << " ";
        file << std::fixed << it->y << " ";
        file << std::fixed << it->z << "\n";
    }
    file << "\n\n";
    file << "CELLS " << positions.size() << " " << 2 * positions.size() << std::endl;
    for(int i = 0; i < positions.size(); ++i) {
        file << "1 " << i << std::endl;
    }
    file << "\n\n";

    file << "CELL_TYPES " << positions.size() << std::endl;
    for(int i = 0; i < positions.size(); ++i) {
        file << "1" << std::endl;
    }
    file << "\n\n";

    file << "POINT_DATA " << masses.size() << "\n";

    file << "SCALARS mass double\n";
    file << "LOOKUP_TABLE default\n";
    for(int i = 0; i < masses.size(); ++i) {
        file << std::fixed << masses[i] << std::endl;
    }

    file << std::endl;

    file << "SCALARS velocity_x double\n";
    file << "LOOKUP_TABLE default\n";
    for(int i = 0; i < velocities.size(); ++i) {
        file << std::fixed << velocities[i].x << std::endl;
    }
    file << std::endl;

    file << "SCALARS velocity_y double\n";
    file << "LOOKUP_TABLE default\n";
    for(int i = 0; i < velocities.size(); ++i) {
        file << std::fixed << velocities[i].y << std::endl;
    }
    file << std::endl;

    file << "SCALARS velocity_z double\n";
    file << "LOOKUP_TABLE default\n";
    for(int i = 0; i < velocities.size(); ++i) {
        file << std::fixed << velocities[i].z << std::endl;
    }

    file << std::endl;
    file.close();
}



int main()
{
    double dt = 1e-3;
    double const cutoff_radius = 5.0;
    double const epsilon = 1.0;
    double const sigma = 5.0;
    double potential_minimum = std::pow(2.0, 1.0/6.0) * sigma;
    std::cout << "Potential minimum at: " << potential_minimum << std::endl;
    AABB aabb;
    double spacing[3];
    for(int i = 0; i < 3; ++i) {
        aabb.min[i] = 0;
        aabb.max[i] = 50*potential_minimum;
        spacing[i] = potential_minimum;
    }
    int size = init_rectangular_grid(aabb, spacing, 5, 1024);
    std::cout << "Number of particles: " << size << std::endl;
    std::vector<double> masses(size);
    std::vector<Vector3D> positions(size);
    std::vector<Vector3D> velocities(size);
    int nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
    write_vtk_to_file("particles_0.vtk", masses, positions, velocities);
    for(int i = 0; i < 1000; ++i) {
//        std::cout << "Time step: " << i+1 << std::endl;
//        std::cout << "Integrate position" << std::endl;
        cpu_integrate_position(dt);
        //cpu_print_grid();
//        std::cout << "Redistribute particles" << std::endl;
        cpu_redistribute_particles();
//        std::cout << "Initialize clusters" << std::endl;
        cpu_initialize_clusters(64);
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
        /*nparticles = cpu_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), size);
        if(nparticles > 0) {
            masses.resize(nparticles);
            positions.resize(nparticles);
            velocities.resize(nparticles);
            std::string filename("particles_");
            filename += std::to_string(i+1);
            filename += ".vtk";
            write_vtk_to_file(filename, masses, positions, velocities);
        }*/
    }
    cpu_deallocate_grid();
    return 0;
}
