cmake_minimum_required(VERSION 3.13)

project(tree-sitter-luau
        VERSION "0.1.0"
        DESCRIPTION "Tree-sitter grammars for Luau and LuauX"
        HOMEPAGE_URL "https://github.com/0hirume/tree-sitter-luau"
        LANGUAGES C)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
option(TREE_SITTER_REUSE_ALLOCATOR "Reuse the library allocator" OFF)

set(TREE_SITTER_ABI_VERSION 15 CACHE STRING "Tree-sitter ABI version")
if(NOT ${TREE_SITTER_ABI_VERSION} MATCHES "^[0-9]+$")
    unset(TREE_SITTER_ABI_VERSION CACHE)
    message(FATAL_ERROR "TREE_SITTER_ABI_VERSION must be an integer")
endif()

include(GNUInstallDirs)

find_program(TREE_SITTER_CLI tree-sitter DOC "Tree-sitter CLI")

function(add_parser NAME SOURCE_PATH GRAMMAR_PATH DESCRIPTION)
    set(SOURCE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_PATH}")
    set(GRAMMAR "${CMAKE_CURRENT_SOURCE_DIR}/${GRAMMAR_PATH}")
    set(GRAMMAR_DEPENDENCIES "${GRAMMAR}" "${CMAKE_CURRENT_SOURCE_DIR}/grammar.js")
    list(REMOVE_DUPLICATES GRAMMAR_DEPENDENCIES)

    add_custom_command(OUTPUT "${SOURCE_DIRECTORY}/grammar.json"
                              "${SOURCE_DIRECTORY}/node-types.json"
                       DEPENDS ${GRAMMAR_DEPENDENCIES}
                       COMMAND "${TREE_SITTER_CLI}" generate "${GRAMMAR}"
                               --output "${SOURCE_DIRECTORY}" --no-parser
                               --js-runtime=native
                       WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                       COMMENT "Generating ${NAME} grammar metadata")

    add_custom_command(OUTPUT "${SOURCE_DIRECTORY}/parser.c"
                       BYPRODUCTS "${SOURCE_DIRECTORY}/tree_sitter/parser.h"
                                  "${SOURCE_DIRECTORY}/tree_sitter/alloc.h"
                                  "${SOURCE_DIRECTORY}/tree_sitter/array.h"
                       DEPENDS "${SOURCE_DIRECTORY}/grammar.json"
                       COMMAND "${TREE_SITTER_CLI}" generate
                               "${SOURCE_DIRECTORY}/grammar.json"
                               --output "${SOURCE_DIRECTORY}"
                               --abi=${TREE_SITTER_ABI_VERSION} --js-runtime=native
                       WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                       COMMENT "Generating ${NAME} parser")

    add_library(tree-sitter-${NAME}
                "${SOURCE_DIRECTORY}/parser.c"
                "${SOURCE_DIRECTORY}/scanner.c")
    target_include_directories(tree-sitter-${NAME}
                               PRIVATE "${SOURCE_DIRECTORY}"
                               INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/bindings/c>
                                         $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

    target_compile_definitions(tree-sitter-${NAME} PRIVATE
                               $<$<BOOL:${TREE_SITTER_REUSE_ALLOCATOR}>:TREE_SITTER_REUSE_ALLOCATOR>
                               $<$<CONFIG:Debug>:TREE_SITTER_DEBUG>)

    set_target_properties(tree-sitter-${NAME}
                          PROPERTIES
                          C_STANDARD 11
                          POSITION_INDEPENDENT_CODE ON
                          SOVERSION "${TREE_SITTER_ABI_VERSION}.${PROJECT_VERSION_MAJOR}"
                          DEFINE_SYMBOL "")

    set(PROJECT_DESCRIPTION "${DESCRIPTION}")
    configure_file("bindings/c/tree-sitter-${NAME}.pc.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/tree-sitter-${NAME}.pc" @ONLY)

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/tree-sitter-${NAME}.pc"
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig")
    install(TARGETS tree-sitter-${NAME}
            LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}")
endfunction()

add_parser(luau src grammar.js "Tree-sitter grammar for Luau")
add_parser(luaux luaux/src luaux/grammar.js "Tree-sitter grammar for LuauX")

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bindings/c/tree_sitter"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        FILES_MATCHING PATTERN "*.h")

file(GLOB LUAU_QUERIES queries/*.scm)
install(FILES ${LUAU_QUERIES}
        DESTINATION "${CMAKE_INSTALL_DATADIR}/tree-sitter/queries/luau")

file(GLOB LUAUX_QUERIES luaux/queries/*.scm)
install(FILES ${LUAUX_QUERIES}
        DESTINATION "${CMAKE_INSTALL_DATADIR}/tree-sitter/queries/luaux")

add_custom_target(ts-test "${TREE_SITTER_CLI}" test
                  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                  COMMENT "tree-sitter test")
