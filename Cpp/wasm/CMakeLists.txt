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


if (DEFINED EMSCRIPTEN)
  add_executable(${PROJECT_NAME} src/main.cpp)
  target_link_libraries(${PROJECT_NAME} myLib) # link library

  ADD_SUBDIRECTORY(lib)

  set(CMAKE_EXECUTABLE_SUFFIX ".wasm")

  set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "-Os -s SIDE_MODULE=1 ")
  set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS    "-Os -s WASM=1 -s SIDE_MODULE=1 -s STANDALONE_WASM --no-entry")
else()

endif()
