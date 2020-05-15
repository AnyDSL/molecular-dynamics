#ifndef INITIALIZE_H
#define INITIALIZE_H

#include <vector>
#include <string>
#include <cmath>
#include <tuple>
#include <chrono>
#include <random>
//---
#include "anydsl_includes.h"

#ifdef USE_WALBERLA_LOAD_BALANCING
#include <blockforest/BlockForest.h>
#include <blockforest/Initialization.h>
#include <blockforest/loadbalancing/DynamicCurve.h>
#include <blockforest/loadbalancing/DynamicDiffusive.h>
#include <blockforest/loadbalancing/DynamicParMetis.h>
#include <blockforest/loadbalancing/InfoCollection.h>
#include <blockforest/loadbalancing/PODPhantomData.h>
#include <pe/amr/level_determination/MinMaxLevelDetermination.h>
#include <pe/amr/weight_assignment/MetisAssignmentFunctor.h>
#include <pe/amr/weight_assignment/WeightAssignmentFunctor.h>
//---
#include "MDDataHandling.h"
#endif

/* Random function from miniMD (used to validate our results) */
#define IA 16807
#define IM 2147483647
#define AM (1.0/IM)
#define IQ 127773
#define IR 2836
#define MASK 123459876

using namespace std;

struct AABB {
		double min[3];
		double max[3];
};

double random(int* idum) {
    int k;
    double ans;

    k = (*idum) / IQ;
    *idum = IA * (*idum - k * IQ) - IR * k;

    if(*idum < 0) *idum += IM;

    ans = AM * (*idum);
    return ans;
}

::AABB get_rank_aabb(::AABB aabb) {
    ::AABB rank_aabb;
    md_get_node_bounding_box(aabb.min, aabb.max, &rank_aabb.min, &rank_aabb.max);
    return rank_aabb;
}

bool is_within_aabb(double x, double y, double z, ::AABB aabb) {
    return (
        x >= aabb.min[0] && x < aabb.max[0] - 0.00001 &&
        y >= aabb.min[1] && y < aabb.max[1] - 0.00001 &&
        z >= aabb.min[2] && z < aabb.max[2] - 0.00001
    );
}

#ifdef USE_WALBERLA_LOAD_BALANCING
using namespace walberla;

::AABB getBlockForestAABB(shared_ptr<BlockForest> forest) {
    ::AABB rank_aabb;
    auto aabb_union = forest->begin()->getAABB();

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
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

bool isWithinBlockForest(double x, double y, double z, shared_ptr<BlockForest> forest) {
    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);

        if(block->getAABB().contains(x, y, z)) {
            return true;
        }
    }

    return false;
}
#endif

