CMAKE_MINIMUM_REQUIRED(VERSION 2.8.0)
set(PROJECT_NAME_STR mutton_demo)
project(${PROJECT_NAME_STR} C CXX)

#-------------------
# The version number
#-------------------
set (mutton_demo_VERSION_MAJOR 0)
set (mutton_demo_VERSION_MINOR 5)
set (mutton_demo_VERSION_STRING ${mutton_demo_VERSION_MAJOR}.${mutton_demo_VERSION_MINOR})

#-------------------
# setup deps
#-------------------
set(EXT_PREFIX ${PROJECT_SOURCE_DIR}/ext)
set(CMAKE_MODULE_PATH ${EXT_PREFIX})

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(Boost_USE_STATIC_LIBS ON)
  set(Boost_USE_STATIC_RUNTIME ON)
else()
  set(Boost_USE_STATIC_LIBS OFF)
  set(Boost_USE_STATIC_RUNTIME OFF)
endif()

# Boost
set(Boost_USE_MULTITHREADED ON)
find_package(Boost 1.47.0 COMPONENTS system filesystem REQUIRED )
set(INCLUDES ${INCLUDES} ${Boost_INCLUDE_DIRS} )
set(LIBS ${LIBS} ${Boost_LIBRARIES} )

# Threading
find_package(Threads)
set(LIBS ${LIBS} ${CMAKE_THREAD_LIBS_INIT} )

# libmutton
include(libmutton)

add_custom_target (AppDependencies ALL
  DEPENDS ${APP_DEPENDENCIES}
  COMMENT "Installing any missing dependencies.")

if(DEFINED ENV{VERBOSE})
  message(STATUS "All Variables")
  get_cmake_property(_variableNames VARIABLES)
  foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endif()

#-------------------
# mutton_demo executable
#-------------------
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "build/bin/")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build/bin)
set(PROJECT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

include_directories(${INCLUDES} ${PROJECT_INCLUDE_DIR} ${PROJECT_SOURCE_DIR}/src)
file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.cpp)

add_executable(${PROJECT_NAME} ${SRC_FILES})
target_link_libraries(${PROJECT_NAME} ${LIBS})
add_dependencies(${PROJECT_NAME} libmutton)

#-------------------
# Set compiler flags
#-------------------
set(PROJECT_COMPILER_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wall -pedantic -Wextra -Werror -Wno-long-long")

set_property(
  TARGET ${PROJECT_NAME}
  APPEND PROPERTY COMPILE_FLAGS ${PROJECT_COMPILER_FLAGS})
