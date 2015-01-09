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

m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([INSTR_INDEX_ITEM], [
    { .fullName = "INSTR_FULLNAME$1", .code = COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1), .numArgs = INSTR_ARGS$1 },])

m4_define([DO_INSTRS_INDEX], [foreach([INSTR_INDEX_ITEM], [(INSTRS)])])

m4_divert[]m4_dnl
static const SharemindVmInstruction sharemindVmInstructionIndex[[]] = {DO_INSTRS_INDEX
    { .fullName = "", .code = 0u, .numArgs = 0u }
};

static const unsigned sharemindVmInstructionCount = INSTR_COUNT;
