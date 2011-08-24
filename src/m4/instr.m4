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

m4_define([_ARG1],[$1])
m4_define([_ARG2],[$2])
m4_define([_ARG3],[$3])
m4_define([_ARG4],[$4])
m4_define([_ARG5],[$5])

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
        union SM_CodeBlock * restrict d;
        SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(2, sizet));
        *d = SMVM_MI_ARG(1);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_imm_stack],
    CODE(0x00, 0x01, OLB_CODE_imm, OLB_CODE_stack, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * restrict d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(2, sizet));
        *d = SMVM_MI_ARG(1);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.mov_reg_reg],
    CODE(0x00, 0x01, OLB_CODE_reg, OLB_CODE_reg, 0xff, 0x00, 0x00, 0x00),
    ARGS(2), PREPARATION([
        SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(1,uint64) != SMVM_PREPARE_ARG_AS(2,uint64),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
    NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * restrict s;
        SMVM_MI_GET_reg(s, SMVM_MI_ARG_AS(1, sizet));
        union SM_CodeBlock * restrict d;
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

m4_define([_MOV_FROM_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_mem_$1_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00, 0x00),
        ARGS(4), PREPARATION([
            SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                        SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                        SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
        NO_IMPL_SUFFIX, IMPL([
            union SM_CodeBlock * restrict ptr;
            SMVM_MI_GET_$1(ptr, SMVM_MI_ARG_AS(1, sizet));
            struct SMVM_MemorySlot * restrict slot; \
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(ptr,uint64), slot);
            union SM_CodeBlock * restrict dest;
            SMVM_MI_GET_$3(dest, SMVM_MI_ARG_AS(3, sizet));
            union SM_CodeBlock * restrict offset;
            m4_ifelse($2, [imm],
                      [offset = SMVM_MI_ARG_P(2);],
                      [SMVM_MI_GET_$2(offset, SMVM_MI_ARG_AS(2, sizet));])
            union SM_CodeBlock * readSize;
            m4_ifelse($4, [imm],
                      [readSize = SMVM_MI_ARG_P(4);],
                      [SMVM_MI_GET_$4(readSize, SMVM_MI_ARG_AS(4, sizet));])
            SMVM_MI_TRY_EXCEPT(slot->size - SMVM_MI_BLOCK_AS(offset,uint64) >= SMVM_MI_BLOCK_AS(readSize,sizet), SMVM_E_INVALID_MEMORY_READ);
            SMVM_MI_MEMCPY(&(SMVM_MI_BLOCK_AS(dest,uint64)), slot->pData + SMVM_MI_BLOCK_AS(offset,uint64), SMVM_MI_BLOCK_AS(readSize,sizet));]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_FROM_MEM_DEFINE], [_MOV_FROM_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_FROM_MEM_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]))))

