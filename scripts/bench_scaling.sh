#!/bin/sh
sleep 600
cd ./cref
./bench_strong_scaling.sh >> ../strong_scaling_c.dat
cd ../cref
./bench_weak_scaling.sh >> ../weak_scaling_c.dat
cd ../impala
./bench_strong_scaling.sh >> ../strong_scaling_impala.dat
cd ../impala
./bench_weak_scaling.sh >> ../weak_scaling_impala.dat
