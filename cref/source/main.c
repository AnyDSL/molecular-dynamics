#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>
#include <likwid.h>

#include <common.h>
#include <algorithm.h>
#include <time_integration.h>

#ifdef COUNT_COLLISIONS
#define count_collisions true
#else
#define count_collisions false
#endif

void print_usage(char *name) {
    printf("Usage: %s dt steps particles numthreads [-vtk]\n", name);
}

int main(int argc, char** argv) {

    if(argc != 5 && argc != 6) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    bool vtk = false;
    if(argc == 6) {
        if(strlen(argv[5]) != 4 || strncmp(argv[5], "-vtk", 4) != 0) {
            print_usage(argv[0]);
            return EXIT_FAILURE;
        }
        else {
            vtk = true;
        }
    }
    double l[3];
    l[0] = 250;
    l[1] = 250;
    l[2] = 250;
    //dt = 0.00005;
    initialize_system(atol(argv[3]), l);
    real dt = atof(argv[1]);
    struct timeval t1, t2;
    LIKWID_MARKER_INIT;
    LIKWID_MARKER_START("Compute");
    gettimeofday(&t1, NULL);
    time_integration(0.0, atol(argv[2])*dt, dt, atol(argv[4]), vtk, count_collisions);
    gettimeofday(&t2, NULL);
    LIKWID_MARKER_STOP("Compute");
    LIKWID_MARKER_CLOSE;
    double seconds = (t2.tv_sec - t1.tv_sec);      // sec
    seconds += (t2.tv_usec - t1.tv_usec) * 1e-6;   // us to sec
    if(seconds > 60.0) {
        unsigned long minutes = (unsigned long)(floor(seconds / 60.0));
        seconds -= minutes * 60.0;
        printf("Elapsed Time: %lu min %f s\n", minutes, seconds);
    }
    else {
        printf("Elapsed Time: %f s\n", seconds);
    }
    if(count_collisions) {
        if(get_number_of_collisions() + 1 == 0) {
            printf("Maximum number of countable collisions reached\n");
        }
        printf("Number of collisons: %lu\n", get_number_of_collisions());
    }
    deallocate_system();

    return EXIT_SUCCESS;
}
