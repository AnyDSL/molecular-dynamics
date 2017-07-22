#!/bin/sh
sleep 600
echo "#strong scaling C vs Impala" > strong_scaling.dat
cd ./cref
./bench_strong_scaling.sh >> ../strong_scaling.dat
cd ../impala
./bench_strong_scaling.sh >> ../strong_scaling.dat
echo "#weak scaling C vs Impala" > weak_scaling.dat
cd ../cref
./bench_weak_scaling.sh >> ../weak_scaling.dat
cd ../impala
./bench_weak_scaling.sh >> ../weak_scaling.dat
