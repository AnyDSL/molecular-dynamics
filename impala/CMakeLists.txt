cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(ANYDSL-MD C)
#enable_testing()

SET(CMAKE_C_COMPILER "/software/anydsl/llvm_build/bin/clang")
#SET(CMAKE_C_COMPILER "/usr/bin/clang")
#SET(CMAKE_C_COMPILER "/usr/bin/gcc")
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)
include_directories(${LIKWID_DIR}/include)

set(DATASTRUCTURE ${DATASTRUCTURE} CACHE STRING "select the data structure from the following: linked_cell, array")
if(NOT DATASTRUCTURE)
    set(DATASTRUCTURE linked_cell CACHE STRING "select the data structure from the following: linked_cell, array" FORCE)
endif()
string(TOLOWER "${DATASTRUCTURE}" DATASTRUCTURE)
message(STATUS "Selected data structure: ${DATASTRUCTURE}")

set(INIT ${INIT} CACHE STRING "select the particle initialization method from the following: grid, random, body_collision")
if(NOT INIT)
    set(INIT body_collision CACHE STRING "select the particle initialization method from the following: grid, random, body_collision" FORCE)
endif()
string(TOLOWER "${INIT}" INIT)
message(STATUS "Selected particle initialization method: ${INIT}")


option(LIKWID_PERFMON "LIKWID_PERFMON" OFF)
option(COUNT_FORCE_EVALUATIONS "COUNT_COLLISIONS" OFF)
option(CHECK_INVARIANTS "CHECK_INVARIANTS" OFF)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=native")
if(LIKWID_PERFMON)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLIKWID_PERFMON")
endif()
if(COUNT_FORCE_EVALUATIONS)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DCOUNT_FORCE_EVALUATIONS")
endif()

set(CLANG_FLAGS -O3 -march=native )
set(IMPALA_FLAGS --log-level error)
# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES intrinsics/intrinsics_cpu.impala utilities/common.impala utilities/linked_list.impala linked_list/default.impala potential/lennard_jones.impala particle_system/${DATASTRUCTURE}.impala boundary/default.impala count_force_evaluations/${COUNT_FORCE_EVALUATIONS}.impala algorithm/${DATASTRUCTURE}.impala initialization/constants/test.impala initialization/particles/${INIT}.impala integration/verlet.impala checking/${CHECK_INVARIANTS}/${DATASTRUCTURE}.impala run.impala)

add_executable(md main.c ${MD_PROGRAM} ../clib/fileIO.c ../clib/allocate.c ../clib/random.c)
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
set_target_properties(md PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
#add_test("md" md)
