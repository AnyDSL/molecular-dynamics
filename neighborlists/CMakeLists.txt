cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

project(molecular-dynamics CXX)
#enable_testing()

find_package(AnyDSL_runtime REQUIRED)
include_directories(${AnyDSL_runtime_INCLUDE_DIRS})
set(BACKEND ${BACKEND} CACHE STRING "select the cpu backend from the following: cpu, avx, cuda, nvvm, opencl, amdgpu")
if(NOT BACKEND)
    set(BACKEND cpu CACHE STRING "select the cpu backend from the following: cpu, avx, cuda, nvvm, opencl, amdgpu" FORCE)
endif()
string(TOLOWER "${BACKEND}" BACKEND)
message(STATUS "Selected backend: ${BACKEND}")

set(BACKEND_FILE backend_${BACKEND}.impala)

if(BACKEND STREQUAL "cpu" OR BACKEND STREQUAL "avx")
    set(MAPPING_FILE mapping_cpu.impala)
else()
    set(MAPPING_FILE mapping_gpu.impala)
endif()

option(COUNT_FLOPS "COUNT_FLOPS" OFF)
option(MONITOR_ONLY_FORCE_COMPUTATION "MONITOR_ONLY_FORCE_COMPUTATION" ON)

include_directories(${LIKWID_DIR}/include)

set(CLANG_FLAGS -march=native -O3)
set(IMPALA_FLAGS --log-level warn)
set(ANYDSL_RUNTIME_LIBRARIES ${AnyDSL_runtime_LIBRARIES})
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    NAME md
    FILES
    ${BACKEND_FILE} ${MAPPING_FILE} definitions.impala utilities.impala utilities_accelerator.impala atomic.impala count_flops/${COUNT_FLOPS}.impala cell.impala grid.impala neighborlist.impala redistribution.impala integration.impala force_computation.impala accelerator_grid.impala compute.impala lennard_jones.impala energy.impala runtime.impala new_force_kernel.impala)

add_executable(md main.cpp anydsl_includes.h initialize.h time.h vtk.h ${MD_PROGRAM})
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARIES} ${CMAKE_EXE_LINKER_FLAGS})
set_target_properties(md PROPERTIES CXX_STANDARD_REQUIRED ON)
set_target_properties(md PROPERTIES CXX_STANDARD 14)

if(LIKWID_DIR)
    target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARIES} ${CMAKE_EXE_LINKER_FLAGS} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
endif()
if(MONITOR_ONLY_FORCE_COMPUTATION)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLIKWID_PERFMON -pthread ")
endif()

