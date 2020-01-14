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

}
