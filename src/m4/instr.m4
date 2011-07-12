m4_divert(-1)
#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_changequote([,])
m4_include([forloop.m4])
m4_include([foreach.m4])
m4_include([product.m4])
m4_include([datatypebyte.m4])
m4_include([operandlocationbyte.m4])

# (value)
m4_define([DEC_TO_HEX], [_$0(m4_eval([$1 % 16]))[]m4_ifelse(m4_eval([$1 >= 16]),
                                                            [1],
                                                            [$0(m4_eval([$1 / 16]))])])
m4_define([_DEC_TO_HEX], [m4_ifelse([$1], [15], [f], [$1], [14], [e], [$1], [13], [d],
                                    [$1], [12], [c], [$1], [11], [b], [$1], [10], [a], [$1])])

m4_define([_INSTR_EXPAND],[$1])

m4_define([INSTR_COUNT],0)
m4_define([INSTR], [m4_defn(m4_format([[INSTR_%s]], [$1]))])
m4_define([INSTR_DEFINE], [m4_define(m4_format([[INSTR_%s]], [$1]), [$1, $2, $3, $4, $5, $6, $7, $8, ]INSTR_COUNT)
                        m4_define([INSTR_COUNT],m4_incr(INSTR_COUNT))
                        m4_define([INSTR_]INSTR_COUNT,[$1])])

m4_define([INSTRS],[forloop([i], 1, INSTR_COUNT, [m4_ifelse(i, [1], [], [, ])(INSTR(INSTR(i)))])])
m4_define([INSTR_FOREACH],[forloop([i], 1, INSTR_COUNT, [m4_indir([$1],_INSTR_EXPAND(INSTR(INSTR(i))))])])

m4_define([STRIP_NAME], [m4_patsubst($1, [\.[^.]*$])])
m4_define([STRIP_TOP_NAMESPACE], [m4_patsubst($1, [^[^.]*\.])])
m4_define([STRIP_NAMESPACE], [m4_patsubst($1, [^\([^.]*\.\)*])])

m4_define([INSTR_FULLNAME], $1)
m4_define([INSTR_NAME], [STRIP_NAMESPACE($1)])
m4_define([INSTR_NAMESPACE], [STRIP_NAME($1)])
m4_define([INSTR_CODE], $2)
m4_define([INSTR_ARGS], $3)
m4_define([INSTR_PREPARATION], $4)
m4_define([INSTR_IMPL_SUFFIX], $5)
m4_define([INSTR_IMPL], $6)
m4_define([INSTR_NEED_DISPATCH], $7)
m4_define([INSTR_NEED_PREPARE_FINISH], $8)
m4_define([INSTR_INDEX], $9)

m4_define([EMPTY_IMPL_COUNT],0)
m4_define([EMPTY_IMPL], [m4_defn(m4_format([[EMPTY_IMPL_%s]], [$1]))])
m4_define([EMPTY_IMPL_DEFINE], [m4_define(m4_format([[EMPTY_IMPL_%s]], [$1]), [$1, $2, $3, $4, ]EMPTY_IMPL_COUNT)
                        m4_define(m4_format([[EMPTY_IMPL_LABEL_%s]], [$1]), [$1])
                        m4_define(m4_format([[EMPTY_IMPL_ARGS_%s]], [$1]), [$2])
                        m4_define(m4_format([[EMPTY_IMPL_CODE_%s]], [$1]), [$3])
                        m4_define(m4_format([[EMPTY_IMPL_NEED_DISPATCH_%s]], [$1]), [$4])
                        m4_define(m4_format([[EMPTY_IMPL_INDEX_%s]], [$1]), [$5])
                        m4_define([EMPTY_IMPL_COUNT],m4_incr(EMPTY_IMPL_COUNT))
                        m4_define([EMPTY_IMPL_]EMPTY_IMPL_COUNT,[$1])])

