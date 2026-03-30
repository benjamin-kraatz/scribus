#include(FindPkgConfig)
find_package(PkgConfig QUIET)
pkg_search_module(poppler libpoppler>=22.01.0 poppler>=22.01.0)
if (poppler_FOUND)
	pkg_search_module(poppler_cpp REQUIRED libpoppler-cpp>=22.01.0 poppler-cpp>=22.01.0)
endif(poppler_FOUND)
 
find_path(poppler_INCLUDE_DIR
	NAMES poppler/ErrorCodes.h poppler/poppler-config.h
	HINTS ${PKG_poppler_INCLUDE_DIRS} ${poppler_INCLUDE_DIRS}
	PATHS /usr/local/include /usr/include
	)

find_path(poppler_cpp_INCLUDE_DIR
	NAMES poppler/cpp/poppler-version.h
	HINTS ${PKG_poppler_cpp_INCLUDE_DIRS} ${poppler_cpp_INCLUDE_DIRS}
	PATHS /usr/local/include /usr/include
	)

find_path(poppler_PRIVATE_INCLUDE_DIR
	NAMES poppler-config.h
	HINTS ${PKG_poppler_INCLUDE_DIRS} ${poppler_INCLUDE_DIRS}
	PATHS /usr/local/include /usr/include
	PATH_SUFFIXES poppler
	)

find_library(poppler_LIBRARY
	NAMES libpoppler poppler
	PATHS ${PKG_poppler_LIBRARIES} ${poppler_LIBRARY_DIRS} /usr/local/lib /usr/lib /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
	PATH_SUFFIXES poppler
	NO_DEFAULT_PATH
	)

find_library(poppler_cpp_LIBRARY
	NAMES libpoppler-cpp poppler-cpp
	PATHS ${PKG_poppler_cpp_LIBRARIES} ${poppler_cpp_LIBRARY_DIRS} /usr/local/lib /usr/lib /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
	PATH_SUFFIXES poppler
	NO_DEFAULT_PATH
	)

if (poppler_LIBRARY)
	if (poppler_INCLUDE_DIR AND poppler_cpp_INCLUDE_DIR)
		if (poppler_PRIVATE_INCLUDE_DIR)
			list(APPEND poppler_INCLUDE_DIR ${poppler_PRIVATE_INCLUDE_DIR})
		endif()
		set(poppler_CPP_INCLUDE_DIR ${poppler_cpp_INCLUDE_DIR})
		set( FOUND_POPPLER ON )
		set( poppler_LIBRARIES ${poppler_LIBRARY} ${poppler_cpp_LIBRARY} )
		set( poppler_INCLUDES ${poppler_INCLUDE_DIR} ${poppler_cpp_INCLUDE_DIR} )
	endif (poppler_INCLUDE_DIR AND poppler_cpp_INCLUDE_DIR)
endif (poppler_LIBRARY)
