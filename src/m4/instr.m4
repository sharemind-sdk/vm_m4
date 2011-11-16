m4_divert(-1)
#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_changequote([,]) # use [ and ] instead of ` and '


################################################################################
##  MACROS                                                                    ##
################################################################################
##    Here we define some macros used by the instruction definitions below and #
#     m4 files depending these instruction definitions.                        #
################################################################################

m4_include([forloop.m4])
m4_include([foreach.m4])
m4_include([product.m4])
m4_include([datatypebyte.m4])
m4_include([operandlocationbyte.m4])


m4_define([_ARG1],[$1]) # _ARG1(a1,a2,...) -> a1
m4_define([_ARG2],[$2]) # _ARG1(a1,a2,...) -> a2
m4_define([_ARG3],[$3]) # _ARG1(a1,a2,...) -> a3
m4_define([_ARG4],[$4]) # _ARG1(a1,a2,...) -> a4
m4_define([_ARG5],[$5]) # _ARG1(a1,a2,...) -> a5

# DEC_TO_HEX(value) changes the representation of value for decimal base to hexadecimal
m4_define([DEC_TO_HEX], [_$0(m4_eval([$1 % 16]))[]m4_ifelse(m4_eval([$1 >= 16]),
                                                            [1],
                                                            [$0(m4_eval([$1 / 16]))])])
m4_define([_DEC_TO_HEX], [m4_ifelse([$1], [15], [f], [$1], [14], [e], [$1], [13], [d],
                                    [$1], [12], [c], [$1], [11], [b], [$1], [10], [a], [$1])])

m4_define([INSTR_COUNT],0)
m4_define([INSTR], [m4_defn(m4_format([[INSTR_%s]], [$1]))])
m4_define([INSTR_DEFINE], [m4_define(m4_format([[INSTR_%s]], [$1]), [$1, $2, $3, $4, $5, $6, $7, $8, ]INSTR_COUNT)
                        m4_define([INSTR_COUNT],m4_incr(INSTR_COUNT))
                        m4_define([INSTR_]INSTR_COUNT,[$1])])

m4_define([INSTRS],[forloop([i], 1, INSTR_COUNT, [m4_ifelse(i, [1], [], [, ])(INSTR(INSTR(i)))])])
m4_define([INSTR_FOREACH],[forloop([i], 1, INSTR_COUNT, [m4_indir([$1],_ARG1(INSTR(INSTR(i))))])])

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
m4_define([EMPTY_IMPL_FOREACH],[forloop([i], 1, EMPTY_IMPL_COUNT, [m4_indir([$1],_ARG1(EMPTY_IMPL(EMPTY_IMPL(i))))])])

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


################################################################################
##  INSTRUCTION DEFINITIONS                                                   ##
################################################################################

INSTR_DEFINE([common.nop],
    CODE(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_NOP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.trap],
    CODE(0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_TRAP]), DO_DISPATCH, PREPARE_FINISH)

