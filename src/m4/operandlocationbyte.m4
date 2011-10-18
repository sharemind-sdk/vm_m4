#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([OLB_DEFINE], [m4_define(m4_format([[OLB_NAME_%s]], [$1]), [$1])
                         m4_define(m4_format([[OLB_CODE_%s]], [$1]), [$2])])

OLB_DEFINE(imm,         0x01)
OLB_DEFINE(reg,         0x02)
OLB_DEFINE(stack,       0x04)
OLB_DEFINE(ref,         0x08)
OLB_DEFINE(cref,        0x10)
OLB_DEFINE(mem_reg,     0x20)
OLB_DEFINE(mem_stack,   0x40)
