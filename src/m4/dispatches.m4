#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([INSTR_DISPATCH],
          [SMVM_IMPL(INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1,
    {
        INSTR_IMPL$1;
    }
    m4_ifelse(INSTR_NEED_DISPATCH$1, [DO_DISPATCH], [SMVM_MI_DISPATCH(ip += m4_eval(INSTR_ARGS$1 + 1));], []))
])
m4_define([INSTR_DISPATCH_EMPTY_IMPL],
       [SMVM_IMPL(EMPTY_IMPL_LABEL$1,
    {
        EMPTY_IMPL_CODE$1;
    }
    m4_ifelse(EMPTY_IMPL_NEED_DISPATCH$1, [DO_DISPATCH], [SMVM_MI_DISPATCH(ip += m4_eval(EMPTY_IMPL_ARGS$1 + 1));], []))
])

m4_define([DO_INSTRS_DISPATCH_SECTIONS],
          [m4_ifelse(INSTR_COUNT, [0], [], [foreach([INSTR_DISPATCH], (INSTRS))])
m4_ifelse(EMPTY_IMPL_COUNT, [0], [], [foreach([INSTR_DISPATCH_EMPTY_IMPL], (EMPTY_IMPLS))])])

m4_divert[]m4_dnl
DO_INSTRS_DISPATCH_SECTIONS()
