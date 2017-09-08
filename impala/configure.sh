#!/bin/bash
cmake . -DAnyDSL-runtime_DIR=/software/anydsl/runtime -DLIKWID_DIR=/usr/local/likwid -DLIKWID_PERFMON=OFF -DCOUNT_FORCE_EVALUATIONS=OFF -DCHECK_INVARIANTS=OFF
