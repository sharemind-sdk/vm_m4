#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([DO_INSTR_LABEL], [&& label_impl_[]INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1,
])
m4_define([DO_INSTR_LABELS], [foreach([DO_INSTR_LABEL], [(INSTRS)])])

m4_define([DO_EMPTY_IMPL_LABEL], [&& label_impl_[]EMPTY_IMPL_LABEL$1,
])
m4_define([DO_EMPTY_IMPL_LABELS], [foreach([DO_EMPTY_IMPL_LABEL], [(EMPTY_IMPLS)])])

m4_divert[]m4_dnl

static void * instr_labels[[]]      = { DO_INSTR_LABELS NULL };
static void * empty_impl_labels[[]] = { DO_EMPTY_IMPL_LABELS NULL };
