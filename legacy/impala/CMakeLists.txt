cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(ANYDSL-MD C)
#enable_testing()

#SET(CMAKE_C_COMPILER "/software/anydsl/llvm_build/bin/clang")
#SET(CMAKE_C_COMPILER "/usr/bin/clang")
#SET(CMAKE_C_COMPILER "/home/jonas/Software/anydsl/llvm_build/bin/clang")
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)
include_directories(${LIKWID_DIR}/include)

set(INIT ${INIT} CACHE STRING "select the particle initialization method from the following: grid, random, body_collision")
if(NOT INIT)
    set(INIT body_collision CACHE STRING "select the particle initialization method from the following: grid, random, body_collision" FORCE)
endif()
string(TOLOWER "${INIT}" INIT)
message(STATUS "Selected particle initialization method: ${INIT}")


option(LIKWID_PERFMON "LIKWID_PERFMON" OFF)
option(COUNT_FORCE_EVALUATIONS "COUNT_COLLISIONS" OFF)
option(CHECK_INVARIANTS "CHECK_INVARIANTS" OFF)
option(VECTORIZE "VECTORIZE" OFF)

SET(VEC) 
if(VECTORIZE)
    SET(VEC vectorized)
endif()

if(LIKWID_PERFMON)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLIKWID_PERFMON")
endif()
if(COUNT_FORCE_EVALUATIONS)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DCOUNT_FORCE_EVALUATIONS")
endif()

set(CLANG_FLAGS -O3 -march=native )
#set(CLANG_FLAGS -O0 -g )
set(IMPALA_FLAGS -O3 --log-level error)
#set(IMPALA_FLAGS --log-level error -g)
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    intrinsics/cpu.impala
    mapping/cpu.impala mapping/single_node.impala
    utilities/common.impala utilities/linked_list.impala utilities/particle_system.impala utilities/vtk.impala
    datastructures/linked_list.impala datastructures/array_of_addresses.impala datastructures/particle_vector.impala datastructures/particle_system.impala
    potential/${VEC}/lennard_jones.impala algorithm/${VEC}/force_calculation.impala
    integration/${VEC}/verlet.impala boundary/default.impala
    algorithm/${VEC}/integration.impala algorithm/${VEC}/distribution.impala
    initialization/constants/test.impala initialization/particles/${INIT}.impala
    count_force_evaluations/${COUNT_FORCE_EVALUATIONS}.impala checking/${CHECK_INVARIANTS}.impala
    runtime/${VEC}/run.impala)

add_executable(md main.c ${MD_PROGRAM} ../clib/fileIO.c ../clib/allocate.c ../clib/random.c)
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
set_target_properties(md PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