m4_define([EMPTY_IMPLS],[forloop([i], 1, EMPTY_IMPL_COUNT, [m4_ifelse(i, [1], [], [, ])(EMPTY_IMPL(EMPTY_IMPL(i)))])])
m4_define([EMPTY_IMPL_FOREACH],[forloop([i], 1, EMPTY_IMPL_COUNT, [m4_indir([$1],_INSTR_EXPAND(EMPTY_IMPL(EMPTY_IMPL(i))))])])

m4_define([EMPTY_IMPL_FULLLABEL], $1)
m4_define([EMPTY_IMPL_LABEL], [STRIP_NAMESPACE($1)])
m4_define([EMPTY_IMPL_NAMESPACE], [STRIP_NAME($1)])
m4_define([EMPTY_IMPL_ARGS], $2)
m4_define([EMPTY_IMPL_CODE], $3)
m4_define([EMPTY_IMPL_NEED_DISPATCH], $4)
m4_define([EMPTY_IMPL_INDEX], $5)


m4_define([CODE], [($1, $2, $3, $4, $5, $6, $7, $8)])
m4_define([ARGS], [$1])
m4_define([NO_ARGS], [0])
m4_define([PREPARATION], [m4_ifelse([$1], [NO_PREPARATION], [], [$1])])
m4_define([IMPL_SUFFIX], [$1])
m4_define([NO_IMPL_SUFFIX], [])
m4_define([IMPL], [$1])

INSTR_DEFINE([common.nop],
    CODE(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_NOP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.trap],
    CODE(0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_TRAP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_imm_reg],
    CODE(0x00, 0x01, OLB_CODE_imm, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * d;
        SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(2, sizet));
        *d = SMVM_MI_ARG(1);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_imm_stack],
    CODE(0x00, 0x01, OLB_CODE_imm, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(2, sizet));
        *d = SMVM_MI_ARG(1);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_reg_reg],
    CODE(0x00, 0x01, OLB_CODE_reg, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), PREPARATION([
        SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(1,uint64) != SMVM_PREPARE_ARG_AS(2,uint64),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
    NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * s;
        SMVM_MI_GET_reg(s, SMVM_MI_ARG_AS(1, sizet));
        union SM_CodeBlock * d;
        SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(2, sizet));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_reg_stack],
    CODE(0x00, 0x01, OLB_CODE_reg, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * s;
        SMVM_MI_GET_reg(s, SMVM_MI_ARG_AS(1, sizet));
        union SM_CodeBlock * d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(2, sizet));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_stack_reg],
    CODE(0x00, 0x01, OLB_CODE_stack, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * s;
        SMVM_MI_GET_reg(s, SMVM_MI_ARG_AS(1, sizet));
        union SM_CodeBlock * d;
        SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(2, sizet));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_stack_stack],
    CODE(0x00, 0x01, OLB_CODE_stack, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), PREPARATION([
        SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(1,uint64) != SMVM_PREPARE_ARG_AS(2,uint64),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
    NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * s;
        SMVM_MI_GET_reg(s, SMVM_MI_ARG_AS(1, sizet));
        union SM_CodeBlock * d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(2, sizet));
        *d = *s;]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.call_imm_imm],
    CODE(0x00, 0x02, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00),
    NO_ARGS,
    PREPARATION([{
        size_t b = SMVM_PREPARE_ARG_AS(1,sizet);
        SMVM_PREPARE_CHECK_OR_ERROR(
            ((uint64_t) b) != SMVM_PREPARE_ARG_AS(1,uint64),
            SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
        SMVM_PREPARE_CHECK_OR_ERROR(
            b < SMVM_PREPARE_CODESIZE(SMVM_PREPARE_CURRENT_CODE_SECTION),
            SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
        SMVM_PREPARE_CHECK_OR_ERROR(
            SMVM_PREPARE_IS_INSTR(b),
            SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
    }]),
    NO_IMPL_SUFFIX,
    IMPL([SMVM_MI_CALL(SMVM_MI_ARG_AS(1, sizet),NULL,1)]),
    NO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.return_imm],
    CODE(0x00, 0x02, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([SMVM_MI_RETURN(SMVM_MI_ARG_AS(1, int64))]),
    NO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_imm],
    CODE(0x00, 0x02, 0x04, OLB_CODE_imm, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_PUSH(SMVM_MI_ARG(1))]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_reg],
    CODE(0x00, 0x02, 0x04, OLB_CODE_reg, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
            union SM_CodeBlock * d;
            SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_stack],
    CODE(0x00, 0x02, 0x04, OLB_CODE_stack, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.clearstack],
    CODE(0x00, 0x02, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_CLEAR_STACK]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.resizestack],
    CODE(0x00, 0x02, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_RESIZE_STACK(SMVM_MI_ARG_AS(1, uint64))]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.halt],
    CODE(0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_HALT(SMVM_MI_ARG_AS(1, int64))]), DO_DISPATCH, PREPARE_FINISH)

