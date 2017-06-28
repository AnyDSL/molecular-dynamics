#include "random.h"

void c_random_seed(unsigned int seed) {
    srand(seed);
}

double c_random() {
    return (double)rand() / (double)RAND_MAX;
}
