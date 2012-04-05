#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([INSTR_INDEX_ITEM], [
    { .fullName = "INSTR_FULLNAME$1", .code = COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1), .numArgs = INSTR_ARGS$1 },])

m4_define([DO_INSTRS_INDEX], [foreach([INSTR_INDEX_ITEM], [(INSTRS)])])

m4_divert[]m4_dnl
static const SharemindVmInstruction sharemindVmInstructionIndex[[]] = {DO_INSTRS_INDEX
    { .fullName = "", .code = 0u, .numArgs = 0u }
};

const unsigned sharemindVmInstructionCount = INSTR_COUNT;
