# [設定必須の変数]
# SOUND_API (openal | opensl)
# SSE_LEVEL (0-4)
# (to Use SSE instructions)
#	set(SSE_LEVEL 2)
# (to Use NEON instructions)
#	set(NEON_LEVEL 1)

include_directories(${PROJECT_SOURCE_DIR})
# 対象のビット数でフラグを分ける
if(DEFINED M64)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
	if(NOT DEFINED SSE_LEVEL)
		#64bitプロセッサならSSE2は付いているはずなのでフラグを追加
		if(NOT (${SSE_LEVEL} GREATER 2))
			set(SSE_LEVEL 2)
		endif()
	endif()
else()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
endif()
# SSEが設定されているならコンパイラのフラグを付ける
if(DEFINED SSE_LEVEL)
	if(${SSE_LEVEL} GREATER 0)
		# SSE1の時は-msse, SSE2〜4の時は-msse{NUM}とする
		if(${SSE_LEVEL} EQUAL 1)
			set(FLAGNUM "")
		else()
			set(FLAGNUM ${SSE_LEVEL})
		endif()
		add_definitions(-DSSE_LEVEL=${SSE_LEVEL})
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse${FLAGNUM}")
		message(STATUS "configured as to using SSE-" ${SSE_LEVEL} " instructions...")
	endif()
elseif(DEFINED NEON_LEVEL)
	if(${NEON_LEVEL} GREATER 0)
		add_definitions(-DNEON_LEVEL=${NEON_LEVEL})
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon")
		message(STATUS "configured as to using NEON-" ${NEON_LEVEL} " instructions...")
	endif()
endif()
add_definitions(-DBOOST_PP_VARIADICS=1)

