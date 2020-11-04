#ifndef ANYDSL_INCLUDES_H
#define ANYDSL_INCLUDES_H
#include <cstdint>
extern "C" {
    struct Vector3D {
        double x;
        double y;
        double z;
    };
    int md_initialize_grid(double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double, int, int);
    void md_rescale_grid(double const *);
    void md_copy_data_from_accelerator();
    void md_copy_data_to_accelerator();
    void md_initial_integration(double);
    void md_final_integration(double);
    void md_enforce_pbc();
    int md_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *);
    int md_write_grid_ghost_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *);
    int md_write_grid_aabb_data_to_arrays(double *, Vector3D *, Vector3D *, Vector3D *);
    int md_add_region(double, double, double, double, double, double);
    void md_assign_particle_regions();
    void md_distribute_particles();
    void md_assemble_neighborlists(bool, double);
    void md_deallocate_grid();
    void md_print_grid();
    void md_print_ghost();
    void md_create_velocity(double);
    void md_compute_lennard_jones(bool, double, double, double);
    void md_compute_stillinger_weber(bool, double);
    void md_compute_dem(bool, double, double, double, double, double);
    void md_compute_eam(bool, double);
    void md_compute_eam_config(bool, double);
    void md_mpi_initialize();
    void md_mpi_finalize();
    void md_synchronize_ghost_layer();
    void md_borders();
    void md_exchange_particles();
    double md_get_send_buffer_value(int);
    void md_set_recv_buffer_value(int, double);
    void md_resize_recv_buffer_capacity(int);
    int md_serialize_particles(double const *);
    void md_deserialize_particles(int);
    int md_get_world_size();
    int md_get_world_rank();
    int md_get_number_of_particles();
    int md_get_number_of_ghost_particles();
    void md_get_node_bounding_box(double const *, double (*)[6]);
    void md_compute_boundary_weights(double, double, double, double, double, double, unsigned long int *, unsigned long int *);
    void md_update_neighborhood(int, int, int const *, int const *, double const *);
    void md_report_iterations();
    void md_report_particles();
    void md_report_time(double, double, double, double, double, double);
    void md_barrier();
    void md_get_material_position(int, double *, double *, double *);
    void md_get_position(int, double *, double *, double *);
    void md_set_position(int, double, double, double);
    void md_get_force(int, double *, double *, double *);
    void md_remove_neighbor(int, int);
    int md_get_number_of_neighbors(int);
    int md_get_particle_region(int);
    int md_sort_particles_by_region(int *, int);
}
#endif // ANYDSL_INCLUDES

