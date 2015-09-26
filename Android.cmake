set(UNIX 1)
add_definitions(-DUNIX)

function(CheckEnvDefined arg0 example)
	message(STATUS "${arg0}: ${${arg0}}")
	if(NOT DEFINED ${arg0})
		message(FATAL_ERROR "Required value ${arg0} is not defined.\n"
							"Example: ${arg0} = ${example}")
	endif()
endfunction()
function(CheckEnvDir arg0 example)
	CheckEnvDefined(${arg0} ${example})
	if(NOT IS_DIRECTORY ${${arg0}})
		message(FATAL_ERROR "${arg0}: ${${arg0}} is not a valid directory.\n"
							"Example: ${arg0} = ${example}")
	endif()
endfunction()

# 環境変数のチェックとディレクトリの存在確認
set(BOOST_PATH $ENV{BOOST_PATH})
set(ANDROID_NDK_COMPILER_ROOT $ENV{ANDROID_NDK_COMPILER_ROOT})
message(STATUS ">>-- enviroment variables check --<<")
CheckEnvDir(BOOST_PATH "/opt/boost")
CheckEnvDir(ANDROID_NDK_COMPILER_ROOT "/opt/android-x86")
message(STATUS ">>-- enviroment variables ok --<<")

# Boost library ディレクトリが存在するか確認
set(BOOST_PATH "${BOOST_PATH}/${ANDROID_ARCH_LONG}")
message(STATUS "BOOST_PATH(actual): ${BOOST_PATH}")
if(NOT IS_DIRECTORY ${BOOST_PATH})
	message(FATAL_ERROR "${BOOST_PATH} is not exist.")
endif()

set(TOOL_PREFIX ${ANDROID_ARCH_LONG})

if(USE_CLANG)
	set(C_COMPILER "clang")
	set(CXX_COMPILER "clang++")
else()
	set(C_COMPILER "gcc")
	set(CXX_COMPILER "g++")
endif()
set(CMAKE_C_COMPILER "${ANDROID_NDK_COMPILER_ROOT}/bin/${ANDROID_PREF}-${C_COMPILER}")
set(CMAKE_CXX_COMPILER "${ANDROID_NDK_COMPILER_ROOT}/bin/${ANDROID_PREF}-${CXX_COMPILER}")

add_definitions(-DUSE_OPENGLES2)

# Android用のビルド設定
include_directories(${BOOST_PATH}
					${PROJECT_SOURCE_DIR})
link_directories(${BOOST_PATH}/android_${ARCHITECTURE}/lib)
add_definitions(-DANDROID
				-D__ANDROID__
				-DGLIBC
				-D_GLIBCPP_USE_WCHAR_T
				-D_REENTRANT
				-D_LITTLE_ENDIAN)
#				-DPAGE_SIZE=2048
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Wno-attributes -std=c++1y -I${BOOST_PATH}/include")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG -ggdb3 -O0 -UNDEBUG -fno-omit-frame-pointer -fno-strict-aliasing -Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DNDEBUG -O2 -fomit-frame-pointer")

set(LDFLAGS "-no-canonical-prefixes")
set(CMAKE_MODULE_LINKER_FLAGS ${LDFLAGS})
set(CMAKE_SHARED_LINKER_FLAGS ${LDFLAGS})
set(CMAKE_EXE_LINKER_FLAGS ${LDFLAGS})

file(GLOB COMMON_CMAKE "${CMAKE_CURRENT_LIST_DIR}/Common.cmake")
include(${COMMON_CMAKE})
