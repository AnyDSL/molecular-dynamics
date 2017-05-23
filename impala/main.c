#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>


typedef double real;
extern void run_simulation(real *, real, real, bool);

void print_usage(char *name) {
    printf("Usage: %s dt steps -vtk\n", name);
}
int main(int argc, char** argv) {
    if(argc != 3 && argc != 4) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    bool vtk = false;
    if(argc == 4) {
        if(strlen(argv[3]) != 4 || strncmp(argv[3], "-vtk", 4) != 0) {
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
    real dt = atof(argv[1]);
    struct timeval t1, t2;
    gettimeofday(&t1, NULL);
    run_simulation(l, dt, atol(argv[2])*dt, vtk);
    gettimeofday(&t2, NULL);
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

    return EXIT_SUCCESS;
}
