m4_divert(-1)

m4_changequote([,])
m4_include([forloop.m4])
m4_include([foreach.m4])
m4_include([product.m4])
m4_include([datatypebyte.m4])
m4_include([operandlocationbyte.m4])



m4_define([_INSTR_EXPAND],[$1])

m4_define([INSTR_COUNT],0)
m4_define([INSTR], [m4_defn(m4_format([[INSTR_%s]], [$1]))])
m4_define([INSTR_DEFINE], [m4_define(m4_format([[INSTR_%s]], [$1]), [$1, $2, $3, $4, $5, $6, $7, $8])
                        m4_define([INSTR_COUNT],m4_incr(INSTR_COUNT))
                        m4_define([INSTR_]INSTR_COUNT,[$1])])

m4_define([INSTRS],[forloop([i], 1, INSTR_COUNT, [m4_ifelse(i, [1], [], [, ])(INSTR(INSTR(i)))])])
m4_define([INSTR_FOREACH],[forloop([i], 1, INSTR_COUNT, [m4_indir([$1],_INSTR_EXPAND(INSTR(INSTR(i))))])])

m4_define([INSTR_NAME], $1)
m4_define([INSTR_CODE], $2)
m4_define([INSTR_ARGS], $3)
m4_define([INSTR_PREPARATION], $4)
m4_define([INSTR_IMPL_SUFFIX], $5)
m4_define([INSTR_IMPL], $6)
m4_define([INSTR_NEED_DISPATCH], $7)
m4_define([INSTR_NEED_PREPARE_FINISH], $8)

m4_define([EMPTY_IMPL_COUNT],0)
m4_define([EMPTY_IMPL], [m4_defn(m4_format([[EMPTY_IMPL_%s]], [$1]))])
m4_define([EMPTY_IMPL_DEFINE], [m4_define(m4_format([[EMPTY_IMPL_%s]], [$1]), [$1, $2, $3, $4])
                        m4_define(m4_format([[EMPTY_IMPL_LABEL_%s]], [$1]), [$1])
                        m4_define(m4_format([[EMPTY_IMPL_ARGS_%s]], [$1]), [$2])
                        m4_define(m4_format([[EMPTY_IMPL_CODE_%s]], [$1]), [$3])
                        m4_define(m4_format([[EMPTY_IMPL_NEED_DISPATCH_%s]], [$1]), [$4])
                        m4_define([EMPTY_IMPL_COUNT],m4_incr(EMPTY_IMPL_COUNT))
                        m4_define([EMPTY_IMPL_]EMPTY_IMPL_COUNT,[$1])])

m4_define([EMPTY_IMPLS],[forloop([i], 1, EMPTY_IMPL_COUNT, [m4_ifelse(i, [1], [], [, ])(EMPTY_IMPL(EMPTY_IMPL(i)))])])
m4_define([EMPTY_IMPL_FOREACH],[forloop([i], 1, EMPTY_IMPL_COUNT, [m4_indir([$1],_INSTR_EXPAND(EMPTY_IMPL(EMPTY_IMPL(i))))])])

m4_define([EMPTY_IMPL_LABEL], $1)
m4_define([EMPTY_IMPL_ARGS], $2)
m4_define([EMPTY_IMPL_CODE], $3)
m4_define([EMPTY_IMPL_NEED_DISPATCH], $4)


m4_define([CODE], [($1, $2, $3, $4, $5, $6, $7, $8)])
m4_define([ARGS], [$1])
m4_define([NO_ARGS], [0])
m4_define([PREPARATION], [$1])
m4_define([IMPL_SUFFIX], [$1])
m4_define([NO_IMPL_SUFFIX], [])
m4_define([IMPL], [$1])

