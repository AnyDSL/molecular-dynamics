CMAKE_MINIMUM_REQUIRED( VERSION 2.6 )
PROJECT(C-MD)


SET (CMAKE_C_COMPILER "/simdata/schmitt/anydsl/llvm_build/bin/clang")
INCLUDE_DIRECTORIES(include)
INCLUDE_DIRECTORIES(../clib)

FILE( GLOB_RECURSE PROJ_SOURCES source/*.c ../clib/*.c ../clib/*.h)
FILE( GLOB_RECURSE PROJ_HEADERS include/*.h )

#FIND_PACKAGE( OpenMP REQUIRED)
#if(OPENMP_FOUND)
#message("OPENMP FOUND")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
#endif()

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=native")
ADD_EXECUTABLE(md ${PROJ_SOURCES} ${PROJ_HEADERS})

#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g -fsanitize=memory -fno-omit-frame-pointer")
#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g")
#SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
#SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} -O0 -g -fsanitize=memory -fno-omit-frame-pointer")
set_target_properties(md PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED ON)
target_link_libraries(md m)

# Debugging flags