# common.mov (imm, reg, stack) >> (reg, stack)
# (1=olbsrc,2=olbdest)
m4_define([_MOV_REGS_TO_REGS_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2],
        CODE(0x00, 0x01, OLB_CODE_$1, 0x00, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_CodeBlock * s;
            m4_ifelse($1, [imm],
                      [s = SMVM_MI_ARG_P(1);],
                      [SMVM_MI_GET_$1(s, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_CodeBlock * d;
            SMVM_MI_GET_$2(d, SMVM_MI_ARG_AS(2, sizet));
            (*d) = *s]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REGS_TO_REGS_DEFINE], [_MOV_REGS_TO_REGS_DEFINE(_ARG1$1, _ARG2$1)])
foreach([MOV_REGS_TO_REGS_DEFINE], (product(([imm], [reg], [stack]), ([reg], [stack]))))

# common.mov (mem) >> (reg, stack)
# (1=olbsrc_part,2=olbsrcoffset,3=olbdest,4=olbnbytes)
m4_define([_MOV_MEM_TO_REGS_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_mem_$1, OLB_CODE_$2, OLB_CODE_$3, 0x00, OLB_CODE_$4, 0x00),
        ARGS(4),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const SMVM_CodeBlock * src;
            SMVM_MemorySlot * restrict srcSlot;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            SMVM_CodeBlock * dest;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(src,uint64), srcSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_READ(srcSlot), SMVM_E_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_$3(dest, SMVM_MI_ARG_AS(3, sizet));
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(numBytes, SMVM_MI_ARG_AS(4,sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(numBytes,uint64) <= 8u, SMVM_E_OUT_OF_BOUNDS_WRITE);])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(srcSlot->size, SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            SMVM_MI_MEMCPY(&(SMVM_MI_BLOCK_AS(dest,uint64)), ((const uint8_t *) srcSlot->pData) + SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_REGS_DEFINE], [_MOV_MEM_TO_REGS_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_MEM_TO_REGS_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (imm, reg, stack) >> (mem)
# (1=olbsrc,2=olbdest_part,3=olbdestoffset,4=olbnbytes)
m4_define([_MOV_REGS_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_$1_mem_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, 0x00, OLB_CODE_mem_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00),
        ARGS(4),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const SMVM_CodeBlock * m4_ifelse($1, [imm], [restrict]) src;
            const SMVM_CodeBlock * dest;
            const SMVM_MemorySlot * restrict destSlot;
            const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm], [],
                      [SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_MI_GET_$2(dest, SMVM_MI_ARG_AS(2, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(dest,uint64), destSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_WRITE(destSlot), SMVM_E_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SMVM_MI_GET_$3(destOffset, SMVM_MI_ARG_AS(3, sizet));])
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(numBytes, SMVM_MI_ARG_AS(4,sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(numBytes,uint64) <= 8u, SMVM_E_OUT_OF_BOUNDS_READ);])
            m4_ifelse($3, [imm], [destOffset = SMVM_MI_ARG_P(3);])
            m4_ifelse($4, [imm], [numBytes = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(destSlot->size, SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_ifelse($1, [imm], [src = SMVM_MI_ARG_P(1);])
            SMVM_MI_MEMCPY(((uint8_t *) destSlot->pData) + SMVM_MI_BLOCK_AS(destOffset,uint64), &(SMVM_MI_BLOCK_AS(src,uint64)), SMVM_MI_BLOCK_AS(numBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REGS_TO_MEM_DEFINE], [_MOV_REGS_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_REGS_TO_MEM_DEFINE], (product(([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (mem) >> (mem)
# (1=olbsrc_part,2=olbsrcoffset,3=olbdest_part,4=olbdestoffset,5=olbnbytes)
m4_define([_MOV_MEM_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_mem_$3_$4_$5],
        CODE(0x00, 0x01, OLB_CODE_mem_$1, OLB_CODE_$2, OLB_CODE_mem_$3, OLB_CODE_$4, OLB_CODE_$5, 0x00),
        ARGS(5),
        m4_ifelse($5, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(5,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_CodeBlock * src;
            const SMVM_MemorySlot * srcSlot;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SMVM_CodeBlock * dest;
            const SMVM_MemorySlot * destSlot;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($5, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(src,uint64), srcSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_READ(srcSlot), SMVM_E_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_$3(dest, SMVM_MI_ARG_AS(3, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(dest,uint64), destSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_WRITE(destSlot), SMVM_E_WRITE_DENIED);
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(destOffset, SMVM_MI_ARG_AS(4, sizet));])
            m4_ifelse($5, [imm], [],
                      [SMVM_MI_GET_$5(numBytes, SMVM_MI_ARG_AS(5, sizet));])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($5, [imm], [numBytes = SMVM_MI_ARG_P(5);])
            SMVM_MI_TRY_MEMRANGE(srcSlot->size, SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            m4_ifelse($4, [imm], [destOffset = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(destSlot->size, SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [((uint8_t *) destSlot->pData) + SMVM_MI_BLOCK_AS(destOffset,uint64),
                                    ((const uint8_t *) srcSlot->pData) + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            if (srcSlot != destSlot) {
                SMVM_MI_MEMCPY(CPY_ARGS);
            } else {
                SMVM_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_MEM_DEFINE], [_MOV_MEM_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, _ARG5$1)])
foreach([MOV_MEM_TO_MEM_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (ref, cref) >> (reg, stack)
# (1=olbsrc,2=olbsrcoffset,3=olbdest,4=olbnbytes)
m4_define([_MOV_REF_TO_REGS_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, OLB_CODE_$2, OLB_CODE_$3, 0x00, OLB_CODE_$4, 0x00),
        ARGS(4),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const SMVM_[]m4_ifelse($1, [cref], [C])[]Reference * restrict srcRef;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            SMVM_CodeBlock * dest;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(srcRef, SMVM_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_READ(srcRef), SMVM_E_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_$3(dest, SMVM_MI_ARG_AS(3, sizet));
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(numBytes, SMVM_MI_ARG_AS(4,sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(numBytes,uint64) <= 8u, SMVM_E_OUT_OF_BOUNDS_WRITE);])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(srcRef), SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            m4_pushdef([CPY_ARGS], [&(SMVM_MI_BLOCK_AS(dest,uint64)),
                                    SMVM_MI_REFERENCE_GET_CONST_PTR(srcRef) + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            m4_ifelse($3, [stack],
                      [SMVM_MI_MEMCPY(CPY_ARGS);],
                      [if (SMVM_MI_REFERENCE_GET_MEMORY_PTR(srcRef)) {
                           SMVM_MI_MEMCPY(CPY_ARGS);
                       } else {
                           SMVM_MI_MEMMOVE(CPY_ARGS);
                       }])
            m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REF_TO_REGS_DEFINE], [_MOV_REF_TO_REGS_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_REF_TO_REGS_DEFINE], (product(([cref], [ref]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (imm, reg, stack) >> (ref)
# (1=olbsrc,2=olbdestoffset,3=olbnbytes)
m4_define([_MOV_REGS_TO_REF_DEFINE], [
    INSTR_DEFINE([common.mov_$1_ref_$2_$3],
        CODE(0x00, 0x01, OLB_CODE_$1, 0x00, OLB_CODE_ref, OLB_CODE_$2, OLB_CODE_$3, 0x00),
        ARGS(4),
        m4_ifelse($3, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const SMVM_CodeBlock * m4_ifelse($1, [imm], [restrict]) src;
            const SMVM_Reference * restrict destRef;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm], [],
                      [SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_MI_GET_ref(destRef, SMVM_MI_ARG_AS(2, sizet));
            SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_WRITE(destRef), SMVM_E_WRITE_DENIED);
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(destOffset, SMVM_MI_ARG_AS(3, sizet));])
            m4_ifelse($3, [imm], [],
                      [SMVM_MI_GET_$3(numBytes, SMVM_MI_ARG_AS(4,sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(numBytes,uint64) <= 8u, SMVM_E_OUT_OF_BOUNDS_READ);])
            m4_ifelse($2, [imm], [destOffset = SMVM_MI_ARG_P(3);])
            m4_ifelse($3, [imm], [numBytes = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(destRef), SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_ifelse($1, [imm], [src = SMVM_MI_ARG_P(1);])
            m4_pushdef([CPY_ARGS], [SMVM_MI_REFERENCE_GET_PTR(destRef) + SMVM_MI_BLOCK_AS(destOffset,uint64),
                                    &(SMVM_MI_BLOCK_AS(src,uint64)),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            m4_ifelse($1, [reg],
                      [if (SMVM_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                           SMVM_MI_MEMCPY(CPY_ARGS);
                       } else {
                           SMVM_MI_MEMMOVE(CPY_ARGS);
                       }],
                      [SMVM_MI_MEMCPY(CPY_ARGS)])m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REGS_TO_REF_DEFINE], [_MOV_REGS_TO_REF_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1)])
foreach([MOV_REGS_TO_REF_DEFINE], (product(([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (cref, ref) >> (ref)
# (1=olbsrc,2=olbsrcoffset,3=olbdestoffset,4=olbnbytes)
m4_define([_MOV_REF_TO_REF_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2_ref_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, OLB_CODE_$2, OLB_CODE_ref, OLB_CODE_$3, OLB_CODE_$4, 0x00),
        ARGS(5),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(5,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_[]m4_ifelse($1, [cref], [C])Reference * srcRef;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SMVM_Reference * destRef;
            const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(srcRef, SMVM_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_READ(srcRef), SMVM_E_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_ref(destRef, SMVM_MI_ARG_AS(3, sizet));
            SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_WRITE(destRef), SMVM_E_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SMVM_MI_GET_$3(destOffset, SMVM_MI_ARG_AS(4, sizet));])
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(numBytes, SMVM_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SMVM_MI_ARG_P(5);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(srcRef), SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            m4_ifelse($3, [imm], [destOffset = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(destRef), SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [SMVM_MI_REFERENCE_GET_PTR(destRef) + SMVM_MI_BLOCK_AS(destOffset,uint64),
                                    SMVM_MI_REFERENCE_GET_CONST_PTR(srcRef) + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            if (SMVM_MI_REFERENCE_GET_MEMORY_PTR(srcRef) != SMVM_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                SMVM_MI_MEMCPY(CPY_ARGS);
            } else {
                SMVM_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REF_TO_REF_DEFINE], [_MOV_REF_TO_REF_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_REF_TO_REF_DEFINE], (product(([cref], [ref]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (cref, ref) >> (mem)
# (1=olbsrc,2=olbsrcoffset,3=olbdest_part,4=olbdestoffset,5=olbnbytes)
m4_define([_MOV_REF_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2_mem_$3_$4_$5],
        CODE(0x00, 0x01, OLB_CODE_$1, OLB_CODE_$2, OLB_CODE_mem_$3, OLB_CODE_$4, OLB_CODE_$5, 0x00),
        ARGS(5),
        m4_ifelse($5, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(5,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_[]m4_ifelse($1, [cref], [C])Reference * restrict srcRef;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SMVM_CodeBlock * restrict dest;
            const SMVM_MemorySlot * restrict destSlot;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($5, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(srcRef, SMVM_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_READ(srcRef), SMVM_E_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_$3(dest, SMVM_MI_ARG_AS(3, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(dest,uint64), destSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_WRITE(destSlot), SMVM_E_WRITE_DENIED);
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(destOffset, SMVM_MI_ARG_AS(4, sizet));])
            m4_ifelse($5, [imm], [],
                      [SMVM_MI_GET_$5(numBytes, SMVM_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($5, [imm], [numBytes = SMVM_MI_ARG_P(5);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(srcRef), SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            m4_ifelse($4, [imm], [destOffset = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(destSlot->size, SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [((uint8_t *) destSlot->pData) + SMVM_MI_BLOCK_AS(destOffset,uint64),
                                    SMVM_MI_REFERENCE_GET_CONST_PTR(srcRef) + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            if (SMVM_MI_REFERENCE_GET_MEMORY_PTR(srcRef) != destSlot) {
                SMVM_MI_MEMCPY(CPY_ARGS);
            } else {
                SMVM_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REF_TO_MEM_DEFINE], [_MOV_REF_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, _ARG5$1)])
foreach([MOV_REF_TO_MEM_DEFINE], (product(([cref], [ref]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (mem) >> (ref)
# (1=olbsrc_part,2=olbsrcoffset,3=olbdestoffset,4=olbnbytes)
m4_define([_MOV_MEM_TO_REF_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_ref_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_mem_$1, OLB_CODE_$2, OLB_CODE_ref, OLB_CODE_$3, OLB_CODE_$4, 0x00),
        ARGS(5),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(5,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_CodeBlock * restrict src;
            const SMVM_MemorySlot * restrict srcSlot;
            const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SMVM_Reference * restrict destRef;
            const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SMVM_MI_GET_$1(src, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(src,uint64), srcSlot);
            SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_READ(srcSlot), SMVM_E_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SMVM_MI_GET_$2(srcOffset, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_GET_ref(destRef, SMVM_MI_ARG_AS(3, sizet));
            SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_WRITE(destRef), SMVM_E_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SMVM_MI_GET_$3(destOffset, SMVM_MI_ARG_AS(4, sizet));])
            m4_ifelse($4, [imm], [],
                      [SMVM_MI_GET_$4(numBytes, SMVM_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SMVM_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SMVM_MI_ARG_P(5);])
            SMVM_MI_TRY_MEMRANGE(srcSlot->size, SMVM_MI_BLOCK_AS(srcOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_READ);
            m4_ifelse($3, [imm], [destOffset = SMVM_MI_ARG_P(4);])
            SMVM_MI_TRY_MEMRANGE(SMVM_MI_REFERENCE_GET_SIZE(destRef), SMVM_MI_BLOCK_AS(destOffset,uint64), SMVM_MI_BLOCK_AS(numBytes,uint64), SMVM_E_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [SMVM_MI_REFERENCE_GET_PTR(destRef) + SMVM_MI_BLOCK_AS(destOffset,uint64),
                                    ((const uint8_t *) srcSlot->pData) + SMVM_MI_BLOCK_AS(srcOffset,uint64),
                                    SMVM_MI_BLOCK_AS(numBytes,uint64)])
            if (srcSlot != SMVM_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                SMVM_MI_MEMCPY(CPY_ARGS);
            } else {
                SMVM_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_REF_DEFINE], [_MOV_MEM_TO_REF_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_MEM_TO_REF_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

m4_define([CHECK_CALL_TARGET], [SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_IS_INSTR($1), SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);])

# common.proc.call
m4_define([_CALL_DEFINE], [
    INSTR_DEFINE([common.proc.call_$1_$2],
        CODE(0x00, 0x02, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(m4_ifelse($2, [imm], 1, 2)),
        m4_ifelse($1, [imm], CHECK_CALL_TARGET(SMVM_PREPARE_ARG_AS(1,sizet)), NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm],,[
                const SMVM_CodeBlock * addr;
                SMVM_MI_GET_$1(addr, SMVM_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm],,[
                SMVM_CodeBlock * rv;
                SMVM_MI_GET_$2(rv, SMVM_MI_ARG_AS(2, sizet));])
            m4_ifelse($1, [imm],
                [SMVM_MI_CALL(SMVM_MI_ARG_AS(1, sizet),m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))],
                [SMVM_MI_CHECK_CALL(addr,m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))])]),
        NO_DISPATCH, PREPARE_FINISH)
])
m4_define([CALL_DEFINE], [_CALL_DEFINE(_ARG1$1, _ARG2$1)])
foreach([CALL_DEFINE], (product(([[imm]], [[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

# common.proc.syscall
m4_define([_SYSCALL_DEFINE], [
    INSTR_DEFINE([common.proc.syscall_$1_$2],
        CODE(0x00, 0x02, 0x02, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(m4_ifelse($2, [imm], 1, 2)),
        m4_ifelse($1, [imm],
                  [SMVM_PREPARE_SYSCALL(1);],
                  NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm],,[
                const SMVM_CodeBlock * addr;
                SMVM_MI_GET_$1(addr, SMVM_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm],,[
                SMVM_CodeBlock * rv;
                SMVM_MI_GET_$2(rv, SMVM_MI_ARG_AS(2, sizet));])
            m4_ifelse($1, [imm],
                [SMVM_MI_SYSCALL(SMVM_MI_ARG_AS(1, p),m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))],
                [SMVM_MI_CHECK_SYSCALL(addr,m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))])]),
        DO_DISPATCH, PREPARE_FINISH)
])
m4_define([SYSCALL_DEFINE], [_SYSCALL_DEFINE(_ARG1$1, _ARG2$1)])
foreach([SYSCALL_DEFINE], (product(([[imm]], [[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

# common.proc.return
m4_define([RETURN_DEFINE], [
    INSTR_DEFINE([common.proc.return_$1],
        CODE(0x00, 0x02, 0x03, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL(m4_ifelse($1, [imm],
                       [SMVM_MI_RETURN(SMVM_MI_ARG(1))],
                       [SMVM_CodeBlock * v;
                        SMVM_MI_GET_$1(v, SMVM_MI_ARG_AS(1, sizet));
                        SMVM_MI_RETURN(*v);])),
        NO_DISPATCH, PREPARE_FINISH)])
RETURN_DEFINE([imm])
RETURN_DEFINE([reg])
RETURN_DEFINE([stack])

# common.proc.push
m4_define([PUSH_DEFINE], [
    INSTR_DEFINE([common.proc.push_$1],
        CODE(0x00, 0x02, 0x04, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL(m4_ifelse($1, [imm],
                       [SMVM_MI_PUSH(SMVM_MI_ARG(1))],
                       [SMVM_CodeBlock * restrict d;
                        SMVM_MI_GET_$1(d, SMVM_MI_ARG_AS(1, sizet));
                        SMVM_MI_PUSH(*d);])),
        DO_DISPATCH, PREPARE_FINISH)])
PUSH_DEFINE([imm])
PUSH_DEFINE([reg])
PUSH_DEFINE([stack])

# common.proc.pushref (reg, stack) + common.proc.pushcref (imm, reg, stack)
# (1=ref_or_cref,2=olbsrc)
m4_define([_PUSHREF_BLOCK_DEFINE], [
    INSTR_DEFINE([common.proc.push$1_$2],
        CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x05], [0x07]), OLB_CODE_$2, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [cref], [const]) SMVM_CodeBlock * restrict b;
            m4_ifelse($2, [imm],
                      [b = SMVM_MI_ARG_P(1);],
                      [SMVM_MI_GET_$2(b, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_MI_PUSHREF_BLOCK_$1(b)]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREF_BLOCK_DEFINE], [_PUSHREF_BLOCK_DEFINE(_ARG1$1, _ARG2$1)])
foreach([PUSHREF_BLOCK_DEFINE], (product(([cref], [ref]), ([reg], [stack]))))
_PUSHREF_BLOCK_DEFINE([cref], [imm])

# common.proc.pushref (ref) + common.proc.pushcref (ref, cref)
# (1=ref_or_cref,2=olbsrc)
m4_define([PUSHREF_REF_DEFINE], [
    INSTR_DEFINE([common.proc.push$1_$2],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x05], [0x07]), OLB_CODE_$2, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        const SMVM_[]m4_ifelse($2, [cref], [C])Reference * restrict srcRef;
        SMVM_MI_GET_$2(srcRef, SMVM_MI_ARG_AS(1, sizet));
        m4_ifelse($1, [cref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_READ(srcRef), SMVM_E_INVALID_ARGUMENT);])
        SMVM_MI_PUSHREF_REF_$1(srcRef)]),
    DO_DISPATCH, PREPARE_FINISH)])
PUSHREF_REF_DEFINE([cref], [cref])
PUSHREF_REF_DEFINE([cref], [ref])
PUSHREF_REF_DEFINE([ref], [ref])

# common.proc.pushref (mem) + common.proc.pushcref (mem)
# (1=ref_or_cref,2=olbsrc_part)
m4_define([_PUSHREF_MEM_DEFINE], [
    INSTR_DEFINE([common.proc.push$1_mem_$2],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x05], [0x07]), OLB_CODE_mem_$2, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        const SMVM_CodeBlock * srcPtr;
        SMVM_MemorySlot * srcSlot;
        SMVM_MI_GET_$2(srcPtr, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(srcPtr,uint64), srcSlot);
        m4_ifelse($1, [cref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_READ(srcSlot), SMVM_E_INVALID_ARGUMENT);])
        SMVM_MI_PUSHREF_MEM_$1(srcSlot)]),
    DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREF_MEM_DEFINE], [_PUSHREF_MEM_DEFINE(_ARG1$1, _ARG2$1)])
foreach([PUSHREF_MEM_DEFINE], (product(([cref], [ref]), ([reg], [stack]))))

# common.proc.pushrefpart (reg, stack) + common.proc.pushcrefpart (imm, reg, stack)
# (1=ref_or_cref,2=olbsrc,3=olbsrcoffset,4=olblength)
m4_define([_PUSHREFPART_BLOCK_DEFINE], [
    INSTR_DEFINE([common.proc.push$1part_$2_$3_$4],
        CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x06], [0x08]), OLB_CODE_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
        ARGS(3),
        m4_ifelse($3_$4, [imm_imm],
                  PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(2,uint64) < 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(3,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(2,uint64) + SMVM_PREPARE_ARG_AS(3,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  $3, [imm],
                  PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(2,uint64) < 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  $4, [imm],
                  PREPARATION([
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(3,uint64) > 0u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(3,uint64) <= 8u,
                                                  SMVM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($2, [imm], [const]) SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) b;
            const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) offset;
            const SMVM_CodeBlock * m4_ifelse($4, [imm], [restrict]) nBytes;
            m4_ifelse($2, [imm],
                      [b = SMVM_MI_ARG_P(1);],
                      [SMVM_MI_GET_$2(b, SMVM_MI_ARG_AS(1, sizet));])
            m4_ifelse($3, [imm],
                      [offset = SMVM_MI_ARG_P(2);],
                      [SMVM_MI_GET_$3(offset, SMVM_MI_ARG_AS(2, sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset, uint64) < 8u,
                                          SMVM_E_OUT_OF_BOUNDS_REFERENCE_INDEX);])
            m4_ifelse($4, [imm],
                      [nBytes = SMVM_MI_ARG_P(3);],
                      [SMVM_MI_GET_$4(nBytes, SMVM_MI_ARG_AS(3, sizet));
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(nBytes, uint64) > 0u,
                                          SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);
                       SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(nBytes, uint64) <= 8u,
                                          SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);])
            m4_ifelse($3_$4, [imm_imm], [],
                      [SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset, uint64) + SMVM_MI_BLOCK_AS(nBytes, uint64) <= 8u,
                                          SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);])
            SMVM_MI_PUSHREFPART_BLOCK_$1(b,SMVM_MI_BLOCK_AS(offset,uint64),SMVM_MI_BLOCK_AS(nBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREFPART_BLOCK_DEFINE], [_PUSHREFPART_BLOCK_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([PUSHREFPART_BLOCK_DEFINE], (product(([cref], [ref]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))
foreach([PUSHREFPART_BLOCK_DEFINE], (product(([cref]), ([imm]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.proc.pushrefpart (ref) + common.proc.pushcrefpart (ref, cref)
# (1=ref_or_cref,2=olbsrc,3=olbsrcoffset,4=olblength)
m4_define([PUSHREFPART_REF_DEFINE], [
    INSTR_DEFINE([common.proc.push$1part_$2_$3_$4],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x06], [0x08]), OLB_CODE_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
    ARGS(3),
    m4_ifelse($4, [imm],
              PREPARATION([SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(3,uint64) > 0u,
                                                       SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);]),
              NO_PREPARATION),
    NO_IMPL_SUFFIX,
    IMPL([
        const SMVM_[]m4_ifelse($1, [cref], [C])Reference * restrict srcRef;
        const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) offset;
        const SMVM_CodeBlock * m4_ifelse($3, [imm], [restrict]) nBytes;
        SMVM_MI_GET_$2(srcRef, SMVM_MI_ARG_AS(1, sizet));
        m4_ifelse($1, [cref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_REF_CAN_READ(srcRef), SMVM_E_INVALID_ARGUMENT);])
        m4_ifelse($3, [imm],
                  [offset = SMVM_MI_ARG_P(2);],
                  [SMVM_MI_GET_$3(offset, SMVM_MI_ARG_AS(2, sizet));])
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset,sizet) < srcRef->size,
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_INDEX);
        m4_ifelse($4, [imm],
                  [nBytes = SMVM_MI_ARG_P(3);],
                  [SMVM_MI_GET_$4(nBytes, SMVM_MI_ARG_AS(3, sizet));])
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(nBytes,uint64) <= srcRef->size,
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset,uint64) < srcRef->size - SMVM_MI_BLOCK_AS(nBytes,uint64),
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SMVM_MI_PUSHREFPART_REF_$1(srcRef, SMVM_MI_BLOCK_AS(offset,uint64), SMVM_MI_BLOCK_AS(nBytes,uint64))]),
    DO_DISPATCH, PREPARE_FINISH)])

# common.proc.pushrefpart (mem) + common.proc.pushcrefpart (mem)
# (1=ref_or_cref,2=olbsrc_part,3=olbsrcoffset,4=olblength)
m4_define([_PUSHREFPART_MEM_DEFINE], [
    INSTR_DEFINE([common.proc.push$1part_mem_$2_$3_$4],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x06], [0x08]), OLB_CODE_mem_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
    ARGS(3),
    m4_ifelse($4, [imm],
              PREPARATION([SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(3,uint64) > 0u,
                                                       SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);]),
              NO_PREPARATION),
    NO_IMPL_SUFFIX,
    IMPL([
        const SMVM_CodeBlock * srcPtr;
        const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) offset;
        const SMVM_CodeBlock * m4_ifelse($2, [imm], [restrict]) nBytes;
        SMVM_MemorySlot * srcSlot;
        SMVM_MI_GET_$2(srcPtr, SMVM_MI_ARG_AS(1, sizet));
        SMVM_MI_MEM_GET_SLOT_OR_EXCEPT(SMVM_MI_BLOCK_AS(srcPtr,uint64), srcSlot);
        m4_ifelse($1, [cref], [SMVM_MI_TRY_EXCEPT(SMVM_MI_MEM_CAN_READ(srcSlot), SMVM_E_INVALID_ARGUMENT);])
        m4_ifelse($3, [imm],
                  [offset = SMVM_MI_ARG_P(2);],
                  [SMVM_MI_GET_$3(offset, SMVM_MI_ARG_AS(2, sizet));])
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset,sizet) < srcSlot->size,
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_INDEX);
        m4_ifelse($4, [imm],
                  [nBytes = SMVM_MI_ARG_P(3);],
                  [SMVM_MI_GET_$4(nBytes, SMVM_MI_ARG_AS(3, sizet));])
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(nBytes,uint64) <= srcSlot->size,
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SMVM_MI_TRY_EXCEPT(SMVM_MI_BLOCK_AS(offset,uint64) < srcSlot->size - SMVM_MI_BLOCK_AS(nBytes,uint64),
                           SMVM_E_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SMVM_MI_PUSHREFPART_MEM_$1(srcSlot, SMVM_MI_BLOCK_AS(offset,uint64), SMVM_MI_BLOCK_AS(nBytes,uint64))]),
    DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREFPART_MEM_DEFINE], [_PUSHREFPART_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([PUSHREFPART_MEM_DEFINE], (product(([cref], [ref]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

INSTR_DEFINE([common.proc.clearstack],
    CODE(0x00, 0x02, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        if (likely(SMVM_MI_HAS_STACK)) {
            SMVM_MI_CLEAR_STACK;
        } else (void) 0]),
    DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.resizestack],
    CODE(0x00, 0x02, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SMVM_MI_RESIZE_STACK(SMVM_MI_ARG_AS(1, uint64))]), DO_DISPATCH, PREPARE_FINISH)

# common.mem.alloc
m4_define([_MEM_ALLOC_DEFINE], [
    INSTR_DEFINE([common.mem.alloc_$1_$2],
        CODE(0x00, 0x03, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * ptrDest;
            SMVM_MI_GET_$1(ptrDest, SMVM_MI_ARG_AS(1, sizet));
            m4_ifelse($2, [imm],,
                [SMVM_CodeBlock * sizeReg;
                 SMVM_MI_GET_$2(sizeReg, SMVM_MI_ARG_AS(2, sizet));])
            SMVM_MI_MEM_ALLOC(ptrDest,m4_ifelse($2, [imm], [SMVM_MI_ARG_P(2)], [sizeReg]))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MEM_ALLOC_DEFINE], [_MEM_ALLOC_DEFINE(_ARG1$1, _ARG2$1)])
foreach([MEM_ALLOC_DEFINE], (product(([[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

# common.mem.free
m4_define([MEM_FREE_DEFINE], [
    INSTR_DEFINE([common.mem.free_$1],
        CODE(0x00, 0x03, 0x01, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * ptr;
            SMVM_MI_GET_$1(ptr, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_FREE(ptr)]),
        DO_DISPATCH, PREPARE_FINISH)])
MEM_FREE_DEFINE([reg])
MEM_FREE_DEFINE([stack])

# common.mem.getsize
m4_define([MEM_GET_SIZE_DEFINE], [
    INSTR_DEFINE([common.mem.getsize_$1_$2],
        CODE(0x00, 0x03, 0x02, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * ptr;
            SMVM_MI_GET_$1(ptr, SMVM_MI_ARG_AS(1, sizet));
            SMVM_CodeBlock * sizedest;
            SMVM_MI_GET_$2(sizedest, SMVM_MI_ARG_AS(2, sizet));
            SMVM_MI_MEM_GET_SIZE(ptr,sizedest);]),
        DO_DISPATCH, PREPARE_FINISH
    )])
MEM_GET_SIZE_DEFINE([reg],[reg])
MEM_GET_SIZE_DEFINE([reg],[stack])
MEM_GET_SIZE_DEFINE([stack],[reg])
MEM_GET_SIZE_DEFINE([stack],[stack])

# common.mem.getdatasegment
m4_define([SECTION_CODE_bss], 0x00)
m4_define([SECTION_CODE_rodata], 0x01)
m4_define([SECTION_CODE_data], 0x02)
m4_define([_MEM_GETDATASEGMENT_DEFINE], [
    INSTR_DEFINE([common.mem.getdatasegment_$1_$2],
        CODE(0x00, 0x03, 0x05, SECTION_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * ptrDest;
            SMVM_MI_GET_$2(ptrDest, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_MEM_GETSEGMENT_$1(ptrDest)]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MEM_GETDATASEGMENT_DEFINE], [_MEM_GETDATASEGMENT_DEFINE(_ARG1$1, _ARG2$1)])
foreach([MEM_GETDATASEGMENT_DEFINE], (product(([[bss]], [[rodata]], [[data]]),([[reg]], [[stack]]))))

# common.convert
m4_define([_CONVERT_DEFINE], [m4_ifelse($1, $3, [], [
    INSTR_DEFINE([common.convert_$1_$2_$3_$4],
        CODE(0x00, 0x04, DTB_CODE_$1, OLB_CODE_$2, DTB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SMVM_CodeBlock * s;
            SMVM_MI_GET_$2(s, SMVM_MI_ARG_AS(1, sizet));
            SMVM_CodeBlock * d;
            SMVM_MI_GET_$4(d, SMVM_MI_ARG_AS(2, sizet));
            m4_ifelse($1, [float32],
                      [SMVM_MI_CONVERT_$1_TO_$3(SMVM_MI_BLOCK_AS(d,$3), SMVM_MI_BLOCK_AS(s,$1))],
                      $3, [float32],
                      [SMVM_MI_CONVERT_$1_TO_$3(SMVM_MI_BLOCK_AS(d,$3), SMVM_MI_BLOCK_AS(s,$1))],
                      [SMVM_MI_BLOCK_AS(d,$3) = (DTB_TYPE_$3) SMVM_MI_BLOCK_AS(s,$1)])
            ]),
        DO_DISPATCH, PREPARE_FINISH
    )])])
m4_define([CONVERT_DEFINE], [_$0(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([CONVERT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]), ([reg], [stack]), ([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]), ([reg], [stack]))))

# common.halt
m4_define([HALT_DEFINE], [
    INSTR_DEFINE([common.halt_$1],
        CODE(0x00, 0xff, 0x00, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm], [],
                [SMVM_CodeBlock * haltCode;
                 SMVM_MI_GET_$1(haltCode, SMVM_MI_ARG_AS(1, sizet));])
            SMVM_MI_HALT(m4_ifelse($1, [imm], [SMVM_MI_ARG(1)], [*haltCode]))]),
        NO_DISPATCH, PREPARE_FINISH)])
HALT_DEFINE([imm])
HALT_DEFINE([reg])
HALT_DEFINE([stack])

INSTR_DEFINE([common.except],
    CODE(0x00, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), PREPARATION([
        SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_IS_EXCEPTIONCODE(SMVM_PREPARE_ARG_AS(1,int64)),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
    ]), NO_IMPL_SUFFIX, IMPL([SMVM_MI_DO_EXCEPT(SMVM_MI_ARG_AS(1,int64))]), DO_DISPATCH, PREPARE_FINISH)


# (1=name,2=namespace,3=class,4=dtb,5=olb,6=prepare,7=impl)
m4_define([ALBI_D_DEFINE], [
    INSTR_DEFINE($1_$4_$5,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), $6, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * bd;
            SMVM_MI_GET_$5(bd, SMVM_MI_ARG_AS(1, sizet));
            DTB_TYPE_$4 * d = SMVM_MI_BLOCK_AS_P(bd,$4);
            $7]),
        DO_DISPATCH, PREPARE_FINISH)])

# (1=name,2=namespace,3=class,4=dtb_d,5=olb_d,6=olb_s,7=prepare,8=impl)
m4_define([ALBI_DS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, 0x00, 0x00, 0x00),
        ARGS(2), $7, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * bd;
            m4_ifelse($6, [imm], [const]) SMVM_CodeBlock * m4_ifelse($6, [imm], [restrict]) bs;
            DTB_TYPE_$4 * d;
            m4_ifelse($6, [imm], [const]) DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) s;
            SMVM_MI_GET_$5(bd, SMVM_MI_ARG_AS(1, sizet));
            d = SMVM_MI_BLOCK_AS_P(bd,$4);
            m4_ifelse($6, [imm], [bs = SMVM_MI_ARG_P(2);], [SMVM_MI_GET_$6(bs, SMVM_MI_ARG_AS(2, sizet));])
            s = SMVM_MI_BLOCK_AS_P(bs,$4);
            $8]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([ALBI_DDS_DEFINE], [ALBI_DSS_DEFINE])

# (1=name,2=namespace,3=class,4=dtb_d,5=olb_d,6=olb_s1,7=olb_s2,8=prepare,9=impl)
m4_define([ALBI_DSS_DEFINE], [m4_ifelse($6, $7, m4_ifelse($6, [imm], [], [_$0($@)]))])
m4_define([_ALBI_DSS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6_$7,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, OLB_CODE_$7, 0x00, 0x00),
        ARGS(3), $8, NO_IMPL_SUFFIX,
        IMPL([
            SMVM_CodeBlock * bd;
            m4_ifelse($6, [imm], [const]) SMVM_CodeBlock * m4_ifelse($6, [imm], [restrict]) bs1;
            m4_ifelse($7, [imm], [const]) SMVM_CodeBlock * m4_ifelse($7, [imm], [restrict]) bs2;
            DTB_TYPE_$4 * d;
            m4_ifelse($6, [imm], [const]) DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) s1;
            m4_ifelse($7, [imm], [const]) DTB_TYPE_$4 * m4_ifelse($7, [imm], [restrict]) s2;
            SMVM_MI_GET_$5(bd, SMVM_MI_ARG_AS(1, sizet));
            d = SMVM_MI_BLOCK_AS_P(bd,$4);
            m4_ifelse($6, [imm], [bs1 = SMVM_MI_ARG_P(2);], [SMVM_MI_GET_$6(bs1, SMVM_MI_ARG_AS(2, sizet));])
            s1 = SMVM_MI_BLOCK_AS_P(bs1,$4);
            m4_ifelse($7, [imm], [bs2 = SMVM_MI_ARG_P(3);], [SMVM_MI_GET_$7(bs2, SMVM_MI_ARG_AS(3, sizet));])
            s2 = SMVM_MI_BLOCK_AS_P(bs2,$4);
            m4_ifelse(DTB_CAT_$4, [float], [], [
                m4_ifelse($1, [arith.tdiv], [
                    if ((*s2) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                    m4_ifelse(DTB_CAT_$4, [signed], [else if ((*s2) == -1 && (*s1) == DTB_MIN_$4) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_OVERFLOW); }])])])
            $9]),
        DO_DISPATCH, PREPARE_FINISH)])

# See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50865
m4_define([GCC_BUG_50865_WORKAROUND], [if (($4) == -1) { ($1) = ($2) (($3) % 1); } else { ($1) = ($2) (($3) % -($4)); }])

# arith.uneg
m4_define([ARITH_UNEG_OP], [m4_ifelse($1, [float32], [SMVM_MI_UNEG_FLOAT32(*d)], [(*d) = (DTB_TYPE_$1) -(*d)])])
m4_define([ARITH_UNEG_DEFINE], [ALBI_D_DEFINE([[arith.uneg]], 0x1, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UNEG_OP(_ARG1$1))])
foreach([ARITH_UNEG_DEFINE], (product(([int8], [int16], [int32], [int64], [float32]), ([reg], [stack]))))

# arith.uinc
m4_define([ARITH_UINC_OP], [m4_ifelse($1, [float32], [SMVM_MI_UINC_FLOAT32(*d)], [(*d)++])])
m4_define([ARITH_UINC_DEFINE], [ALBI_D_DEFINE([[arith.uinc]], 0x1, 0x01, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UINC_OP(_ARG1$1))])
foreach([ARITH_UINC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]), ([reg], [stack]))))

# arith.udec
m4_define([ARITH_UDEC_OP], [m4_ifelse($1, [float32], [SMVM_MI_UDEC_FLOAT32(*d)], [(*d)--])])
m4_define([ARITH_UDEC_DEFINE], [ALBI_D_DEFINE([[arith.udec]], 0x1, 0x02, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UDEC_OP(_ARG1$1))])
foreach([ARITH_UDEC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]), ([reg], [stack]))))

# arith.bneg
m4_define([ARITH_BNEG_OP], [m4_ifelse($1, [float32], [SMVM_MI_BNEG_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) -(*s)])])
m4_define([ARITH_BNEG_DEFINE], [ALBI_DS_DEFINE([[arith.bneg]], 0x1, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BNEG_OP(_ARG1$1))])
foreach([ARITH_BNEG_DEFINE], (product(([int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.binc
m4_define([ARITH_BINC_OP], [m4_ifelse($1, [float32], [SMVM_MI_BINC_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) + 1)])])
m4_define([ARITH_BINC_DEFINE], [ALBI_DS_DEFINE([[arith.binc]], 0x1, 0x41, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BINC_OP(_ARG1$1))])
foreach([ARITH_BINC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.bdec
m4_define([ARITH_BDEC_OP], [m4_ifelse($1, [float32], [SMVM_MI_BDEC_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) - 1)])])
m4_define([ARITH_BDEC_DEFINE], [ALBI_DS_DEFINE([[arith.bdec]], 0x1, 0x42, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDEC_OP(_ARG1$1))])
foreach([ARITH_BDEC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.badd
m4_define([ARITH_BADD_OP], [m4_ifelse($1, [float32], [SMVM_MI_BADD_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) + (*s))])])
m4_define([ARITH_BADD_DEFINE], [ALBI_DS_DEFINE([[arith.badd]], 0x1, 0x80, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BADD_OP(_ARG1$1))])
foreach([ARITH_BADD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bsub
m4_define([ARITH_BSUB_OP], [m4_ifelse($1, [float32], [SMVM_MI_BSUB_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) - (*s))])])
m4_define([ARITH_BSUB_DEFINE], [ALBI_DS_DEFINE([[arith.bsub]], 0x1, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BSUB_OP(_ARG1$1))])
foreach([ARITH_BSUB_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bsub2
m4_define([ARITH_BSUB2_OP], [m4_ifelse($1, [float32], [SMVM_MI_BSUB2_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) - (*d))])])
m4_define([ARITH_BSUB2_DEFINE], [ALBI_DS_DEFINE([[arith.bsub2]], 0x1, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BSUB2_OP(_ARG1$1))])
foreach([ARITH_BSUB2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.bmul
m4_define([ARITH_BMUL_OP], [m4_ifelse($1, [float32], [SMVM_MI_BMUL_FLOAT32(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) * (*s))])])
m4_define([ARITH_BMUL_DEFINE], [ALBI_DS_DEFINE([[arith.bmul]], 0x1, 0x83, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMUL_OP(_ARG1$1))])
foreach([ARITH_BMUL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bdiv
m4_define([ARITH_BDIV_OP],
          [m4_ifelse($1, [float32],
                     [SMVM_MI_BDIV_FLOAT32(*d,*s)],
                     [if ((*s) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if ((*s) == -1 && (*d) == DTB_MIN_$1) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_OVERFLOW); }])
                      (*d) = (DTB_TYPE_$1) ((*d) / (*s))])])
m4_define([ARITH_BDIV_DEFINE], [ALBI_DS_DEFINE([[arith.bdiv]], 0x1, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDIV_OP(_ARG1$1))])
foreach([ARITH_BDIV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bdiv2
m4_define([ARITH_BDIV2_OP],
          [m4_ifelse($1, [float32],
                     [SMVM_MI_BDIV2_FLOAT32(*d,*s)],
                     [if ((*d) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if ((*d) == -1 && (*s) == DTB_MIN_$1) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_OVERFLOW); }])
                      (*d) = (DTB_TYPE_$1) ((*s) / (*d))])])
m4_define([ARITH_BDIV2_DEFINE], [ALBI_DS_DEFINE([[arith.bdiv2]], 0x1, 0x85, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDIV2_OP(_ARG1$1))])
foreach([ARITH_BDIV2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.bmod
m4_define([ARITH_BMOD_OP],
          [m4_ifelse($1, [float32],
                     [SMVM_MI_BMOD_FLOAT32(*d,*s)],
                     [if ((*s) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*s) < 0) && ((*s) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*d), (*s)); }])
                      else (*d) = (DTB_TYPE_$1) ((*d) % (*s))])])
m4_define([ARITH_BMOD_DEFINE], [ALBI_DS_DEFINE([[arith.bmod]], 0x1, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMOD_OP(_ARG1$1))])
foreach([ARITH_BMOD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bmod2
m4_define([ARITH_BMOD2_OP],
          [m4_ifelse($1, [float32],
                     [SMVM_MI_BMOD2_FLOAT32(*d,*s)],
                     [if ((*d) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*d) < 0) && ((*d) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*s), (*d)); }])
                      else (*d) = (DTB_TYPE_$1) ((*s) % (*d))])])
m4_define([ARITH_BMOD2_DEFINE], [ALBI_DS_DEFINE([[arith.bmod2]], 0x1, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMOD2_OP(_ARG1$1))])
foreach([ARITH_BMOD2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.tadd
m4_define([ARITH_TADD_OP], [m4_ifelse($1, [float32], [SMVM_MI_TADD_FLOAT32(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) + (*s2))])])
m4_define([ARITH_TADD_DEFINE], [ALBI_DSS_DEFINE([[arith.tadd]], 0x1, 0xc0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TADD_OP(_ARG1$1))])
foreach([ARITH_TADD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tsub
m4_define([ARITH_TSUB_OP], [m4_ifelse($1, [float32], [SMVM_MI_TSUB_FLOAT32(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) - (*s2))])])
m4_define([ARITH_TSUB_DEFINE], [ALBI_DSS_DEFINE([[arith.tsub]], 0x1, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TSUB_OP(_ARG1$1))])
foreach([ARITH_TSUB_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tmul
m4_define([ARITH_TMUL_OP], [m4_ifelse($1, [float32], [SMVM_MI_TMUL_FLOAT32(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) * (*s2))])])
m4_define([ARITH_TMUL_DEFINE], [ALBI_DSS_DEFINE([[arith.tmul]], 0x1, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TMUL_OP(_ARG1$1))])
foreach([ARITH_TMUL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tdiv
m4_define([ARITH_TDIV_OP], [m4_ifelse($1, [float32], [SMVM_MI_TDIV_FLOAT32(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) / (*s2))])])
m4_define([ARITH_TDIV_DEFINE], [ALBI_DSS_DEFINE([[arith.tdiv]], 0x1, 0xc3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TDIV_OP(_ARG1$1))])
foreach([ARITH_TDIV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tmod
m4_define([ARITH_TMOD_OP],
          [m4_ifelse($1, [float32],
                     [SMVM_MI_TMOD_FLOAT32(*d,*s1,*s2)],
                     [if ((*s2) == 0) { SMVM_MI_DO_EXCEPT(SMVM_E_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*s2) < 0) && ((*s2) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*s1), (*s2)); }])
                      else (*d) = (DTB_TYPE_$1) ((*s1) % (*s2))])])
m4_define([ARITH_TMOD_DEFINE], [ALBI_DSS_DEFINE([[arith.tmod]], 0x1, 0xc4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TMOD_OP(_ARG1$1))])
foreach([ARITH_TMOD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# binary.uinv
m4_define([BINARY_UINV_DEFINE], [ALBI_D_DEFINE([[binary.uinv]], 0x2, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~(*d)])])
foreach([BINARY_UINV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.urtl
m4_define([BINARY_URTL_DEFINE], [ALBI_D_DEFINE([[binary.urtl]], 0x2, 0x02, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | (((*d) >> m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_URTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.urtr
m4_define([BINARY_URTR_DEFINE], [ALBI_D_DEFINE([[binary.urtr]], 0x2, 0x03, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*d) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_URTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl0
m4_define([BINARY_USHL0_DEFINE], [ALBI_D_DEFINE([[binary.ushl0]], 0x2, 0x04, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) << 1u)])])
foreach([BINARY_USHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl1
m4_define([BINARY_USHL1_DEFINE], [ALBI_D_DEFINE([[binary.ushl1]], 0x2, 0x05, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u))])])
foreach([BINARY_USHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr0
m4_define([BINARY_USHR0_DEFINE], [ALBI_D_DEFINE([[binary.ushr0]], 0x2, 0x06, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_USHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr1
m4_define([BINARY_USHR1_DEFINE], [ALBI_D_DEFINE([[binary.ushr1]], 0x2, 0x07, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_USHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl
m4_define([BINARY_USHL_DEFINE], [ALBI_D_DEFINE([[binary.ushl]], 0x2, 0x08, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | ((*d) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_USHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr
m4_define([BINARY_USHR_DEFINE], [ALBI_D_DEFINE([[binary.ushr]], 0x2, 0x09, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) | ((*d) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_USHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.binv
m4_define([BINARY_BINV_DEFINE], [ALBI_DS_DEFINE([[binary.binv]], 0x2, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~(*s)])])
foreach([BINARY_BINV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1rtl
m4_define([BINARY_B1RTL_DEFINE], [ALBI_DS_DEFINE([[binary.b1rtl]], 0x2, 0x42, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | (((*s) >> m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_B1RTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1rtr
m4_define([BINARY_B1RTR_DEFINE], [ALBI_DS_DEFINE([[binary.b1rtr]], 0x2, 0x43, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*s) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_B1RTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl0
m4_define([BINARY_B1SHL0_DEFINE], [ALBI_DS_DEFINE([[binary.b1shl0]], 0x2, 0x44, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s) << 1u)])])
foreach([BINARY_B1SHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl1
m4_define([BINARY_B1SHL1_DEFINE], [ALBI_DS_DEFINE([[binary.b1shl1]], 0x2, 0x45, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u))])])
foreach([BINARY_B1SHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr0
m4_define([BINARY_B1SHR0_DEFINE], [ALBI_DS_DEFINE([[binary.b1shr0]], 0x2, 0x46, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_B1SHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr1
m4_define([BINARY_B1SHR1_DEFINE], [ALBI_DS_DEFINE([[binary.b1shr1]], 0x2, 0x47, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_B1SHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl
m4_define([BINARY_B1SHL_DEFINE], [ALBI_DS_DEFINE([[binary.b1shl]], 0x2, 0x48, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | ((*s) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_B1SHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr
m4_define([BINARY_B1SHR_DEFINE], [ALBI_DS_DEFINE([[binary.b1shr]], 0x2, 0x49, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) | ((*s) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_B1SHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.bband
m4_define([BINARY_BAND_DEFINE], [ALBI_DS_DEFINE([[binary.bband]], 0x2, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) & (*s))])])
foreach([BINARY_BAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_0010
m4_define([BINARY_B0010_DEFINE], [ALBI_DS_DEFINE([[binary.bb_0010]], 0x2, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) & ~(*s))])])
foreach([BINARY_B0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_0100
m4_define([BINARY_B0100_DEFINE], [ALBI_DS_DEFINE([[binary.bb_0100]], 0x2, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (~(*d) & (*s))])])
foreach([BINARY_B0100_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bbxor
m4_define([BINARY_BXOR_DEFINE], [ALBI_DS_DEFINE([[binary.bbxor]], 0x2, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) ^ (*s))])])
foreach([BINARY_BXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bbor
m4_define([BINARY_BOR_DEFINE], [ALBI_DS_DEFINE([[binary.bbor]], 0x2, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) | (*s))])])
foreach([BINARY_BOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1000
m4_define([BINARY_B1000_DEFINE], [ALBI_DS_DEFINE([[binary.bb_1000]], 0x2, 0x88, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) | (*s))])])
foreach([BINARY_B1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1001
m4_define([BINARY_B1001_DEFINE], [ALBI_DS_DEFINE([[binary.bb_1001]], 0x2, 0x89, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) ^ (*s))])])
foreach([BINARY_B1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1011
m4_define([BINARY_B1011_DEFINE], [ALBI_DS_DEFINE([[binary.bb_1011]], 0x2, 0x8b, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) | ~(*s))])])
foreach([BINARY_B1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1101
m4_define([BINARY_B1101_DEFINE], [ALBI_DS_DEFINE([[binary.bb_1101]], 0x2, 0x8d, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (~(*d) | (*s))])])
foreach([BINARY_B1101_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1110
m4_define([BINARY_B1110_DEFINE], [ALBI_DS_DEFINE([[binary.bb_1110]], 0x2, 0x8e, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) & (*s))])])
foreach([BINARY_B1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.brtl
m4_define([BINARY_BRTL_DEFINE], [ALBI_DS_DEFINE([[binary.brtl]], 0x2, 0x90, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | (((*d) >> (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BRTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.brtr
m4_define([BINARY_BRTR_DEFINE], [ALBI_DS_DEFINE([[binary.brtr]], 0x2, 0x91, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_BRTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl0
m4_define([BINARY_BSHL0_DEFINE], [ALBI_DS_DEFINE([[binary.bshl0]], 0x2, 0x92, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u))])])
foreach([BINARY_BSHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl1
m4_define([BINARY_BSHL1_DEFINE], [ALBI_DS_DEFINE([[binary.bshl1]], 0x2, 0x93, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u)))])])
foreach([BINARY_BSHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr0
m4_define([BINARY_BSHR0_DEFINE], [ALBI_DS_DEFINE([[binary.bshr0]], 0x2, 0x94, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr1
m4_define([BINARY_BSHR1_DEFINE], [ALBI_DS_DEFINE([[binary.bshr1]], 0x2, 0x95, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl
m4_define([BINARY_BSHL_DEFINE], [ALBI_DS_DEFINE([[binary.bshl]], 0x2, 0x96, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ((*d) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr
m4_define([BINARY_BSHR_DEFINE], [ALBI_DS_DEFINE([[binary.bshr]], 0x2, 0x97, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ((*d) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_BSHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.btand
m4_define([BINARY_TAND_DEFINE], [ALBI_DSS_DEFINE([[binary.btand]], 0x2, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) & (*s2))])])
foreach([BINARY_TAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_0010
m4_define([BINARY_T0010_DEFINE], [ALBI_DSS_DEFINE([[binary.bt_0010]], 0x2, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) & ~(*s2))])])
foreach([BINARY_T0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.btxor
m4_define([BINARY_TXOR_DEFINE], [ALBI_DSS_DEFINE([[binary.btxor]], 0x2, 0xc6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) ^ (*s2))])])
foreach([BINARY_TXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.btor
m4_define([BINARY_TOR_DEFINE], [ALBI_DSS_DEFINE([[binary.btor]], 0x2, 0xc7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) | (*s2))])])
foreach([BINARY_TOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1000
m4_define([BINARY_T1000_DEFINE], [ALBI_DSS_DEFINE([[binary.bt_1000]], 0x2, 0xc8, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) | (*s2))])])
foreach([BINARY_T1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1001
m4_define([BINARY_T1001_DEFINE], [ALBI_DSS_DEFINE([[binary.bt_1001]], 0x2, 0xc9, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) ^ (*s2))])])
foreach([BINARY_T1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1011
m4_define([BINARY_T1011_DEFINE], [ALBI_DSS_DEFINE([[binary.bt_1011]], 0x2, 0xcb, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) | ~(*s2))])])
foreach([BINARY_T1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1110
m4_define([BINARY_T1110_DEFINE], [ALBI_DSS_DEFINE([[binary.bt_1110]], 0x2, 0xce, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) & (*s2))])])
foreach([BINARY_T1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.trtl
m4_define([BINARY_TRTL_DEFINE], [ALBI_DSS_DEFINE([[binary.trtl]], 0x2, 0xd0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | (((*s1) >> (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TRTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.trtr
m4_define([BINARY_TRTR_DEFINE], [ALBI_DSS_DEFINE([[binary.trtr]], 0x2, 0xd1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_TRTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl0
m4_define([BINARY_TSHL0_DEFINE], [ALBI_DSS_DEFINE([[binary.tshl0]], 0x2, 0xd2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u))])])
foreach([BINARY_TSHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl1
m4_define([BINARY_TSHL1_DEFINE], [ALBI_DSS_DEFINE([[binary.tshl1]], 0x2, 0xd3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)))])])
foreach([BINARY_TSHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr0
m4_define([BINARY_TSHR0_DEFINE], [ALBI_DSS_DEFINE([[binary.tshr0]], 0x2, 0xd4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TSHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr1
m4_define([BINARY_TSHR1_DEFINE], [ALBI_DSS_DEFINE([[binary.tshr1]], 0x2, 0xd5, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TSHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl
m4_define([BINARY_TSHL_DEFINE], [ALBI_DSS_DEFINE([[binary.tshl]], 0x2, 0xd6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ((*s1) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)))))])])
foreach([BINARY_TSHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr
m4_define([BINARY_TSHR_DEFINE], [ALBI_DSS_DEFINE([[binary.tshr]], 0x2, 0xd7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ((*s1) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_TSHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.unot
m4_define([LOGICAL_UNOT_DEFINE], [ALBI_D_DEFINE([[logical.unot]], 0x3, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = !(*d)])])
foreach([LOGICAL_UNOT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# logical.bnot
m4_define([LOGICAL_BNOT_DEFINE], [ALBI_DS_DEFINE([[logical.bnot]], 0x3, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !(*s)])])
foreach([LOGICAL_BNOT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# logical.lband
m4_define([LOGICAL_BAND_DEFINE], [ALBI_DS_DEFINE([[logical.lband]], 0x3, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*d) && (*s)])])
foreach([LOGICAL_BAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_0010
m4_define([LOGICAL_B0010_DEFINE], [ALBI_DS_DEFINE([[logical.lb_0010]], 0x3, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*d) && !(*s)])])
foreach([LOGICAL_B0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_0100
m4_define([LOGICAL_B0100_DEFINE], [ALBI_DS_DEFINE([[logical.lb_0100]], 0x3, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !(*d) && (*s)])])
foreach([LOGICAL_B0100_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lbxor
m4_define([LOGICAL_BXOR_DEFINE], [ALBI_DS_DEFINE([[logical.lbxor]], 0x3, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) && !(*s)) || (!(*d) && (*s))])])
foreach([LOGICAL_BXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lbor
m4_define([LOGICAL_BOR_DEFINE], [ALBI_DS_DEFINE([[logical.lbor]], 0x3, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*d) || (*s)])])
foreach([LOGICAL_BOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1000
m4_define([LOGICAL_B1000_DEFINE], [ALBI_DS_DEFINE([[logical.lb_1000]], 0x3, 0x88, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !((*d) || (*s))])])
foreach([LOGICAL_B1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1001
m4_define([LOGICAL_B1001_DEFINE], [ALBI_DS_DEFINE([[logical.lb_1001]], 0x3, 0x89, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) && (*s)) || (!(*d) && !(*s))])])
foreach([LOGICAL_B1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1011
m4_define([LOGICAL_B1011_DEFINE], [ALBI_DS_DEFINE([[logical.lb_1011]], 0x3, 0x8b, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*d) || !(*s)])])
foreach([LOGICAL_B1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1101
m4_define([LOGICAL_B1101_DEFINE], [ALBI_DS_DEFINE([[logical.lb_1101]], 0x3, 0x8d, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !(*d) || (*s)])])
foreach([LOGICAL_B1101_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1110
m4_define([LOGICAL_B1110_DEFINE], [ALBI_DS_DEFINE([[logical.lb_1110]], 0x3, 0x8e, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !((*d) && (*s))])])
foreach([LOGICAL_B1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.beq
m4_define([LOGICAL_BEQ_DEFINE], [ALBI_DS_DEFINE([[logical.beq]], 0x3, 0x90, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) == (*s))])])
foreach([LOGICAL_BEQ_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bne
m4_define([LOGICAL_BNE_DEFINE], [ALBI_DS_DEFINE([[logical.bne]], 0x3, 0x91, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) != (*s))])])
foreach([LOGICAL_BNE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.blt
m4_define([LOGICAL_BLT_DEFINE], [ALBI_DS_DEFINE([[logical.blt]], 0x3, 0x92, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) < (*s))])])
foreach([LOGICAL_BLT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.ble
m4_define([LOGICAL_BLE_DEFINE], [ALBI_DS_DEFINE([[logical.ble]], 0x3, 0x93, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) <= (*s))])])
foreach([LOGICAL_BLE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bge
m4_define([LOGICAL_BGE_DEFINE], [ALBI_DS_DEFINE([[logical.bge]], 0x3, 0x94, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) >= (*s))])])
foreach([LOGICAL_BGE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bgt
m4_define([LOGICAL_BGT_DEFINE], [ALBI_DS_DEFINE([[logical.bgt]], 0x3, 0x95, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*d) > (*s))])])
foreach([LOGICAL_BGT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltand
m4_define([LOGICAL_TAND_DEFINE], [ALBI_DSS_DEFINE([[logical.ltand]], 0x3, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) && (*s2)])])
foreach([LOGICAL_TAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_0010
m4_define([LOGICAL_T0010_DEFINE], [ALBI_DSS_DEFINE([[logical.lt_0010]], 0x3, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) && !(*s2)])])
foreach([LOGICAL_T0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltxor
m4_define([LOGICAL_TXOR_DEFINE], [ALBI_DSS_DEFINE([[logical.ltxor]], 0x3, 0xc6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) && !(*s2)) || (!(*s1) && (*s2))])])
foreach([LOGICAL_TXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltor
m4_define([LOGICAL_TOR_DEFINE], [ALBI_DSS_DEFINE([[logical.ltor]], 0x3, 0xc7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) || (*s2)])])
foreach([LOGICAL_TOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1000
m4_define([LOGICAL_T1000_DEFINE], [ALBI_DSS_DEFINE([[logical.lt_1000]], 0x3, 0xc8, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = !((*s1) || (*s2))])])
foreach([LOGICAL_T1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1001
m4_define([LOGICAL_T1001_DEFINE], [ALBI_DSS_DEFINE([[logical.lt_1001]], 0x3, 0xc9, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) && (*s2)) || (!(*s1) && !(*s2))])])
foreach([LOGICAL_T1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1011
m4_define([LOGICAL_T1011_DEFINE], [ALBI_DSS_DEFINE([[logical.lt_1011]], 0x3, 0xcb, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) || !(*s2)])])
foreach([LOGICAL_T1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1110
m4_define([LOGICAL_T1110_DEFINE], [ALBI_DSS_DEFINE([[logical.lt_1110]], 0x3, 0xce, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = !((*s1) && (*s2))])])
foreach([LOGICAL_T1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.teq
m4_define([LOGICAL_TEQ_DEFINE], [ALBI_DSS_DEFINE([[logical.teq]], 0x3, 0xd0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) == (*s2))])])
foreach([LOGICAL_TEQ_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.tne
m4_define([LOGICAL_TNE_DEFINE], [ALBI_DSS_DEFINE([[logical.tne]], 0x3, 0xd1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) != (*s2))])])
foreach([LOGICAL_TNE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.tlt
m4_define([LOGICAL_TLT_DEFINE], [ALBI_DSS_DEFINE([[logical.tlt]], 0x3, 0xd2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) < (*s2))])])
foreach([LOGICAL_TLT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.tle
m4_define([LOGICAL_TLE_DEFINE], [ALBI_DSS_DEFINE([[logical.tle]], 0x3, 0xd3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) <= (*s2))])])
foreach([LOGICAL_TLE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.tge
m4_define([LOGICAL_TGE_DEFINE], [ALBI_DSS_DEFINE([[logical.tge]], 0x3, 0xd4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) >= (*s2))])])
foreach([LOGICAL_TGE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.tgt
m4_define([LOGICAL_TGT_DEFINE], [ALBI_DSS_DEFINE([[logical.tgt]], 0x3, 0xd5, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) > (*s2))])])
foreach([LOGICAL_TGT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))


# (1=name,2=suffixes,3=code,4=b3,5=b4,6=b5,7=args,8=prep,9=precode,10=conds,11=dispatch)
m4_define([INSTR_JUMP_DEFINE], [
    INSTR_DEFINE($1[_imm]$2,
        CODE(0x04, $3, OLB_CODE_imm, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        [if (1) {
            m4_ifelse([$8], [NO_PREPARATION], [], [$8;
            ])
            if (SMVM_PREPARE_ARG_AS(1,int64) < 0) {
                uint64_t delta_minus_one = (uint64_t) -(SMVM_PREPARE_ARG_AS(1,int64) + 1);
                SMVM_PREPARE_CHECK_OR_ERROR(
                    delta_minus_one < SMVM_PREPARE_CURRENT_I,
                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                SMVM_PREPARE_CHECK_OR_ERROR(
                    SMVM_PREPARE_IS_INSTR((uintptr_t) (SMVM_PREPARE_CURRENT_I - 1u - delta_minus_one)),
                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            } else {
                uint64_t delta = (uint64_t) SMVM_PREPARE_ARG_AS(1,int64);
                SMVM_PREPARE_CHECK_OR_ERROR(
                    delta < (size_t) (SMVM_PREPARE_CODESIZE - SMVM_PREPARE_CURRENT_I - 1u),
                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
                SMVM_PREPARE_CHECK_OR_ERROR(
                    delta == 0u || SMVM_PREPARE_IS_INSTR((uintptr_t) (SMVM_PREPARE_CURRENT_I + delta)),
                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);
            }
        }],
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$9], [NO_JUMP_PRECODE], [], [
        $9;])m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        if ($10) {])
            SMVM_MI_JUMP_REL(SMVM_MI_ARG_P(1));m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        } else (void) 0])]),
        $11, PREPARE_FINISH)
    INSTR_DEFINE($1[_reg]$2,
        CODE(0x04, $3, OLB_CODE_reg, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$9], [NO_JUMP_PRECODE], [], [
        $9;])m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        if ($10) {])
            const SMVM_CodeBlock * t;
            SMVM_MI_GET_reg(t, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_CHECK_JUMP_REL(SMVM_MI_BLOCK_AS(t,int64));m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        } else (void) 0])]),
        $11, PREPARE_FINISH)
    INSTR_DEFINE($1[_stack]$2,
        CODE(0x04, $3, OLB_CODE_stack, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([m4_ifelse([$9], [NO_JUMP_PRECODE], [], [
        $9;])m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        if ($10) {])
            const SMVM_CodeBlock * t;
            SMVM_MI_GET_stack(t, SMVM_MI_ARG_AS(1, sizet));
            SMVM_MI_CHECK_JUMP_REL(SMVM_MI_BLOCK_AS(t,int64));m4_ifelse([$10], [NO_JUMP_CONDITION], [], [
        } else (void) 0])]),
        $11, PREPARE_FINISH)
])

INSTR_JUMP_DEFINE([jump.jmp], [], 0x00, 0x00, 0x00, 0x00, 1, NO_PREPARATION, NO_JUMP_PRECODE, NO_JUMP_CONDITION, NO_DISPATCH)

# (name, code, cond, dtb, olb)
m4_define([INSTR_JUMP_COND_1_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump.$1, _$4_$5,
        $2, DTB_CODE_$4, OLB_CODE_$5, 0x00, 2,
        NO_PREPARATION,
        [
        m4_ifelse($1, [dnjz],, $1, [dnjnz],, [const]) SMVM_CodeBlock * c;
        SMVM_MI_GET_[]$5(c, SMVM_MI_ARG_AS(2, sizet))],
        $3, DO_DISPATCH)])

# (name, code, cond, dtb, olb, olb2)
m4_define([INSTR_JUMP_COND_2_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump.$1, _$4_$5_$6,
        $2, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, 3,
        m4_ifelse([$5], [$7], [SMVM_PREPARE_CHECK_OR_ERROR(SMVM_PREPARE_ARG_AS(1,uint64) != SMVM_PREPARE_ARG_AS(2,uint64),
                                    SMVM_PREPARE_ERROR_INVALID_ARGUMENTS);], [NO_PREPARATION]),
        [
        const DTB_TYPE_$4 * c1;
        m4_ifelse([$5], [imm], [c1 = SMVM_MI_ARG_AS_P(2, $4)],
                    [SMVM_MI_GET_T_$5(c1, $4, SMVM_MI_ARG_AS(2, sizet))]);
        const DTB_TYPE_$4 * c2;
        SMVM_MI_GET_T_$6(c2, $4, SMVM_MI_ARG_AS(3, sizet))],
        $3, DO_DISPATCH)])

m4_define([INSTR_JUMP_JZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jz],0x01,(SMVM_MI_BLOCK_AS(c,_ARG1$1) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jnz],0x02,(SMVM_MI_BLOCK_AS(c,_ARG1$1) != 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjz],0x03,(--(SMVM_MI_BLOCK_AS(c,_ARG1$1)) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjnz],0x04,(--(SMVM_MI_BLOCK_AS(c,_ARG1$1)) != 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JEQ_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jeq],0x05,((*c1) == (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JEQ_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jne],0x06,((*c1) != (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JNE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jge],0x07,((*c1) >= (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JGE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jgt],0x08,((*c1) > (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JGT_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jle],0x09,((*c1) <= (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JLE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jlt],0x0a,((*c1) < (*c2)),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JLT_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))
