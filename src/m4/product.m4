m4_include([foreach.m4])

m4_define([__product_push], [$@])
m4_define([_product_push],
       [m4_ifelse([$1], [()], [($2)],
                  [(_$0$1,$2)])])

m4_define([_product_shift],[m4_shift$1])
m4_define([_product_expand],[_product_arg1$1])
m4_define([_product_arg1],[$1])
m4_define([_product_arg2],[$2])
m4_define([_product],
       [m4_ifelse(ps, [()], comma[]$0_push(ready, $1)[m4_define([comma],[[,]])],
                  [m4_pushdef([ready], $0_push(ready, $1))m4_dnl
m4_pushdef([ps2], $0_expand(ps))m4_dnl
m4_pushdef([ps], ($0_shift(ps)))m4_dnl
foreach([$0], ps2)m4_dnl
m4_popdef([ps2])m4_dnl
m4_popdef([ps])m4_dnl
m4_popdef([ready])])])

m4_define([product],
       [m4_ifelse([$#], [0], [], [$#], [1], [$1],
                  [m4_pushdef([comma],[])m4_pushdef([ready], [()])m4_pushdef([ps], [(m4_shift($@))])foreach([_$0], $1)m4_popdef([ps])m4_popdef([ready])m4_popdef([comma])])])])