# (name,suffixes,code,b3,b4,b5,b6,args,prep,precode,conds,dispatch)
m4_define([INSTR_JUMP_DEFINE], [
    INSTR_DEFINE($1[_imm]$2,
        CODE(0x04, $3, OLB_CODE_imm, $4, $5, $6, $7, 0x00),
        ARGS($8),
        [if (1) {
            m4_ifelse([$9], [NO_PREPARATION], [], [$9;
            ])SMVM_PREPARE_CHECK_OR_ERROR(
                SMVM_PREPARE_IS_INSTR((size_t) SMVM_PREPARE_CURRENT_I + SMVM_PREPARE_ARG_AS(1,int64)),
                SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
        }],
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$10], [NO_JUMP_PRECODE], [], [
        $10;])m4_ifelse([$11], [NO_JUMP_CONDITION], [], [
        if ($11) {])
            SMVM_MI_JUMP_REL(SMVM_MI_ARG_P(1));m4_ifelse([$11], [NO_JUMP_CONDITION], [], [[
        } else (void) 0]])]),
        $12, PREPARE_FINISH)
    INSTR_DEFINE($1[_reg]$2,
        CODE(0x04, $3, OLB_CODE_reg, $4, $5, $6, $7, 0x00),
        ARGS($8),
        PREPARATION([$9]),
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$10], [NO_JUMP_PRECODE], [], [
        $10;])m4_ifelse([$11], [NO_JUMP_CONDITION], [], [
        if ($11) {])
            union SM_CodeBlock * t;
            SMVM_MI_GET_reg(t, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_CHECK_JUMP_REL(SMVM_MI_BLOCK_AS(t,int64));m4_ifelse([$11], [NO_JUMP_CONDITION], [], [[
        } else (void) 0]])]),
        $12, PREPARE_FINISH)
    INSTR_DEFINE($1[_stack]$2,
        CODE(0x04, $3, OLB_CODE_stack, $4, $5, $6, $7, 0x00),
        ARGS($8),
        PREPARATION([$9]),
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$10], [NO_JUMP_PRECODE], [], [
        $10;])m4_ifelse([$11], [NO_JUMP_CONDITION], [], [
        if ($11) {])
            union SM_CodeBlock * t;
            SMVM_MI_GET_stack(t, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_CHECK_JUMP_REL(SMVM_MI_BLOCK_AS(t,int64));m4_ifelse([$11], [NO_JUMP_CONDITION], [], [[
        } else (void) 0]])]),
        $12, PREPARE_FINISH)
])

INSTR_JUMP_DEFINE([jump.jmp], [], 0x00, 0x00, 0x00, 0x00, 0x00, 1, NO_PREPARATION, NO_JUMP_PRECODE, NO_JUMP_CONDITION, NO_DISPATCH)


