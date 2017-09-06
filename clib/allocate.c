#include <stdlib.h>
#include <string.h>
#include "allocate.h"

static size_t ALIGNMENT = 64ul;
char * allocate(size_t size) {
    //return (unsigned char *)aligned_alloc(ALIGNMENT, size);
    return (char *)malloc(size);
}


char * allocate_and_initialize(size_t size, int val) {
    //void *ptr = aligned_alloc(ALIGNMENT, size);
    void *ptr = malloc(size);
    memset(ptr, val, size);
    return (char *)ptr;
}

void initialize(char ptr [], size_t size, int val) {
    memset((void *)ptr, val, size);
}

void deallocate(char ptr[]) {
    free(ptr);
}
