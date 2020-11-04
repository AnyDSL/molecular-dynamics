#include <cstdint>
#include <iostream>
#include <fstream>
#include <functional>
#include <string>
#include <utility>
#include <getopt.h>
//---
#include "anydsl_includes.h"
#include "initialize.h"
#include "vtk.h"
#include "ceres/ceres.h"
//---
#include "MultiTimer.h"
#ifdef LIKWID_PERFMON
#include <likwid.h>
#else
#define LIKWID_MARKER_INIT
#define LIKWID_MARKER_THREADINIT
#define LIKWID_MARKER_SWITCH
#define LIKWID_MARKER_REGISTER(regionTag)
#define LIKWID_MARKER_START(regionTag)
#define LIKWID_MARKER_STOP(regionTag)
#define LIKWID_MARKER_CLOSE
#define LIKWID_MARKER_GET(regionTag, nevents, events, time, count)
#endif

#if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
#include <x86intrin.h>
#endif

using namespace std;

void print_usage(char *name) {
    cout << "Usage: " << name << " [OPTION]..." << endl;
    cout << "A fast, scalable and portable application for pair-wise interactions implemented in AnyDSL." << endl << endl;
    cout << "Mandatory arguments to long options are also mandatory for short options." << endl;
    cout << "\t-f, --force_field=STRING  force field to use (options are lj and dem, default is lj)." << endl;
    cout << "\t-b, --benchmark=STRING    benchmark to use (options are default, half, body_collision and granular_gas)." << endl;
    cout << "\t-x, --nx=SIZE             number of unit cells in x dimension (default 32)." << endl;
    cout << "\t-y, --ny=SIZE             number of unit cells in y dimension (default 32)." << endl;
    cout << "\t-z, --nz=SIZE             number of unit cells in z dimension (default 32)." << endl;
    cout << "\t-s, --timesteps=NUMBER    number of timesteps in the simulation (default 100)." << endl;
    cout << "\t-r, --runs=NUMBER         number of test runs (default 1)." << endl;
    cout << "\t-t, --threads=NUMBER      number of threads to run (default 1)." << endl;
    cout << "\t-a, --algorithm=STRING    load balancing algorithm to use." << endl;
    cout << "\t-v, --vtk=DIRECTORY       VTK output directory (for MPI simulations, the rank number is concatenated" << endl;
    cout << "\t                          at the end of this name, i.e. output[0-3] when using --vtk=output and 4 ranks)." << endl;
    cout << "\t                          VTK directories are NOT automatically created and therefore must exist." << endl;
    cout << "\t    --reneigh=NUMBER      timesteps to simulate before reneighboring (default 20)." << endl;
    cout << "\t    --rebalance=NUMBER    timesteps to simulate before load balancing (default 100)." << endl;
    cout << "\t    --dt=REAL             timestep size (default 0.005)." << endl;
    cout << "\t    --temp=REAL           initial temperature (default 1.44)." << endl;
    cout << "\t    --cutoff=REAL         cutoff radius (default 2.5)." << endl;
    cout << "\t    --verlet=REAL         verlet buffer (default 0.3)." << endl;
    cout << "\t    --epsilon=REAL        epsilon value for Lennard-Jones force-field (default 1.0)." << endl;
    cout << "\t    --sigma=REAL          sigma value for Lennard-Jones force-field (default 1.0)." << endl;
    cout << "\t    --damping_n=REAL      Normal damping for DEM force-field (default 0.0)." << endl;
    cout << "\t    --damping_t=REAL      Tangential damping for DEM force-field (default 0.0)." << endl;
    cout << "\t    --stiffness=REAL      Stiffness for DEM force-field (default 0.0)." << endl;
    cout << "\t    --friction=REAL       Friction for DEM force-field (default 0.0)." << endl;
    cout << "\t    --potmin=REAL         potential minimum (default 1.6796)." << endl;
    cout << "\t    --half_nb             compute with half neighbor list." << endl;
    cout << "\t    --prebalance          perform static load balancing before execution." << endl;
    cout << "\t-h, --help                display this help message." << endl;
}

