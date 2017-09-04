#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "fileIO.h"


void size_t_to_string(size_t i, unsigned char *buf, size_t bufsize) {
    snprintf(buf, bufsize, "%lu", i);
}

void generate_filename(size_t i, unsigned char const *lang, unsigned char *buf, size_t bufsize) {
    snprintf(buf, bufsize, "../%s_vtk/particles%lu.vtk",lang, i);
}

uintptr_t open_file(unsigned char const *fname) {
    FILE *fp = fopen(fname, "w");
    if(fp == NULL) {
        fprintf(stderr, "open_file: Could not open file %s", fname);
        perror("");
        return 0;
    }
    else {
        return (uintptr_t)fp;
    }
}
void close_file(uintptr_t fp) {
    fclose((FILE *)fp);
}

void fprint_string(uintptr_t fp, unsigned char const *str) {
    fputs(str, (FILE *)fp);
}

void fprint_line(uintptr_t fp, unsigned char const *str) {
    fprintf((FILE *)fp, "%s\n", str);
}
void fprint_f64(uintptr_t fp, double d) {
    if(isnan(d)) {
        fprintf((FILE *)fp, "%f", 0.0);
    }
    else {
        fprintf((FILE *)fp, "%f", d);
    }
}

void fprint_f32(uintptr_t fp, float f) {
    if(isnan(f)) {
        fprintf((FILE *)fp, "%f", 0.0);
    }
    else {
        fprintf((FILE *)fp, "%f", f);
    }
}

void fprint_i32(uintptr_t fp, int i) {
    fprintf((FILE *)fp, "%d", i);
}


void fprint_size_t(uintptr_t fp, size_t i) {
    fprintf((FILE *)fp, "%lu", i);
}

void fprint_u8(uintptr_t fp, unsigned char c) {
    fputc((int)c, (FILE *)fp);
}
