#
# Copyright (C) 2015 Cybernetica
#
# Research/Commercial License Usage
# Licensees holding a valid Research License or Commercial License
# for the Software may use this file according to the written
# agreement between you and Cybernetica.
#
# GNU General Public License Usage
# Alternatively, this file may be used under the terms of the GNU
# General Public License version 3.0 as published by the Free Software
# Foundation and appearing in the file LICENSE.GPL included in the
# packaging of this file.  Please review the following information to
# ensure the GNU General Public License version 3.0 requirements will be
# met: http://www.gnu.org/copyleft/gpl-3.0.html.
#
# For further information, please contact us at sharemind@cyber.ee.
#

CMAKE_MINIMUM_REQUIRED(VERSION "2.8.12")
PROJECT("SHAREMIND_VM_M4" NONE)

SET(VM_M4_VERSION "0.1.0.0")

INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/config.local" OPTIONAL)
INCLUDE("${CMAKE_CURRENT_BINARY_DIR}/config.local" OPTIONAL)

IF(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    FIND_PROGRAM(M4 gm4)
ELSE()
    FIND_PROGRAM(M4 m4)
ENDIF()

IF(M4)
    MESSAGE(STATUS "Found m4 at ${M4}")
ELSE()
    MESSAGE(FATAL_ERROR "Required m4 command not found!")
ENDIF()


################################################################################
# m4 files
################################################################################

FILE(GLOB_RECURSE ALL_M4_FILES "${CMAKE_CURRENT_SOURCE_DIR}/m4/*.m4")
ADD_CUSTOM_TARGET("include_ALL_M4_FILES_in_IDE" SOURCES ${ALL_M4_FILES})
SET(M4_DIR_S "${CMAKE_CURRENT_SOURCE_DIR}/m4")
SET(M4_DIR_B "${CMAKE_CURRENT_BINARY_DIR}/m4")
FILE(MAKE_DIRECTORY "${M4_DIR_B}")

SET(M4_2_H_SOURCES
    "dispatches.m4"
    "instruction_index.m4"
    "static_label_structs.m4"
    "preprocess_pass2_functions.m4")

ADD_CUSTOM_COMMAND(OUTPUT "${M4_DIR_B}/instr.m4f"
                   COMMAND ${M4} -E -P "--include=${M4_DIR_S}"
                                 "${M4_DIR_S}/instr.m4"
                                 "--freeze-state=${M4_DIR_B}/instr.m4f"
                   MAIN_DEPENDENCY "${M4_DIR_S}/instr.m4"
                   COMMENT "Generating ${M4_DIR_B}/instr.m4f")
ADD_CUSTOM_TARGET(m4_instr_m4f ALL DEPENDS  "${M4_DIR_B}/instr.m4f")

FOREACH(_H_SOURCE ${M4_2_H_SOURCES})
  STRING(REGEX REPLACE "\\.m4$" ".h" _H_TARGET ${_H_SOURCE})
  LIST(APPEND M4_H_TARGETS "${M4_DIR_B}/${_H_TARGET}")

  STRING(REPLACE ".h" "_h" M4_TARGET_NAME "m4_${_H_TARGET}")

  ADD_CUSTOM_COMMAND(OUTPUT "${M4_DIR_B}/${_H_TARGET}"
                     COMMAND ${M4} -E -P "--include=${M4_DIR_S}"
                                   "--reload-state=${M4_DIR_B}/instr.m4f"
                                   "${M4_DIR_S}/${_H_SOURCE}" >
                                   "${M4_DIR_B}/${_H_TARGET}"
                     MAIN_DEPENDENCY "${M4_DIR_S}/${_H_SOURCE}"
                     DEPENDS m4_instr_m4f
                     COMMENT "Generating ${M4_DIR_B}/${_H_TARGET}")
  ADD_CUSTOM_TARGET("${M4_TARGET_NAME}" ALL DEPENDS "${M4_DIR_B}/${_H_TARGET}")
ENDFOREACH(_H_SOURCE ${M4_2_H_SOURCES})

INSTALL(FILES ${M4_H_TARGETS}
        DESTINATION "include/sharemind/m4")


################################################################################
# CMake FIND_PACKAGE support:
################################################################################

FILE(GLOB sharemind_vm_m4_in_files "${CMAKE_CURRENT_SOURCE_DIR}/*.in")
ADD_CUSTOM_TARGET("include_sharemind_vm_m4_in_files_in_IDE"
                  SOURCES ${sharemind_vm_m4_in_files})
SET(VM_M4_INSTALL_LINK_LIBRARIES "")
SET(VM_M4_INSTALL_INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/include")
SET(VM_M4_INSTALL_DEFINITIONS "")

CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/SharemindVmM4Config.cmake.in"
               "${CMAKE_CURRENT_BINARY_DIR}/SharemindVmM4Config.cmake" @ONLY)
CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/SharemindVmM4ConfigVersion.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/SharemindVmM4ConfigVersion.cmake" @ONLY)
INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/SharemindVmM4Config.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/SharemindVmM4ConfigVersion.cmake"
        DESTINATION "lib/SharemindVmM4")
