CMAKE_MINIMUM_REQUIRED(VERSION 3.11)

PROJECT(PROJECT_NAME VERSION 0.1.0)

SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_STANDARD 23)
SET(CMAKE_CXX_FLAGS "-O3")


if(USE_LOCAL_PACKAGES)
  # find_package( REQUIRED)
else()
  # include(FetchContent)
  # FetchContent_Declare()
  # FetchContent_MakeAvailable()

endif(USE_LOCAL_PACKAGES)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(lib)


# https://stunlock.gg/posts/emscripten_with_cmake/#tldr
if (DEFINED EMSCRIPTEN)
  set(CMAKE_EXECUTABLE_SUFFIX ".wasm")
  set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "-O3 -s SIDE_MODULE=1")
  set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS    "-O3 -s WASM=1 -s SIDE_MODULE=0 -s STANDALONE_WASM --no-entry -s \"EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap']\"")
else()

endif()
