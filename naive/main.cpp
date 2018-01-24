#include <cstdlib>
#include <iostream>
#include <random>
#include <chrono>


void integrate_position(int const size, double * __restrict__ positions, double * __restrict__ forces, double const * __restrict__ velocities, double const dt) {
    for(int i = 0; i < size * 3; ++i) {
        positions[i] += dt * velocities[i];
        forces[i] = 0.0;
    }
}

void integrate_velocities(int const size, double const * __restrict__ masses, double * __restrict__ velocities, double const * __restrict__ forces, double const dt) {
    for(int i = 0; i < size; ++i) {
        double const inverse_mass = 1.0 / masses[i];
        int const base = i * 3;
        for(int j = 0; j < 3; ++j) {
            velocities[base + j] += dt * forces[base + j] * inverse_mass;
        }
    }
}

void compute_forces(int const size, double const * __restrict__ positions, double * __restrict__ forces, double const squared_cutoff_radius, double const tmp1, double const tmp2) {
    for(int i = 0; i < size; ++i) {
        for(int j = i + 1; j < size; ++j) {
            int const base_i = i * 3;
            int const base_j = j * 3;
            double const dx = positions[base_j] - positions[base_i];
            double const dy = positions[base_j + 1] - positions[base_i + 1];
            double const dz = positions[base_j + 2] - positions[base_i + 2];
            double const squared_distance = dx*dx + dy*dy + dz*dz;
            if(squared_distance < squared_cutoff_radius) {
                double const distance_4 = squared_distance * squared_distance;
                double const distance_8_inv = 1.0 / (distance_4 * distance_4);
                double const f = tmp1 * distance_8_inv * (1.0 - squared_distance * distance_8_inv * tmp2);
                forces[base_i] += f * dx;
                forces[base_i + 1] += f * dy;
                forces[base_i + 2] += f * dz;
                forces[base_j] -= f * dx;
                forces[base_j + 1] -= f * dy;
                forces[base_j + 2] -= f * dz;
            }
        }
    }
}

int main(int argc, char **argv)
{
    if(argc < 3) {
        std::cout << "Usage: " << argv[0] << " particles timesteps" << std::endl;
        return EXIT_FAILURE;
    }
    int const size = atoi(argv[1]);
    int const steps = atoi(argv[2]);
    unsigned seed = std::chrono::high_resolution_clock::now().time_since_epoch().count();
    std::mt19937_64 random_engine(seed);
    std::uniform_real_distribution<double> velocity_distribution(-1.0, 1.0);
    std::uniform_real_distribution<double> position_distribution(0.0, 10.0);
    double * __restrict__ masses = (double * __restrict__)malloc(size * sizeof(double));
    double * __restrict__ positions = (double * __restrict__)malloc(size * 3 *sizeof(double));
    double * __restrict__ velocities = (double * __restrict__)malloc(size * 3 * sizeof(double));
    double * __restrict__ forces = (double * __restrict__)malloc(size * 3 * sizeof(double));


    for(int i = 0; i < size; ++i) {
        masses[i] = 1.0;
    }

    for(int i = 0; i < size * 3; ++i) {
        positions[i] = position_distribution(random_engine);
        velocities[i] = velocity_distribution(random_engine);
    }
    double const dt = 1e-3;
    double const tmp1 = 24.0;
    double const tmp2 = 2.0;
    double const cutoff_radius = 2.5;
    double const squared_cutoff_radius = cutoff_radius * cutoff_radius;
    for(int i = 0; i < steps; ++i) {
        integrate_position(size, positions, forces, velocities, dt);
        compute_forces(size, positions, forces, squared_cutoff_radius, tmp1, tmp2);
        integrate_velocities(size, masses, velocities, forces, dt);
    }
    free(masses);
    free(positions);
    free(velocities);
    free(forces);

}

