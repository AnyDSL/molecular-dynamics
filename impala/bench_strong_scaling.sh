#!/bin/sh
likwid-pin -q -c 0 ./md 5e-5 1000 10000 1 
likwid-pin -q -c 0,2 ./md 5e-5 1000 10000 2
likwid-pin -q -c 0,2,4 ./md 5e-5 1000 10000 3 
likwid-pin -q -c 0,2,4,6 ./md 5e-5 1000 10000 4 
