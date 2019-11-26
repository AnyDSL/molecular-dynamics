cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

project(molecular-dynamics CXX)
#enable_testing()

find_package(AnyDSL_runtime REQUIRED)
include_directories(${AnyDSL_runtime_INCLUDE_DIRS})
set(BACKEND ${BACKEND} CACHE STRING "select the cpu backend from the following: cpu, avx, avx512, nvvm")
if(NOT BACKEND)
    set(BACKEND cpu CACHE STRING "select the cpu backend from the following: cpu, avx, avx512, nvvm" FORCE)
endif()
string(TOLOWER "${BACKEND}" BACKEND)
message(STATUS "Selected backend: ${BACKEND}")

set(BACKEND_FILE backend_${BACKEND}.impala)

if(BACKEND STREQUAL "nvvm")
    set(MAPPING_FILE mapping_gpu.impala)
else()
    set(MAPPING_FILE mapping_cpu.impala)
endif()

option(USE_SOA "USE_SOA" ON)
option(USE_MPI "USE_MPI" ON)
option(COUNT_FLOPS "COUNT_FLOPS" OFF)
option(MONITOR_ONLY_FORCE_COMPUTATION "MONITOR_ONLY_FORCE_COMPUTATION" OFF)
option(BODY_COLLISION_TEST "BODY_COLLISION_TEST" OFF)

# Just use -march=native when compiling and executing in the same machine
#set(CLANG_FLAGS -march=native -O3)
set(CLANG_FLAGS -O3)
set(IMPALA_FLAGS --log-level warn -O3)
set(ANYDSL_RUNTIME_LIBRARIES ${AnyDSL_runtime_LIBRARIES})

if(USE_SOA)
    set(ARRAY_3D_FILES mapping_soa.impala)
else()
    set(ARRAY_3D_FILES mapping_aos.impala)
endif()

if(USE_MPI)
    set(MPI_FILES mpi.impala mapping_mpi.impala)
    set(MPI_CPP "mpi.cpp")
else()
    set(MPI_FILES mapping_no_mpi.impala)
    set(MPI_CPP "")
endif()

# examples based on the "mapping"
anydsl_runtime_wrap(MD_PROGRAM
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    NAME md
    FILES
    definitions.impala ${BACKEND_FILE} ${MAPPING_FILE} ${ARRAY_3D_FILES} ${MPI_FILES} utilities.impala utilities_accelerator.impala atomic.impala count_flops/${COUNT_FLOPS}.impala cell.impala grid.impala neighborlist.impala accelerator_grid.impala compute.impala lennard_jones.impala energy.impala runtime.impala memory.impala)

add_executable(md main.cpp ${MPI_CPP} anydsl_includes.h initialize.h time.h vtk.h ${MD_PROGRAM})
target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARIES} ${CMAKE_EXE_LINKER_FLAGS})
set_target_properties(md PROPERTIES CXX_STANDARD_REQUIRED ON)
set_target_properties(md PROPERTIES CXX_STANDARD 14)

if(USE_MPI)
    find_package(MPI REQUIRED)
    include_directories(SYSTEM ${MPI_INCLUDE_PATH})
    target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARIES} ${MPI_LIBRARIES})
endif()

if(LIKWID_DIR)
    target_link_libraries(md m ${ANYDSL_RUNTIME_LIBRARIES} ${CMAKE_EXE_LINKER_FLAGS} -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)
	include_directories(${LIKWID_DIR}/include)
endif()

if(MONITOR_ONLY_FORCE_COMPUTATION)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLIKWID_PERFMON -llikwid -pthread ")
endif()


if(BODY_COLLISION_TEST)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBODY_COLLISION_TEST ")
endif()

