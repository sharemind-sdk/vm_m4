#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([DO_CODE_CASE_PREFIX], [foreach([INSTR_NAME_CASE], [(INSTRS)])])

m4_define([CC_COUNT],0)
m4_define([CC], [m4_defn(m4_format([[CC_%s]], [$1]))])
m4_define([CC_DEFINE], [m4_define([CC_COUNT],m4_incr(CC_COUNT))
                        m4_define([CC_]CC_COUNT,[$1, $2, $3])])

m4_define([CCS],[forloop([i], 1, CC_COUNT, [m4_ifelse(i, [1], [], [, ])(CC(i))])])
m4_define([CC_FOREACH],[forloop([i], 1, CC_COUNT, [m4_indir([$1],_ARG1(CC(CC(i))))])])

# (fu.ll.name) -> (fu.ll.name, ll.name, name)
m4_define([CODE_CASE_NAMES], [[[$1]]m4_pushdef([A], STRIP_TOP_NAMESPACE($1))m4_ifelse(A, [$1], [], [, CODE_CASE_NAMES(A)])m4_popdef([A])])

# (fu.ll.name, code) -> (fu.ll.name, code, fu.ll.name), (ll.name, code, fu.ll.name), (name, code, fu.ll.name)
m4_define([_CODE_CASE_EXPAND], [CC_DEFINE($1, CODE, FN)])
m4_define([CODE_CASE_EXPAND], [m4_pushdef([FN], INSTR_FULLNAME$1)m4_pushdef([CODE], COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1))foreach([_$0], [(CODE_CASE_NAMES(INSTR_FULLNAME$1))])m4_popdef([CODE])m4_popdef([FN])])

foreach([CODE_CASE_EXPAND], [(INSTRS)])
#foreach([CODE_CASE_EXPAND], [((fu.ll.name, CODE(0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80)), (fu.ll.stuff, CODE(0x1a, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80)))])

## START OF UNUSED CODE

m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([_DO_CASE],
          [
        case 'L': goto code_[]C;])
m4_define([DO_CASE], [m4_pushdef([L], m4_substr($1, PL, [1]))m4_pushdef([C], FNSANIT(PREFIX[]L))m4_pushdef([D], m4_format([[HAVE_GOTO_%s]], C))m4_ifdef(D, [],
                                [m4_define(D, [[7]])_$0($1)])m4_popdef([D])m4_popdef([C])m4_popdef([L])])

m4_define([DO_CASES], [m4_syscmd([echo -n ''])[]m4_pushdef([FN], INSTR_FULLNAME$1)m4_ifelse(m4_substr(FN, [0], PL), PREFIX,
                                 [m4_ifelse(m4_len(FN), PL, [
        case '\0': return INSTR_CODE$1;], [DO_CASE(FN)])])m4_popdef([FN])])


m4_define([DO_PREFIX],
          [m4_pushdef([PREFIX], $1)m4_ifdef([PREFIX_DEFINED_$2], [],
                    [m4_pushdef([PL], m4_len(PREFIX))m4_define([PREFIX_DEFINED_]$2, [1])code_[]$2: switch (*m4_ifelse(PL,[0],[],[++])name) {foreach([DO_CASES], [(CCS)])
        default: goto code_fail;
    }
m4_ifelse(PL, [0], [], [m4_pushdef([B], m4_substr($1, [0], m4_eval(PL[-1])))$0(B,FNSANIT(B))m4_popdef([B])])m4_popdef([PL])])m4_popdef([PREFIX])])

m4_define([HELPER], [m4_pushdef([FN], INSTR_FULLNAME$1)DO_PREFIX(FN, FNSANIT(FN))m4_popdef([FN])])

#m4_define([DO_TOSTRING], [goto code_; foreach([HELPER], [(CCS)])])

## END OF UNUSED CODE

m4_define([CC_FULLNAME], $3)

m4_define([SIMPLE], [
    if (strcmp("INSTR_FULLNAME$1",N) == 0)
        return & SMVMI_Instr_[]FNSANIT(CC_FULLNAME$1);])

m4_define([DO_TOSTRING], [foreach([SIMPLE], [(CCS)])])

m4_divert[]m4_dnl
DO_TOSTRING
