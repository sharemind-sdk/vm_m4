m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([INSTR_CODE_CASE], [
    case COMPOSE([INSTR_CODE_TO_BYTECODE],INSTR_CODE$1):
        return & SVM_Instr_[]FNSANIT(INSTR_FULLNAME$1);])

m4_define([DO_INSTRS_CODE_CASES], [foreach([INSTR_CODE_CASE], [(INSTRS)])])

m4_divert[]m4_dnl
DO_INSTRS_CODE_CASES
