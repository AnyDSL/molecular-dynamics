#include <stdlib.h>
#include <string.h>

static size_t ALIGNMENT = 64ul;
unsigned char * allocate(size_t size) {
    //return (unsigned char *)aligned_alloc(ALIGNMENT, size);
    return (unsigned char *)malloc(size);
}


unsigned char * allocate_and_initialize(size_t size, int val) {
    //void *ptr = aligned_alloc(ALIGNMENT, size);
    void *ptr = malloc(size);
    memset(ptr, val, size);
    return (unsigned char *)ptr;
}

void initialize(unsigned char * ptr, size_t size, int val) {
    memset((void *)ptr, val, size);
}

void deallocate(unsigned char *ptr) {
    free(ptr);
}
