#!/bin/bash
for i in {20..20}
do
    n=100
    likwid-pin -q -c 2 ./md 5e-4 1000 $((i*n)) 1
done
