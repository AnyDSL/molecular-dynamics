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

void sync_ghost_layer_loop(
    int neighs,
    const char *send_buffer, char *recv_buffer,
    int *send_ranks, int *recv_ranks,
    int *send_offsets, int *recv_offsets,
    int *send_lengths, int *recv_lengths) {

    MPI_Request request;
    MPI_Status status;
    int neigh;

    for(neigh = 0; neigh < neighs; ++neigh) {
        int send_rank = send_ranks[neigh];
        int recv_rank = recv_ranks[neigh];
        unsigned long send_offset = send_offsets[neigh] * 3 * sizeof(double);
        unsigned long recv_offset = recv_offsets[neigh] * 3 * sizeof(double);

        MPI_Irecv(&(recv_buffer[recv_offset]), recv_lengths[neigh] * 3, MPI_DOUBLE, recv_rank, 0, MPI_COMM_WORLD, &request);
        MPI_Send(&(send_buffer[send_offset]), send_lengths[neigh] * 3, MPI_DOUBLE, send_rank, 0, MPI_COMM_WORLD);
        MPI_Wait(&request, &status);
    }
}

static MPI_Request send_reqs[128];
static MPI_Request recv_reqs[128];

int MPI_Isend_ex(const void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm, int req_id) {
    return MPI_Isend(buf, count, datatype, dest, tag, comm, &send_reqs[req_id]);
}

int MPI_Irecv_ex(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, int req_id) {
    return MPI_Irecv(buf, count, datatype, source, tag, comm, &recv_reqs[req_id]);
}

void MPI_Waitall_ex(int count) {
    MPI_Waitall(count, recv_reqs, MPI_STATUSES_IGNORE);
    MPI_Waitall(count, send_reqs, MPI_STATUSES_IGNORE);
}

}
