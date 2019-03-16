#ifndef ANYDSL_INCLUDES_H
#define ANYDSL_INCLUDES_H
#include <cstdint>
extern "C" {
    struct Vector3D {
        double x;
        double y;
        double z;
    };
    int md_initialize_grid(double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double, int);
    void md_copy_data_from_accelerator();
    void md_copy_data_to_accelerator();
    void md_integrate_position(double);
    void md_integrate_velocity(double);
    void md_integration(double);
    int md_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *);
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
    int md_get_sync_timesteps();
    void md_synchronize_ghost_layer();
    int md_get_world_rank();
    int md_get_number_of_particles();
}
#endif // ANYDSL_INCLUDES

