#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

CMAKE_MINIMUM_REQUIRED(VERSION "2.8")
CMAKE_POLICY(SET CMP0015 NEW)
PROJECT("SHAREMIND_VM_M4")

FIND_PROGRAM(M4 m4)
IF(M4)
    MESSAGE(STATUS "Found m4 at ${M4}")
ELSE(M4)
    MESSAGE(FATAL_ERROR "Required m4 command not found!")
ENDIF(M4)

IF(NOT SHAREMIND_GEN_DIR)
    MESSAGE(FATAL_ERROR "SHAREMIND_GEN_DIR not defined!")
ENDIF(NOT SHAREMIND_GEN_DIR)


################################################################################
# m4 files
################################################################################

SET(M4_DIR_S "${CMAKE_CURRENT_SOURCE_DIR}/m4")
SET(M4_DIR_B "${SHAREMIND_GEN_DIR}/sharemind/m4")
FILE(MAKE_DIRECTORY "${M4_DIR_B}")

SET(M4_2_H_SOURCES
    "dispatches.m4"
    "instruction_index.m4"
    "instruction_structs.m4"
    "static_label_structs.m4"
    "preprocess_pass2_functions.m4")

ADD_CUSTOM_COMMAND(OUTPUT "${M4_DIR_B}/instr.m4f"
                   COMMAND ${M4} -E -P "--include=${M4_DIR_S}" "${M4_DIR_S}/instr.m4" "--freeze-state=${M4_DIR_B}/instr.m4f"
                   MAIN_DEPENDENCY "${M4_DIR_S}/instr.m4"
                   COMMENT "Generating ${M4_DIR_B}/instr.m4f")

FOREACH(_H_SOURCE ${M4_2_H_SOURCES})
  SET(M4_2_H_SOURCES_S ${M4_2_H_SOURCES_S} "${M4_DIR_S}/${_H_SOURCE}")

  STRING(REGEX REPLACE "\\.m4$" ".h" _H_TARGET ${_H_SOURCE})
  SET(M4_H_TARGETS ${M4_H_TARGETS} "${M4_DIR_B}/${_H_TARGET}")

  STRING(REPLACE ".h" "_h" M4_TARGET_NAME "m4_${_H_TARGET}")

  ADD_CUSTOM_COMMAND(OUTPUT "${M4_DIR_B}/${_H_TARGET}"
                     COMMAND ${M4} -E -P "--include=${M4_DIR_S}" "--reload-state=${M4_DIR_B}/instr.m4f" "${M4_DIR_S}/${_H_SOURCE}" > "${M4_DIR_B}/${_H_TARGET}"
                     MAIN_DEPENDENCY "${M4_DIR_S}/${_H_SOURCE}"
                     DEPENDS "${M4_DIR_B}/instr.m4f"
                     COMMENT "Generating ${M4_DIR_B}/${_H_TARGET}")
  ADD_CUSTOM_TARGET("${M4_TARGET_NAME}" ALL DEPENDS "${M4_DIR_B}/${_H_TARGET}")
ENDFOREACH(_H_SOURCE ${M4_2_H_SOURCES})
