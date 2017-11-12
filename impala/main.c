#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>
#include <likwid.h>

#ifdef COUNT_FORCE_EVALUATIONS
#define count_force_evaluations true
#else
#define count_force_evaluations false
#endif

typedef double real;
void initialize_system(size_t, real *);
void time_integration(real, real, real, bool);
void time_integration_vector(real, real, real, bool);
void deallocate_system();
size_t get_number_of_force_evaluations();
void print_usage(char *name) {
    printf("Usage: %s dt steps nparticles -vtk\n", name);
}
int main(int argc, char** argv) {
    if(argc != 4 && argc != 5) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    bool vtk = false;
    if(argc == 5) {
        if(strlen(argv[4]) != 4 || strncmp(argv[4], "-vtk", 4) != 0) {
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
    //initialize_system(atol(argv[3]), l);
    real dt = atof(argv[1]);
    struct timeval t1, t2;
    //size_t const nsamples = 100;
    size_t const nsamples = 1;
    double average = 0.0;
    double samples[nsamples];
    size_t np = atol(argv[3]);
    /*for(size_t i = 0; i < 50; ++i) { 
        initialize_system(np, l);
        time_integration(0.0, atol(argv[2])*dt, dt, vtk);
        deallocate_system();
    }*/


    for(size_t i = 0; i < nsamples; ++i) { 
        initialize_system(np, l);
        LIKWID_MARKER_INIT;
        LIKWID_MARKER_THREADINIT;
        LIKWID_MARKER_START("Compute");
        gettimeofday(&t1, NULL);
        // To run the vectorized code:
        // time_integration_vector(0.0, atol(argv[2])*dt, dt, vtk);
        time_integration(0.0, atol(argv[2])*dt, dt, vtk);
        gettimeofday(&t2, NULL);
        LIKWID_MARKER_STOP("Compute");
        LIKWID_MARKER_CLOSE;
        double time = 0.0;
        time += (t2.tv_sec - t1.tv_sec);      // sec
        time += (t2.tv_usec - t1.tv_usec) * 1e-6;   // us to sec
        //printf("Runtime: %f s\n", time);
        average += time;
        samples[i] = time;
        deallocate_system();
    }
    average /= nsamples;
    double stdev = 0;
    for(size_t i = 0; i < nsamples; ++i) {
        double tmp = samples[i] - average;
        stdev += tmp*tmp;
    }
    stdev = sqrt(stdev/(nsamples-1));
    printf("Average Runtime: %f s\tStandard Deviation: %f s\n", average, stdev);
    //printf("%f\t%f\n", average, stdev);

    if(count_force_evaluations) {
        if(get_number_of_force_evaluations() + 1 == 0) {
            printf("Maximum number of countable force_evaluations reached\n");
        }
        printf("Number of collisons: %lu\n", get_number_of_force_evaluations());
    }

    return EXIT_SUCCESS;
}
