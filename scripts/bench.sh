#!/bin/sh
cd impala-build
make
likwid-perfctr -C S0:1 -g FLOPS_DP ./md 5e-5 10000 100000 > bench_impala.out
cd ../cref-build
make
likwid-perfctr -C S0:1 -g FLOPS_DP ./md 5e-5 10000 100000 > bench_cref.out
