#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>
#include <likwid.h>

#ifdef COUNT_COLLISIONS
#define count_collisions true
#else
#define count_collisions false
#endif

typedef double real;
extern void initialize_system(size_t, real *);
extern void time_integration(real, real, real, int, bool);
extern void deallocate_system();
extern size_t get_number_of_collisions();
void print_usage(char *name) {
    printf("Usage: %s dt steps particles numthreads -vtk\n", name);
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
    size_t const nsamples = 100;
    double average = 0.0;
    double samples[nsamples];
    for(size_t i = 0; i < nsamples; ++i) { 
        LIKWID_MARKER_INIT;
        LIKWID_MARKER_THREADINIT;
        LIKWID_MARKER_START("Compute");
        gettimeofday(&t1, NULL);
        time_integration(0.0, atol(argv[2])*dt, dt, atoi(argv[4]), vtk);
        gettimeofday(&t2, NULL);
        LIKWID_MARKER_STOP("Compute");
        LIKWID_MARKER_CLOSE;
        double time = 0.0;
        time += (t2.tv_sec - t1.tv_sec);      // sec
        time += (t2.tv_usec - t1.tv_usec) * 1e-6;   // us to sec
        average += time;
        samples[i] = time;
    }
    average /= nsamples;
    double stdev = 0;
    for(size_t i = 0; i < nsamples; ++i) {
        double tmp = samples[i] - average;
        stdev += tmp*tmp;
    }
    stdev = sqrt(stdev/(nsamples-1));
    /*if(average > 60.0) {
        unsigned long minutes = (unsigned long)(floor(average / 60.0));
        average -= minutes * 60.0;
        printf("Elapsed Time: %lu min %f s\n", minutes, average);
    }*/
    //else {
    //printf("Average Runtime: %f s\tStandard Deviation: %f s\n", average, stdev);
    printf("%f\t%f\n", average, stdev);
    //}
    if(count_collisions) {
        if(get_number_of_collisions() + 1 == 0) {
            printf("Maximum number of countable collisions reached\n");
        }
        printf("Number of collisons: %lu\n", get_number_of_collisions());
    }
    deallocate_system();

    return EXIT_SUCCESS;
}
