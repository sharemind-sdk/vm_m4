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

m4_define([INSTR_PREPARE_FUNCTION_PASS2], [
    /* INSTR_FULLNAME$1: */
    SHAREMIND_PREPARE_PASS2_FUNCTION(INSTR_NAME$1,COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1),m4_pushdef([A], INSTR_PREPARATION$1)m4_ifelse(A, [NO_PREPARATION], [], [
        A;])m4_popdef([A])
        SHAREMIND_PREPARE_END_AS(INSTR_INDEX$1,INSTR_ARGS$1);)])

m4_define([DO_INSTRS_PREPARE_FUNCTIONS_PASS2], [foreach([INSTR_PREPARE_FUNCTION_PASS2], [(INSTRS)])])

m4_divert[]m4_dnl
DO_INSTRS_PREPARE_FUNCTIONS_PASS2
