CMAKE_MINIMUM_REQUIRED( VERSION 2.6 )
PROJECT(C-MD)


SET(CMAKE_C_COMPILER "/software/anydsl/llvm_build/bin/clang")
#SET(CMAKE_C_COMPILER "/usr/bin/clang")
#SET(CMAKE_C_COMPILER "/usr/bin/gcc")
INCLUDE_DIRECTORIES(include)
INCLUDE_DIRECTORIES(../clib)
include_directories(${LIKWID_DIR}/include)

FILE( GLOB_RECURSE PROJ_SOURCES source/*.c ../clib/*.c )
FILE( GLOB_RECURSE PROJ_HEADERS include/*.h ../clib/*.h)

#FIND_PACKAGE( OpenMP REQUIRED)
#if(OPENMP_FOUND)
#message("OPENMP FOUND")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
#endif()
option(LIKWID_PERFMON "LIKWID_PERFMON" OFF)
option(COUNT_COLLISIONS "COUNT_COLLISIONS" OFF)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=native")
find_package(OpenMP)
if (OPENMP_FOUND)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
endif()
if(LIKWID_PERFMON)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLIKWID_PERFMON")
endif()
if(COUNT_COLLISIONS)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DCOUNT_COLLISIONS")
endif()
ADD_EXECUTABLE(md ${PROJ_SOURCES} ${PROJ_HEADERS})

#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g -fsanitize=memory -fno-omit-frame-pointer")
#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g")
#SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
#SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} -O0 -g -fsanitize=memory -fno-omit-frame-pointer")
set_target_properties(md PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
target_link_libraries(md m -I${LIKWID_DIR}/include -L${LIKWID_DIR}/lib -llikwid)

# Debugging flags
