#include <common.h>

real sqr(real const x) {
    return x * x;
}

void fprint_vector(uintptr_t fp, real v[DIM]) {
    for(size_t d = 0; d < DIM-1; ++d) {
        fprint_f64(fp, v[d]);
        fprint_u8(fp, ' ');
    }
    fprint_u8(fp, v[DIM-1]);
}
