#ifndef ANYDSL_INCLUDES_H
#define ANYDSL_INCLUDES_H
#include <cstdint>
extern "C" {
    struct Vector3D {
        double x;
        double y;
        double z;
    };
    void md_initialize_grid(double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double, int);
    void md_copy_data_from_accelerator();
    void md_copy_data_to_accelerator();
    void md_integrate_position(double);
    void md_integrate_velocity(double);
    void md_integration(double);
    int md_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *, int);
    void md_redistribute_particles();
    void md_initialize_clusters(int);
    void md_assemble_neighbor_lists(double);
    void md_deallocate_grid();
    void md_print_grid();
    void md_reset_forces();
    void md_compute_forces(double, double, double);
    double md_compute_total_kinetic_energy();
    uint64_t get_number_of_flops();
    void md_set_thread_count(int);
    void md_mpi_initialize();
    void md_mpi_finalize();
    void md_mpi_distribute_data(int, int);
}
#endif // ANYDSL_INCLUDES

