#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_include([forloop.m4])

m4_define([_OLBS_EXPAND],[$1])

m4_define([OLB_COUNT],0)
m4_define([OLB], [m4_defn(m4_format([[OLB_%s]], [$1]))])
m4_define([OLB_DEFINE], [m4_define(m4_format([[OLB_%s]], [$1]), [$1, $2, $3])
                         m4_define(m4_format([[OLB_NAME_%s]], [$1]), [$1])
                         m4_define(m4_format([[OLB_CODE_%s]], [$1]), [$2])
                         m4_define(m4_format([[OLB_ARGS_%s]], [$1]), [$3])
                         m4_define([OLB_COUNT],m4_incr(OLB_COUNT))
                         m4_define([OLB_]OLB_COUNT,[$1])])

#m4_define([OLBS],[forloop([i], 1, OLB_COUNT, [(OLB(OLB(i)))])])
m4_define([OLBS_FOREACH],[forloop([i], 1, OLB_COUNT, [m4_indir([$1],_OLBS_EXPAND(OLB(OLB(i))))])])

m4_define([OLB_GET_NAME], OLB_NAME_$1)
m4_define([OLB_GET_CODE], OLB_CODE_$1)
m4_define([OLB_GET_ARGS], OLB_ARGS_$1)

OLB_DEFINE(imm,         0x01, 1)
OLB_DEFINE(reg,         0x02, 1)
OLB_DEFINE(stack,       0x04, 1)
OLB_DEFINE(ref,         0x08, 2)
OLB_DEFINE(cref,        0x10, 2)
OLB_DEFINE(mem_reg,     0x20, 2)
OLB_DEFINE(mem_stack,   0x40, 2)
