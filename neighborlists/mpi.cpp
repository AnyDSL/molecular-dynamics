#include <mpi.h>

extern "C" {

int MPI_init() { return MPI_Init(0, 0); }

MPI_Op get_mpi_max() { return MPI_MAX; }
MPI_Op get_mpi_sum() { return MPI_SUM; }

MPI_Datatype get_mpi_int() { return MPI_INT; }
MPI_Datatype get_mpi_double() { return MPI_DOUBLE; }
MPI_Datatype get_mpi_float() { return MPI_FLOAT; }
MPI_Datatype get_mpi_int64() { return MPI_LONG_LONG_INT; }

MPI_Comm get_mpi_comm_world() { return MPI_COMM_WORLD; }

MPI_Status* get_mpi_status_ignore() { return MPI_STATUS_IGNORE; }

void get_mpi_cart_neighborhood(
    int gx, int gy, int gz,
    int *locx, int *locy, int *locz,
    int *xprev, int *xnext,
    int *yprev, int *ynext,
    int *zprev, int *znext) {

    MPI_Comm cartesian;
    int procgrid[3];
    int myloc[3];
    int periods[3];
    int reorder = 0;

    procgrid[0] = gx;
    procgrid[1] = gy;
    procgrid[2] = gz;

    periods[0] = periods[1] = periods[2] = 1;

    MPI_Cart_create(MPI_COMM_WORLD, 3, procgrid, periods, reorder, &cartesian);
    MPI_Cart_get(cartesian, 3, procgrid, periods, myloc);
    MPI_Cart_shift(cartesian, 0, 1, xprev, xnext);
    MPI_Cart_shift(cartesian, 1, 1, yprev, ynext);
    MPI_Cart_shift(cartesian, 2, 1, zprev, znext);

    *locx = myloc[0];
    *locy = myloc[1];
    *locz = myloc[2];

    MPI_Comm_free(&cartesian);
}

}
