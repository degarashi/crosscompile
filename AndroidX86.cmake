set(ARCHITECTURE x86)
set(ANDROID_PREF "i686-linux-android")
set(ANDROID_TOOLCHAIN "x86")
set(ANDROID_ARCH_SHORT "x86")
set(ANDROID_ARCH_LONG "x86")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -target i686-linux-android -ffunction-sections -funwind-tables -no-canonical-prefixes -fstack-protector")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fstrict-aliasing -funswitch-loops")
if(NOT USE_CLANG)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -finline-limit=300")
endif()

file(GLOB ANDROID_CMAKE "${CMAKE_CURRENT_LIST_DIR}/Android.cmake")
include(${ANDROID_CMAKE})
