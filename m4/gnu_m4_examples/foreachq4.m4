# foreachq(x, [item_1, item_2, ..., item_n], stmt)
#   quoted list, version based on forloop
m4_define([foreachq],
[m4_ifelse([$2], [], [], [_$0([$1], [$3], $2)])])
m4_define([_foreachq],
[m4_pushdef([$1], forloop([$1], [3], [$#],
  [$0_([1], [2], m4_indir([$1]))])[m4_popdef(
    [$1])])m4_indir([$1], $@)])
m4_define([_foreachq_],
[[m4_define([$$1], [$$3])$$2[]]])