void vtk_write_local_data(string filename) {
    const int size = md_get_number_of_particles();
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

void vtk_write_ghost_data(string filename) {
    const int size = md_get_number_of_ghost_particles();
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_ghost_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

void vtk_write_aabb_data(string filename) {
    const int size = 8;
    vector<double> masses(size);
    vector<Vector3D> positions(size);
    vector<Vector3D> velocities(size);
    vector<Vector3D> forces(size);

    md_write_grid_aabb_data_to_arrays(masses.data(), positions.data(), velocities.data(), forces.data());
    write_vtk_to_file(filename, masses, positions, velocities, forces);
}

class MolecularStatic : public ceres::FirstOrderFunction {
private:
	int dof;
    bool half_nb;
    double cutoff_radius;

public:
    MolecularStatic(int dof_, bool half_nb_, double cutoff_radius_) : dof(dof_), half_nb(half_nb_), cutoff_radius(cutoff_radius_) {}
	virtual bool Evaluate (const double *parameters, double *cost, double *gradient) const {
        for(int i = 0; i < dof; i++) {
            md_set_position(i, parameters[i * 3 + 0], parameters[i * 3 + 1], parameters[i * 3 + 2]);
        }

        if(gradient != NULL) {
            md_compute_eam(half_nb, cutoff_radius);

            int iter_force = 0;
            double fx, fy, fz;
            for(int i = 0; i < dof; i++) {
                md_get_force(i, &fx, &fy, &fz);
                gradient[i * 3 + 0] = fx;
                gradient[i * 3 + 1] = fy;
                gradient[i * 3 + 2] = fz;

                //gradient[iter_force]=-1*atom_morse_force.GetXCoord()-1*atom_embedding_force.GetXCoord();
                //gradient[iter_force+1]=-1*atom_morse_force.GetYCoord()-1*atom_embedding_force.GetYCoord();
                //gradient[iter_force+2]=-1*atom_morse_force.GetZCoord()-1*atom_embedding_force.GetZCoord();
            }
        }


        //cost[0] = md_energy_morse() + md_energy_embedding();
        cout << "eng:" << cost[0] << endl;
        return true;
	}

	virtual int NumParameters() const {
	    return dof;
	}
};

int main(int argc, char **argv) {
    using namespace placeholders;

    // Force flush to zero mode for denormals
    #if defined(__x86_64__) || defined(__amd64__) || defined(_M_X64)
    _mm_setcsr(_mm_getcsr() | (_MM_FLUSH_ZERO_ON | _MM_DENORMALS_ZERO_ON));
    #endif

    string benchmark = "default";
    string force_field = "lj";
    string algorithm;
    string vtk_directory;
    int gridsize[3] = {32, 32, 32};
    int steps = 100;
    int runs = 1;
    int nthreads = 1;
    int reneigh_every = 20;
    int rebalance_every = 100;
    double dt = 0.005;
    double cutoff_radius = 2.6;
    double verlet_buffer = 0.0;
    double epsilon = 1.0;
    double sigma = 1.0;
    double potential_minimum = 1.6796;
    double init_temp = 1.44;
    double damping_n = 0.0;
    double damping_t = 0.0;
    double stiffness = 0.0;
    double friction = 0.0;
    double lattice_const = 3.615;
    //double lattice_const = 5.4310;
    bool half = false;
    bool half_nb = false;
    bool use_walberla = false;
    bool prebalance = false;

    int opt = 0;
    struct option long_opts[] = {
        {"force_field", required_argument,    nullptr,    'f'},
        {"benchmark",   required_argument,    nullptr,    'b'},
        {"nx",          required_argument,    nullptr,    'x'},
        {"ny",          required_argument,    nullptr,    'y'},
        {"nz",          required_argument,    nullptr,    'z'},
        {"timesteps",   required_argument,    nullptr,    's'},
        {"runs",        required_argument,    nullptr,    'r'},
        {"threads",     required_argument,    nullptr,    't'},
        {"algorithm",   required_argument,    nullptr,    'a'},
        {"vtk",         required_argument,    nullptr,    'v'},
        {"help",        no_argument,          nullptr,    'h'},
        {"reneigh",     required_argument,    nullptr,    0},
        {"rebalance",   required_argument,    nullptr,    1},
        {"dt",          required_argument,    nullptr,    2},
        {"temp",        required_argument,    nullptr,    3},
        {"cutoff",      required_argument,    nullptr,    4},
        {"verlet",      required_argument,    nullptr,    5},
        {"epsilon",     required_argument,    nullptr,    6},
        {"sigma",       required_argument,    nullptr,    7},
        {"damping_n",   required_argument,    nullptr,    8},
        {"damping_t",   required_argument,    nullptr,    9},
        {"stiffness",   required_argument,    nullptr,    10},
        {"friction",    required_argument,    nullptr,    11},
        {"potmin",      required_argument,    nullptr,    12},
        {"half_nb",     no_argument,          nullptr,    13},
        {"prebalance",  no_argument,          nullptr,    14}
    };

    while((opt = getopt_long(argc, argv, "f:b:x:y:z:s:r:t:a:v:h", long_opts, nullptr)) != -1) {
        switch(opt) {
            case 0:
                reneigh_every = atoi(optarg);
                break;

            case 1:
                rebalance_every = atoi(optarg);
                break;

            case 2:
                dt = atof(optarg);
                break;

            case 3:
                init_temp = atof(optarg);
                break;

            case 4:
                cutoff_radius = atof(optarg);
                break;

            case 5:
                verlet_buffer = atof(optarg);
                break;

            case 6:
                epsilon = atof(optarg);
                break;

            case 7:
                sigma = atof(optarg);
                break;

            case 8:
                damping_n = atof(optarg);
                break;

            case 9:
                damping_t = atof(optarg);
                break;

            case 10:
                stiffness = atof(optarg);
                break;

            case 11:
                friction = atof(optarg);
                break;

            case 12:
                potential_minimum = atof(optarg);
                break;

            case 13:
                half_nb = true;
                break;

            case 14:
                prebalance = true;
                break;

            case 'f':
                force_field = string(optarg);
                break;

            case 'b':
                benchmark = string(optarg);
                break;

            case 'x':
                gridsize[0] = atoi(optarg);
                break;

            case 'y':
                gridsize[1] = atoi(optarg);
                break;

            case 'z':
                gridsize[2] = atoi(optarg);
                break;

            case 's':
                steps = atoi(optarg);
                break;

            case 'r':
                runs = atoi(optarg);
                break;

            case 't':
                nthreads = atoi(optarg);
                break;

            case 'a':
                algorithm = string(optarg);
                break;

            case 'v':
                vtk_directory = string(optarg);
                break;

            case 'h':
            case '?':
            default:
                print_usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    if(rebalance_every % reneigh_every != 0) {
        cerr << "Error: rebalancing timesteps must be multiple of reneighboring timesteps!" << endl;
        return EXIT_FAILURE;
    }

    enum timers {
        TIME_FORCE,
        TIME_NEIGHBORLISTS,
        TIME_COMM,
        TIME_LOAD_BALANCING,
        TIME_OTHER,
        NTIMERS
    };

    double world_aabb[6], rank_aabb[6], aabb1[6], aabb2[6], new_aabb[6];
    MultiTimer<double> timer(NTIMERS, runs, 1e-6);
    bool vtk = !vtk_directory.empty();
    bool use_load_balancing = false;

    if(benchmark == "body_collision") {
        double shift = 2.0 * (gridsize[1] + 1);

        for(int d = 0; d < 3; ++d) {
            aabb1[d * 2 + 0] = 0;
            aabb1[d * 2 + 1] = gridsize[d] * potential_minimum;
            aabb2[d * 2 + 0] = 0;
            aabb2[d * 2 + 1] = gridsize[d] * potential_minimum;
        }

        aabb2[2] -= shift;
        aabb2[3] -= shift;

        for(int d = 0; d < 3; ++d) {
            world_aabb[d * 2 + 0] = min(aabb1[d * 2 + 0], aabb2[d * 2 + 0]) - 20;
            world_aabb[d * 2 + 1] = max(aabb1[d * 2 + 1], aabb2[d * 2 + 1]) + 20;
        }
    } else if(benchmark == "silicon") {
        for(int d = 0; d < 3; ++d) {
            world_aabb[d * 2 + 0] = -10.0;
            world_aabb[d * 2 + 1] = gridsize[d] * lattice_const + 10.0;
        }
    } else {
        if(benchmark != "default" && benchmark != "half" && benchmark != "granular_gas") {
            cerr << "Invalid benchmark specified: \"" << benchmark << "\"" << endl;
            cerr << "Available options are default, half and body_collision" << endl;
            return EXIT_FAILURE;
        }

        for(int d = 0; d < 3; ++d) {
            world_aabb[d * 2 + 0] = 0;
            world_aabb[d * 2 + 1] = gridsize[d] * potential_minimum;
        }

        half = benchmark == "half";
    }

    md_mpi_initialize();
    md_get_node_bounding_box(world_aabb, &rank_aabb);
    auto is_within_domain = bind(is_within_aabb, _1, _2, _3, rank_aabb);

    if(md_get_world_rank() == 0) {
        cout << "Simulation settings:" << endl;
        cout << "- Force field: " << force_field << endl;

        if(force_field == "dem") {
            cout << "- Normal damping: " << damping_n << endl;
            cout << "- Tangential damping: " << damping_t << endl;
            cout << "- Stiffness: " << stiffness << endl;
            cout << "- Friction: " << friction << endl;
        } else {
            cout << "- Epsilon: " << epsilon << endl;
            cout << "- Sigma: " << sigma << endl;
        }

        cout << "- Benchmark: " << benchmark << endl;
        cout << "- Unit cells (x, y, z): " << gridsize[0] << ", " << gridsize[1] << ", " << gridsize[2] << endl;
        cout << "- Number of timesteps: " << steps << endl;
        cout << "- Number of runs: " << runs << endl;
        cout << "- Number of threads: " << nthreads << endl;
        cout << "- Reneighboring timesteps: " << reneigh_every << endl;
        cout << "- Rebalancing timesteps: " << rebalance_every << endl;
        cout << "- Timestep size: " << dt << endl;
        cout << "- Initial temperature: " << init_temp << endl;
        cout << "- Cutoff radius: " << cutoff_radius << endl;
        cout << "- Verlet buffer: " << verlet_buffer << endl;
        cout << "- Potential minimum: " << potential_minimum << endl;
        cout << "- Half neighbor lists: " << (half_nb? "yes" : "no") << endl;
        cout << "- Walberla domain partitioning: " << (use_walberla ? "yes" : "no") << endl;
        cout << "- Prebalance: " << (prebalance ? "yes" : "no") << endl;
        cout << "- Dynamic load balancing algorithm: " << ((use_load_balancing) ? algorithm : "none") << endl;
        cout << "- VTK output directory: " << ((vtk) ? vtk_directory : "none") << endl << endl;
    }

    if(vtk) {
        if(md_get_world_size() > 1) {
            vtk_directory += to_string(md_get_world_rank());
        }

        vtk_directory += "/";
    }

    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    if(benchmark == "body_collision") {
        init_body_collision(world_aabb, aabb1, aabb2, rank_aabb, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
    } else if(benchmark == "granular_gas") {
        init_granular_gas(world_aabb, rank_aabb, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
    } else if(benchmark == "silicon") {
        init_silicon(world_aabb, rank_aabb, gridsize, lattice_const, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
    } else if(benchmark == "eam") {
        init_eam(world_aabb, rank_aabb, gridsize, lattice_const, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
    } else {
        init_rectangular_grid(world_aabb, rank_aabb, half, potential_minimum * 0.5, cutoff_radius + verlet_buffer, 60, 100, is_within_domain);
    }

    // EAM test
    //unrelax_atoms = UnrelaxedConfigGenerator <3> (20, 9, 39, 3.615, 3);
    int bottom_bc = md_add_region(0.0, 70.0, 0.0, 70.0, 0.0, 0.1);
    int top_bc = md_add_region(0.0, 70.0, 0.0, 70.0, 54.0, 55.0);
    int crack_top = md_add_region(0.0, 8.0 * 3.615, 0.0, 4.6 * 3.615, 9.5 * 3.615, 11.5 * 3.615);
    int crack_bottom = md_add_region(0.0, 8.0 * 3.615, 0.0, 4.6 * 3.615, 7.5 * 3.615, 9.5 * 3.615);

    //int bottom_bc = md_add_region(0.0, 110.0, 0.0, 110.0, 0.0, 0.1);
    //int top_bc = md_add_region(0.0, 110.0, 0.0, 110.0, 54.0, 55.0);
    //int crack_top = md_add_region(0.0, 11.0, 0.0, 25.8, 28.4, 28.7);
    //int crack_bottom = md_add_region(0.0, 11.0, 0.0, 27.2, 27.0, 27.2);

    md_barrier();
    md_copy_data_to_accelerator();

    timer.startRun();

    md_exchange_particles();
    md_borders();
    timer.accum(TIME_COMM);

    md_assign_particle_regions();
    int nopt = md_sort_particles_by_regions([crack_top, crack_bottom], 2);

    md_distribute_particles();
    md_assemble_neighborlists(half_nb, cutoff_radius + verlet_buffer);
    timer.accum(TIME_NEIGHBORLISTS);

    /*
    if(force_field == "dem") {
        md_compute_dem(half_nb, cutoff_radius, damping_n, damping_t, stiffness, friction);
    } else if(force_field == "sw") {
        md_compute_stillinger_weber(half_nb, cutoff_radius);
    } else if(force_field == "eam") {
        md_compute_eam(half_nb, cutoff_radius);
    } else {
        md_compute_lennard_jones(half_nb, cutoff_radius, epsilon, sigma);
    }
    */

    md_compute_eam_config(half_nb, cutoff_radius);
    timer.accum(TIME_FORCE);

    double force_norm = 0.0;
    for(int i = 0; i < md_get_number_of_particles(); ++i) {
        md_get_force(i, &fx, &fy, &fz);
        force_norm += sqrt(fx * fx + fy * fy + fz * fz);
    }

    std::cout << "atom embedding force: " << force_norm << std::endl;

    double parameters[nopt * 3];

    for(int i = 0; i < nopt; ++i) {
        double x, y, z;
        md_get_position(i, &x, &y, &z);
        parameters[i * 3 + 0] = x;
        parameters[i * 3 + 1] = y;
        parameters[i * 3 + 2] = z;
    }

    std::cout << "number of optimized atoms: " << nopt << std::endl;

    double max_load = 24.0;
    double load = 0.0;
    double unload = 0.05;
    double load_secondary = 0.05;
    int load_step = 0;

    while(load < max_load) {
        load += 0.05;
        load_step++;

        ceres::GradientProblem problem(new MolecularStatic(nopt * 3));
        ceres::GradientProblemSolver::Options options;
        options.minimizer_progress_to_stdout = true;
        options.max_num_iterations = 2000;
        options.gradient_tolerance = 1e-6;
        options.line_search_direction_type = ceres::LBFGS;
        ceres::GradientProblemSolver::Summary summary;
        ceres::Solve(options, problem, parameters, &summary);
        std::cout << summary.FullReport() << std::endl;

        if(load < 8.0 && load_step > 120) {
            const double critical_config_force = 10.32;
            const double crack_line_z = 33.5;
            const double xmin = 1.0,  xmax = 67.0;
            const double ymin = -1.0, ymax = 16.0;
            const double zmin = 32.0, zmax = 35.0;
            double x, y, z;

            md_compute_eam_config(half_nb, cutoff_radius);

            for(int i = 0; i < md_get_number_of_particles(); ++i) {
                md_get_material_position(i, &x, &y, &z);

                if(x > xmin && x < xmax && y > ymin && y < ymax && z > zmin && z < zmax) {
                    double fx, fy, fz;
                    md_get_force(i, &fx, &fy, &fz);
                    force_norm += sqrt(fx * fx + fy * fy + fz * fz);

                    if(force_norm > critical_config_force) {
                        const int nneigh = md_get_number_of_neighbors(i);
                        for(int j = 0; j < nneigh; ++j) {
                            int neigh = md_get_neighbor(i, j);
                            double nx, ny, nz;
                            md_get_position(neigh, &nx, &ny, &nz);
                            if((z > crack_line_z && nz > crack_line_z) || (z < crack_line_z && nz < crack_line_z)) {
                                md_remove_neighbor(i, j);
                            }
                        }
                    }
                }
            }
        }

        for(int i = 0; i < md_get_number_of_particles(); ++i) {
            int particle_region = md_get_particle_region(i);
            double x, y, z;

            if(load <= 8.0) {
                if(particle_region == bottom_bc || particle_region == top_bc) {
                    md_get_material_position(i, &x, &y, &z);
                    z += (particle_region == bottom_bc) ? -load * 0.5 : load * 0.5;
                    md_set_position(i, x, y, z);
                }
            } else if(load <= 16.0) {
                if(particle_region == bottom_bc || particle_region == top_bc) {
                    md_get_position(i, &x, &y, &z);
                    z += (particle_region == bottom_bc) ? unload * 0.5 : -unload * 0.5;
                    md_set_position(i, x, y, z);
                }
            } else if(load <= 24.0) {
                if(particle_region == bottom_bc || particle_region == top_bc) {
                    md_get_position(i, &x, &y, &z);
                    z += (particle_region == bottom_bc) ? -load_secondary * 0.5 : load_secondary * 0.5;
                    md_set_position(i, x, y, z);
                }
            }
        }
    }

    timer.finishRun();

    md_enforce_pbc();
    md_copy_data_from_accelerator();
    md_report_iterations();
    md_report_particles();
    md_deallocate_grid();

    LIKWID_MARKER_CLOSE;

    md_report_time(
        timer.getRunsTotalAverage(),
        timer.getRunsAverage(TIME_FORCE),
        timer.getRunsAverage(TIME_NEIGHBORLISTS),
        timer.getRunsAverage(TIME_COMM),
        timer.getRunsAverage(TIME_LOAD_BALANCING),
        timer.getRunsAverage(TIME_OTHER)
    );

    md_mpi_finalize();
    return EXIT_SUCCESS;
}
