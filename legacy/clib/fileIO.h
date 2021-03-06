#include <stdio.h>
#include <stdint.h>



void size_t_to_string(size_t i, unsigned char *buf, size_t bufsize); 

void generate_filename(size_t i, unsigned char const *lang, unsigned char *buf, size_t bufsize);

uintptr_t open_file(unsigned char const *fname);

void close_file(uintptr_t fp);

void fprint_string(uintptr_t fp, unsigned char const *str);

void fprint_line(uintptr_t fp, unsigned char const *str);
void fprint_f64(uintptr_t fp, double d);

void fprint_f32(uintptr_t fp, float f);

void fprint_i32(uintptr_t fp, int i);

void fprint_size_t(uintptr_t fp, size_t i);

void fprint_u8(uintptr_t fp, unsigned char c);

