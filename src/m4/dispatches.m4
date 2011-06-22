m4_define([INSTR_DISPATCH],
          [label_impl_[]INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1:
    {
        INSTR_IMPL$1;
    }
    m4_ifelse(INSTR_NEED_DISPATCH$1, [DO_DISPATCH], [SVM_MI_DISPATCH(ip += m4_eval(INSTR_ARGS$1 + 1));])

])
m4_define([INSTR_DISPATCH_EMPTY_IMPL],
       [label_impl_[]EMPTY_IMPL_LABEL$1:
    {
        EMPTY_IMPL_CODE$1;
    }
    m4_ifelse(EMPTY_IMPL_NEED_DISPATCH$1, [DO_DISPATCH], [SVM_MI_DISPATCH(ip += m4_eval(EMPTY_IMPL_ARGS$1 + 1));], [])
])

m4_define([DO_INSTRS_DISPATCH_SECTIONS],
          [foreach([INSTR_DISPATCH], (INSTRS))
foreach([INSTR_DISPATCH_EMPTY_IMPL], (EMPTY_IMPLS))])

m4_divert[]m4_dnl
DO_INSTRS_DISPATCH_SECTIONS()
