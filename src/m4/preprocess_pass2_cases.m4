#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([INSTR_PREPARE_CASE_PASS2], [
    case COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1): /* INSTR_FULLNAME$1 */m4_pushdef([A], INSTR_PREPARATION$1)m4_ifelse(A, [NO_PREPARATION], [], [
        A;])m4_popdef([A])
        SMVM_PREPARE_END_AS(INSTR_INDEX$1,,INSTR_ARGS$1);])

m4_define([DO_INSTRS_PREPARE_CASES_PASS2], [foreach([INSTR_PREPARE_CASE_PASS2], [(INSTRS)])])

m4_divert[]m4_dnl
DO_INSTRS_PREPARE_CASES_PASS2
