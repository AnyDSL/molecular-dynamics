#include "stdlib.h"

char * allocate(size_t size);
char * allocate_and_initialize(size_t size, int val);
void initialize(char ptr[], size_t size, int val);
void deallocate(char ptr[]);
