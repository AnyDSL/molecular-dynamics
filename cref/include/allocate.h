#pragma once
#include <stdlib.h>
unsigned char * allocate(size_t size);
unsigned char * allocate_and_initialize(size_t size, int val);
void initialize(unsigned char *ptr, size_t size, int val);
void deallocate(unsigned char *ptr);
