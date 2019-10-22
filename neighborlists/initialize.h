#ifndef INITIALIZE_H
#define INITIALIZE_H

#include <vector>
#include <string>
#include <cmath>
#include <tuple>
#include <chrono>
#include <random>
#include "anydsl_includes.h"

struct AABB {
		double min[3];
		double max[3];
};

std::tuple<std::vector<double>, std::vector<Vector3D>, std::vector<Vector3D>> generate_rectangular_grid(AABB aabb, AABB rank_aabb, double spacing[3], double const mass, double velocity[3]) {
    int nvertices[3];
    int size = 0;
    for(int i = 0; i < 3; ++i) {
        nvertices[i] = (aabb.max[i] - aabb.min[i]) / spacing[i];
    }
    std::vector<Vector3D> positions;

    for(int i = 0; i < nvertices[0]; ++i) {
        for(int j = 0; j < nvertices[1]; ++j) {
            for(int k = 0; k < nvertices[2]; ++k) {
                if((i + j + k) % 2 == 0) {
                    Vector3D pos;

                    pos.x = aabb.min[0] + i * spacing[0];
                    pos.y = aabb.min[1] + j * spacing[1];
                    pos.z = aabb.min[2] + k * spacing[2];

                    if(
                        pos.x >= rank_aabb.min[0] && pos.x <= rank_aabb.max[0] &&
                        pos.y >= rank_aabb.min[1] && pos.y <= rank_aabb.max[1] &&
                        pos.z >= rank_aabb.min[2] && pos.z <= rank_aabb.max[2]
                    ) {
                      positions.push_back(pos);
                      size++;
                    }

                    //std::cout << "Position: " << positions[index].x << " " << positions[index].y << " " << positions[index].z << "\n";
                    //++index;
                }
            }
        }
    }

    Vector3D velocity_vector;
    velocity_vector.x = velocity[0];
    velocity_vector.y = velocity[1];
    velocity_vector.z = velocity[2];
    std::vector<double> masses(size, mass);
    std::vector<Vector3D> velocities(size, velocity_vector);

    //if(index != size) {
    //    std::cout << "Count: " << index << "Size: " << size << std::endl;
    //}
    /*for(int i = 0; i < size; i++) {
                std::cout << "Position: " << positions[i].x << " " << positions[i].y << " " << positions[i].z << "\n";
        }*/
    return std::make_tuple(masses, positions, velocities);
}

int init_rectangular_grid(unsigned seed, AABB aabb, double spacing[3], double maximum_velocity, double cell_spacing, int cell_capacity) {
    AABB ext_aabb, rank_aabb;
    //seed = std::chrono::high_resolution_clock::now().time_since_epoch().count();
    std::mt19937_64 random_engine(seed);
    std::uniform_real_distribution<double> distribution(-maximum_velocity, maximum_velocity);
    double velocity[3];

    for(int i = 0; i < 3; ++i) {
        velocity[i] = 0.0;

        ext_aabb.min[i] = aabb.min[i] - cell_spacing;
        ext_aabb.max[i] = aabb.max[i] + cell_spacing;
    }

    md_get_node_bounding_box(
      cell_spacing, ext_aabb.min, ext_aabb.max, &rank_aabb.min, &rank_aabb.max);

    auto tuple = generate_rectangular_grid(aabb, rank_aabb, spacing, 1.0, velocity);
    auto& velocities = std::get<2>(tuple);
    for(size_t i = 0; i < velocities.size(); ++i) {
        velocities[i].x = distribution(random_engine);
        velocities[i].y = distribution(random_engine);
        velocities[i].z = distribution(random_engine);
    }

    /*for(int i = 0; i < size; i++) {
                std::cout << "Position: " << positions[i].x << " " << positions[i].y << " " << positions[i].z << "\n";
        }*/
    auto size = std::get<0>(tuple).size();
    return md_initialize_grid(std::get<0>(tuple).data(), std::get<1>(tuple).data(), std::get<2>(tuple).data(), size, ext_aabb.min, ext_aabb.max, rank_aabb.min, rank_aabb.max, cell_spacing, cell_capacity);
}


int init_body_collision(unsigned const seed, AABB aabb1, AABB aabb2, double spacing1[3], double spacing2[3], double mass1, double mass2, double velocity, double cell_spacing, int cell_capacity) {
    if(aabb1.min[1] < aabb2.max[1]) {
        std::cerr << "The first bounding box must be located on top of the second!" << std::endl;
        std::cerr << "aabb1: " << aabb1.min[1] << " aabb2: " << aabb2.max[1] << std::endl;
        return 0;
    }
    AABB aabb, rank_aabb;
    for(int d = 0; d < 3; ++d) {
        aabb.min[d] = std::min(aabb1.min[d], aabb2.min[d]) - 20;
        aabb.max[d] = std::max(aabb1.max[d], aabb2.max[d]) + 20;
    }

    double velocity1[3];
    velocity1[0] = 0;
    velocity1[1] = -velocity;
    velocity1[2] = 0;

    double velocity2[3];
    velocity2[0] = 0;
    velocity2[1] = velocity;
    velocity2[2] = 0;

    md_get_node_bounding_box(
      cell_spacing, aabb.min, aabb.max, &rank_aabb.min, &rank_aabb.max);

    auto tuple1 = generate_rectangular_grid(aabb1, rank_aabb, spacing1, mass1, velocity1);
    auto tuple2 = generate_rectangular_grid(aabb2, rank_aabb, spacing2, mass2, velocity2);
    std::get<0>(tuple1).insert(std::get<0>(tuple1).end(), std::get<0>(tuple2).begin(), std::get<0>(tuple2).end());
    std::get<1>(tuple1).insert(std::get<1>(tuple1).end(), std::get<1>(tuple2).begin(), std::get<1>(tuple2).end());
    std::get<2>(tuple1).insert(std::get<2>(tuple1).end(), std::get<2>(tuple2).begin(), std::get<2>(tuple2).end());

    auto size = std::get<0>(tuple1).size();
    return md_initialize_grid(std::get<0>(tuple1).data(), std::get<1>(tuple1).data(), std::get<2>(tuple1).data(), size, aabb.min, aabb.max, rank_aabb.min, rank_aabb.max, cell_spacing, cell_capacity);
}

#endif // INITIALIZE_H

