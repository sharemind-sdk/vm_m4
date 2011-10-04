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
    &SMVMI_Instr_[]FNSANIT(INSTR_FULLNAME$1),])

m4_define([DO_INSTRS_INDEX], [foreach([INSTR_INDEX_ITEM], [(INSTRS)])])

m4_divert[]m4_dnl
const struct SMVMI_Instruction * const SMVMI_instructions_index[[]] = {DO_INSTRS_INDEX
    NULL
};

const unsigned SMVMI_num_instructions = INSTR_COUNT;
