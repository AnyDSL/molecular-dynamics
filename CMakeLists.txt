cmake_minimum_required(VERSION 3.8.2 FATAL_ERROR)

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

set(BACKEND_FILE backend/backend_${BACKEND}.impala)

if(BACKEND STREQUAL "nvvm")
    set(MAPPING_FILE backend/mapping_gpu.impala)
else()
    set(MAPPING_FILE backend/mapping_cpu.impala)
endif()

set(COMM_MAPPING ${COMM_MAPPING} CACHE STRING "select the MPI mapping from the following: anydsl, nompi")
if(NOT COMM_MAPPING)
    set(COMM_MAPPING anydsl CACHE STRING "select the MPI mapping from the following: anydsl, nompi" FORCE)
endif()

set(COMM_MAPPING_FILE comm/mapping_${COMM_MAPPING}.impala)

option(USE_SOA "USE_SOA" ON)
option(USE_MPI "USE_MPI" ON)
option(COUNT_FLOPS "COUNT_FLOPS" OFF)
option(MONITOR_ONLY_FORCE_COMPUTATION "MONITOR_ONLY_FORCE_COMPUTATION" OFF)
option(BODY_COLLISION_TEST "BODY_COLLISION_TEST" OFF)
option(USE_WALBERLA_LOAD_BALANCING "USE_WALBERLA_LOAD_BALANCING" OFF)

# Just use -march=native when compiling and executing in the same machine
#set(CLANG_FLAGS -O3 -march=native -ffast-math)
set(CLANG_FLAGS -O3 -ffast-math)
set(IMPALA_FLAGS -O3 --log-level warn)
set(ANYDSL_RUNTIME_LIBRARIES ${AnyDSL_runtime_LIBRARIES})

if(USE_SOA)
    set(DATA_LAYOUT_FILE data_layout/mapping_soa.impala)
else()
    set(DATA_LAYOUT_FILE data_layout/mapping_aos.impala)
endif()

if(COMM_MAPPING STREQUAL "anydsl")
    set(MPI_FILES comm/mpi.impala)
    set(MPI_CPP comm/mpi.cpp)
else()
    set(MPI_FILES "")
    set(MPI_CPP "")
endif()

set(MD_SRCS
    core/compute.impala
    core/grid.impala
    core/neighborlist.impala
    core/runtime.impala
    utils/atomic.impala
    utils/definitions.impala
    utils/utilities.impala
    utils/utilities_accelerator.impala
    ${DATA_LAYOUT_FILE}
    ${BACKEND_FILE}
    ${MAPPING_FILE}
    ${COMM_MAPPING_FILE}
    ${MPI_FILES})

anydsl_runtime_wrap(MD_OBJS
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    NAME md
    FILES ${MD_SRCS})

if(USE_WALBERLA_LOAD_BALANCING)
    find_package(waLBerla REQUIRED)
    add_subdirectory( ${walberla_SOURCE_DIR} ${walberla_BINARY_DIR} EXCLUDE_FROM_ALL )

    waLBerla_import()

    waLBerla_add_executable(
        NAME md
        FILES main.cpp core/force_lj.cpp ${MPI_CPP} anydsl_includes.h initialize.h time.h vtk.h ${MD_OBJS}
        DEPENDS blockforest core pe)
else()
    add_executable(md main.cpp core/force_lj.cpp ${MPI_CPP} anydsl_includes.h initialize.h time.h vtk.h ${MD_OBJS})
endif()

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

if(USE_WALBERLA_LOAD_BALANCING)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSE_WALBERLA_LOAD_BALANCING ")
endif()

if(BODY_COLLISION_TEST)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBODY_COLLISION_TEST ")
endif()

