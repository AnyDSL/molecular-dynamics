#include <math.h>

#include <fileIO.h>
#include <algorithm.h>
#include <potential.h>
#include <integration.h>
#include <boundary.h>

void compute_force(ParticleSystem P) {
    size_t ic[DIM];
    for(ic[0] = P.start[0]; ic[0] < P.end[0]; ++ic[0]) {
        for(ic[1] = P.start[1]; ic[1] < P.end[1]; ++ic[1]) {
            for(ic[2] = P.start[2]; ic[2] < P.end[2]; ++ic[2]) {
                for(ParticleList * restrict pl=P.grid[compute_index(ic, P.nc)]; pl!=NULL; pl=pl->next) {
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
    for(ic[0] = ic_start[0]; ic[0] < ic_end[0]; ++ic[0]) {
        for(ic[1] = ic_start[1]; ic[1] < ic_end[1]; ++ic[1]) {
            for(ic[2] = ic_start[2]; ic[2] < ic_end[2]; ++ic[2]) {
                bool write_i = true;
                size_t jc[DIM], jc_start[DIM], jc_end[DIM];
                for(size_t d = 0; d < DIM; ++d) {
                    if(ic[d] >= P.start[d]) {
                        jc_start[d] = ic[d] - 1;
                    }
                    else {
                        jc_start[d] = ic[d] + 1;
                        write_i = false;
                    }
                    if(ic[d] < P.end[d]) {
                        jc_end[d] = ic[d] + 2;
                    }
                    else {
                        jc_end[d] = ic[d];
                        write_i = false;
                    }
                }
                for(ParticleList * restrict pl1=P.grid[compute_index(ic, P.nc)]; pl1!=NULL; pl1=pl1->next) {
                    for(jc[0] = jc_start[0]; jc[0] < jc_end[0]; ++jc[0]) {
                        for(jc[1] = jc_start[1]; jc[1] < jc_end[1]; ++jc[1]) {
                            for(jc[2] = jc_start[2]; jc[2] < jc_end[2]; ++jc[2]) {
                                bool write_j = true;
                                for(size_t d = 0; d < DIM; ++d) {
                                    if(jc[d] < P.start[d] || jc[d] >= P.end[d])
                                    {
                                        write_j = false;
                                        break;
                                    }
                                }
                                for(ParticleList * restrict pl2 = P.grid[compute_index(jc, P.nc)]; pl2 != NULL; pl2 = pl2->next) {
                                    if(pl1 < pl2) {
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
    size_t ic[DIM];
    for(ic[0] = P.start[0]; ic[0] < P.end[0]; ++ic[0]) {
        for(ic[1] = P.start[1]; ic[1] < P.end[1]; ++ic[1]) {
            for(ic[2] = P.start[2]; ic[2] < P.end[2]; ++ic[2]) {
                ParticleList **q = &(P.grid[compute_index(ic, P.nc)]);
                ParticleList *pl = *q;
                size_t jc[DIM];
                while(pl != NULL) {
                    boundary(&pl->p, P);
                    for(size_t d = 0; d < DIM; ++d) {
                        jc[d] = (size_t)floor(pl->p.x[d] * P.nc[d] / P.l[d]);
                    }
                    if(ic[0] != jc[0] || ic[1] != jc[1] || ic[2] != jc[2]) {
                        removeNode(q);
                        insertNode(&(P.grid[compute_index(jc, P.nc)]), pl);
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
    size_t ic[DIM];
    for(ic[0] = P.start[0]; ic[0] < P.end[0]; ++ic[0]) {
        for(ic[1] = P.start[1]; ic[1] < P.end[1]; ++ic[1]) {
            for(ic[2] = P.start[2]; ic[2] < P.end[2]; ++ic[2]) {
                for(ParticleList * restrict pl=P.grid[compute_index(ic, P.nc)]; pl!=NULL; pl=pl->next) {
                    update_x(&pl->p, dt);
                }
            }
        }
    }
    move_particles(P);
}

void update_velocities(ParticleSystem P, real const dt) {
    size_t ic[DIM];
    for(ic[0] = P.start[0]; ic[0] < P.end[0]; ++ic[0]) {
        for(ic[1] = P.start[1]; ic[1] < P.end[1]; ++ic[1]) {
            for(ic[2] = P.start[2]; ic[2] < P.end[2]; ++ic[2]) {
                for(ParticleList * restrict pl=P.grid[compute_index(ic, P.nc)]; pl!=NULL; pl=pl->next) {
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
