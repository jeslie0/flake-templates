cmake_minimum_required(VERSION 4.1.2)

project(
  PROJECT_NAME
  LANGUAGES CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(${PROJECT_NAME}
  src/main.cpp
)
