#include <math.h>

#include <fileIO.h>
#include <algorithm.h>
#include <potential.h>
#include <integration.h>
#include <boundary.h>
#include <omp.h>

#ifdef COUNT_COLLISIONS
#define count_collisions true
#else
#define count_collisions false
#endif

static size_t  collisions_ = 1;

size_t get_number_of_collisions() {
    return collisions_ - 1;
}

void compute_force(ParticleSystem P) {
    #pragma omp parallel for schedule(static)
    for(size_t k = P.start[2]; k < P.end[2]; ++k) {
        for(size_t j  = P.start[1]; j < P.end[1]; ++j) {
            for(size_t i = P.start[0]; i < P.end[0]; ++i) {
                for(ParticleList * restrict pl=P.grid[i + P.nc[0] * (j + P.nc[1] * k)]; pl!=NULL; pl=pl->next) {
                    for(size_t d =0; d < DIM; ++d) {
                        pl->p.F[d] = 0.0;
                    }
                }
            }
        }
    }
    size_t ic_start[DIM], ic_end[DIM];
    for(size_t d = 0; d < DIM; ++d) {
        ic_start[d] = 0;
        ic_end[d] = P.nc[d];
    }
    #pragma omp parallel for schedule(static)
    for(size_t k1 = ic_start[2]; k1 < ic_end[2]; ++k1) {
        for(size_t j1  = ic_start[1]; j1 < ic_end[1]; ++j1) {
            for(size_t i1 = ic_start[0]; i1 < ic_end[0]; ++i1) {
                size_t k2_start, j2_start, i2_start;
                size_t k2_end, j2_end, i2_end;
                bool write_i = true;
                if(i1 >= P.start[0]) {
                    i2_start = i1 - 1;
                }
                else {
                    i2_start = i1 + 1;
                    write_i = false;
                }
                if(i1 < P.end[0]) {
                    i2_end = i1 + 2;
                }
                else {
                    i2_end = i1;
                    write_i = false;
                }

                if(j1 >= P.start[1]) {
                    j2_start = j1 - 1;
                }
                else {
                    j2_start = j1 + 1;
                    write_i = false;
                }
                if(j1 < P.end[1]) {
                    j2_end = j1 + 2;
                }
                else {
                    j2_end = j1;
                    write_i = false;
                }

                if(k1 >= P.start[2]) {
                    k2_start = k1 - 1;
                }
                else {
                    k2_start = k1 + 1;
                    write_i = false;
                }
                if(k1 < P.end[2]) {
                    k2_end = k1 + 2;
                }
                else {
                    k2_end = k1;
                    write_i = false;
                }

                for(ParticleList * restrict pl1=P.grid[i1 + P.nc[0] * (j1 + P.nc[1] * k1)]; pl1!=NULL; pl1=pl1->next) {
                    for(size_t k2 = k2_start; k2 < k2_end; ++k2) {
                        for(size_t j2 = j2_start; j2 < j2_end; ++j2) {
                            for(size_t i2 = i2_start; i2 < i2_end; ++i2) {
                                bool write_j = true;
                                if(i2 < P.start[0] || i2 >= P.end[0] || j2 < P.start[1] || j2 >= P.end[1] || k2 < P.start[2] || k2 >= P.end[2]) {
                                    write_j = false;
                                }
                                for(ParticleList * restrict pl2 = P.grid[i2 + P.nc[0]*(j2 + P.nc[1] * k2)]; pl2 != NULL; pl2 = pl2->next) {
                                    if(pl1 < pl2) {
                                        if(count_collisions) { 
                                            if(collisions_ > 0)// overflow detection 
                                            collisions_ = collisions_ + 1; 
                                        }
                                        force(&pl1->p, &pl2->p, write_i, write_j, P.constants);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

void move_particles(ParticleSystem P) {
    for(size_t k = P.start[2]; k < P.end[2]; ++k) {
        for(size_t j  = P.start[1]; j < P.end[1]; ++j) {
            for(size_t i = P.start[0]; i < P.end[0]; ++i) {
                ParticleList **q = &(P.grid[i + P.nc[0] * (j + P.nc[1] * k)]);
                ParticleList *pl = *q;
                size_t jc[DIM];
                while(pl != NULL) {
                    boundary(&pl->p, P);
                    compute_cell_position(&pl->p, &P, jc);
                    if(i != jc[0] || j != jc[1] || k != jc[2]) {
                        removeNode(q);
                        insertNode(&(P.grid[jc[0] + P.nc[0] * (jc[1] + P.nc[1] * jc[2])]), pl);
                    }
                    else {
                        q = &pl->next;
                    }
                    pl = *q;
                }
            }
        }
    }


}

void update_coordinates(ParticleSystem P, real const dt) {
    #pragma omp parallel for schedule(static)
    for(size_t k = P.start[2]; k < P.end[2]; ++k) {
        for(size_t j  = P.start[1]; j < P.end[1]; ++j) {
            for(size_t i = P.start[0]; i < P.end[0]; ++i) {
                for(ParticleList * restrict pl=P.grid[i + P.nc[0] * (j + P.nc[1] * k)]; pl!=NULL; pl=pl->next) {
                    update_x(&pl->p, dt);
                }
            }
        }
    }
    move_particles(P);
}

void update_velocities(ParticleSystem P, real const dt) {
    #pragma omp parallel for schedule(static)
    for(size_t k = P.start[2]; k < P.end[2]; ++k) {
        for(size_t j  = P.start[1]; j < P.end[1]; ++j) {
            for(size_t i = P.start[0]; i < P.end[0]; ++i) {
                for(ParticleList * restrict pl=P.grid[i + P.nc[0] * (j + P.nc[1] * k)]; pl!=NULL; pl=pl->next) {
                    update_v(&pl->p, dt);
                }
            }
        }
    }
}

void fprint_particle_system(unsigned char fname[], size_t step, ParticleSystem P) {
    uintptr_t const fp = open_file(fname);
    size_t const N = P.np;
    fprint_line(fp, "# vtk DataFile Version 2.0");
    fprint_string(fp, "Step ");
    fprint_size_t(fp, step);
    fprint_line(fp, " data");
    fprint_line(fp, "ASCII");
    fprint_line(fp, "DATASET UNSTRUCTURED_GRID");
    fprint_string(fp, "POINTS ");
    fprint_size_t(fp, N);
    fprint_line(fp, " double");

    for(size_t i = 0; i < N; ++i) {
        Particle *p = (Particle *)(P.addresses[i]);
        fprint_vector(fp, p->x);
        fprint_string(fp, "\n");
    }

    fprint_string(fp, "\n\n");
    fprint_string(fp, "CELLS ");
    fprint_size_t(fp, N);
    fprint_string(fp, " ");
    fprint_size_t(fp, 2*N);
    fprint_string(fp, "\n");

    for(size_t i = 0; i < N; ++i) {
        fprint_string(fp, "1 ");
        fprint_size_t(fp, i);
        fprint_string(fp, "\n");
    }

    fprint_string(fp, "\n\n");

    fprint_string(fp, "CELL_TYPES ");
    fprint_size_t(fp, N);
    fprint_string(fp, "\n");
    for(size_t i = 0; i < N; ++i) {
        fprint_string(fp, "1");
        fprint_string(fp, "\n");
    }

    fprint_string(fp, "\n\n");
    fprint_string(fp, "POINT_DATA ");
    fprint_size_t(fp, N);
    fprint_string(fp, "\n");
    for(size_t d = 0; d < DIM; ++d) {
        fprint_string(fp, "SCALARS velocity_dim_");
        fprint_size_t(fp, d);
        fprint_line(fp, " double");
        fprint_line(fp, "LOOKUP_TABLE default");
        for(size_t i = 0; i < N; ++i) {
            Particle *p = (Particle *)(P.addresses[i]);
            fprint_double(fp, p->v[d]);
            fprint_string(fp, "\n");
        }
        fprint_string(fp, "\n");
    }

    for (size_t d = 0; d < DIM; ++d) {
        fprint_string(fp, "SCALARS force_dim_");
        fprint_size_t(fp, d);
        fprint_line(fp, " double");
        fprint_line(fp, "LOOKUP_TABLE default");
        for(size_t i = 0; i < N; ++i) {
            Particle *p = (Particle *)(P.addresses[i]);
            fprint_double(fp, p->F[d]);
            fprint_string(fp, "\n");
        }
        fprint_string(fp, "\n");
    }

    fprint_string(fp, "SCALARS mass");
    fprint_line(fp, " double");
    fprint_line(fp, "LOOKUP_TABLE default");
    for(size_t i = 0; i < N; ++i) {
        Particle *p = (Particle *)(P.addresses[i]);
        fprint_double(fp, p->m);
        fprint_string(fp, "\n");
    }
    fprint_string(fp, "\n");


    close_file(fp);
}
