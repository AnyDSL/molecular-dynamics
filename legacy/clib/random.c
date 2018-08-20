#include "random.h"

void c_random_seed(long int seed) {
    srand48(seed);
}

double c_random() {
    return drand48();
}
