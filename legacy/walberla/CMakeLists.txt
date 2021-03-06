cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)

set(CMAKE_C_COMPILER "/software/anydsl/llvm_build/bin/clang")
set(CLANG_FLAGS -O3 -march=native)
set(IMPALA_FLAGS --emit-llvm --log-level error)
set(IMPALA_SRC_DIR ../impala)


option(CHECK_INVARIANTS "CHECK_INVARIANTS" OFF)
option(VECTORIZE_MD "VECTORIZE_MD" ON)

SET(VEC) 
if(VECTORIZE_MD)
    SET(VEC vectorized)
endif()


# examples based on the "mapping"
anydsl_runtime_wrap(IMPALA_OBJECT_FILE
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES
    ${IMPALA_SRC_DIR}/mapping/walberla.impala  
    ${IMPALA_SRC_DIR}/intrinsics/cpu.impala  
    ${IMPALA_SRC_DIR}/utilities/common.impala ${IMPALA_SRC_DIR}/utilities/linked_list.impala ${IMPALA_SRC_DIR}/utilities/particle_system.impala     
    ${IMPALA_SRC_DIR}/datastructures/pe_linked_list.impala ${IMPALA_SRC_DIR}/datastructures/pe_array_of_addresses.impala ${IMPALA_SRC_DIR}/datastructures/particle_system.impala block_list.impala
    ${IMPALA_SRC_DIR}/datastructures/particle_vector.impala
    ${IMPALA_SRC_DIR}/potential/${VEC}/lennard_jones.impala ${IMPALA_SRC_DIR}/integration/${VEC}/verlet.impala ${IMPALA_SRC_DIR}/boundary/default.impala  
    ${IMPALA_SRC_DIR}/algorithm/${VEC}/force_calculation.impala ${IMPALA_SRC_DIR}/algorithm/${VEC}/pe_integration.impala ${IMPALA_SRC_DIR}/algorithm/${VEC}/distribution.impala 
    ${IMPALA_SRC_DIR}/initialization/constants/test.impala 
    ${IMPALA_SRC_DIR}/utilities/pe_vtk.impala  
    ${IMPALA_SRC_DIR}/count_force_evaluations/OFF.impala ${IMPALA_SRC_DIR}/checking/${CHECK_INVARIANTS}.impala 
    runtime/init.impala runtime/${VEC}/solver.impala)
waLBerla_add_executable ( NAME md_simulation
    FILES md_simulation.cpp anydsl_md.cpp ${IMPALA_OBJECT_FILE} pe_impala_interfaces.cpp ${IMPALA_SRC_DIR}/../clib/fileIO.c ${IMPALA_SRC_DIR}/../clib/allocate.c     
    DEPENDS core blockforest pe domain_decomposition vtk
 )
target_link_libraries(md_simulation m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES})
set_target_properties(md_simulation PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
