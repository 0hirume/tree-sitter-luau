cmake_minimum_required(VERSION 3.13)

project(
    tree-sitter-luau
    VERSION "0.1.0"
    DESCRIPTION "Tree-sitter grammar for Luau"
    HOMEPAGE_URL "https://github.com/0hirume/tree-sitter-luau"
    LANGUAGES C
)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
option(TREE_SITTER_REUSE_ALLOCATOR "Reuse the library allocator" OFF)

file(
    STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/src/parser.c"
    TREE_SITTER_LANGUAGE_VERSION
    REGEX "^#define LANGUAGE_VERSION [0-9]+$"
)

string(
    REGEX REPLACE "^#define LANGUAGE_VERSION "
    ""
    TREE_SITTER_LANGUAGE_VERSION
    "${TREE_SITTER_LANGUAGE_VERSION}"
)

include(GNUInstallDirs)

add_library(
    tree-sitter-luau
    "${CMAKE_CURRENT_SOURCE_DIR}/src/parser.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/scanner.c"
)

target_include_directories(
    tree-sitter-luau
    PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src"
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/bindings/c>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_definitions(
    tree-sitter-luau
    PRIVATE
        $<$<BOOL:${TREE_SITTER_REUSE_ALLOCATOR}>:TREE_SITTER_REUSE_ALLOCATOR>
        $<$<CONFIG:Debug>:TREE_SITTER_DEBUG>
)

set_target_properties(
    tree-sitter-luau
    PROPERTIES
        C_STANDARD 11
        POSITION_INDEPENDENT_CODE ON
        SOVERSION "${TREE_SITTER_LANGUAGE_VERSION}.${PROJECT_VERSION_MAJOR}"
        DEFINE_SYMBOL ""
)

configure_file(
    "bindings/c/tree-sitter-luau.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/tree-sitter-luau.pc"
    @ONLY
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/tree-sitter-luau.pc"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
)

install(TARGETS tree-sitter-luau LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}")

install(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bindings/c/tree_sitter"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    FILES_MATCHING
    PATTERN "*.h"
)

file(GLOB LUAU_QUERIES queries/*.scm)

install(
    FILES ${LUAU_QUERIES}
    DESTINATION "${CMAKE_INSTALL_DATADIR}/tree-sitter/queries/luau"
)
