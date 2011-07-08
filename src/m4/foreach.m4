#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([_foreach_u], $@)
m4_define([_foreach_f], [$1])
m4_define([_foreach_q], [[$@]])
m4_define([_foreach],
          [m4_ifelse(m4_len((A)), [2], [],
                     [$1($0_f(A))m4_define([A],$0_q(m4_shift(A)))$0([$1])])])
m4_define([foreach], [m4_pushdef([A],[_$0_u$2])_$0([$1])m4_popdef([A])])
