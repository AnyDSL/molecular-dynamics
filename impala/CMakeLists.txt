cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(ANYDSL-MD C)
enable_testing()

SET(CMAKE_C_COMPILER "/simdata/ja42rica/anydsl/llvm_build/bin/clang")
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)

set(DATASTRUCTURE ${DATASTRUCTURE} CACHE STRING "select the data structure from the following: linked_cell, array")
if(NOT DATASTRUCTURE)
    set(DATASTRUCTURE linked_cell CACHE STRING "select the data structure from the following: linked_cell, array" FORCE)
endif()
string(TOLOWER "${DATASTRUCTURE}" DATASTRUCTURE)
message(STATUS "Selected data structure: ${DATASTRUCTURE}")

set(INIT ${INIT} CACHE STRING "select the particle initialization method from the following: random, body_collision")
if(NOT INIT)
    set(INIT random CACHE STRING "select the particle initialization method from the following: random, body_collision" FORCE)
endif()
string(TOLOWER "${INIT}" INIT)
message(STATUS "Selected particle initialization method: ${INIT}")

set(CLANG_FLAGS -O3 -march=native)
set(IMPALA_FLAGS --log-level info)

#set(BACKEND ${BACKEND} CACHE STRING "select the backend from the following: CPU, AVX, NVVM, CUDA, OPENCL")
#if(NOT BACKEND)
#    set(BACKEND cpu CACHE STRING "select the backend from the following: CPU, AVX, NVVM, CUDA, OPENCL" FORCE)
#endif()
#string(TOLOWER "${BACKEND}" BACKEND)
#message(STATUS "Selected backend: ${BACKEND}")

#set(BACKEND_FILE intrinsics_${BACKEND}.impala)

#if(BACKEND STREQUAL "cpu" OR BACKEND STREQUAL "avx")
#    set(DEVICE "cpu")
#else()
#    set(DEVICE "acc")
#endif()

# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES intrinsics/intrinsics_cpu.impala common.impala datastructures/${DATASTRUCTURE}/cpu.impala utilities/${DATASTRUCTURE}/cpu.impala algorithm/${DATASTRUCTURE}/cpu.impala initialization/constants/test.impala initialization/particles/${INIT}.impala potential/lennard_jones.impala integration/verlet.impala boundary/test.impala time_integration/cpu.impala run/cpu.impala )

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=native")
add_executable(md main.c ${MD_PROGRAM} ../clib/fileIO.c ../clib/allocate.c ../clib/random.c)
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES})
set_target_properties(md PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
add_test("md" md)