tuple<vector<double>, vector<Vector3D>, vector<Vector3D>> generate_rectangular_grid(
    ::AABB aabb,
    bool half,
    double spacing[3],
    double const mass,
    double const velocity[3],
    bool fixed_velocity,
    function<bool(double, double, double)> is_within_domain) {

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

    vector<Vector3D> positions;
    vector<Vector3D> velocities;
    Vector3D pos, vel;

    for(size_t d = 0; d < 3; ++d) {
        nvertices[d] = (int)((aabb.max[d] - aabb.min[d]) / spacing[d]);
        nxyz[d] = nvertices[d] / 2;
    }

    int ilo = static_cast<int>(aabb.min[0] / spacing[0] - 1);
    int ihi = static_cast<int>(aabb.max[0] / spacing[0] + 1);
    int jlo = static_cast<int>(aabb.min[1] / spacing[1] - 1);
    int jhi = static_cast<int>(aabb.max[1] / spacing[1] + 1);
    int klo = static_cast<int>(aabb.min[2] / spacing[2] - 1);
    int khi = static_cast<int>(aabb.max[2] / spacing[2] + 1);

    ilo = max(ilo, 0);
    ihi = min(ihi, nvertices[0] - 1);
    jlo = max(jlo, 0);
    jhi = min(jhi, nvertices[1] - 1);
    klo = max(klo, 0);
    khi = min(khi, nvertices[2] - 1);

    vel.x = velocity[0];
    vel.y = velocity[1];
    vel.z = velocity[2];

    while(oz * subboxdim <= khi) {
        k = oz * subboxdim + sz;
        j = oy * subboxdim + sy;
        i = ox * subboxdim + sx;

        if((i + j + k) % 2 == 0 &&
           (i >= ilo) && (i <= ihi) &&
           (j >= jlo) && (j <= jhi) &&
           (k >= klo) && (k <= khi)) {
            pos.x = aabb.min[0] + i * spacing[0];
            pos.y = aabb.min[1] + j * spacing[1];
            pos.z = aabb.min[2] + k * spacing[2];

            if(is_within_domain(pos.x, pos.y, pos.z) && (!half || pos.y < aabb.min[1] + ((jhi - jlo) / 2) * spacing[1] + 0.00001)) {
                if(!fixed_velocity) {
                    n = k * (2 * nxyz[1]) * (2 * nxyz[0]) + j * (2 * nxyz[0]) + i + 1;

                    for(m = 0; m < 5; m++) random(&n);

                    vel.x = random(&n);

                    for(m = 0; m < 5; m++) random(&n);

                    vel.y = random(&n);

                    for(m = 0; m < 5; m++) random(&n);

                    vel.z = random(&n);
                }

                velocities.push_back(vel);
                positions.push_back(pos);
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

    vector<double> masses(size, mass);
    return make_tuple(masses, positions, velocities);
}

int init_rectangular_grid(
    ::AABB aabb,
    ::AABB rank_aabb,
    bool half,
    double spacing[3],
    double cell_spacing,
    int cell_capacity,
    int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    double velocity[3] = {0.0, 0.0, 0.0};
    auto tuple = generate_rectangular_grid(aabb, half, spacing, 1.0, velocity, false, is_within_domain);
    int size = (int) get<0>(tuple).size();

    return md_initialize_grid(
        get<0>(tuple).data(),
        get<1>(tuple).data(),
        get<2>(tuple).data(),
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

int init_granular_gas(
    ::AABB aabb,
    ::AABB rank_aabb,
    double cell_spacing,
    int cell_capacity,
    int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    vector<double> masses;
    vector<Vector3D> positions;
    vector<Vector3D> velocities;
    Vector3D center;
    Vector3D normal;
    Vector3D shift;
    double spacing = 1.0;

    center.x = aabb.min[0] + (aabb.max[0] - aabb.min[0]) * 0.5;
    center.y = aabb.min[1] + (aabb.max[1] - aabb.min[1]) * 0.5;
    center.z = aabb.min[2] + (aabb.max[2] - aabb.min[2]) * 0.5;

    normal.x = 1.0;
    normal.y = 1.0;
    normal.z = 1.0;

    shift.x = 0.01;
    shift.y = 0.01;
    shift.z = 0.01;

    int nx = (int)((aabb.max[0] - aabb.min[0]) / spacing);
    int ny = (int)((aabb.max[1] - aabb.min[1]) / spacing);
    int nz = (int)((aabb.max[2] - aabb.min[2]) / spacing);

    for(int x = 0; x < nx; x++) {
        for(int y = 0; y < ny; y++) {
            for(int z = 0; z < nz; z++) {
                Vector3D pos;
                Vector3D vel;
                Vector3D dis;

                pos.x = aabb.min[0] + (double) x * spacing + spacing * 0.5 + shift.x;
                pos.y = aabb.min[1] + (double) y * spacing + spacing * 0.5 + shift.y;
                pos.z = aabb.min[2] + (double) z * spacing + spacing * 0.5 + shift.z;

                vel.x = 0.0;
                vel.y = 0.0;
                vel.z = 0.0;

                dis.x = pos.x - center.x;
                dis.y = pos.y - center.y;
                dis.z = pos.z - center.z;

                if(is_within_domain(pos.x, pos.y, pos.z) && dis.x * normal.x + dis.y * normal.y + dis.z * normal.z < 0.0) {
                    masses.push_back(1.0);
                    positions.push_back(pos);
                    velocities.push_back(vel);
                }
            }
        }
    }

    return md_initialize_grid(
        masses.data(),
        positions.data(),
        velocities.data(),
        (int) positions.size(),
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
    ::AABB aabb,
    ::AABB aabb1,
    ::AABB aabb2,
    ::AABB rank_aabb,
    double spacing[3],
    double cell_spacing,
    int cell_capacity,
    int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    double const velocity = 1.0;
    double velocity1[3] = {0.0, -velocity, 0.0};
    double velocity2[3] = {0.0, velocity,  0.0};

    if(aabb1.min[1] < aabb2.max[1]) {
        cerr << "The first bounding box must be located on top of the second!" << endl;
        cerr << "aabb1: " << aabb1.min[1] << " aabb2: " << aabb2.max[1] << endl;
        return 0;
    }

    auto tuple1 = generate_rectangular_grid(aabb1, false, spacing, 1.0, velocity1, true, is_within_domain);
    auto tuple2 = generate_rectangular_grid(aabb2, false, spacing, 1.0, velocity2, true, is_within_domain);

    get<0>(tuple1).insert(get<0>(tuple1).end(), get<0>(tuple2).begin(), get<0>(tuple2).end());
    get<1>(tuple1).insert(get<1>(tuple1).end(), get<1>(tuple2).begin(), get<1>(tuple2).end());
    get<2>(tuple1).insert(get<2>(tuple1).end(), get<2>(tuple2).begin(), get<2>(tuple2).end());

    int size = (int) get<0>(tuple1).size();

    return md_initialize_grid(
        get<0>(tuple1).data(),
        get<1>(tuple1).data(),
        get<2>(tuple1).data(),
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

