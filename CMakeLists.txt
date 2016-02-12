cmake_minimum_required(VERSION 3.3)
project(tclap VERSION 2.0.0 LANGUAGES CXX)
enable_testing()

option(BUILD_DOCUMENTATION "Build the documentation" OFF)
option(BUILD_EXAMPLES "Build the example programs" ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
        -fcolor-diagnostics \
        -Werror -Wall -Weverything \
        -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-padded \
        -Wno-weak-vtables -Wno-global-constructors -Wno-exit-time-destructors \
        -Wno-gnu-zero-variadic-macro-arguments -Wno-unused-member-function \
        -Wno-switch-enum -Wno-covered-switch-default"
    )

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
            -fprofile-instr-generate -fcoverage-mapping \
            -fno-omit-frame-pointer -fno-optimize-sibling-calls \
            -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize=enum"
        )
    endif()
endif()

find_package(Doxygen)

add_library(tclap INTERFACE)
target_include_directories(tclap INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

if(DOXYGEN_FOUND)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doc/Doxyfile.in
        ${CMAKE_CURRENT_BINARY_DIR}/doc/Doxyfile)

    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/doc/Doxyfile
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc
        COMMENT "Generating documentation"
        VERBATIM
    )
endif()

if(BUILD_DOCUMENTATION)
    if(NOT DOXYGEN_FOUND)
        message(FATAL_ERROR "Doxygen is required to build the documentation")
    endif()

    add_dependencies(tclap doc)
endif()

if(BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

include(CPack)
install(DIRECTORY include/ DESTINATION include)

if(BUILD_DOCUMENTATION)
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc DESTINATION share/docs/tclap PATTERN Doxyfile EXCLUDE)
endif()
