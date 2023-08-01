ADD_SUBDIRECTORY("${CMAKE_CURRENT_SOURCE_DIR}/myLib")

if(USE_LOCAL_PACKAGES)
  # ADD_SUBDIRECTORY("${CMAKE_CURRENT_SOURCE_DIR}/LIB")
  # target_include_directories(${PROJECT_NAME} PUBLIC LIB)
else()
endif(USE_LOCAL_PACKAGES)

target_include_directories(${PROJECT_NAME} PUBLIC myLib) # don't need to