m4_define([_MOV_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_$1_mem_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, OLB_CODE_mem_$2_$3, OLB_CODE_$4, 0x00, 0x00, 0x00),
        ARGS(4), PREPARATION([
            SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                        SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                        SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
        NO_IMPL_SUFFIX, IMPL([
            union SM_CodeBlock * restrict src;
            m4_ifelse($1, [imm],
                      [src = SMVM_MI_ARG_P(1);],
                      [SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));])
            union SM_CodeBlock * restrict ptr;
            SMVM_MI_GET_$2(ptr, SMVM_MI_ARG_AS(2, sizet));
            struct SMVM_MemorySlot * restrict slot; \
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(ptr,uint64), slot);
            union SM_CodeBlock * restrict offset;
            m4_ifelse($3, [imm],
                      [offset = SMVM_MI_ARG_P(3);],
                      [SMVM_MI_GET_$3(offset, SMVM_MI_ARG_AS(3, sizet));])
            union SM_CodeBlock * writeSize;
            m4_ifelse($4, [imm],
                      [writeSize = SMVM_MI_ARG_P(4);],
                      [SMVM_MI_GET_$4(writeSize, SMVM_MI_ARG_AS(4, sizet));])
            SMVM_MI_TRY_EXCEPT(slot->size - SMVM_MI_BLOCK_AS(offset,uint64) >= SMVM_MI_BLOCK_AS(writeSize,sizet), SMVM_E_INVALID_MEMORY_WRITE);
            SMVM_MI_MEMCPY(slot->pData + SMVM_MI_BLOCK_AS(offset,uint64), &(SMVM_MI_BLOCK_AS(src,uint64)), SMVM_MI_BLOCK_AS(writeSize,sizet));]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_TO_MEM_DEFINE], [_MOV_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_TO_MEM_DEFINE], (product(([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

m4_define([_MOV_MEM_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_mem_$3_$4_$5],
        CODE(0x00, 0x01, OLB_CODE_mem_$1_$2, OLB_CODE_mem_$3_$4, OLB_CODE_$5, 0x00, 0x00, 0x00),
        ARGS(5), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            union SM_CodeBlock * restrict srcPtr;
            SMVM_MI_GET_$1(srcPtr, SMVM_MI_ARG_AS(1, sizet));
            struct SMVM_MemorySlot * restrict srcSlot; \
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(srcPtr,uint64), srcSlot);
            union SM_CodeBlock * restrict srcOffset;
            m4_ifelse($2, [imm],
                      [srcOffset = SMVM_MI_ARG_P(2);],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            union SM_CodeBlock * writeSize;
            m4_ifelse($5, [imm],
                      [writeSize = SMVM_MI_ARG_P(5);],
                      [SMVM_MI_GET_$5(writeSize, SMVM_MI_ARG_AS(5, sizet));])
            SMVM_MI_TRY_EXCEPT(srcSlot->size - SMVM_MI_BLOCK_AS(srcOffset,uint64) >= SMVM_MI_BLOCK_AS(writeSize,sizet), SMVM_E_INVALID_MEMORY_READ);
            union SM_CodeBlock * restrict dstPtr;
            SMVM_MI_GET_$3(dstPtr, SMVM_MI_ARG_AS(3, sizet));
            struct SMVM_MemorySlot * restrict dstSlot; \
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(dstPtr,uint64), dstSlot);
            union SM_CodeBlock * restrict dstOffset;
            m4_ifelse($4, [imm],
                      [dstOffset = SMVM_MI_ARG_P(4);],
                      [SMVM_MI_GET_$4(dstOffset, SMVM_MI_ARG_AS(4, sizet));])
            SMVM_MI_TRY_EXCEPT(dstSlot->size - SMVM_MI_BLOCK_AS(dstOffset,uint64) >= SMVM_MI_BLOCK_AS(writeSize,sizet), SMVM_E_INVALID_MEMORY_WRITE);
            SMVM_MI_MEMCPY(dstSlot->pData + SMVM_MI_BLOCK_AS(dstOffset,uint64),
                           srcSlot->pData + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                           SMVM_MI_BLOCK_AS(writeSize,sizet));]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_MEM_DEFINE], [_MOV_MEM_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, _ARG5$1)])
