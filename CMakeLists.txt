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

CMAKE_MINIMUM_REQUIRED(VERSION "3.0.0")
PROJECT(SharemindVmM4 VERSION 0.5.0 LANGUAGES)

INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/config.local" OPTIONAL)
INCLUDE("${CMAKE_CURRENT_BINARY_DIR}/config.local" OPTIONAL)

FIND_PACKAGE(SharemindCMakeHelpers 1.6 REQUIRED)


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

SET(M4_2_H_SOURCES
    "dispatches.m4"
    "instruction_index.m4"
    "static_label_structs.m4"
    "preprocess_pass2_functions.m4")

ADD_CUSTOM_COMMAND(
  OUTPUT "instr.m4f"
  COMMAND ${M4} -E -P "--include=${M4_DIR_S}" "${M4_DIR_S}/instr.m4"
                "--freeze-state=instr.m4f"
  MAIN_DEPENDENCY "${M4_DIR_S}/instr.m4"
  DEPENDS
    "${M4_DIR_S}/datatypebyte.m4"
    "${M4_DIR_S}/foreach.m4"
    "${M4_DIR_S}/forloop.m4"
    "${M4_DIR_S}/gnu_m4_examples/foreachq4.m4"
    "${M4_DIR_S}/operandlocationbyte.m4"
    "${M4_DIR_S}/product.m4"
  COMMENT "Generating instr.m4f"
)
ADD_CUSTOM_TARGET(m4_instr_m4f ALL DEPENDS "instr.m4f")

SET(M4_INSTALL_TARGETS tmp)
LIST(REMOVE_ITEM M4_INSTALL_TARGETS tmp)
FOREACH(S ${M4_2_H_SOURCES})
  STRING(REGEX REPLACE "\\.m4$" ".h" T ${S})
  LIST(APPEND M4_INSTALL_TARGETS "${CMAKE_CURRENT_BINARY_DIR}/${T}")
  STRING(REPLACE ".h" "_h" M4_TARGET_NAME "m4_${T}")

  ADD_CUSTOM_COMMAND(
    OUTPUT "${T}"
    COMMAND ${M4} -E -P "--include=${M4_DIR_S}"
                  "--reload-state=instr.m4f"
                  "${M4_DIR_S}/${S}" >
                  "${T}"
    MAIN_DEPENDENCY "${M4_DIR_S}/${S}"
    DEPENDS "instr.m4f"
    COMMENT "Generating ${T}"
  )

  ADD_CUSTOM_TARGET("${M4_TARGET_NAME}" ALL DEPENDS "${T}")
  ADD_DEPENDENCIES("${M4_TARGET_NAME}" m4_instr_m4f)
ENDFOREACH()

INSTALL(FILES ${M4_INSTALL_TARGETS}
        DESTINATION "include/sharemind/m4"
        COMPONENT "dev")


################################################################################
# CMake FIND_PACKAGE support:
################################################################################

SharemindAddInterfaceLibrary(VmM4)
ADD_DEPENDENCIES(VmM4 ${M4_INSTALL_TARGETS})
TARGET_INCLUDE_DIRECTORIES(VmM4
    INTERFACE
        # $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src> # TODO
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>
    )
SharemindCreateCMakeFindFilesForTarget(VmM4)


################################################################################
# Misc. files
################################################################################

FILE(GLOB MD_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.md")
FILE(GLOB_RECURSE DOC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/doc/*")
FILE(GLOB LICENSE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE*")
FILE(GLOB_RECURSE ALL_SOURCE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/m4/*")
ADD_CUSTOM_TARGET("include_MISC_FILES_in_IDE" SOURCES
    ${MD_FILES} ${DOC_FILES} ${LICENSE_FILES} ${ALL_SOURCE_FILES}
)


# Packaging:
SharemindSetupPackaging()
SharemindAddComponentPackage("dev"
    NAME "libsharemind-vm-m4-dev"
    DESCRIPTION "M4 generated development headers for Sharemind VM"
    DEB_SECTION "libdevel")
SharemindPackagingFinalize()
