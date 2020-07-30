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

double random(int* idum) {
    int k;
    double ans;

    k = (*idum) / IQ;
    *idum = IA * (*idum - k * IQ) - IR * k;

    if(*idum < 0) *idum += IM;

    ans = AM * (*idum);
    return ans;
}

bool is_within_aabb(double x, double y, double z, double aabb[6]) {
    return (
        x >= aabb[0] && x < aabb[1] - 0.00001 &&
        y >= aabb[2] && y < aabb[3] - 0.00001 &&
        z >= aabb[4] && z < aabb[5] - 0.00001
    );
}

#ifdef USE_WALBERLA_LOAD_BALANCING
using namespace walberla;

void getBlockForestAABB(shared_ptr<BlockForest> forest, double (&rank_aabb)[6]) {
    auto aabb_union = forest->begin()->getAABB();

    for(auto& iblock: *forest) {
        auto block = static_cast<blockforest::Block *>(&iblock);
        aabb_union.merge(block->getAABB());
    }

    rank_aabb[0] = aabb_union.xMin();
    rank_aabb[1] = aabb_union.xMax();
    rank_aabb[2] = aabb_union.yMin();
    rank_aabb[3] = aabb_union.yMax();
    rank_aabb[4] = aabb_union.zMin();
    rank_aabb[5] = aabb_union.zMax();
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
    double aabb[6], bool half,
    double spacing, double const mass, double const velocity[3], bool fixed_velocity,
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
        nvertices[d] = (int)((aabb[d * 2 + 1] - aabb[d * 2 + 0]) / spacing);
        nxyz[d] = nvertices[d] / 2;
    }

    int ilo = static_cast<int>(aabb[0] / spacing - 1);
    int ihi = static_cast<int>(aabb[1] / spacing + 1);
    int jlo = static_cast<int>(aabb[2] / spacing - 1);
    int jhi = static_cast<int>(aabb[3] / spacing + 1);
    int klo = static_cast<int>(aabb[4] / spacing - 1);
    int khi = static_cast<int>(aabb[5] / spacing + 1);

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
            pos.x = aabb[0] + i * spacing;
            pos.y = aabb[2] + j * spacing;
            pos.z = aabb[4] + k * spacing;

            if(is_within_domain(pos.x, pos.y, pos.z) && (!half || pos.y < aabb[2] + ((jhi - jlo) / 2) * spacing + 0.00001)) {
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
    double aabb[6], double rank_aabb[6], bool half,
    double spacing, double cell_spacing,
    int cell_capacity, int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    double velocity[3] = {0.0, 0.0, 0.0};
    auto tuple = generate_rectangular_grid(aabb, half, spacing, 1.0, velocity, false, is_within_domain);
    int size = (int) get<0>(tuple).size();

    return md_initialize_grid(
        get<0>(tuple).data(),
        get<1>(tuple).data(),
        get<2>(tuple).data(),
        size,
        aabb,
        rank_aabb,
        cell_spacing,
        cell_capacity,
        neighborlist_capacity
    );
}

int init_granular_gas(
    double aabb[6], double rank_aabb[6],
    double cell_spacing,
    int cell_capacity, int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    vector<double> masses;
    vector<Vector3D> positions;
    vector<Vector3D> velocities;
    Vector3D center;
    Vector3D normal;
    Vector3D shift;
    double const spacing = 1.0;

    center.x = aabb[0] + (aabb[1] - aabb[0]) * 0.5;
    center.y = aabb[2] + (aabb[3] - aabb[2]) * 0.5;
    center.z = aabb[4] + (aabb[5] - aabb[4]) * 0.5;

    normal.x = 1.0;
    normal.y = 1.0;
    normal.z = 1.0;

    shift.x = 0.01;
    shift.y = 0.01;
    shift.z = 0.01;

    int nx = (int)((aabb[1] - aabb[0]) / spacing);
    int ny = (int)((aabb[3] - aabb[2]) / spacing);
    int nz = (int)((aabb[5] - aabb[4]) / spacing);

    for(int x = 0; x < nx; x++) {
        for(int y = 0; y < ny; y++) {
            for(int z = 0; z < nz; z++) {
                Vector3D pos;
                Vector3D vel;
                Vector3D dis;

                pos.x = aabb[0] + (double) x * spacing + spacing * 0.5 + shift.x;
                pos.y = aabb[2] + (double) y * spacing + spacing * 0.5 + shift.y;
                pos.z = aabb[4] + (double) z * spacing + spacing * 0.5 + shift.z;

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
        aabb,
        rank_aabb,
        cell_spacing,
        cell_capacity,
        neighborlist_capacity
    );
}

int init_body_collision(
    double aabb[6], double aabb1[6], double aabb2[6], double rank_aabb[6],
    double cell_spacing, int cell_capacity, int neighborlist_capacity,
    function<bool(double, double, double)> is_within_domain) {

    vector<Vector3D> positions;
    vector<Vector3D> velocities;
    vector<double> masses;
    double const spacing = 1.0;
    double const velocity = 5.0;

    if(aabb1[2] < aabb2[3]) {
        cerr << "The first bounding box must be located on top of the second!" << endl;
        cerr << "aabb1: " << aabb1[2] << " aabb2: " << aabb2[3] << endl;
        return 0;
    }

    int nx = static_cast<int>(aabb1[1] - aabb1[0] / spacing);
    int ny = static_cast<int>(aabb1[3] - aabb1[2] / spacing);
    int nz = static_cast<int>(aabb1[5] - aabb1[4] / spacing);

    for(int x = 0; x < nx; ++x) {
        for(int y = 0; y < ny; ++y) {
            for(int z = 0; z < nz; ++z) {
                Vector3D pos, vel;

                vel.x = 0.0;
                vel.z = 0.0;

                pos.x = aabb1[0] + (double) x * spacing + spacing * 0.5;
                pos.y = aabb1[2] + (double) y * spacing + spacing * 0.5;
                pos.z = aabb1[4] + (double) z * spacing + spacing * 0.5;

                if(is_within_domain(pos.x, pos.y, pos.z)) {
                    vel.y = -velocity;
                    masses.push_back(1.0);
                    positions.push_back(pos);
                    velocities.push_back(vel);
                }

                pos.x = aabb2[0] + (double) x * spacing + spacing * 0.5;
                pos.y = aabb2[2] + (double) y * spacing + spacing * 0.5;
                pos.z = aabb2[4] + (double) z * spacing + spacing * 0.5;

                if(is_within_domain(pos.x, pos.y, pos.z)) {
                    vel.y = velocity;
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
        aabb,
        rank_aabb,
        cell_spacing,
        cell_capacity,
        neighborlist_capacity
    );
}

#endif // INITIALIZE_H

