cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(molecular-dynamics CXX)
#enable_testing()

find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)
include_directories(${LIKWID_DIR}/include)

set(BACKEND ${BACKEND} CACHE STRING "select the backend from the following: CPU, AVX")
if(NOT BACKEND)
    set(BACKEND cpu CACHE STRING "select the backend from the following: CPU, AVX" FORCE)
endif()
string(TOLOWER "${BACKEND}" BACKEND)
message(STATUS "Selected backend: ${BACKEND}")

set(BACKEND_FILE backend_${BACKEND}.impala)

option(COUNT_FLOPS "COUNT_FLOPS" OFF)
option(LIKWID_PERFMON "LIKWID_PERFMON" OFF)
if(LIKWID_PERFMON)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLIKWID_PERFMON -pthread")
endif()

set(CLANG_FLAGS -O3 -march=native)
set(IMPALA_FLAGS -O3 --log-level error)
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    backend_${BACKEND}.impala definitions.impala utilities.impala atomic.impala count_flops/${COUNT_FLOPS}.impala cell.impala grid.impala neighborlist.impala redistribution.impala integration.impala force_computation.impala lennard_jones.impala energy.impala test_cpu.impala)

add_executable(md main.cpp anydsl_includes.h initialize.h time.h vtk.h ${MD_PROGRAM})
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
set_target_properties(md PROPERTIES CXX_STANDARD 14 CXX_STANDARD_REQUIRED ON)
