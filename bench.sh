#!/bin/sh
cd impala-build
make
./md 5e-5 10000 100000 > bench_impala.out
cd ../cref-build
make
./md 5e-5 10000 100000 > bench_cref.out
