
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  #
  # Install leveldb from source
  #
  if (NOT libmutton_NAME)

    CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)

    include (ExternalProject)

    set(ABBREV "libmutton")
    set(${ABBREV}_NAME         ${ABBREV})
    set(${ABBREV}_INCLUDE_DIRS ${EXT_PREFIX}/src/libmutton/include)
    set(APP_DEPENDENCIES ${APP_DEPENDENCIES} ${ABBREV})

    message("Installing ${libmutton_NAME} into ext build area: ${EXT_PREFIX} ...")

    ExternalProject_Add(libmutton
      PREFIX ${EXT_PREFIX}
      URL https://github.com/project-z/mutton/archive/85f896e2bcb5675bb9d6b4c777985b245723acd7.zip
      URL_MD5 ff194cfc78c59f7952b5203f556cb77f
      CMAKE_ARGS "-DCMAKE_BUILD_TYPE=debug"
      BUILD_IN_SOURCE 1
      )


    set(${ABBREV}_LIBRARIES ${EXT_PREFIX}/src/libmutton/build/lib/libmutton.dylib)
    set(${ABBREV}_STATIC_LIBRARIES ${EXT_PREFIX}/src/libmutton/build/lib/libmutton.a)

    set_target_properties(${libmutton_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

  endif (NOT libmutton_NAME)
else()
  find_path(libmutton_INCLUDE_DIRS NAMES libmutton/mutton.h HINTS /usr/include /usr/local/include)
  find_library(libmutton_LIBRARIES NAMES libmutton.a libmutton.lib libmutton.dylib HINTS /usr/lib /usr/local/lib)
endif()

if(libmutton_INCLUDE_DIRS AND libmutton_LIBRARIES)
  set(libmutton_FOUND TRUE)
endif(libmutton_INCLUDE_DIRS AND libmutton_LIBRARIES)

if(libmutton_FOUND)
  message(STATUS "Found libmutton: ${libmutton_LIBRARIES}")
else(libmutton_FOUND)
  message(FATAL_ERROR "Could not find libmutton library.")
endif(libmutton_FOUND)

set(INCLUDES ${INCLUDES} ${libmutton_INCLUDE_DIRS} )
set(LIBS ${LIBS} ${libmutton_LIBRARIES} )