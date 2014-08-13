#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([forloop],
          [m4_pushdef([$1], [$2])_$0($@)m4_popdef([$1])])
m4_define([_forloop],
          [$4[]m4_ifelse($1, [$3], [], [m4_define([$1], m4_incr($1))$0($@)])])