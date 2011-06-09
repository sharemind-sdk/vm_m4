m4_define([_foreach_u], $@)
m4_define([_foreach_f], [$1])
m4_define([_foreach_q], [[$@]])
m4_define([_foreach],
          [m4_ifelse(m4_len((A)), [2], [],
                     [$1($0_f(A))m4_define([A],$0_q(m4_shift(A)))$0([$1])])])
m4_define([foreach], [m4_pushdef([A],[_$0_u$2])_$0([$1])m4_popdef([A])])
