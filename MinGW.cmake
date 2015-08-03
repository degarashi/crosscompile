set(WIN32 1)
add_definitions(-DWIN32)
set(TOOL_PREFIX mingw)

# set(CMAKE_STATIC_LIBRARY_PREFIX "")
# set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
# set(CMAKE_SHARED_LIBRARY_PREFIX "")
# set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
# set(CMAKE_IMPORT_LIBRARY_PREFIX "")
# set(CMAKE_IMPORT_LIBRARY_SUFFIX ".a")
# set(CMAKE_EXECUTABLE_SUFFIX ".exe")
# set(CMAKE_LINK_LIBRARY_SUFFIX ".a")
# set(CMAKE_DL_LIBS "")

# set(CMAKE_FIND_LIBRARY_PREFIXES "")
# set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

set(CCPATH $ENV{HOME}/local/bin)
set(CMAKE_C_COMPILER ${CCPATH}/i686-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER ${CCPATH}/i686-w64-mingw32-g++)
set(CMAKE_AR ${CCPATH}/i686-w64-mingw32-ar)
set(CMAKE_RANLIB ${CCPATH}/i686-w64-mingw32-ranlib)
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

link_directories($ENV{HOME}/local/i686-w64-mingw32/lib)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${DEPEND_CFLAG} -mpreferred-stack-boundary=2")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++1y")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG -Og -Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")

file(GLOB_RECURSE COMMON_CMAKE ${CMAKE_HOME_DIRECTORY} "Common.cmake")
include(${COMMON_CMAKE})

