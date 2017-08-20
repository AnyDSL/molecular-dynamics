#!/bin/sh
likwid-pin -q -c 0 ./md 5e-5 100 5000 1 
likwid-pin -q -c 0,2 ./md 5e-5 100 5000 2
likwid-pin -q -c 0,2,4 ./md 5e-5 100 5000 3 
likwid-pin -q -c 0,2,4,6 ./md 5e-5 100 5000 4 
