m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([INSTR_STRUCT], [
    const struct SVM_Instruction SVM_Instr_[]FNSANIT(INSTR_FULLNAME$1) = { .fullname = "INSTR_FULLNAME$1", .code = COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1), .numargs = INSTR_ARGS$1 };])

m4_define([DO_INSTRS_STRUCTS], [foreach([INSTR_STRUCT], [(INSTRS)])])

m4_divert[]m4_dnl
DO_INSTRS_STRUCTS