INSTR_DEFINE([common_nop],
    CODE(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_NOP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_trap],
    CODE(0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_TRAP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_imm_reg_all_0],
    CODE(0x00, 0x01, OLB_CODE_imm, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        uint64_t * d;
        SVM_MI_GET_reg(d, SVM_MI_ARG_AS(2, size_t));
        *d = SVM_MI_ARG_AS(1,uint64_t);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_imm_stack_all_0],
    CODE(0x00, 0x01, OLB_CODE_imm, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        uint64_t * d;
        SVM_MI_GET_stack(d, SVM_MI_ARG_AS(2, size_t));
        *d = SVM_MI_ARG_AS(1,uint64_t);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_reg_reg_all_0],
    CODE(0x00, 0x01, OLB_CODE_reg, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), PREPARATION([
        SVM_PREPARE_CHECK_OR_ERROR(SVM_PREPARE_ARG(1) != SVM_PREPARE_ARG(2),
                                   SVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
    NO_IMPL_SUFFIX, IMPL([
        uint64_t * s;
        SVM_MI_GET_reg(s, SVM_MI_ARG_AS(1, size_t));
        uint64_t * d;
        SVM_MI_GET_reg(d, SVM_MI_ARG_AS(2, size_t));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_reg_stack_all_0],
    CODE(0x00, 0x01, OLB_CODE_reg, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        uint64_t * s;
        SVM_MI_GET_reg(s, SVM_MI_ARG_AS(1, size_t));
        uint64_t * d;
        SVM_MI_GET_stack(d, SVM_MI_ARG_AS(2, size_t));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_stack_reg_all_0],
    CODE(0x00, 0x01, OLB_CODE_stack, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        uint64_t * s;
        SVM_MI_GET_reg(s, SVM_MI_ARG_AS(1, size_t));
        uint64_t * d;
        SVM_MI_GET_reg(d, SVM_MI_ARG_AS(2, size_t));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_mov_stack_stack_all_0],
    CODE(0x00, 0x01, OLB_CODE_stack, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), PREPARATION([
        SVM_PREPARE_CHECK_OR_ERROR(SVM_PREPARE_ARG(1) != SVM_PREPARE_ARG(2),
                                   SVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
    NO_IMPL_SUFFIX, IMPL([
        uint64_t * s;
        SVM_MI_GET_reg(s, SVM_MI_ARG_AS(1, size_t));
        uint64_t * d;
        SVM_MI_GET_stack(d, SVM_MI_ARG_AS(2, size_t));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_push_imm],
    CODE(0x00, 0x02, 0x04, OLB_CODE_imm, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_PUSH(SVM_MI_ARG_AS(1, uint64_t))]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_push_reg],
    CODE(0x00, 0x02, 0x04, OLB_CODE_reg, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
            uint64_t * d;
            SVM_MI_GET_reg(d, SVM_MI_ARG_AS(1, size_t));
            SVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_push_stack],
    CODE(0x00, 0x02, 0x04, OLB_CODE_stack, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        uint64_t * d;
        SVM_MI_GET_stack(d, SVM_MI_ARG_AS(1, size_t));
        SVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_clearstack],
    CODE(0x00, 0x02, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_CLEAR_STACK]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_proc_resizestack],
    CODE(0x00, 0x02, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_RESIZE_STACK(SVM_MI_ARG_AS(1, uint64_t))]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common_halt],
    CODE(0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SVM_MI_HALT(SVM_MI_ARG_AS(1, int64_t))]), DO_DISPATCH, PREPARE_FINISH)

# (name,arg,numargs,backward,forward)
m4_define([INSTR_JUMP_PREPARE_IMM],
       [{
        int64_t a = *((int64_t *) SVM_PREPARE_ARG_P($2));
        if (a > 0) {
            uint64_t b = SVM_PREPARE_CURRENT_I + 1 + ($3);
            SVM_PREPARE_CHECK_OR_ERROR(
                b > SVM_PREPARE_CURRENT_I,
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            b += ((uint64_t) a);
            SVM_PREPARE_CHECK_OR_ERROR(
                b > SVM_PREPARE_CURRENT_I + 1 + ($3),
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SVM_PREPARE_CHECK_OR_ERROR(
                b < SVM_PREPARE_CODESIZE(SVM_PREPARE_CURRENT_CODE_SECTION),
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SVM_PREPARE_CHECK_OR_ERROR(
                SVM_PREPARE_IS_INSTR((size_t) b),
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SVM_PREPARE_END_AS($1[]$5,$3);
        } else {
            a = -a;
            SVM_PREPARE_CHECK_OR_ERROR(
                SVM_PREPARE_CURRENT_I > ((uint64_t) a),
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SVM_PREPARE_CHECK_OR_ERROR(
                SVM_PREPARE_IS_INSTR(SVM_PREPARE_CURRENT_I - ((uint64_t) a) - 1),
                SVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SVM_PREPARE_END_AS($1[]$4,$3);
        }
    }])

m4_define([JUMP_PREPARATION], [$1])
m4_define([JUMP_PRECODE], [$1])
m4_define([JUMP_CONDITION], [$1])
# (name,code,b3,b4,b5,b6,args,prep,precode,conds,dispatch)
m4_define([INSTR_JUMP_DEFINE], [
    INSTR_DEFINE($1[_imm],
        CODE(0x04, $2, OLB_CODE_imm, $3, $4, $5, $6, 0x00),
        ARGS($7),
        PREPARATION([m4_ifelse([$8], [NO_PREPARATION], [], [
            if (1) {
                $8;
                ])INSTR_JUMP_PREPARE_IMM($1[_imm],1,1,_backward,_forward)m4_ifelse([$8], [NO_PREPARATION], [], [;
            } else (void) 0])]),
        IMPL_SUFFIX(_forward),
        IMPL([
            if (1) {
                $9;m4_ifelse([$10], [[NO_JUMP_CONDITION]], [], [
                if ($10) {])
                    SVM_MI_JUMP_REL_FORWARD(SVM_MI_ARG_AS(1, int64_t), $7);m4_ifelse([$10], [NO_JUMP_CONDITION], [], [[
                }]])
            } else (void) 0]), $11, NO_PREPARE_FINISH)
    EMPTY_IMPL_DEFINE($1[_imm_backward], ARGS($7), IMPL[
        if (1) {
            $9;
            if ($10) {
                SVM_MI_JUMP_REL_BACKWARD(SVM_MI_ARG_AS(1, int64_t))
            }
        } else (void) 0], $11)
    INSTR_DEFINE($1[_reg],
        CODE(0x04, $2, OLB_CODE_reg, $3, $4, $5, $6, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([
            if (1) {
                $9;m4_ifelse([$10], [[NO_JUMP_CONDITION]], [], [
                if ($10) {])
                    uint64_t * t;
                    SVM_MI_GET_reg(t, SVM_MI_ARG_AS(1, size_t));
                    SVM_MI_CHECK_JUMP_REL(*((int64_t *) t),1);m4_ifelse([$10], [NO_JUMP_CONDITION], [], [[
                }]])
            } else (void) 0]), $11, PREPARE_FINISH)
    INSTR_DEFINE($1[_stack],
        CODE(0x04, $2, OLB_CODE_stack, $3, $4, $5, $6, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([
            if (1) {
                $9;m4_ifelse([$10], [[NO_JUMP_CONDITION]], [], [
                if ($10) {])
                    uint64_t * t;
                    SVM_MI_GET_stack(t, SVM_MI_ARG_AS(1, size_t));
                    SVM_MI_CHECK_JUMP_REL(*((int64_t *) t),1);m4_ifelse([$10], [NO_JUMP_CONDITION], [], [[
                }]])
            } else (void) 0]), $11, PREPARE_FINISH)
])



m4_define([_ARG1],[$1])
m4_define([_ARG2],[$2])
m4_define([_ARG3],[$3])
m4_define([_ARG4],[$4])

# (name, code, cond, dtb, olb)
m4_define([INSTR_JUMP_COND_1_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump_$1_$4_$5,
        $2, DTB_CODE_$4, OLB_CODE_$5, 0x00, 0x00, 2,
        NO_PREPARATION,
        JUMP_PRECODE([
            uint64_t * c;
            SVM_MI_GET_[]$5(c, SVM_MI_ARG_AS(2,size_t))]),
        $3, DO_DISPATCH)])

# (name, code, cond, dtb, olb, dtb2, olb2)
m4_define([INSTR_JUMP_COND_2_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump_$1_$4_$5_$6_$7,
        $2, DTB_CODE_$4, OLB_CODE_$5, DTB_CODE_$6, OLB_CODE_$7, 3,
        m4_ifelse([$4], [$6], m4_ifelse([$5], [$7], [if (SVM_PREPARE_ARG(1) == SVM_PREPARE_ARG(2))
            SVM_PREPARE_ERROR(SVM_PREPARE_ERROR_INVALID_ARGUMENTS);], [NO_PREPARATION]), [NO_PREPARATION]),
        JUMP_PRECODE([
            DTB_TYPE_$4 * c1;
            m4_ifelse([$5], [imm], [c1 = SVM_MI_ARG_AS_P(2, DTB_TYPE_$4)], [SVM_MI_GET_$5(c1, SVM_MI_ARG_AS(2,size_t))]);
            DTB_TYPE_$6 * c2;
            SVM_MI_GET_$7(c2, SVM_MI_ARG_AS(3,size_t))]),
        $3, DO_DISPATCH)])

INSTR_JUMP_DEFINE([jump_jmp], 0x10, 0x20, 0x30, 0x40, 0x50, 1, NO_PREPARATION, NO_JUMP_PRECODE, NO_JUMP_CONDITION, NO_DISPATCH)

m4_define([INSTR_JUMP_JZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jz],0x01,((*((DTB_GET_TYPE(_ARG1$1)*)c)) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jnz],0x02,[((*((DTB_GET_TYPE(_ARG1$1)*)c)) != 0)],_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjz],0x03,[(--(*((DTB_GET_TYPE(_ARG1$1)*)c)) == 0)],_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjnz],0x04,[(--(*((DTB_GET_TYPE(_ARG1$1)*)c)) != 0)],_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([je],0x05,((*c1) == (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JE_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jne],0x06,((*c1) != (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JNE_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jge],0x07,((*c1) >= (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JGE_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jgt],0x08,((*c1) > (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JGT_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jle],0x09,((*c1) <= (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JLE_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jlt],0x0a,((*c1) < (*c2)),_ARG1$1,_ARG2$1,_ARG3$1,_ARG4$1)])
foreach([INSTR_JUMP_JLT_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))



m4_define([INSTR_DISPATCH],
          [INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1:
    INSTR_IMPL$1;
    m4_ifelse(INSTR_NEED_DISPATCH$1, [DO_DISPATCH], [goto *((void*) *(ip += eval(INSTR_ARGS$1 + 1)));])

])
m4_define([INSTR_DISPATCH_EMPTY_IMPL],
       [EMPTY_IMPL_LABEL$1:
    EMPTY_IMPL_CODE$1;
    m4_ifelse(EMPTY_IMPL_NEED_DISPATCH$1, [DO_DISPATCH], [goto *((void*) *(ip += eval(EMPTY_IMPL_ARGS$1 + 1)));], [])
])

m4_define([REVERSE_2], [$2, $1])
m4_define([REVERSE_4], [$4, $3, $2, $1])
m4_define([REVERSE_8], [$8, $7, $6, $5, $4, $3, $2, $1])
m4_define([BYTES_TO_UINT16_BE], [m4_format([0x%02x%02x],m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT16_LE], [BYTES_TO_UINT16_BE(REVERSE_2($@))])
m4_define([BYTES_TO_UINT32_BE], [m4_format([0x%02x%02x%02x%02x],m4_eval($4),m4_eval($3),m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT32_LE], [BYTES_TO_UINT32_BE(REVERSE_4($@))])
m4_define([BYTES_TO_UINT64_BE], [m4_format([0x%02x%02x%02x%02x%02x%02x%02x%02x],m4_eval($8),m4_eval($7),m4_eval($6),m4_eval($5),m4_eval($4),m4_eval($3),m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT64_LE], [BYTES_TO_UINT64_BE(REVERSE_8($@))])

m4_define([INSTR_CODE_TO_BINARY], [BYTES_TO_UINT64_BE($@)]) # must be big-endian for little-endian targets (x86)
m4_define([COMPOSE], [$1$2])

m4_define([INSTR_PREPARE_CASE], [
    case COMPOSE([INSTR_CODE_TO_BINARY],INSTR_CODE$1): /* INSTR_NAME$1 */m4_pushdef([A], INSTR_PREPARATION$1)m4_ifelse(A, [NO_PREPARATION], [], [
        A;])m4_popdef([A])
        SVM_PREPARE_END_AS(INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1,INSTR_ARGS$1);])



#m4_define([PRINT], [print($1)])
#m4_define([NUMBRID], [([[yks]], [[kaks]], [[kolm]])])
#foreach([PRINT], NUMBRID)
#m4_define([PRINT2], [print(ARG1$1 = ARG2$1)])
#product(NUMBRID,NUMBRID)
#foreach([PRINT2], (product(NUMBRID,NUMBRID)))

m4_define([DO_INSTRS_PREPARE_CASES], [foreach([INSTR_PREPARE_CASE], [(INSTRS)])])
m4_define([DO_INSTRS_DISPATCH_SECTIONS],
          [foreach([INSTR_DISPATCH], (INSTRS))
foreach([INSTR_DISPATCH_EMPTY_IMPL], (EMPTY_IMPLS))])

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
