#include <common.h>
#include <datastructures.h>

void insertNode(ParticleList ** root, ParticleList * pl) {
    pl->next = *root;
    *root = pl;
}

void removeNode(ParticleList **root) {
    *root = (*root)->next;
}

size_t compute_index(const size_t ic[DIM], const size_t nc[DIM]) {
   return ic[0] + nc[0]*(ic[1] + nc[1]*ic[2]);
}

void compute_cell_position(Particle *p, ParticleSystem *P, size_t jc[DIM]) {
    for(size_t d = 0; d < DIM; ++d) {
        jc[d] = (size_t)floor((p->x[d] + P->offset) * P->tmp[d]);
    }
}


void allocate_particle_system(size_t np, real l[DIM], size_t ghost_layer, Constants constants, ParticleSystem *P) {
    P->np = np;
    size_t pnc = 1;
    for(size_t d = 0; d < DIM; ++d) {
        P->l[d] = l[d] + 2.0*ghost_layer*constants.r_cut;
        P->nc[d] = (size_t)floor(l[d]/constants.r_cut) + 2*ghost_layer;
        pnc *= P->nc[d];
        P->tmp[d] = P->nc[d]/P->l[d];
        P->start[d] = ghost_layer;
        P->end[d] = P->nc[d] - ghost_layer;
    }
    P->ghost_layer = ghost_layer;
    P->offset = constants.r_cut * ghost_layer;
    P->grid = (Cell *)allocate_and_initialize(pnc*sizeof(Cell), 0);
    P->addresses = (size_t *)allocate(P->np*sizeof(size_t));
    P->constants = constants;
}

void deallocate_particle_system(ParticleSystem P) {
    size_t ic[DIM];
    size_t ic_start[DIM], ic_end[DIM];
    for(size_t d = 0; d < DIM; ++d) {
        ic_start[d] = 0;
        ic_end[d] = P.nc[d];
    }
    for(ic[0] = ic_start[0]; ic[0] < ic_end[0]; ++ic[0]) {
        for(ic[1] = ic_start[1]; ic[1] < ic_end[1]; ++ic[1]) {
            for(ic[2] = ic_start[2]; ic[2] < ic_end[2]; ++ic[2]) {
                ParticleList* pl = P.grid[compute_index(ic, P.nc)];
                while(pl != NULL) {
                    ParticleList *ptr = pl;
                    pl = pl->next;
                    deallocate((unsigned char *)ptr);
                }
            }
        }
    }
    deallocate((unsigned char *)P.grid);
    deallocate((unsigned char *)P.addresses);
}

void init_addresses(ParticleSystem *P) {
    size_t count = 0;
    size_t ic[DIM];
    for(ic[0] = P->start[0]; ic[0] < P->end[0]; ++ic[0]) {
        for(ic[1] = P->start[1]; ic[1] < P->end[1]; ++ic[1]) {
            for(ic[2] = P->start[2]; ic[2] < P->end[2]; ++ic[2]) {
                for(ParticleList * pl=P->grid[compute_index(ic, P->nc)]; pl!=NULL; pl=pl->next) {
                    P->addresses[count++] = (uintptr_t)(&pl->p);
                }
            }
        }
    }
}
