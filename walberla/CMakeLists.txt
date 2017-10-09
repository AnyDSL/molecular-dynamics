cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)

set(CLANG_FLAGS -O3 -march=native)
set(IMPALA_FLAGS --log-level warn)
set(IMPALA_SRC_DIR ../impala)


option(CHECK_INVARIANTS "CHECK_INVARIANTS" OFF)

# examples based on the "mapping"
anydsl_runtime_wrap(IMPALA_OBJECT_FILE
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    ${IMPALA_SRC_DIR}/intrinsics/intrinsics_cpu.impala 
    ${IMPALA_SRC_DIR}/utilities/common.impala ${IMPALA_SRC_DIR}/utilities/linked_list.impala ${IMPALA_SRC_DIR}/utilities/particle_system.impala     
    ${IMPALA_SRC_DIR}/datastructures/pe_linked_list.impala ${IMPALA_SRC_DIR}/datastructures/pe_array_of_addresses.impala ${IMPALA_SRC_DIR}/datastructures/particle_system.impala block_list.impala
    ${IMPALA_SRC_DIR}/datastructures/particle_vector.impala
    ${IMPALA_SRC_DIR}/potential/lennard_jones_simd.impala ${IMPALA_SRC_DIR}/integration/verlet.impala ${IMPALA_SRC_DIR}/boundary/default.impala  
    ${IMPALA_SRC_DIR}/algorithm/force_calculation.impala ${IMPALA_SRC_DIR}/algorithm/pe_integration.impala ${IMPALA_SRC_DIR}/algorithm/distribution.impala 
    ${IMPALA_SRC_DIR}/initialization/constants/test.impala 
    ${IMPALA_SRC_DIR}/utilities/pe_vtk.impala  
    ${IMPALA_SRC_DIR}/count_force_evaluations/OFF.impala ${IMPALA_SRC_DIR}/checking/${CHECK_INVARIANTS}.impala 
    runtime.impala)
waLBerla_add_executable ( NAME md_simulation
    FILES md_simulation.cpp anydsl_md.cpp ${IMPALA_OBJECT_FILE} pe_impala_interfaces.cpp ${IMPALA_SRC_DIR}/../clib/fileIO.c ${IMPALA_SRC_DIR}/../clib/allocate.c     
    DEPENDS core blockforest pe domain_decomposition vtk
 )
target_link_libraries(md_simulation m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES})
