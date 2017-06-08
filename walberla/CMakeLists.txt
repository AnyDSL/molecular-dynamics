cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
find_package(AnyDSL-runtime REQUIRED)
include(${ANYDSL_RUNTIME_CMAKE_DIR}/Runtime.cmake)
include_directories(${ANYDSL_RUNTIME_DIR}/src)

set(CLANG_FLAGS -O3 -march=native)
set(IMPALA_FLAGS --log-level info)
set(IMPALA_SRC_DIR ../impala)

# examples based on the "mapping"
anydsl_runtime_wrap(IMPALA_OBJECT_FILE
    CLANG_FLAGS ${CLANG_FLAGS}
    IMPALA_FLAGS ${IMPALA_FLAGS}
    FILES ${IMPALA_SRC_DIR}/intrinsics/intrinsics_cpu.impala ${IMPALA_SRC_DIR}/common.impala ${IMPALA_SRC_DIR}/datastructures/linked_cell/cpu.impala ${IMPALA_SRC_DIR}/utilities/linked_cell/cpu.impala ${IMPALA_SRC_DIR}/initialization/constants/test_walberla.impala ${IMPALA_SRC_DIR}/algorithm/linked_cell/cpu.impala ${IMPALA_SRC_DIR}/potential/lennard_jones.impala ${IMPALA_SRC_DIR}/integration/verlet.impala ${IMPALA_SRC_DIR}/boundary/test.impala ${IMPALA_SRC_DIR}/walberla_runtime/cpu.impala)

waLBerla_add_executable ( NAME md_simulation
    FILES ${IMPALA_OBJECT_FILE} ${IMPALA_SRC_DIR}/../clib/fileIO.c ${IMPALA_SRC_DIR}/../clib/allocate.c md_simulation.cpp     
    DEPENDS core blockforest pe domain_decomposition vtk
 )
target_link_libraries(md_simulation m ${ANYDSL_RUNTIME_LIBRARY} ${ANYDSL_RUNTIME_LIBRARIES})
