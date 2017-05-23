#!/bin/sh
cd impala
make clean
make
./md 5e-5 30000 > bench_impala.out
cd ../cref
make clean
make
./md 5e-5 30000 > bench_cref.out
