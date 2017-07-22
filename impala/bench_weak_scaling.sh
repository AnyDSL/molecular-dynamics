#!/bin/sh
sleep 10
likwid-pin -q -c 0 ./md 5e-5 1000 500 1
likwid-pin -q -c 0,2 ./md 5e-5 1000 1000 2
likwid-pin -q -c 0,2,4 ./md 5e-5 1000 1500 3 
likwid-pin -q -c 0,2,4,6 ./md 5e-5 1000 2000 4 