foreach([MOV_MEM_TO_MEM_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

m4_define([CHECK_CALL_TARGET], [SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_IS_INSTR($1), SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);])

m4_define([_CALL_DEFINE], [
    INSTR_DEFINE([common.proc.call_$1_$2],
        CODE(0x00, 0x02, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(m4_ifelse($2, [imm], 1, 2)),
        m4_ifelse($1, [imm], CHECK_CALL_TARGET(SMVM_PREPARE_ARG_AS(1,sizet)), NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm],,[
                union SM_CodeBlock * addr;
                SMVM_MI_GET_$1(addr, SMVM_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm],,[
                union SM_CodeBlock * rv;
                SMVM_MI_GET_$2(rv, SMVM_MI_ARG_AS(2, sizet));])
            m4_ifelse($1, [imm],
                [SMVM_MI_CALL(SMVM_MI_ARG_AS(1, sizet),m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))],
                [SMVM_MI_CHECK_CALL(addr,m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))])]),
        NO_DISPATCH, PREPARE_FINISH)
])
m4_define([CALL_DEFINE], [_CALL_DEFINE(_ARG1$1, _ARG2$1)])
foreach([CALL_DEFINE], (product(([[imm]], [[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

INSTR_DEFINE([common.proc.return_imm],
    CODE(0x00, 0x02, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([SMVM_MI_RETURN(SMVM_MI_ARG(1))]),
    NO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.return_reg],
    CODE(0x00, 0x02, 0x03, 0x02, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        union SM_CodeBlock * v;
        SMVM_MI_GET_reg(v, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_RETURN(*v);]),
    NO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.return_stack],
    CODE(0x00, 0x02, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        union SM_CodeBlock * v;
        SMVM_MI_GET_stack(v, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_RETURN(*v);]),
    NO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_imm],
    CODE(0x00, 0x02, 0x04, OLB_CODE_imm, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_PUSH(SMVM_MI_ARG(1))]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_reg],
    CODE(0x00, 0x02, 0x04, OLB_CODE_reg, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
            union SM_CodeBlock * restrict d;
            SMVM_MI_GET_reg(d, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.push_stack],
    CODE(0x00, 0x02, 0x04, OLB_CODE_stack, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([
        union SM_CodeBlock * restrict d;
        SMVM_MI_GET_stack(d, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_PUSH(*d);]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.clearstack],
    CODE(0x00, 0x02, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_CLEAR_STACK]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.resizestack],
    CODE(0x00, 0x02, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_RESIZE_STACK(SMVM_MI_ARG_AS(1, uint64))]), DO_DISPATCH, PREPARE_FINISH)

m4_define([_MEM_ALLOC_DEFINE], [
    INSTR_DEFINE([common.mem.alloc_$1_$2],
        CODE(0x00, 0x03, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            union SM_CodeBlock * ptrDest;
            SMVM_MI_GET_$1(ptrDest, SMVM_MI_ARG_AS(1, sizet));
            m4_ifelse($2, [imm],,
                [union SM_CodeBlock * sizeReg;
                 SMVM_MI_GET_$2(sizeReg, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_MEM_ALLOC(ptrDest,m4_ifelse($2, [imm], [SMVM_MI_ARG_P(2)], [sizeReg]))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MEM_ALLOC_DEFINE], [_MEM_ALLOC_DEFINE(_ARG1$1, _ARG2$1)])
foreach([MEM_ALLOC_DEFINE], (product(([[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

m4_define([MEM_FREE_DEFINE], [
    INSTR_DEFINE([common.mem.free_$1],
        CODE(0x00, 0x03, 0x01, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            union SM_CodeBlock * ptr;
            SMVM_MI_GET_$1(ptr, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_FREE(ptr)]),
        DO_DISPATCH, PREPARE_FINISH)])
MEM_FREE_DEFINE([reg])
MEM_FREE_DEFINE([stack])

m4_define([MEM_GET_SIZE_DEFINE], [
    INSTR_DEFINE([common.mem.getsize_$1_$2],
        CODE(0x00, 0x03, 0x02, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            union SM_CodeBlock * ptr;
            SMVM_MI_GET_$1(ptr, SMVM_MI_ARG_AS(1, sizet));
            union SM_CodeBlock * sizedest;
            SMVM_MI_GET_$2(sizedest, SMVM_MI_ARG_AS(2, sizet));
            SMVM_MI_MEM_GET_SIZE(ptr,sizedest);]),
        DO_DISPATCH, PREPARE_FINISH
    )])
MEM_GET_SIZE_DEFINE([reg],[reg])
MEM_GET_SIZE_DEFINE([reg],[stack])
MEM_GET_SIZE_DEFINE([stack],[reg])
MEM_GET_SIZE_DEFINE([stack],[stack])

m4_define([HALT_DEFINE], [
    INSTR_DEFINE([common.halt_$1],
        CODE(0x00, 0xff, 0x00, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm],,
                [union SM_CodeBlock * haltCode;
                 SMVM_MI_GET_$1(haltCode, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_MI_HALT(m4_ifelse($1, [imm], [SMVM_MI_ARG(1)], [*haltCode]))]),
        NO_DISPATCH, PREPARE_FINISH])
HALT_DEFINE([imm])
HALT_DEFINE([reg])
HALT_DEFINE([stack])

INSTR_DEFINE([common.except],
    CODE(0x00, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), PREPARATION([
        SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_IS_EXCEPTIONCODE(SMVM_PREPARE_ARG_AS(1,int64)),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
    ]), NO_IMPL_SUFFIX, IMPL([SMVM_MI_DO_EXCEPT(SMVM_MI_ARG_AS(1,int64))]), DO_DISPATCH, PREPARE_FINISH)

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
        m4_ifelse([$4], [$6], m4_ifelse([$5], [$7], [SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(1,uint64) != SMVM_PREPARE_ARG_AS(2,uint64),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
        ], [NO_PREPARATION]), [NO_PREPARATION]),
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
