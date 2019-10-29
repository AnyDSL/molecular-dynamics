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

/* Random function from miniMD (used to validate our results) */
#define IA 16807
#define IM 2147483647
#define AM (1.0/IM)
#define IQ 127773
#define IR 2836
#define MASK 123459876

double random(int* idum) {
    int k;
    double ans;

    k = (*idum) / IQ;
    *idum = IA * (*idum - k * IQ) - IR * k;

    if(*idum < 0) *idum += IM;

    ans = AM * (*idum);
    return ans;
}

std::tuple<std::vector<double>, std::vector<Vector3D>, std::vector<Vector3D>> generate_rectangular_grid(AABB aabb, AABB rank_aabb, double spacing[3], double const mass, double velocity[3]) {
    int nvertices[3];
    int nxyz[3];
    int size = 0;
    int i, j, k, m, n;
    int sx = 0;
    int sy = 0;
    int sz = 0;
    int ox = 0;
    int oy = 0;
    int oz = 0;
    int subboxdim = 8;

    std::vector<Vector3D> positions;
    std::vector<Vector3D> velocities;

    for(int i = 0; i < 3; ++i) {
        nvertices[i] = (aabb.max[i] - aabb.min[i]) / spacing[i];
        nxyz[i] = nvertices[i] / 2;
    }

    int ilo = static_cast<int>(aabb.min[0] / spacing[0] - 1);
    int ihi = static_cast<int>(aabb.max[0] / spacing[0] + 1);
    int jlo = static_cast<int>(aabb.min[1] / spacing[1] - 1);
    int jhi = static_cast<int>(aabb.max[1] / spacing[1] + 1);
    int klo = static_cast<int>(aabb.min[2] / spacing[2] - 1);
    int khi = static_cast<int>(aabb.max[2] / spacing[2] + 1);

    ilo = std::max(ilo, 0);
    ihi = std::min(ihi, nvertices[0] - 1);
    jlo = std::max(jlo, 0);
    jhi = std::min(jhi, nvertices[1] - 1);
    klo = std::max(klo, 0);
    khi = std::min(khi, nvertices[2] - 1);

    while(oz * subboxdim <= khi) {
        k = oz * subboxdim + sz;
        j = oy * subboxdim + sy;
        i = ox * subboxdim + sx;

        if((i + j + k) % 2 == 0 &&
           (i >= ilo) && (i <= ihi) &&
           (j >= jlo) && (j <= jhi) &&
           (k >= klo) && (k <= khi)) {
            Vector3D pos, vel;

            pos.x = aabb.min[0] + i * spacing[0];
            pos.y = aabb.min[1] + j * spacing[1];
            pos.z = aabb.min[2] + k * spacing[2];

            if(
                pos.x >= rank_aabb.min[0] && pos.x < rank_aabb.max[0] &&
                pos.y >= rank_aabb.min[1] && pos.y < rank_aabb.max[1] &&
                pos.z >= rank_aabb.min[2] && pos.z < rank_aabb.max[2]
            ) {
              n = k * (2 * nxyz[1]) * (2 * nxyz[0]) + j * (2 * nxyz[0]) + i + 1;

              for(m = 0; m < 5; m++) random(&n);

              vel.x = random(&n);

              for(m = 0; m < 5; m++) random(&n);

              vel.y = random(&n);

              for(m = 0; m < 5; m++) random(&n);

              vel.z = random(&n);

              //std::cout << pos.x << " " << pos.y << " " << pos.z << " --- " << vel.x << " " << vel.y << " " << vel.z << "\n";
              positions.push_back(pos);
              velocities.push_back(vel);
              size++;
            }
        }

        sx++;

        if(sx == subboxdim) {
          sx = 0;
          sy++;
        }

        if(sy == subboxdim) {
          sy = 0;
          sz++;
        }

        if(sz == subboxdim) {
          sz = 0;
          ox++;
        }

        if(ox * subboxdim > ihi) {
          ox = 0;
          oy++;
        }

        if(oy * subboxdim > jhi) {
          oy = 0;
          oz++;
        }
    }

    std::vector<double> masses(size, mass);
    return std::make_tuple(masses, positions, velocities);
}

int init_rectangular_grid(unsigned seed, AABB aabb, double spacing[3], double maximum_velocity, double cell_spacing, int cell_capacity, int neighbor_list_capacity) {
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

    /*for(int i = 0; i < size; i++) {
                std::cout << "Position: " << positions[i].x << " " << positions[i].y << " " << positions[i].z << "\n";
        }*/
    auto size = std::get<0>(tuple).size();
    return md_initialize_grid(std::get<0>(tuple).data(), std::get<1>(tuple).data(), std::get<2>(tuple).data(), size, ext_aabb.min, ext_aabb.max, rank_aabb.min, rank_aabb.max, cell_spacing, cell_capacity, neighbor_list_capacity);
}


int init_body_collision(unsigned const seed, AABB aabb1, AABB aabb2, double spacing1[3], double spacing2[3], double mass1, double mass2, double velocity, double cell_spacing, int cell_capacity, int neighbor_list_capacity) {
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
    return md_initialize_grid(std::get<0>(tuple1).data(), std::get<1>(tuple1).data(), std::get<2>(tuple1).data(), size, aabb.min, aabb.max, rank_aabb.min, rank_aabb.max, cell_spacing, cell_capacity, neighbor_list_capacity);
}

#endif // INITIALIZE_H

