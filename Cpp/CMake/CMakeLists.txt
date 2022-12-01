CMAKE_MINIMUM_REQUIRED(VERSION 3.11)

PROJECT(PROJECT_NAME LANGUAGES CXX VERSION 0.1.0)


if(USE_LOCAL_PACKAGES)
  # find_package( REQUIRED)
else()
  # include(FetchContent)
  # FetchContent_Declare()
  # FetchContent_MakeAvailable()

endif(USE_LOCAL_PACKAGES)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(lib)
