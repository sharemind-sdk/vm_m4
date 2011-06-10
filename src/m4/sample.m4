m4_divert[]m4_dnl
#include <stdio.h>
#include <stdint.h>

#define SVM_MI_ARG_AS(a,b) 0
#define SVM_PREPARE_END_AS(a,b) printf("END_AS(%s,%s)\n", #a, #b); break;
#define SVM_PREPARE_CHECK_OR_ERROR(a,b) printf("CHECK_OR_ERROR(%s,%s)\n", #a, #b);
#define SVM_PREPARE_ARG_P(a) NULL
#define SVM_PREPARE_ARG(a) 0
#define SVM_PREPARE_CURRENT_I 0
#define SVM_PREPARE_ERROR_INVALID_ARGUMENTS 1
#define SVM_PREPARE_CURRENT_CODE_SECTION 0
#define SVM_PREPARE_IS_INSTR 1
#define SVM_PREPARE_ERROR(a) printf("ERROR(%s)\n", #a);

int main(int argc, char *argv[]) {
    uint64_t c = argc - 1;
    switch (c) {
        DO_INSTRS_PREPARE_CASES()
        default:
            printf("Invalid instruction: %lu\n", c);
    }
    return 0;
}

/*
   Statistics:
     Total instructions: INSTR_COUNT
     Dispatch sections:  m4_eval(INSTR_COUNT + EMPTY_IMPL_COUNT)
*/
