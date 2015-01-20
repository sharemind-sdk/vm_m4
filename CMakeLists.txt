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

SET(M4_DIR_S "${CMAKE_CURRENT_SOURCE_DIR}/m4")
FILE(GLOB_RECURSE ALL_M4_FILES "${M4_DIR_S}/*.m4")
ADD_CUSTOM_TARGET("include_ALL_M4_FILES_in_IDE" SOURCES ${ALL_M4_FILES})

SET(M4_2_H_SOURCES
    "dispatches.m4"
    "instruction_index.m4"
    "static_label_structs.m4"
    "preprocess_pass2_functions.m4")

ADD_CUSTOM_TARGET(m4_instr_m4f ALL
  COMMAND ${M4} -E -P "--include=${M4_DIR_S}" "${M4_DIR_S}/instr.m4"
          "--freeze-state=instr.m4f"
  DEPENDS "${M4_DIR_S}/instr.m4"
  COMMENT "Generating instr.m4f"
)

SET(M4_INSTALL_TARGETS tmp)
LIST(REMOVE_ITEM M4_INSTALL_TARGETS tmp)
FOREACH(S ${M4_2_H_SOURCES})
  STRING(REGEX REPLACE "\\.m4$" ".h" T ${S})
  LIST(APPEND M4_INSTALL_TARGETS "${CMAKE_CURRENT_BINARY_DIR}/${T}")
  STRING(REPLACE ".h" "_h" M4_TARGET_NAME "m4_${T}")

  ADD_CUSTOM_TARGET("${M4_TARGET_NAME}" ALL
    COMMAND ${M4} -E -P "--include=${M4_DIR_S}"
                  "--reload-state=instr.m4f"
                  "${M4_DIR_S}/${S}" >
                  "${T}"
    DEPENDS "${M4_DIR_S}/${S}"
    COMMENT "Generating ${T}"
    )
  ADD_DEPENDENCIES("${M4_TARGET_NAME}" m4_instr_m4f)
ENDFOREACH()

INSTALL(FILES ${M4_INSTALL_TARGETS} DESTINATION "include/sharemind/m4")


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
