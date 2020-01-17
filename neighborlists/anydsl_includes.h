#ifndef ANYDSL_INCLUDES_H
#define ANYDSL_INCLUDES_H
#include <cstdint>
extern "C" {
    struct Vector3D {
        double x;
        double y;
        double z;
    };
    int md_initialize_grid(
        double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double const *, double const *,
        double, int, int, int
    );
    void md_copy_data_from_accelerator();
    void md_copy_data_to_accelerator();
    void md_integration(double);
    int md_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *);
    void md_redistribute_particles();
    void md_initialize_clusters();
    void md_assemble_neighborlists(double);
    void md_deallocate_grid();
    void md_print_grid();
    void md_compute_forces(double, double, double);
    double md_compute_total_kinetic_energy();
    uint64_t get_number_of_flops();
    void md_set_thread_count(int);
    void md_mpi_initialize();
    void md_mpi_finalize();
    int md_get_sync_timesteps();
    void md_synchronize_ghost_layer();
    void md_exchange_ghost_layer();
    int md_get_world_rank();
    int md_get_number_of_particles();
    void md_get_node_bounding_box(double, double const *, double const *, double (*)[3], double (*)[3]);
    void md_report_iterations();
    void md_report_particles();
    void md_report_time(double, double, double, double, double);
    void md_report_memory_allocation();
}
#endif // ANYDSL_INCLUDES

