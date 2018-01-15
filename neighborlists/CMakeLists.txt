cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(molecular-dynamics CXX)
#enable_testing()

find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)

set(CLANG_FLAGS -O3)
set(IMPALA_FLAGS -O3 --log-level error)
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    backend_avx.impala definitions.impala utilities.impala atomic.impala cell.impala grid.impala neighborlist.impala redistribution.impala integration.impala force_computation.impala lennard_jones.impala test_cpu.impala)

add_executable(md main.cpp anydsl_includes.h initialize.h vtk.h ${MD_PROGRAM})
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES})
set_target_properties(md PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON)
