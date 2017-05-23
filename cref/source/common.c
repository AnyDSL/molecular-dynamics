#include <common.h>

real sqr(real const x) {
    return x * x;
}

void fprint_vector(uintptr_t fp, real v[DIM]) {
    for(size_t d = 0; d < DIM-1; ++d) {
        fprint_double(fp, v[d]);
        fprint_char(fp, ' ');
    }
    fprint_double(fp, v[DIM-1]);
}
