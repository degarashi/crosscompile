set(UNIX 1)
add_definitions(-DUNIX)

# 環境変数のチェックとディレクトリの存在確認
set(BOOST_PATH $ENV{BOOST_PATH})
set(ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT})
set(ANDROID_VER $ENV{ANDROID_VER})

message(STATUS ">>-- enviroment variables check --<<")
message(STATUS "BOOST_PATH: ${BOOST_PATH}")
message(STATUS "ANDROID_NDK_ROOT: ${ANDROID_NDK_ROOT}")
message(STATUS "ANDROID_VER: ${ANDROID_VER}")
if((NOT IS_DIRECTORY ${BOOST_PATH})
	OR (NOT IS_DIRECTORY ${ANDROID_NDK_ROOT})
	OR (NOT DEFINED ANDROID_VER)
	OR ("${ANDROID_VER}" LESS "1"))
	message(FATAL_ERROR "
		Some required enviroment values are not defined or invalid.
		Example:
			BOOST_PATH = /opt/boost/arm
			ANDROID_NDK_ROOT = /opt/android-ndk
			ANDROID_VER = 10")
endif()
message(STATUS ">>-- enviroment variables ok --<<")

# Boost library ディレクトリが存在するか確認
set(BOOST_PATH "${BOOST_PATH}/${ANDROID_ARCH_LONG}")
message(STATUS "BOOST_PATH(actual): ${BOOST_PATH}")
if(NOT IS_DIRECTORY ${BOOST_PATH})
	message(FATAL_ERROR "${BOOST_PATH} is not exist.")
endif()

set(ANDROID_PLATFORM "linux-x86_64")
set(TOOL_PREFIX ${ANDROID_ARCH_LONG})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --sysroot=${ANDROID_NDK_ROOT}/platforms/android-${ANDROID_VER}/arch-${ANDROID_ARCH_SHORT}")
if(USE_CLANG)
	set(CMAKE_TOOLBASE "${ANDROID_NDK_ROOT}/toolchains/llvm-3.4/prebuilt/${ANDROID_PLATFORM}/bin/")
	set(CMAKE_C_COMPILER "${CMAKE_TOOLBASE}clang")
	set(CMAKE_CXX_COMPILER "${CMAKE_TOOLBASE}clang++")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --gcc-toolchain=${ANDROID_NDK_ROOT}/toolchains/${ANDROID_TOOLCHAIN}-4.8/prebuilt/${ANDROID_PLATFORM}")
else()
	set(CMAKE_TOOLBASE "${ANDROID_NDK_ROOT}/toolchains/${ANDROID_TOOLCHAIN}-4.8/prebuilt/${ANDROID_PLATFORM}/bin/${ANDROID_PREF}-")
	set(CMAKE_C_COMPILER "${CMAKE_TOOLBASE}gcc")
	set(CMAKE_CXX_COMPILER "${CMAKE_TOOLBASE}g++")
endif()

add_definitions(-DUSE_OPENGLES2)

# Android用のビルド設定
include_directories(${ANDROID_NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.8/include
					${ANDROID_NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.8/libs/${ANDROID_ARCH_LONG}/include
					${ANDROID_NDK_ROOT}/platforms/android-${ANDROID_VER}/arch-${ANDROID_ARCH_SHORT}/usr/include
					${BOOST_PATH}
					${PROJECT_SOURCE_DIR})
link_directories(${BOOST_PATH}/android_${ARCHITECTURE}/lib
				${ANDROID_NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.8/libs/${ANDROID_ARCH_LONG}
				${ANDROID_NDK_ROOT}/platforms/android-${ANDROID_VER}/arch-${ANDROID_ARCH_SHORT}/usr/lib)
add_definitions(-DANDROID
				-D__ANDROID__
				-DGLIBC
				-D_GLIBCPP_USE_WCHAR_T
				-D_REENTRANT
				-D_LITTLE_ENDIAN)
#				-DPAGE_SIZE=2048
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Wno-attributes -std=c++1y -I${BOOST_PATH}/include")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG -ggdb3 -O0 -UNDEBUG -fno-omit-frame-pointer -fno-strict-aliasing")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DNDEBUG -O2 -fomit-frame-pointer")

set(LDFLAGS "-no-canonical-prefixes")
set(CMAKE_MODULE_LINKER_FLAGS ${LDFLAGS})
set(CMAKE_SHARED_LINKER_FLAGS ${LDFLAGS})
set(CMAKE_EXE_LINKER_FLAGS ${LDFLAGS})

file(GLOB_RECURSE COMMON_CMAKE ${CMAKE_HOME_DIRECTORY} "Common.cmake")
include(${COMMON_CMAKE})