m4_define([_ARG1],[$1])
m4_define([_ARG2],[$2])
m4_define([_ARG3],[$3])
m4_define([_ARG4],[$4])

# (name, code, cond, dtb, olb)
m4_define([INSTR_JUMP_COND_1_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump.$1, _$4_$5,
        $2, DTB_CODE_$4, OLB_CODE_$5, 0x00, 0x00, 2,
        NO_PREPARATION,
        [
        union SM_CodeBlock * c;
        SMVM_MI_GET_[]$5(c, SMVM_MI_ARG_AS(2, sizet))],
        $3, DO_DISPATCH)])

# (name, code, cond, dtb, olb, dtb2, olb2)
m4_define([INSTR_JUMP_COND_2_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump.$1, _$4_$5_$6_$7,
        $2, DTB_CODE_$4, OLB_CODE_$5, DTB_CODE_$6, OLB_CODE_$7, 3,
        m4_ifelse([$4], [$6], m4_ifelse([$5], [$7], [if (SMVM_PREPARE_ARG_AS(1,uint64) == SMVM_PREPARE_ARG_AS(2,uint64)) {
            SMVM_PREPARE_ERROR(SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
        }], [NO_PREPARATION]), [NO_PREPARATION]),
        [
        DTB_TYPE_$4 * c1;
        m4_ifelse([$5], [imm], [c1 = SMVM_MI_ARG_AS_P(2, DTB_NAME_$4)],
                    [SMVM_MI_GET_T_$5(c1, $4, SMVM_MI_ARG_AS(2, sizet))]);
        DTB_TYPE_$6 * c2;
        SMVM_MI_GET_T_$7(c2, $6, SMVM_MI_ARG_AS(3, sizet))],
        $3, DO_DISPATCH)])

m4_define([INSTR_JUMP_JZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jz],0x01,(SMVM_MI_BLOCK_AS(c,_ARG1$1) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jnz],0x02,[SMVM_MI_BLOCK_AS(c,_ARG1$1) != 0)],_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjz],0x03,[(--(SMVM_MI_BLOCK_AS(c,_ARG1$1)) == 0)],_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjnz],0x04,[(--(SMVM_MI_BLOCK_AS(c,_ARG1$1)) != 0)],_ARG1$1,_ARG2$1)])
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

m4_define([REVERSE_2], [$2, $1])
m4_define([REVERSE_4], [$4, $3, $2, $1])
m4_define([REVERSE_8], [$8, $7, $6, $5, $4, $3, $2, $1])
m4_define([BYTES_TO_UINT16_BE], [m4_format([0x%02x%02x],m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT16_LE], [BYTES_TO_UINT16_BE(REVERSE_2($@))])
m4_define([BYTES_TO_UINT32_BE], [m4_format([0x%02x%02x%02x%02x],m4_eval($4),m4_eval($3),m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT32_LE], [BYTES_TO_UINT32_BE(REVERSE_4($@))])
m4_define([BYTES_TO_UINT64_BE], [m4_format([0x%02x%02x%02x%02x%02x%02x%02x%02x],m4_eval($8),m4_eval($7),m4_eval($6),m4_eval($5),m4_eval($4),m4_eval($3),m4_eval($2),m4_eval($1))])
m4_define([BYTES_TO_UINT64_LE], [BYTES_TO_UINT64_BE(REVERSE_8($@))])

m4_define([INSTR_CODE_TO_BYTECODE], [BYTES_TO_UINT64_BE($@)])
m4_define([COMPOSE], [$1$2])

#m4_define([PRINT], [print($1)])
#m4_define([NUMBRID], [([[yks]], [[kaks]], [[kolm]])])
#foreach([PRINT], NUMBRID)
#m4_define([PRINT2], [print(ARG1$1 = ARG2$1)])
#product(NUMBRID,NUMBRID)
#foreach([PRINT2], (product(NUMBRID,NUMBRID)))
