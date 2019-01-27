cmake_minimum_required (VERSION 2.8)
project(fuse-wsfs)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(FUSE3 REQUIRED fuse3)
pkg_check_modules(LWS REQUIRED libwebsockets)
pkg_check_modules(JANSSON REQUIRED jansson)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -pedantic -Wextra")

set(EXTRA_INCLUDE_DIRS
	${FUSE3_INCLUDE_DIRS} 
	${LWS_INCLUDE_DIRS} 
	${JANSSON_INCLUDE_DIRS}
)

set(EXTRA_LIBS 
	${EXTRA_LIBS}
	${FUSE3_LIBRARIES}
	${LWS_LIBRARIES}
	${JANSSON_LIBRARIES}
	${CMAKE_THREAD_LIBS_INIT}
)

set(EXTRA_CFLAGS
	${FUSE3_CFLAGS_OTHER}
	${LWS_CFLAGS_OTHER}
	${JANSSON_CFLAGS_OTHER}
	"-pthread"
)


# libfuse-wsfs

add_library(fuse-wsfs
	src/wsfs/operations.c
	src/wsfs/filesystem.c
	src/wsfs/response_parser.c
	src/wsfs/server.c
	src/wsfs/protocol.c
	src/wsfs/jsonrpc.c
)

target_include_directories(fuse-wsfs PUBLIC src ${EXTRA_INCLUDE_DIRS})
target_compile_options(fuse-wsfs PUBLIC  ${EXTRA_CFLAGS})

# app

add_executable(wsfs
	src/app/main.c
)

target_link_libraries(wsfs PUBLIC fuse-wsfs ${EXTRA_LIBS})
target_include_directories(wsfs PUBLIC src ${EXTRA_INCLUDE_DIRS})
target_compile_options(wsfs PUBLIC ${EXTRA_CFLAGS})

# tests
	
add_executable(alltests
	test-src/test_main.c
	test-src/test_util.c
	test-src/test_response_parser.c
)

target_link_libraries(alltests PUBLIC fuse-wsfs ${EXTRA_LIBS})
target_include_directories(alltests PUBLIC src ${EXTRA_INCLUDE_DIRS})
target_compile_options(alltests PUBLIC ${EXTRA_CFLAGS})
