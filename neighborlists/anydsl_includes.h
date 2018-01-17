#ifndef ANYDSL_INCLUDES_H
#define ANYDSL_INCLUDES_H
#include <cstdint>
extern "C" {
		struct Vector3D {
				double x;
				double y;
				double z;
		};
		void cpu_initialize_grid(double const *, Vector3D const *, Vector3D const *, int, double const *, double const *, double, int);
		void cpu_integrate_position(double);
		void cpu_integrate_velocity(double);
		int cpu_write_grid_data_to_arrays(double *, Vector3D *, Vector3D *, int);
		void cpu_redistribute_particles();
		void cpu_initialize_clusters(int);
		void cpu_assemble_neighbor_lists(double);
		void cpu_deallocate_grid();
		void cpu_print_grid();
        void cpu_reset_forces();
		void cpu_compute_forces(double, double, double);
        uint64_t get_number_of_flops();
}
#endif // ANYDSL_INCLUDES

