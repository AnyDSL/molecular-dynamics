cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(molecular-dynamics CXX)
#enable_testing()

find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)
include_directories(${LIKWID_DIR}/include)

set(CPU_BACKEND ${CPU_BACKEND} CACHE STRING "select the cpu backend from the following: CPU, AVX")
if(NOT CPU_BACKEND)
    set(CPU_BACKEND cpu CACHE STRING "select the cpu backend from the following: CPU, AVX" FORCE)
endif()
string(TOLOWER "${CPU_BACKEND}" CPU_BACKEND)
message(STATUS "Selected backend: ${CPU_BACKEND}")

set(CPU_BACKEND_FILE backend_${CPU_BACKEND}.impala)


set(GPU_BACKEND ${GPU_BACKEND} CACHE STRING "select the gpu backend from the following: cuda, nvvm, opencl, amdgpu")
if(NOT GPU_BACKEND)
    set(GPU_BACKEND opencl CACHE STRING "select the cpu backend from the following: cuda, nvvm, opencl, amdgpu" FORCE)
endif()
string(TOLOWER "${GPU_BACKEND}" GPU_BACKEND)
message(STATUS "Selected backend: ${GPU_BACKEND}")

set(GPU_BACKEND_FILE backend_${GPU_BACKEND}.impala)

option(USE_GPU "USE_GPU" OFF)
if(USE_GPU)
    set(RUNTIME_FILE test_gpu.impala)
else()
    set(RUNTIME_FILE test_cpu.impala)
endif()

option(COUNT_FLOPS "COUNT_FLOPS" OFF)
option(MONITOR_FORCE_COMPUTATION "MONITOR_FORCE_COMPUTATION" OFF)
if(MONITOR_FORCE_COMPUTATION)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLIKWID_PERFMON -pthread")
endif()

set(CLANG_FLAGS -march=native)
set(IMPALA_FLAGS -O3 --log-level error)
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    ${CPU_BACKEND_FILE} ${GPU_BACKEND_FILE} definitions.impala utilities.impala atomic.impala count_flops/${COUNT_FLOPS}.impala cell.impala grid.impala neighborlist.impala redistribution.impala integration.impala force_computation.impala lennard_jones.impala energy.impala gpu_grid.impala ${RUNTIME_FILE})

add_executable(md main.cpp anydsl_includes.h initialize.h time.h vtk.h ${MD_PROGRAM})
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
set_target_properties(md PROPERTIES CXX_STANDARD 14 CXX_STANDARD_REQUIRED ON)
