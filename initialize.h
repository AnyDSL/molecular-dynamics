#ifndef INITIALIZE_H
#define INITIALIZE_H

#include <vector>
#include <string>
#include <cmath>
#include <tuple>
#include <chrono>
#include <random>
#include "anydsl_includes.h"
//---
#ifdef USE_WALBERLA_LOAD_BALANCING
#include <blockforest/BlockForest.h>
#include <blockforest/Initialization.h>
#include <blockforest/loadbalancing/DynamicCurve.h>
#include <blockforest/loadbalancing/DynamicParMetis.h>
#include <blockforest/loadbalancing/InfoCollection.h>
#include <blockforest/loadbalancing/PODPhantomData.h>
#endif

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

AABB get_rank_aabb(AABB aabb) {
    AABB rank_aabb;
    md_get_node_bounding_box(aabb.min, aabb.max, &rank_aabb.min, &rank_aabb.max);
    return rank_aabb;
}

bool is_within_aabb(double x, double y, double z, AABB aabb) {
    return (
        x >= aabb.min[0] && x < aabb.max[0] - 0.00001 &&
        y >= aabb.min[1] && y < aabb.max[1] - 0.00001 &&
        z >= aabb.min[2] && z < aabb.max[2] - 0.00001
    );
}

#ifdef USE_WALBERLA_LOAD_BALANCING
AABB get_rank_aabb_from_block_forest(std::shared_ptr<walberla::BlockForest> forest) {
    AABB rank_aabb;
    auto aabb_union = forest->begin()->getAABB();

    for(auto& iblock: *forest) {
        auto block = static_cast<walberla::blockforest::Block *>(&iblock);
        aabb_union.merge(block->getAABB());
    }

    rank_aabb.min[0] = aabb_union.xMin();
    rank_aabb.max[0] = aabb_union.xMax();
    rank_aabb.min[1] = aabb_union.yMin();
    rank_aabb.max[1] = aabb_union.yMax();
    rank_aabb.min[2] = aabb_union.zMin();
    rank_aabb.max[2] = aabb_union.zMax();

    return rank_aabb;
}

bool is_within_block_forest(double x, double y, double z, std::shared_ptr<walberla::BlockForest> forest) {
    for(auto& iblock: *forest) {
        auto block = static_cast<walberla::blockforest::Block *>(&iblock);

        if(block->getAABB().contains(x, y, z)) {
            return true;
        }
    }

    return false;
}
#endif

std::tuple<std::vector<double>, std::vector<Vector3D>, std::vector<Vector3D>> generate_rectangular_grid(
    AABB aabb,
    double spacing[3],
    double const mass,
    std::function<bool(double, double, double)> is_within_domain) {

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

    for(std::size_t d = 0; d < 3; ++d) {
        nvertices[d] = (int)((aabb.max[d] - aabb.min[d]) / spacing[d]);
        nxyz[d] = nvertices[d] / 2;
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

            if(is_within_domain(pos.x, pos.y, pos.z)) {
                n = k * (2 * nxyz[1]) * (2 * nxyz[0]) + j * (2 * nxyz[0]) + i + 1;

                for(m = 0; m < 5; m++) random(&n);

                vel.x = random(&n);

                for(m = 0; m < 5; m++) random(&n);

                vel.y = random(&n);

                for(m = 0; m < 5; m++) random(&n);

                vel.z = random(&n);

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

int init_rectangular_grid(
    AABB aabb,
    AABB rank_aabb,
    double spacing[3],
    double cell_spacing,
    int cell_capacity,
    int neighborlist_capacity,
    std::function<bool(double, double, double)> is_within_domain) {

    auto tuple = generate_rectangular_grid(aabb, spacing, 1.0, is_within_domain);
    int size = (int) std::get<0>(tuple).size();

    return md_initialize_grid(
        std::get<0>(tuple).data(),
        std::get<1>(tuple).data(),
        std::get<2>(tuple).data(),
        size,
        aabb.min,
        aabb.max,
        rank_aabb.min,
        rank_aabb.max,
        cell_spacing,
        cell_capacity,
        neighborlist_capacity
    );
}


int init_body_collision(
    AABB aabb,
    AABB aabb1,
    AABB aabb2,
    AABB rank_aabb,
    double spacing[3],
    double cell_spacing,
    int cell_capacity,
    int neighborlist_capacity,
    std::function<bool(double, double, double)> is_within_domain) {

    if(aabb1.min[1] < aabb2.max[1]) {
        std::cerr << "The first bounding box must be located on top of the second!" << std::endl;
        std::cerr << "aabb1: " << aabb1.min[1] << " aabb2: " << aabb2.max[1] << std::endl;
        return 0;
    }

    /*
    double velocity1[3];
    double velocity2[3];

    velocity1[0] = 0;
    velocity1[1] = -velocity;
    velocity1[2] = 0;

    velocity2[0] = 0;
    velocity2[1] = velocity;
    velocity2[2] = 0;
    */

    auto tuple1 = generate_rectangular_grid(aabb1, spacing, 1.0, is_within_domain);
    auto tuple2 = generate_rectangular_grid(aabb2, spacing, 1.0, is_within_domain);

    std::get<0>(tuple1).insert(std::get<0>(tuple1).end(), std::get<0>(tuple2).begin(), std::get<0>(tuple2).end());
    std::get<1>(tuple1).insert(std::get<1>(tuple1).end(), std::get<1>(tuple2).begin(), std::get<1>(tuple2).end());
    std::get<2>(tuple1).insert(std::get<2>(tuple1).end(), std::get<2>(tuple2).begin(), std::get<2>(tuple2).end());

    int size = (int) std::get<0>(tuple1).size();

    return md_initialize_grid(
        std::get<0>(tuple1).data(),
        std::get<1>(tuple1).data(),
        std::get<2>(tuple1).data(),
        size,
        aabb.min,
        aabb.max,
        rank_aabb.min,
        rank_aabb.max,
        cell_spacing,
        cell_capacity,
        neighborlist_capacity
    );
}

#endif // INITIALIZE_H

