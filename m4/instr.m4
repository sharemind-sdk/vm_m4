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
m4_define([INSTR_DEFINE], [m4_ifelse(m4_eval(m4_len([$1])[ >= 64]),[1],[m4_errprint([Instruction name "$1" (length ]m4_len([$1])[) exceeds maximum length limit of 63 characters!])m4_m4exit(1)])
                        m4_define(m4_format([[INSTR_%s]], [$1]), [$1, $2, $3, $4, $5, $6, $7, $8, ]INSTR_COUNT)
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
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SHAREMIND_MI_NOP]), DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.trap],
    CODE(0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SHAREMIND_MI_TRAP]), DO_DISPATCH, PREPARE_FINISH)

m4_define([FPU_GETSTATE_DEFINE], [
    INSTR_DEFINE([common.fpu.getstate_$1],
        CODE(0x00, 0x05, 0x00, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * d;
            SHAREMIND_MI_GET_$1(d, SHAREMIND_MI_ARG_AS(1, sizet));
            SHAREMIND_MI_BLOCK_AS(d,uint64) = SHAREMIND_MI_FPU_STATE]), DO_DISPATCH, PREPARE_FINISH)])
FPU_GETSTATE_DEFINE([reg])
FPU_GETSTATE_DEFINE([stack])

m4_define([FPU_SETSTATE_DEFINE], [
    INSTR_DEFINE([common.fpu.setstate_$1],
        CODE(0x00, 0x05, 0x01, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * s;
            m4_ifelse($1, [imm],
                      [s = SHAREMIND_MI_ARG_P(1)],
                      [SHAREMIND_MI_GET_CONST_$1(s, SHAREMIND_MI_ARG_AS(1, sizet))]);
            SHAREMIND_MI_FPU_STATE_SET(SHAREMIND_MI_BLOCK_AS(s,uint64))]), DO_DISPATCH, PREPARE_FINISH)])
FPU_SETSTATE_DEFINE([imm])
FPU_SETSTATE_DEFINE([reg])
FPU_SETSTATE_DEFINE([stack])

# common.mov (imm, reg, stack) >> (reg, stack)
# (1=olbsrc,2=olbdest)
m4_define([_MOV_REGS_TO_REGS_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2],
        CODE(0x00, 0x01, OLB_CODE_$1, 0x00, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * s;
            m4_ifelse($1, [imm],
                      [s = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(s, SHAREMIND_MI_ARG_AS(1, sizet));])
            SharemindCodeBlock * d;
            SHAREMIND_MI_GET_$2(d, SHAREMIND_MI_ARG_AS(2, sizet));
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
        PREPARATION([
            m4_ifelse($1, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($4, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) > 0u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])]),
        NO_IMPL_SUFFIX, IMPL([
            const SharemindCodeBlock * src;
            SharemindMemorySlot * restrict srcSlot;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            SharemindCodeBlock * dest;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm],
                      [src = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(src, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(src,uint64), srcSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_READ(srcSlot), SHAREMIND_VM_PROCESS_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_GET_$3(dest, SHAREMIND_MI_ARG_AS(3, sizet));
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(numBytes, SHAREMIND_MI_ARG_AS(4,sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(numBytes,uint64) <= 8u, SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(srcSlot->size, SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            SHAREMIND_MI_MEMCPY(&(SHAREMIND_MI_BLOCK_AS(dest,uint64)), ((const uint8_t *) srcSlot->pData) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_REGS_DEFINE], [_MOV_MEM_TO_REGS_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_MEM_TO_REGS_DEFINE], (product(([imm], [reg], [stack]), ([imm], [reg], [stack]), ([reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (imm, reg, stack) >> (mem)
# (1=olbsrc,2=olbdest_part,3=olbdestoffset,4=olbnbytes)
m4_define([_MOV_REGS_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_$1_mem_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, 0x00, OLB_CODE_mem_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00),
        ARGS(4),
        PREPARATION([
            m4_ifelse($2, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(2,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(2,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($4, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) > 0u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])]),
        NO_IMPL_SUFFIX, IMPL([
            const SharemindCodeBlock * m4_ifelse($1, [imm], [restrict]) src;
            const SharemindCodeBlock * dest;
            const SharemindMemorySlot * restrict destSlot;
            const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$1(src, SHAREMIND_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm],
                      [dest = SHAREMIND_MI_ARG_P(2);],
                      [SHAREMIND_MI_GET_CONST_$2(dest, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(dest,uint64), destSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_WRITE(destSlot), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$3(destOffset, SHAREMIND_MI_ARG_AS(3, sizet));])
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(numBytes, SHAREMIND_MI_ARG_AS(4,sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(numBytes,uint64) <= 8u, SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);])
            m4_ifelse($3, [imm], [destOffset = SHAREMIND_MI_ARG_P(3);])
            m4_ifelse($4, [imm], [numBytes = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(destSlot->size, SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_ifelse($1, [imm], [src = SHAREMIND_MI_ARG_P(1);])
            SHAREMIND_MI_MEMCPY(((uint8_t *) destSlot->pData) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64), &(SHAREMIND_MI_BLOCK_AS(src,uint64)), SHAREMIND_MI_BLOCK_AS(numBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_REGS_TO_MEM_DEFINE], [_MOV_REGS_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_REGS_TO_MEM_DEFINE], (product(([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (mem) >> (mem)
# (1=olbsrc_part,2=olbsrcoffset,3=olbdest_part,4=olbdestoffset,5=olbnbytes)
m4_define([_MOV_MEM_TO_MEM_DEFINE], [
    INSTR_DEFINE([common.mov_mem_$1_$2_mem_$3_$4_$5],
        CODE(0x00, 0x01, OLB_CODE_mem_$1, OLB_CODE_$2, OLB_CODE_mem_$3, OLB_CODE_$4, OLB_CODE_$5, 0x00),
        ARGS(5),
        PREPARATION([
            m4_ifelse($1, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($3, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($5, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(5,uint64) > 0u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * src;
            const SharemindMemorySlot * srcSlot;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SharemindCodeBlock * dest;
            const SharemindMemorySlot * destSlot;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($5, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm],
                      [src = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(src, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(src,uint64), srcSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_READ(srcSlot), SHAREMIND_VM_PROCESS_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($3, [imm],
                      [dest = SHAREMIND_MI_ARG_P(3);],
                      [SHAREMIND_MI_GET_CONST_$3(dest, SHAREMIND_MI_ARG_AS(3, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(dest,uint64), destSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_WRITE(destSlot), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(destOffset, SHAREMIND_MI_ARG_AS(4, sizet));])
            m4_ifelse($5, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$5(numBytes, SHAREMIND_MI_ARG_AS(5, sizet));])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($5, [imm], [numBytes = SHAREMIND_MI_ARG_P(5);])
            SHAREMIND_MI_TRY_MEMRANGE(srcSlot->size, SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            m4_ifelse($4, [imm], [destOffset = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(destSlot->size, SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [((uint8_t *) destSlot->pData) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64),
                                    ((const uint8_t *) srcSlot->pData) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            if (srcSlot != destSlot) {
                SHAREMIND_MI_MEMCPY(CPY_ARGS);
            } else {
                SHAREMIND_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_MEM_DEFINE], [_MOV_MEM_TO_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, _ARG5$1)])
foreach([MOV_MEM_TO_MEM_DEFINE], (product(([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.mov (ref, cref) >> (reg, stack)
# (1=olbsrc,2=olbsrcoffset,3=olbdest,4=olbnbytes)
m4_define([_MOV_REF_TO_REGS_DEFINE], [
    INSTR_DEFINE([common.mov_$1_$2_$3_$4],
        CODE(0x00, 0x01, OLB_CODE_$1, OLB_CODE_$2, OLB_CODE_$3, 0x00, OLB_CODE_$4, 0x00),
        ARGS(4),
        m4_ifelse($4, [imm],
                  [PREPARATION([
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) > 0u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const Sharemind[]m4_ifelse($1, [cref], [C])[]Reference * restrict srcRef;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            SharemindCodeBlock * dest;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SHAREMIND_MI_GET_$1(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_READ(srcRef), SHAREMIND_VM_PROCESS_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_GET_$3(dest, SHAREMIND_MI_ARG_AS(3, sizet));
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(numBytes, SHAREMIND_MI_ARG_AS(4,sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(numBytes,uint64) <= 8u, SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(srcRef), SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            m4_pushdef([CPY_ARGS], [&(SHAREMIND_MI_BLOCK_AS(dest,uint64)),
                                    SHAREMIND_MI_REFERENCE_GET_CONST_PTR(srcRef) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            m4_ifelse($3, [stack],
                      [SHAREMIND_MI_MEMCPY(CPY_ARGS);],
                      [if (SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(srcRef)) {
                           SHAREMIND_MI_MEMCPY(CPY_ARGS);
                       } else {
                           SHAREMIND_MI_MEMMOVE(CPY_ARGS);
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
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) > 0u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(4,uint64) <= 8u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX, IMPL([
            const SharemindCodeBlock * m4_ifelse($1, [imm], [restrict]) src;
            const SharemindReference * restrict destRef;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$1(src, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_GET_ref(destRef, SHAREMIND_MI_ARG_AS(2, sizet));
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_WRITE(destRef), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(destOffset, SHAREMIND_MI_ARG_AS(3, sizet));])
            m4_ifelse($3, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$3(numBytes, SHAREMIND_MI_ARG_AS(4,sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(numBytes,uint64) <= 8u, SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);])
            m4_ifelse($2, [imm], [destOffset = SHAREMIND_MI_ARG_P(3);])
            m4_ifelse($3, [imm], [numBytes = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(destRef), SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_ifelse($1, [imm], [src = SHAREMIND_MI_ARG_P(1);])
            m4_pushdef([CPY_ARGS], [SHAREMIND_MI_REFERENCE_GET_PTR(destRef) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64),
                                    &(SHAREMIND_MI_BLOCK_AS(src,uint64)),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            m4_ifelse($1, [reg],
                      [if (SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                           SHAREMIND_MI_MEMCPY(CPY_ARGS);
                       } else {
                           SHAREMIND_MI_MEMMOVE(CPY_ARGS);
                       }],
                      [SHAREMIND_MI_MEMCPY(CPY_ARGS)])m4_popdef([CPY_ARGS])]),
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
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(5,uint64) > 0u,
                                                  SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)])],
                  [NO_PREPARATION]),
        NO_IMPL_SUFFIX,
        IMPL([
            const Sharemind[]m4_ifelse($1, [cref], [C])Reference * srcRef;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SharemindReference * destRef;
            const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            SHAREMIND_MI_GET_$1(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_READ(srcRef), SHAREMIND_VM_PROCESS_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_GET_ref(destRef, SHAREMIND_MI_ARG_AS(3, sizet));
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_WRITE(destRef), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$3(destOffset, SHAREMIND_MI_ARG_AS(4, sizet));])
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(numBytes, SHAREMIND_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SHAREMIND_MI_ARG_P(5);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(srcRef), SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            m4_ifelse($3, [imm], [destOffset = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(destRef), SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [SHAREMIND_MI_REFERENCE_GET_PTR(destRef) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64),
                                    SHAREMIND_MI_REFERENCE_GET_CONST_PTR(srcRef) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            if (SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(srcRef) != SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                SHAREMIND_MI_MEMCPY(CPY_ARGS);
            } else {
                SHAREMIND_MI_MEMMOVE(CPY_ARGS);
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
        PREPARATION([
            m4_ifelse($3, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($5, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(5,uint64) > 0u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])]),
        NO_IMPL_SUFFIX,
        IMPL([
            const Sharemind[]m4_ifelse($1, [cref], [C])Reference * restrict srcRef;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SharemindCodeBlock * restrict dest;
            const SharemindMemorySlot * restrict destSlot;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($5, [imm], [restrict]) numBytes;
            SHAREMIND_MI_GET_$1(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($1, [ref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_READ(srcRef), SHAREMIND_VM_PROCESS_READ_DENIED);])
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($3, [imm],
                      [dest = SHAREMIND_MI_ARG_P(3);],
                      [SHAREMIND_MI_GET_CONST_$3(dest, SHAREMIND_MI_ARG_AS(3, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(dest,uint64), destSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_WRITE(destSlot), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(destOffset, SHAREMIND_MI_ARG_AS(4, sizet));])
            m4_ifelse($5, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$5(numBytes, SHAREMIND_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($5, [imm], [numBytes = SHAREMIND_MI_ARG_P(5);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(srcRef), SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            m4_ifelse($4, [imm], [destOffset = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(destSlot->size, SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [((uint8_t *) destSlot->pData) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64),
                                    SHAREMIND_MI_REFERENCE_GET_CONST_PTR(srcRef) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            if (SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(srcRef) != destSlot) {
                SHAREMIND_MI_MEMCPY(CPY_ARGS);
            } else {
                SHAREMIND_MI_MEMMOVE(CPY_ARGS);
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
        PREPARATION([
            m4_ifelse($1, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) >= 1u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                       SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) <= 3u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])
            m4_ifelse($4, [imm],
                      [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(5,uint64) > 0u,
                                                        SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)])]),
        NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * restrict src;
            const SharemindMemorySlot * restrict srcSlot;
            const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) srcOffset;
            const SharemindReference * restrict destRef;
            const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) destOffset;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) numBytes;
            m4_ifelse($1, [imm],
                      [src = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(src, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(src,uint64), srcSlot);
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_READ(srcSlot), SHAREMIND_VM_PROCESS_READ_DENIED);
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$2(srcOffset, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_GET_ref(destRef, SHAREMIND_MI_ARG_AS(3, sizet));
            SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_WRITE(destRef), SHAREMIND_VM_PROCESS_WRITE_DENIED);
            m4_ifelse($3, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$3(destOffset, SHAREMIND_MI_ARG_AS(4, sizet));])
            m4_ifelse($4, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$4(numBytes, SHAREMIND_MI_ARG_AS(5,sizet));])
            m4_ifelse($2, [imm], [srcOffset = SHAREMIND_MI_ARG_P(2);])
            m4_ifelse($4, [imm], [numBytes = SHAREMIND_MI_ARG_P(5);])
            SHAREMIND_MI_TRY_MEMRANGE(srcSlot->size, SHAREMIND_MI_BLOCK_AS(srcOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_READ);
            m4_ifelse($3, [imm], [destOffset = SHAREMIND_MI_ARG_P(4);])
            SHAREMIND_MI_TRY_MEMRANGE(SHAREMIND_MI_REFERENCE_GET_SIZE(destRef), SHAREMIND_MI_BLOCK_AS(destOffset,uint64), SHAREMIND_MI_BLOCK_AS(numBytes,uint64), SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_WRITE);
            m4_pushdef([CPY_ARGS], [SHAREMIND_MI_REFERENCE_GET_PTR(destRef) + SHAREMIND_MI_BLOCK_AS(destOffset,uint64),
                                    ((const uint8_t *) srcSlot->pData) + SHAREMIND_MI_BLOCK_AS(srcOffset,uint64),
                                    SHAREMIND_MI_BLOCK_AS(numBytes,uint64)])
            if (srcSlot != SHAREMIND_MI_REFERENCE_GET_MEMORY_PTR(destRef)) {
                SHAREMIND_MI_MEMCPY(CPY_ARGS);
            } else {
                SHAREMIND_MI_MEMMOVE(CPY_ARGS);
            }m4_popdef([CPY_ARGS])]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MOV_MEM_TO_REF_DEFINE], [_MOV_MEM_TO_REF_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([MOV_MEM_TO_REF_DEFINE], (product(([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

m4_define([CHECK_CALL_TARGET], [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_IS_INSTR($1), SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);])

# common.proc.call
m4_define([_CALL_DEFINE], [
    INSTR_DEFINE([common.proc.call_$1_$2],
        CODE(0x00, 0x02, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(m4_ifelse($2, [imm], 1, 2)),
        m4_ifelse($1, [imm], CHECK_CALL_TARGET(SHAREMIND_PREPARE_ARG_AS(1,sizet)), NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * m4_ifelse($1, [imm], [restrict]) addr;
            m4_ifelse($2, [imm], [], [SharemindCodeBlock * rv;])
            m4_ifelse($1, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$1(addr, SHAREMIND_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_$2(rv, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($1, [imm], [addr = SHAREMIND_MI_ARG_P(1);])
            m4_ifelse($1, [imm],
                [SHAREMIND_MI_CALL(SHAREMIND_MI_BLOCK_AS(addr, sizet),m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))],
                [SHAREMIND_MI_CHECK_CALL(addr,m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))])]),
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
                  [SHAREMIND_PREPARE_SYSCALL(1);],
                  NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * m4_ifelse($1, [imm], [restrict]) addr;
            m4_ifelse($2, [imm], [], [SharemindCodeBlock * rv;])
            m4_ifelse($1, [imm], [],
                      [SHAREMIND_MI_GET_CONST_$1(addr, SHAREMIND_MI_ARG_AS(1, sizet));])
            m4_ifelse($2, [imm], [],
                      [SHAREMIND_MI_GET_$2(rv, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($1, [imm], [addr = SHAREMIND_MI_ARG_P(1);])
            m4_ifelse($1, [imm],
                [SHAREMIND_MI_SYSCALL(SHAREMIND_MI_BLOCK_AS(addr, cp),m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))],
                [SHAREMIND_MI_CHECK_SYSCALL(addr,m4_ifelse($2, [imm], [NULL], [rv]), m4_ifelse($2, [imm], [1], [2]))])]),
        DO_DISPATCH, PREPARE_FINISH)
])
m4_define([SYSCALL_DEFINE], [_SYSCALL_DEFINE(_ARG1$1, _ARG2$1)])
foreach([SYSCALL_DEFINE], (product(([[imm]], [[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

# common.proc.return
m4_define([RETURN_DEFINE], [
    INSTR_DEFINE([common.proc.return_$1],
        CODE(0x00, 0x02, 0x03, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * restrict v;
            m4_ifelse($1, [imm],
                      [v = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(v, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_RETURN(*v);]),
        NO_DISPATCH, PREPARE_FINISH)])
RETURN_DEFINE([imm])
RETURN_DEFINE([reg])
RETURN_DEFINE([stack])

# common.proc.push
m4_define([PUSH_DEFINE], [
    INSTR_DEFINE([common.proc.push_$1],
        CODE(0x00, 0x02, 0x04, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * restrict v;
            m4_ifelse($1, [imm],
                      [v = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(v, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_PUSH(*v);]),
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
            m4_ifelse($1, [cref], [const]) SharemindCodeBlock * restrict b;
            m4_ifelse($2, [imm],
                      [b = SHAREMIND_MI_ARG_P(1);],
                      $1, [cref],
                      [SHAREMIND_MI_GET_CONST_$2(b, SHAREMIND_MI_ARG_AS(1, sizet));],
                      [SHAREMIND_MI_GET_$2(b, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_PUSHREF_BLOCK_$1(b)]),
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
        const Sharemind[]m4_ifelse($2, [cref], [C])Reference * restrict srcRef;
        SHAREMIND_MI_GET_$2(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));
        m4_ifelse($1, [cref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_READ(srcRef), SHAREMIND_VM_PROCESS_INVALID_ARGUMENT);])
        SHAREMIND_MI_PUSHREF_REF_$1(srcRef)]),
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
        const SharemindCodeBlock * restrict srcPtr;
        SharemindMemorySlot * srcSlot;
        SHAREMIND_MI_GET_CONST_$2(srcPtr, SHAREMIND_MI_ARG_AS(1, sizet));
        SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(srcPtr,uint64), srcSlot);
        m4_ifelse($1, [cref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_READ(srcSlot), SHAREMIND_VM_PROCESS_INVALID_ARGUMENT);])
        SHAREMIND_MI_PUSHREF_MEM_$1(srcSlot)]),
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
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(2,uint64) < 7u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) <= 8u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(2,uint64) + SHAREMIND_PREPARE_ARG_AS(3,uint64) <= 8u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  $3, [imm],
                  PREPARATION([
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(2,uint64) < 7u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  $4, [imm],
                  PREPARATION([
                      SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(3,uint64) <= 8u,
                                                       SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS)]),
                  NO_PREPARATION),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [cref], [const]) SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) b;
            const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) offset;
            const SharemindCodeBlock * m4_ifelse($4, [imm], [restrict]) nBytes;
            m4_ifelse($2, [imm],
                      [b = SHAREMIND_MI_ARG_P(1);],
                      $1, [cref],
                      [SHAREMIND_MI_GET_CONST_$2(b, SHAREMIND_MI_ARG_AS(1, sizet));],
                      [SHAREMIND_MI_GET_$2(b, SHAREMIND_MI_ARG_AS(1, sizet));])
            m4_ifelse($3, [imm],
                      [offset = SHAREMIND_MI_ARG_P(2);],
                      [SHAREMIND_MI_GET_CONST_$3(offset, SHAREMIND_MI_ARG_AS(2, sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset, uint64) < 7u,
                                               SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_INDEX);])
            m4_ifelse($4, [imm],
                      [nBytes = SHAREMIND_MI_ARG_P(3);],
                      [SHAREMIND_MI_GET_CONST_$4(nBytes, SHAREMIND_MI_ARG_AS(3, sizet));
                       SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(nBytes, uint64) <= 8u,
                                               SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);])
            m4_ifelse($3_$4, [imm_imm], [],
                      [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset, uint64) + SHAREMIND_MI_BLOCK_AS(nBytes, uint64) <= 8u,
                                               SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);])
            SHAREMIND_MI_PUSHREFPART_BLOCK_$1(b,SHAREMIND_MI_BLOCK_AS(offset,uint64),SHAREMIND_MI_BLOCK_AS(nBytes,uint64))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREFPART_BLOCK_DEFINE], [_PUSHREFPART_BLOCK_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([PUSHREFPART_BLOCK_DEFINE], (product(([cref], [ref]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))
foreach([PUSHREFPART_BLOCK_DEFINE], (product(([cref]), ([imm]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.proc.pushrefpart (ref) + common.proc.pushcrefpart (ref, cref)
# (1=ref_or_cref,2=olbsrc,3=olbsrcoffset,4=olblength)
m4_define([_PUSHREFPART_REF_DEFINE], [
    INSTR_DEFINE([common.proc.push$1part_$2_$3_$4],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x06], [0x08]), OLB_CODE_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
    ARGS(3),
    NO_PREPARATION,
    NO_IMPL_SUFFIX,
    IMPL([
        const Sharemind[]m4_ifelse($2, [cref], [C])Reference * restrict srcRef;
        const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) offset;
        const SharemindCodeBlock * m4_ifelse($3, [imm], [restrict]) nBytes;
        SHAREMIND_MI_GET_$2(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));
        m4_ifelse($1, [cref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_REF_CAN_READ(srcRef), SHAREMIND_VM_PROCESS_INVALID_ARGUMENT);])
        m4_ifelse($3, [imm],
                  [offset = SHAREMIND_MI_ARG_P(2);],
                  [SHAREMIND_MI_GET_CONST_$3(offset, SHAREMIND_MI_ARG_AS(2, sizet));])
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset,sizet) < srcRef->size,
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_INDEX);
        m4_ifelse($4, [imm],
                  [nBytes = SHAREMIND_MI_ARG_P(3);],
                  [SHAREMIND_MI_GET_CONST_$4(nBytes, SHAREMIND_MI_ARG_AS(3, sizet));])
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(nBytes,uint64) <= srcRef->size,
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset,uint64) <= srcRef->size - SHAREMIND_MI_BLOCK_AS(nBytes,uint64),
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SHAREMIND_MI_PUSHREFPART_REF_$1(srcRef, SHAREMIND_MI_BLOCK_AS(offset,uint64), SHAREMIND_MI_BLOCK_AS(nBytes,uint64))]),
    DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREFPART_REF_DEFINE], [_PUSHREFPART_REF_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([PUSHREFPART_REF_DEFINE], (product(([cref], [ref]), ([ref]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))
foreach([PUSHREFPART_REF_DEFINE], (product(([cref]), ([cref]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# common.proc.pushrefpart (mem) + common.proc.pushcrefpart (mem)
# (1=ref_or_cref,2=olbsrc_part,3=olbsrcoffset,4=olblength)
m4_define([_PUSHREFPART_MEM_DEFINE], [
    INSTR_DEFINE([common.proc.push$1part_mem_$2_$3_$4],
    CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x06], [0x08]), OLB_CODE_mem_$2, OLB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
    ARGS(3),
    NO_PREPARATION,
    NO_IMPL_SUFFIX,
    IMPL([
        const SharemindCodeBlock * srcPtr;
        const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) offset;
        const SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) nBytes;
        SharemindMemorySlot * srcSlot;
        SHAREMIND_MI_GET_CONST_$2(srcPtr, SHAREMIND_MI_ARG_AS(1, sizet));
        SHAREMIND_MI_MEM_GET_SLOT_OR_EXCEPT(SHAREMIND_MI_BLOCK_AS(srcPtr,uint64), srcSlot);
        m4_ifelse($1, [cref], [SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_MEM_CAN_READ(srcSlot), SHAREMIND_VM_PROCESS_INVALID_ARGUMENT);])
        m4_ifelse($3, [imm],
                  [offset = SHAREMIND_MI_ARG_P(2);],
                  [SHAREMIND_MI_GET_CONST_$3(offset, SHAREMIND_MI_ARG_AS(2, sizet));])
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset,sizet) < srcSlot->size,
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_INDEX);
        m4_ifelse($4, [imm],
                  [nBytes = SHAREMIND_MI_ARG_P(3);],
                  [SHAREMIND_MI_GET_CONST_$4(nBytes, SHAREMIND_MI_ARG_AS(3, sizet));])
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(nBytes,uint64) <= srcSlot->size,
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SHAREMIND_MI_TRY_EXCEPT(SHAREMIND_MI_BLOCK_AS(offset,uint64) <= srcSlot->size - SHAREMIND_MI_BLOCK_AS(nBytes,uint64),
                                SHAREMIND_VM_PROCESS_OUT_OF_BOUNDS_REFERENCE_SIZE);
        SHAREMIND_MI_PUSHREFPART_MEM_$1(srcSlot, SHAREMIND_MI_BLOCK_AS(offset,uint64), SHAREMIND_MI_BLOCK_AS(nBytes,uint64))]),
    DO_DISPATCH, PREPARE_FINISH)])
m4_define([PUSHREFPART_MEM_DEFINE], [_PUSHREFPART_MEM_DEFINE(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([PUSHREFPART_MEM_DEFINE], (product(([cref], [ref]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

INSTR_DEFINE([common.proc.clearstack],
    CODE(0x00, 0x02, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00),
    NO_ARGS, NO_PREPARATION, NO_IMPL_SUFFIX,
    IMPL([
        if (likely(SHAREMIND_MI_HAS_STACK)) {
            SHAREMIND_MI_CLEAR_STACK;
        }]),
    DO_DISPATCH, PREPARE_FINISH)

INSTR_DEFINE([common.proc.resizestack],
    CODE(0x00, 0x02, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX, IMPL([SHAREMIND_MI_RESIZE_STACK(SHAREMIND_MI_ARG_AS(1, uint64))]), DO_DISPATCH, PREPARE_FINISH)

# common.proc.get(c)refsize
# (1=ref/cref,2=olbsrc,3=olbnbytes)
m4_define([_PROC_GETREFSIZE], [
    INSTR_DEFINE([common.proc.get$1size_$2_$3],
        CODE(0x00, 0x02, m4_ifelse($1, [ref], [0x0c], [0x0d]), OLB_CODE_$2, OLB_CODE_$3, 0x00, 0x00, 0x00),
        ARGS(2),
        NO_PREPARATION,
        NO_IMPL_SUFFIX, IMPL([
            const Sharemind[]m4_ifelse($1, [cref], [C])[]Reference * restrict srcRef;
            m4_ifelse($2, [imm], [], [const SharemindCodeBlock * src;])
            SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) dest;
            m4_ifelse($2, [imm],
                      [SHAREMIND_MI_GET_$1(srcRef, SHAREMIND_MI_ARG_AS(1, sizet));],
                      [SHAREMIND_MI_GET_CONST_$2(src, SHAREMIND_MI_ARG_AS(1,sizet));
                       SHAREMIND_MI_GET_$1(srcRef, SHAREMIND_MI_BLOCK_AS(src, sizet));])
            SHAREMIND_MI_GET_$3(dest, SHAREMIND_MI_ARG_AS(2, sizet));
            SHAREMIND_MI_BLOCK_AS(dest,sizet) = srcRef->size]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([PROC_GETREFSIZE_DEFINE], [_PROC_GETREFSIZE(_ARG1$1, _ARG2$1, _ARG3$1)])
foreach([PROC_GETREFSIZE_DEFINE], (product(([cref], [ref]), ([imm], [reg], [stack]), ([reg], [stack]))))

# common.mem.alloc
m4_define([_MEM_ALLOC_DEFINE], [
    INSTR_DEFINE([common.mem.alloc_$1_$2],
        CODE(0x00, 0x03, 0x00, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * m4_ifelse($2, [imm], [restrict]) ptrDest;
            SHAREMIND_MI_GET_$1(ptrDest, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($2, [imm],,
                [const SharemindCodeBlock * sizeReg;
                 SHAREMIND_MI_GET_CONST_$2(sizeReg, SHAREMIND_MI_ARG_AS(2, sizet));])
            SHAREMIND_MI_MEM_ALLOC(ptrDest,m4_ifelse($2, [imm], [SHAREMIND_MI_ARG_P(2)], [sizeReg]))]),
        DO_DISPATCH, PREPARE_FINISH)])
m4_define([MEM_ALLOC_DEFINE], [_MEM_ALLOC_DEFINE(_ARG1$1, _ARG2$1)])
foreach([MEM_ALLOC_DEFINE], (product(([[reg]], [[stack]]),([[imm]], [[reg]], [[stack]]))))

# common.mem.free
m4_define([MEM_FREE_DEFINE], [
    INSTR_DEFINE([common.mem.free_$1],
        CODE(0x00, 0x03, 0x01, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * restrict ptr;
            SHAREMIND_MI_GET_CONST_$1(ptr, SHAREMIND_MI_ARG_AS(1, sizet));
            SHAREMIND_MI_MEM_FREE(ptr)]),
        DO_DISPATCH, PREPARE_FINISH)])
MEM_FREE_DEFINE([reg])
MEM_FREE_DEFINE([stack])

# common.mem.getmemsize
m4_define([MEM_GETMEMSIZE_DEFINE], [
    INSTR_DEFINE([common.mem.getmemsize_$1_$2],
        CODE(0x00, 0x03, 0x02, OLB_CODE_$1, OLB_CODE_$2, 0x00, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse($1, [imm],
                      [const SharemindCodeBlock * const ptr = SHAREMIND_MI_ARG_P(1);],
                      [const SharemindCodeBlock * ptr;
                       SHAREMIND_MI_GET_CONST_$1(ptr, SHAREMIND_MI_ARG_AS(1, sizet));])
            SharemindCodeBlock * sizedest;
            SHAREMIND_MI_GET_$2(sizedest, SHAREMIND_MI_ARG_AS(2, sizet));
            SHAREMIND_MI_MEM_GET_SIZE(ptr,sizedest);]),
        DO_DISPATCH, PREPARE_FINISH
    )])
MEM_GETMEMSIZE_DEFINE([imm],[reg])
MEM_GETMEMSIZE_DEFINE([imm],[stack])
MEM_GETMEMSIZE_DEFINE([reg],[reg])
MEM_GETMEMSIZE_DEFINE([reg],[stack])
MEM_GETMEMSIZE_DEFINE([stack],[reg])
MEM_GETMEMSIZE_DEFINE([stack],[stack])

# common.convert
m4_define([_CONVERT_DEFINE], [m4_ifelse($1, $3, [], [
    INSTR_DEFINE([common.convert_$1_$2_$3_$4],
        CODE(0x00, 0x04, DTB_CODE_$1, OLB_CODE_$2, DTB_CODE_$3, OLB_CODE_$4, 0x00, 0x00),
        ARGS(2), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * s;
            SHAREMIND_MI_GET_CONST_$2(s, SHAREMIND_MI_ARG_AS(1, sizet));
            SharemindCodeBlock * d;
            SHAREMIND_MI_GET_$4(d, SHAREMIND_MI_ARG_AS(2, sizet));
            m4_ifelse(DTB_CAT_$1, [float],
                      [SHAREMIND_MI_CONVERT_$1_TO_$3(SHAREMIND_MI_BLOCK_AS(d,$3), SHAREMIND_MI_BLOCK_AS(s,$1))],
                      DTB_CAT_$3, [float],
                      [SHAREMIND_MI_CONVERT_$1_TO_$3(SHAREMIND_MI_BLOCK_AS(d,$3), SHAREMIND_MI_BLOCK_AS(s,$1))],
                      [SHAREMIND_MI_BLOCK_AS(d,$3) = (DTB_TYPE_$3) SHAREMIND_MI_BLOCK_AS(s,$1)])]),
        DO_DISPATCH, PREPARE_FINISH
    )])])
m4_define([CONVERT_DEFINE], [_$0(_ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1)])
foreach([CONVERT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                   ([reg], [stack]),
                                   ([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                   ([reg], [stack]))))

# common.halt
m4_define([HALT_DEFINE], [
    INSTR_DEFINE([common.halt_$1],
        CODE(0x00, 0xff, 0x00, OLB_CODE_$1, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), NO_PREPARATION, NO_IMPL_SUFFIX,
        IMPL([
            const SharemindCodeBlock * restrict c;
            m4_ifelse($1, [imm],
                      [c = SHAREMIND_MI_ARG_P(1);],
                      [SHAREMIND_MI_GET_CONST_$1(c, SHAREMIND_MI_ARG_AS(1, sizet));])
            SHAREMIND_MI_HALT(*c)]),
        NO_DISPATCH, PREPARE_FINISH)])
HALT_DEFINE([imm])
HALT_DEFINE([reg])
HALT_DEFINE([stack])

INSTR_DEFINE([common.except],
    CODE(0x00, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00),
    ARGS(1), PREPARATION([
        SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_IS_EXCEPTIONCODE(SHAREMIND_PREPARE_ARG_AS(1,int64)),
                                         SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
    ]), NO_IMPL_SUFFIX, IMPL([SHAREMIND_MI_DO_EXCEPT(SHAREMIND_MI_ARG_AS(1,int64))]), DO_DISPATCH, PREPARE_FINISH)


# (1=name,2=namespace,3=class,4=dtb,5=olb,6=prepare,7=impl)
m4_define([UBI_D_DEFINE], [
    INSTR_DEFINE($1_$4_$5,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), $6, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * restrict bd;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            {
                DTB_TYPE_$4 * restrict d = SHAREMIND_MI_BLOCK_AS_P(bd,$4);
                $7;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# (1=name,2=namespace,3=class,4=dtb,5=olb_d,6=olb_s,7=prepare,8=impl)
m4_define([UBI_DS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, 0x00, 0x00, 0x00),
        ARGS(2), $7, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bd;
            const SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bs;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($6, [imm], [bs = SHAREMIND_MI_ARG_P(2)], [SHAREMIND_MI_GET_CONST_$6(bs, SHAREMIND_MI_ARG_AS(2, sizet))]);
            {
                DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) d = SHAREMIND_MI_BLOCK_AS_P(bd,$4);
                const DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) s = SHAREMIND_MI_BLOCK_AS_P(bs,$4);
                $8;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# (1=name,2=namespace,3=class,4=dtb,5=olb_d,6=olb_s1,7=olb_s2,8=prepare,9=impl)
m4_define([UBI_DSS_DEFINE], [m4_ifelse($6, $7, m4_ifelse($6, [imm], [], [_$0($@)]))])
m4_define([_UBI_DSS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6_$7,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, OLB_CODE_$7, 0x00, 0x00),
        ARGS(3), $8, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * m4_ifelse($6, [imm], m4_ifelse($7, [imm], [restrict])) bd;
            const SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bs1;
            const SharemindCodeBlock * m4_ifelse($7, [imm], [restrict]) bs2;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($6, [imm], [bs1 = SHAREMIND_MI_ARG_P(2);], [SHAREMIND_MI_GET_CONST_$6(bs1, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($7, [imm], [bs2 = SHAREMIND_MI_ARG_P(3);], [SHAREMIND_MI_GET_CONST_$7(bs2, SHAREMIND_MI_ARG_AS(3, sizet));])
            {
                DTB_TYPE_$4 * m4_ifelse($6, [imm], m4_ifelse($7, [imm], [restrict])) d = SHAREMIND_MI_BLOCK_AS_P(bd,$4);
                const DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) s1 = SHAREMIND_MI_BLOCK_AS_P(bs1,$4);
                const DTB_TYPE_$4 * m4_ifelse($7, [imm], [restrict]) s2 = SHAREMIND_MI_BLOCK_AS_P(bs2,$4);
                m4_ifelse(DTB_CAT_$4, [float], [], [
                    m4_ifelse($1, [arith.tdiv], [
                        if ((*s2) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                        m4_ifelse(DTB_CAT_$4, [signed], [else if ((*s2) == -1 && (*s1) == DTB_MIN_$4) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_OVERFLOW); }])])])
                $9;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50865
m4_define([GCC_BUG_50865_WORKAROUND], [if (($4) == -1) { ($1) = ($2) (($3) % 1); } else { ($1) = ($2) (($3) % -($4)); }])

# arith.uneg
m4_define([ARITH_UNEG_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_UNEG_FLOAT]DTB_BITS_$1[(*d)], [(*d) = (DTB_TYPE_$1) -(*d)])])
m4_define([ARITH_UNEG_DEFINE], [UBI_D_DEFINE([[arith.uneg]], 0x1, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UNEG_OP(_ARG1$1))])
foreach([ARITH_UNEG_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]), ([reg], [stack]))))

# arith.uinc
m4_define([ARITH_UINC_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_UINC_FLOAT]DTB_BITS_$1[(*d)], [(*d)++])])
m4_define([ARITH_UINC_DEFINE], [UBI_D_DEFINE([[arith.uinc]], 0x1, 0x01, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UINC_OP(_ARG1$1))])
foreach([ARITH_UINC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]), ([reg], [stack]))))

# arith.udec
m4_define([ARITH_UDEC_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_UDEC_FLOAT]DTB_BITS_$1[(*d)], [(*d)--])])
m4_define([ARITH_UDEC_DEFINE], [UBI_D_DEFINE([[arith.udec]], 0x1, 0x02, _ARG1$1, _ARG2$1, NO_PREPARATION, ARITH_UDEC_OP(_ARG1$1))])
foreach([ARITH_UDEC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]), ([reg], [stack]))))

# arith.bneg
m4_define([ARITH_BNEG_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BNEG_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) -(*s)])])
m4_define([ARITH_BNEG_DEFINE], [UBI_DS_DEFINE([[arith.bneg]], 0x1, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BNEG_OP(_ARG1$1))])
foreach([ARITH_BNEG_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.binc
m4_define([ARITH_BINC_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BINC_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) + 1)])])
m4_define([ARITH_BINC_DEFINE], [UBI_DS_DEFINE([[arith.binc]], 0x1, 0x41, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BINC_OP(_ARG1$1))])
foreach([ARITH_BINC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.bdec
m4_define([ARITH_BDEC_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BDEC_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) - 1)])])
m4_define([ARITH_BDEC_DEFINE], [UBI_DS_DEFINE([[arith.bdec]], 0x1, 0x42, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDEC_OP(_ARG1$1))])
foreach([ARITH_BDEC_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([reg], [stack]))))

# arith.badd
m4_define([ARITH_BADD_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BADD_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) + (*s))])])
m4_define([ARITH_BADD_DEFINE], [UBI_DS_DEFINE([[arith.badd]], 0x1, 0x80, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BADD_OP(_ARG1$1))])
foreach([ARITH_BADD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bsub
m4_define([ARITH_BSUB_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BSUB_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) - (*s))])])
m4_define([ARITH_BSUB_DEFINE], [UBI_DS_DEFINE([[arith.bsub]], 0x1, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BSUB_OP(_ARG1$1))])
foreach([ARITH_BSUB_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bsub2
m4_define([ARITH_BSUB2_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BSUB2_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*s) - (*d))])])
m4_define([ARITH_BSUB2_DEFINE], [UBI_DS_DEFINE([[arith.bsub2]], 0x1, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BSUB2_OP(_ARG1$1))])
foreach([ARITH_BSUB2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.bmul
m4_define([ARITH_BMUL_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_BMUL_FLOAT]DTB_BITS_$1[(*d,*s)], [(*d) = (DTB_TYPE_$1) ((*d) * (*s))])])
m4_define([ARITH_BMUL_DEFINE], [UBI_DS_DEFINE([[arith.bmul]], 0x1, 0x83, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMUL_OP(_ARG1$1))])
foreach([ARITH_BMUL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bdiv
m4_define([ARITH_BDIV_OP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_BDIV_FLOAT]DTB_BITS_$1[(*d,*s)],
                     [if ((*s) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if ((*s) == -1 && (*d) == DTB_MIN_$1) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_OVERFLOW); }])
                      (*d) = (DTB_TYPE_$1) ((*d) / (*s))])])
m4_define([ARITH_BDIV_DEFINE], [UBI_DS_DEFINE([[arith.bdiv]], 0x1, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDIV_OP(_ARG1$1))])
foreach([ARITH_BDIV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bdiv2
m4_define([ARITH_BDIV2_OP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_BDIV2_FLOAT]DTB_BITS_$1[(*d,*s)],
                     [if ((*d) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if ((*d) == -1 && (*s) == DTB_MIN_$1) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_OVERFLOW); }])
                      (*d) = (DTB_TYPE_$1) ((*s) / (*d))])])
m4_define([ARITH_BDIV2_DEFINE], [UBI_DS_DEFINE([[arith.bdiv2]], 0x1, 0x85, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BDIV2_OP(_ARG1$1))])
foreach([ARITH_BDIV2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.bmod
m4_define([ARITH_BMOD_OP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_BMOD_FLOAT]DTB_BITS_$1[(*d,*s)],
                     [if ((*s) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*s) < 0) && ((*s) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*d), (*s)); }])
                      else (*d) = (DTB_TYPE_$1) ((*d) % (*s))])])
m4_define([ARITH_BMOD_DEFINE], [UBI_DS_DEFINE([[arith.bmod]], 0x1, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMOD_OP(_ARG1$1))])
foreach([ARITH_BMOD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.bmod2
m4_define([ARITH_BMOD2_OP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_BMOD2_FLOAT]DTB_BITS_$1[(*d,*s)],
                     [if ((*d) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*d) < 0) && ((*d) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*s), (*d)); }])
                      else (*d) = (DTB_TYPE_$1) ((*s) % (*d))])])
m4_define([ARITH_BMOD2_DEFINE], [UBI_DS_DEFINE([[arith.bmod2]], 0x1, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, ARITH_BMOD2_OP(_ARG1$1))])
foreach([ARITH_BMOD2_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                       ([reg], [stack]),
                                       ([imm], [reg], [stack]))))

# arith.tadd
m4_define([ARITH_TADD_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_TADD_FLOAT]DTB_BITS_$1[(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) + (*s2))])])
m4_define([ARITH_TADD_DEFINE], [UBI_DSS_DEFINE([[arith.tadd]], 0x1, 0xc0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TADD_OP(_ARG1$1))])
foreach([ARITH_TADD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tsub
m4_define([ARITH_TSUB_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_TSUB_FLOAT]DTB_BITS_$1[(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) - (*s2))])])
m4_define([ARITH_TSUB_DEFINE], [UBI_DSS_DEFINE([[arith.tsub]], 0x1, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TSUB_OP(_ARG1$1))])
foreach([ARITH_TSUB_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tmul
m4_define([ARITH_TMUL_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_TMUL_FLOAT]DTB_BITS_$1[(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) * (*s2))])])
m4_define([ARITH_TMUL_DEFINE], [UBI_DSS_DEFINE([[arith.tmul]], 0x1, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TMUL_OP(_ARG1$1))])
foreach([ARITH_TMUL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tdiv
m4_define([ARITH_TDIV_OP], [m4_ifelse(DTB_CAT_$1, [float], [SHAREMIND_MI_TDIV_FLOAT]DTB_BITS_$1[(*d,*s1,*s2)], [(*d) = (DTB_TYPE_$1) ((*s1) / (*s2))])])
m4_define([ARITH_TDIV_DEFINE], [UBI_DSS_DEFINE([[arith.tdiv]], 0x1, 0xc3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TDIV_OP(_ARG1$1))])
foreach([ARITH_TDIV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# arith.tmod
m4_define([ARITH_TMOD_OP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_TMOD_FLOAT]DTB_BITS_$1[(*d,*s1,*s2)],
                     [if ((*s2) == 0) { SHAREMIND_MI_DO_EXCEPT(SHAREMIND_VM_PROCESS_INTEGER_DIVIDE_BY_ZERO); }
                      m4_ifelse(DTB_CAT_$1, [signed], [else if (((*s2) < 0) && ((*s2) != DTB_MIN_$1)) { GCC_BUG_50865_WORKAROUND((*d), DTB_TYPE_$1, (*s1), (*s2)); }])
                      else (*d) = (DTB_TYPE_$1) ((*s1) % (*s2))])])
m4_define([ARITH_TMOD_DEFINE], [UBI_DSS_DEFINE([[arith.tmod]], 0x1, 0xc4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, ARITH_TMOD_OP(_ARG1$1))])
foreach([ARITH_TMOD_DEFINE], (product(([uint8], [uint16], [uint32], [uint64], [int8], [int16], [int32], [int64], [float32], [float64]),
                                      ([reg], [stack]),
                                      ([imm], [reg], [stack]),
                                      ([imm], [reg], [stack]))))

# binary.uinv
m4_define([BINARY_UINV_DEFINE], [UBI_D_DEFINE([[binary.uinv]], 0x2, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~(*d)])])
foreach([BINARY_UINV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.urtl
m4_define([BINARY_URTL_DEFINE], [UBI_D_DEFINE([[binary.urtl]], 0x2, 0x02, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | (((*d) >> m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_URTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.urtr
m4_define([BINARY_URTR_DEFINE], [UBI_D_DEFINE([[binary.urtr]], 0x2, 0x03, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*d) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_URTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl0
m4_define([BINARY_USHL0_DEFINE], [UBI_D_DEFINE([[binary.ushl0]], 0x2, 0x04, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) << 1u)])])
foreach([BINARY_USHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl1
m4_define([BINARY_USHL1_DEFINE], [UBI_D_DEFINE([[binary.ushl1]], 0x2, 0x05, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u))])])
foreach([BINARY_USHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr0
m4_define([BINARY_USHR0_DEFINE], [UBI_D_DEFINE([[binary.ushr0]], 0x2, 0x06, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_USHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr1
m4_define([BINARY_USHR1_DEFINE], [UBI_D_DEFINE([[binary.ushr1]], 0x2, 0x07, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_USHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushl
m4_define([BINARY_USHL_DEFINE], [UBI_D_DEFINE([[binary.ushl]], 0x2, 0x08, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << 1u) | ((*d) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_USHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.ushr
m4_define([BINARY_USHR_DEFINE], [UBI_D_DEFINE([[binary.ushr]], 0x2, 0x09, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> 1u) | ((*d) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_USHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# binary.binv
m4_define([BINARY_BINV_DEFINE], [UBI_DS_DEFINE([[binary.binv]], 0x2, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~(*s)])])
foreach([BINARY_BINV_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1rtl
m4_define([BINARY_B1RTL_DEFINE], [UBI_DS_DEFINE([[binary.b1rtl]], 0x2, 0x42, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | (((*s) >> m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_B1RTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1rtr
m4_define([BINARY_B1RTR_DEFINE], [UBI_DS_DEFINE([[binary.b1rtr]], 0x2, 0x43, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*s) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_B1RTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl0
m4_define([BINARY_B1SHL0_DEFINE], [UBI_DS_DEFINE([[binary.b1shl0]], 0x2, 0x44, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s) << 1u)])])
foreach([BINARY_B1SHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl1
m4_define([BINARY_B1SHL1_DEFINE], [UBI_DS_DEFINE([[binary.b1shl1]], 0x2, 0x45, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u))])])
foreach([BINARY_B1SHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr0
m4_define([BINARY_B1SHR0_DEFINE], [UBI_DS_DEFINE([[binary.b1shr0]], 0x2, 0x46, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_B1SHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr1
m4_define([BINARY_B1SHR1_DEFINE], [UBI_DS_DEFINE([[binary.b1shr1]], 0x2, 0x47, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u))])])
foreach([BINARY_B1SHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shl
m4_define([BINARY_B1SHL_DEFINE], [UBI_DS_DEFINE([[binary.b1shl]], 0x2, 0x48, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) << 1u) | ((*s) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << 1u)))])])
foreach([BINARY_B1SHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.b1shr
m4_define([BINARY_B1SHR_DEFINE], [UBI_DS_DEFINE([[binary.b1shr]], 0x2, 0x49, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s) >> 1u) | ((*s) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u)))])])
foreach([BINARY_B1SHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# binary.bband
m4_define([BINARY_BAND_DEFINE], [UBI_DS_DEFINE([[binary.bband]], 0x2, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) & (*s))])])
foreach([BINARY_BAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_0010
m4_define([BINARY_B0010_DEFINE], [UBI_DS_DEFINE([[binary.bb_0010]], 0x2, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) & ~(*s))])])
foreach([BINARY_B0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_0100
m4_define([BINARY_B0100_DEFINE], [UBI_DS_DEFINE([[binary.bb_0100]], 0x2, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (~(*d) & (*s))])])
foreach([BINARY_B0100_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bbxor
m4_define([BINARY_BXOR_DEFINE], [UBI_DS_DEFINE([[binary.bbxor]], 0x2, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) ^ (*s))])])
foreach([BINARY_BXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bbor
m4_define([BINARY_BOR_DEFINE], [UBI_DS_DEFINE([[binary.bbor]], 0x2, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) | (*s))])])
foreach([BINARY_BOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1000
m4_define([BINARY_B1000_DEFINE], [UBI_DS_DEFINE([[binary.bb_1000]], 0x2, 0x88, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) | (*s))])])
foreach([BINARY_B1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1001
m4_define([BINARY_B1001_DEFINE], [UBI_DS_DEFINE([[binary.bb_1001]], 0x2, 0x89, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) ^ (*s))])])
foreach([BINARY_B1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1011
m4_define([BINARY_B1011_DEFINE], [UBI_DS_DEFINE([[binary.bb_1011]], 0x2, 0x8b, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) | ~(*s))])])
foreach([BINARY_B1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1101
m4_define([BINARY_B1101_DEFINE], [UBI_DS_DEFINE([[binary.bb_1101]], 0x2, 0x8d, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (~(*d) | (*s))])])
foreach([BINARY_B1101_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bb_1110
m4_define([BINARY_B1110_DEFINE], [UBI_DS_DEFINE([[binary.bb_1110]], 0x2, 0x8e, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*d) & (*s))])])
foreach([BINARY_B1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.brtl
m4_define([BINARY_BRTL_DEFINE], [UBI_DS_DEFINE([[binary.brtl]], 0x2, 0x90, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | (((*d) >> (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BRTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.brtr
m4_define([BINARY_BRTR_DEFINE], [UBI_DS_DEFINE([[binary.brtr]], 0x2, 0x91, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_BRTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl0
m4_define([BINARY_BSHL0_DEFINE], [UBI_DS_DEFINE([[binary.bshl0]], 0x2, 0x92, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u))])])
foreach([BINARY_BSHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl1
m4_define([BINARY_BSHL1_DEFINE], [UBI_DS_DEFINE([[binary.bshl1]], 0x2, 0x93, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u)))])])
foreach([BINARY_BSHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr0
m4_define([BINARY_BSHR0_DEFINE], [UBI_DS_DEFINE([[binary.bshr0]], 0x2, 0x94, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr1
m4_define([BINARY_BSHR1_DEFINE], [UBI_DS_DEFINE([[binary.bshr1]], 0x2, 0x95, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshl
m4_define([BINARY_BSHL_DEFINE], [UBI_DS_DEFINE([[binary.bshl]], 0x2, 0x96, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) << ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ((*d) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_BSHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.bshr
m4_define([BINARY_BSHR_DEFINE], [UBI_DS_DEFINE([[binary.bshr]], 0x2, 0x97, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*d) >> ((*s) % DTB_GET_BITS(_ARG1$1)u)) | ((*d) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_BSHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# binary.btand
m4_define([BINARY_TAND_DEFINE], [UBI_DSS_DEFINE([[binary.btand]], 0x2, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) & (*s2))])])
foreach([BINARY_TAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_0010
m4_define([BINARY_T0010_DEFINE], [UBI_DSS_DEFINE([[binary.bt_0010]], 0x2, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) & ~(*s2))])])
foreach([BINARY_T0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.btxor
m4_define([BINARY_TXOR_DEFINE], [UBI_DSS_DEFINE([[binary.btxor]], 0x2, 0xc6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) ^ (*s2))])])
foreach([BINARY_TXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.btor
m4_define([BINARY_TOR_DEFINE], [UBI_DSS_DEFINE([[binary.btor]], 0x2, 0xc7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) | (*s2))])])
foreach([BINARY_TOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1000
m4_define([BINARY_T1000_DEFINE], [UBI_DSS_DEFINE([[binary.bt_1000]], 0x2, 0xc8, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) | (*s2))])])
foreach([BINARY_T1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1001
m4_define([BINARY_T1001_DEFINE], [UBI_DSS_DEFINE([[binary.bt_1001]], 0x2, 0xc9, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) ^ (*s2))])])
foreach([BINARY_T1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1011
m4_define([BINARY_T1011_DEFINE], [UBI_DSS_DEFINE([[binary.bt_1011]], 0x2, 0xcb, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) | ~(*s2))])])
foreach([BINARY_T1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.bt_1110
m4_define([BINARY_T1110_DEFINE], [UBI_DSS_DEFINE([[binary.bt_1110]], 0x2, 0xce, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ~((*s1) & (*s2))])])
foreach([BINARY_T1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.trtl
m4_define([BINARY_TRTL_DEFINE], [UBI_DSS_DEFINE([[binary.trtl]], 0x2, 0xd0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | (((*s1) >> (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TRTL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.trtr
m4_define([BINARY_TRTR_DEFINE], [UBI_DSS_DEFINE([[binary.trtr]], 0x2, 0xd1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << m4_eval(DTB_GET_BITS(_ARG1$1) - 1)u) | (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_TRTR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl0
m4_define([BINARY_TSHL0_DEFINE], [UBI_DSS_DEFINE([[binary.tshl0]], 0x2, 0xd2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) ((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u))])])
foreach([BINARY_TSHL0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl1
m4_define([BINARY_TSHL1_DEFINE], [UBI_DSS_DEFINE([[binary.tshl1]], 0x2, 0xd3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)))])])
foreach([BINARY_TSHL1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr0
m4_define([BINARY_TSHR0_DEFINE], [UBI_DSS_DEFINE([[binary.tshr0]], 0x2, 0xd4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TSHR0_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr1
m4_define([BINARY_TSHR1_DEFINE], [UBI_DSS_DEFINE([[binary.tshr1]], 0x2, 0xd5, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u))))])])
foreach([BINARY_TSHR1_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshl
m4_define([BINARY_TSHL_DEFINE], [UBI_DSS_DEFINE([[binary.tshl]], 0x2, 0xd6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) << ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ((*s1) & ~(~((DTB_GET_TYPE(_ARG1$1)) 0u) << ((*s2) % DTB_GET_BITS(_ARG1$1)))))])])
foreach([BINARY_TSHL_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# binary.tshr
m4_define([BINARY_TSHR_DEFINE], [UBI_DSS_DEFINE([[binary.tshr]], 0x2, 0xd7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (DTB_GET_TYPE(_ARG1$1)) (((*s1) >> ((*s2) % DTB_GET_BITS(_ARG1$1)u)) | ((*s1) & (~((DTB_GET_TYPE(_ARG1$1)) 0u) << (DTB_GET_BITS(_ARG1$1)u - ((*s2) % DTB_GET_BITS(_ARG1$1)u)))))])])
foreach([BINARY_TSHR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# (1=name,2=namespace,3=class,4=dtb,5=olb,6=prepare,7=impl)
m4_define([LBI_D_DEFINE], [
    INSTR_DEFINE($1_$4_$5,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, 0x00, 0x00, 0x00, 0x00),
        ARGS(1), $6, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * restrict bd;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            {
                uint64_t * const d = SHAREMIND_MI_BLOCK_AS_P(bd,uint64);
                DTB_TYPE_$4 * const sd = SHAREMIND_MI_BLOCK_AS_P(bd,$4);
                $7;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# (1=name,2=namespace,3=class,4=dtb_s,5=olb_d,6=olb_s,7=prepare,8=impl)
m4_define([LBI_DS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, 0x00, 0x00, 0x00),
        ARGS(2), $7, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bd;
            const SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bs;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($6, [imm], [bs = SHAREMIND_MI_ARG_P(2)], [SHAREMIND_MI_GET_CONST_$6(bs, SHAREMIND_MI_ARG_AS(2, sizet))]);
            {
                uint64_t * const d = SHAREMIND_MI_BLOCK_AS_P(bd,uint64);
                const DTB_TYPE_$4 * const sd = SHAREMIND_MI_BLOCK_AS_P(bd,$4);
                const DTB_TYPE_$4 * const m4_ifelse($6, [imm], [restrict]) s = SHAREMIND_MI_BLOCK_AS_P(bs,$4);
                $8;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# (1=name,2=namespace,3=class,4=dtb_s,5=olb_d,6=olb_s1,7=olb_s2,8=prepare,9=impl)
m4_define([LBI_DSS_DEFINE], [m4_ifelse($6, $7, m4_ifelse($6, [imm], [], [_$0($@)]))])
m4_define([_LBI_DSS_DEFINE], [
    INSTR_DEFINE($1_$4_$5_$6_$7,
        CODE($2, $3, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, OLB_CODE_$7, 0x00, 0x00),
        ARGS(3), $8, NO_IMPL_SUFFIX,
        IMPL([
            SharemindCodeBlock * m4_ifelse($6, [imm], m4_ifelse($7, [imm], [restrict])) bd;
            const SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) bs1;
            const SharemindCodeBlock * m4_ifelse($7, [imm], [restrict]) bs2;
            SHAREMIND_MI_GET_$5(bd, SHAREMIND_MI_ARG_AS(1, sizet));
            m4_ifelse($6, [imm], [bs1 = SHAREMIND_MI_ARG_P(2);], [SHAREMIND_MI_GET_CONST_$6(bs1, SHAREMIND_MI_ARG_AS(2, sizet));])
            m4_ifelse($7, [imm], [bs2 = SHAREMIND_MI_ARG_P(3);], [SHAREMIND_MI_GET_CONST_$7(bs2, SHAREMIND_MI_ARG_AS(3, sizet));])
            {
                uint64_t * const m4_ifelse($6, [imm], m4_ifelse($7, [imm], [restrict])) d = SHAREMIND_MI_BLOCK_AS_P(bd,uint64);
                const DTB_TYPE_$4 * const m4_ifelse($6, [imm], [restrict]) s1 = SHAREMIND_MI_BLOCK_AS_P(bs1,$4);
                const DTB_TYPE_$4 * const m4_ifelse($7, [imm], [restrict]) s2 = SHAREMIND_MI_BLOCK_AS_P(bs2,$4);
                $9;
            }]),
        DO_DISPATCH, PREPARE_FINISH)])

# logical comparison (1=dtb,2=d,3=s1,4=s2,5=floatop,6=otherop)
m4_define([LOG_COMP],
          [m4_ifelse(DTB_CAT_$1, [float],
                     [SHAREMIND_MI_T$5_FLOAT]DTB_BITS_$1[($2,$3,$4)],
                     [($2) = (($3) $6 ($4))])])

# logical.unot
m4_define([LOGICAL_UNOT_DEFINE], [LBI_D_DEFINE([[logical.unot]], 0x3, 0x00, _ARG1$1, _ARG2$1, NO_PREPARATION, [(*d) = !(*sd)])])
foreach([LOGICAL_UNOT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]))))

# logical.bnot
m4_define([LOGICAL_BNOT_DEFINE], [LBI_DS_DEFINE([[logical.bnot]], 0x3, 0x40, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(void) sd; (*d) = !(*s)])])
foreach([LOGICAL_BNOT_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([reg], [stack]))))

# logical.lband
m4_define([LOGICAL_BAND_DEFINE], [LBI_DS_DEFINE([[logical.lband]], 0x3, 0x81, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*sd) && (*s)])])
foreach([LOGICAL_BAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_0010
m4_define([LOGICAL_B0010_DEFINE], [LBI_DS_DEFINE([[logical.lb_0010]], 0x3, 0x82, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*sd) && !(*s)])])
foreach([LOGICAL_B0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_0100
m4_define([LOGICAL_B0100_DEFINE], [LBI_DS_DEFINE([[logical.lb_0100]], 0x3, 0x84, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !(*sd) && (*s)])])
foreach([LOGICAL_B0100_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lbxor
m4_define([LOGICAL_BXOR_DEFINE], [LBI_DS_DEFINE([[logical.lbxor]], 0x3, 0x86, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*sd) && !(*s)) || (!(*sd) && (*s))])])
foreach([LOGICAL_BXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lbor
m4_define([LOGICAL_BOR_DEFINE], [LBI_DS_DEFINE([[logical.lbor]], 0x3, 0x87, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*sd) || (*s)])])
foreach([LOGICAL_BOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1000
m4_define([LOGICAL_B1000_DEFINE], [LBI_DS_DEFINE([[logical.lb_1000]], 0x3, 0x88, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !((*sd) || (*s))])])
foreach([LOGICAL_B1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1001
m4_define([LOGICAL_B1001_DEFINE], [LBI_DS_DEFINE([[logical.lb_1001]], 0x3, 0x89, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = ((*sd) && (*s)) || (!(*sd) && !(*s))])])
foreach([LOGICAL_B1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1011
m4_define([LOGICAL_B1011_DEFINE], [LBI_DS_DEFINE([[logical.lb_1011]], 0x3, 0x8b, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = (*sd) || !(*s)])])
foreach([LOGICAL_B1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1101
m4_define([LOGICAL_B1101_DEFINE], [LBI_DS_DEFINE([[logical.lb_1101]], 0x3, 0x8d, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !(*sd) || (*s)])])
foreach([LOGICAL_B1101_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.lb_1110
m4_define([LOGICAL_B1110_DEFINE], [LBI_DS_DEFINE([[logical.lb_1110]], 0x3, 0x8e, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, [(*d) = !((*sd) && (*s))])])
foreach([LOGICAL_B1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.beq
m4_define([LOGICAL_BEQ_DEFINE], [LBI_DS_DEFINE([[logical.beq]], 0x3, 0x90, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,EQ,==))])
foreach([LOGICAL_BEQ_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bne
m4_define([LOGICAL_BNE_DEFINE], [LBI_DS_DEFINE([[logical.bne]], 0x3, 0x91, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,NE,!=))])
foreach([LOGICAL_BNE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.blt
m4_define([LOGICAL_BLT_DEFINE], [LBI_DS_DEFINE([[logical.blt]], 0x3, 0x92, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,LT,<))])
foreach([LOGICAL_BLT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.ble
m4_define([LOGICAL_BLE_DEFINE], [LBI_DS_DEFINE([[logical.ble]], 0x3, 0x93, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,LE,<=))])
foreach([LOGICAL_BLE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bge
m4_define([LOGICAL_BGE_DEFINE], [LBI_DS_DEFINE([[logical.bge]], 0x3, 0x94, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,GE,>=))])
foreach([LOGICAL_BGE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.bgt
m4_define([LOGICAL_BGT_DEFINE], [LBI_DS_DEFINE([[logical.bgt]], 0x3, 0x95, _ARG1$1, _ARG2$1, _ARG3$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*sd,*s,GT,>))])
foreach([LOGICAL_BGT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]), ([reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltand
m4_define([LOGICAL_TAND_DEFINE], [LBI_DSS_DEFINE([[logical.ltand]], 0x3, 0xc1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) && (*s2)])])
foreach([LOGICAL_TAND_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_0010
m4_define([LOGICAL_T0010_DEFINE], [LBI_DSS_DEFINE([[logical.lt_0010]], 0x3, 0xc2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) && !(*s2)])])
foreach([LOGICAL_T0010_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltxor
m4_define([LOGICAL_TXOR_DEFINE], [LBI_DSS_DEFINE([[logical.ltxor]], 0x3, 0xc6, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) && !(*s2)) || (!(*s1) && (*s2))])])
foreach([LOGICAL_TXOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.ltor
m4_define([LOGICAL_TOR_DEFINE], [LBI_DSS_DEFINE([[logical.ltor]], 0x3, 0xc7, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) || (*s2)])])
foreach([LOGICAL_TOR_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1000
m4_define([LOGICAL_T1000_DEFINE], [LBI_DSS_DEFINE([[logical.lt_1000]], 0x3, 0xc8, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = !((*s1) || (*s2))])])
foreach([LOGICAL_T1000_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1001
m4_define([LOGICAL_T1001_DEFINE], [LBI_DSS_DEFINE([[logical.lt_1001]], 0x3, 0xc9, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = ((*s1) && (*s2)) || (!(*s1) && !(*s2))])])
foreach([LOGICAL_T1001_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1011
m4_define([LOGICAL_T1011_DEFINE], [LBI_DSS_DEFINE([[logical.lt_1011]], 0x3, 0xcb, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = (*s1) || !(*s2)])])
foreach([LOGICAL_T1011_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.lt_1110
m4_define([LOGICAL_T1110_DEFINE], [LBI_DSS_DEFINE([[logical.lt_1110]], 0x3, 0xce, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, [(*d) = !((*s1) && (*s2))])])
foreach([LOGICAL_T1110_DEFINE], (product(([uint8], [uint16], [uint32], [uint64]), ([reg], [stack]), ([imm], [reg], [stack]), ([imm], [reg], [stack]))))

# logical.teq
m4_define([LOGICAL_TEQ_DEFINE], [LBI_DSS_DEFINE([[logical.teq]], 0x3, 0xd0, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,EQ,==))])
foreach([LOGICAL_TEQ_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# logical.tne
m4_define([LOGICAL_TNE_DEFINE], [LBI_DSS_DEFINE([[logical.tne]], 0x3, 0xd1, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,NE,!=))])
foreach([LOGICAL_TNE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# logical.tlt
m4_define([LOGICAL_TLT_DEFINE], [LBI_DSS_DEFINE([[logical.tlt]], 0x3, 0xd2, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,LT,<))])
foreach([LOGICAL_TLT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# logical.tle
m4_define([LOGICAL_TLE_DEFINE], [LBI_DSS_DEFINE([[logical.tle]], 0x3, 0xd3, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,LE,<=))])
foreach([LOGICAL_TLE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# logical.tge
m4_define([LOGICAL_TGE_DEFINE], [LBI_DSS_DEFINE([[logical.tge]], 0x3, 0xd4, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,GE,>=))])
foreach([LOGICAL_TGE_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# logical.tgt
m4_define([LOGICAL_TGT_DEFINE], [LBI_DSS_DEFINE([[logical.tgt]], 0x3, 0xd5, _ARG1$1, _ARG2$1, _ARG3$1, _ARG4$1, NO_PREPARATION, LOG_COMP(_ARG1$1,*d,*s1,*s2,GT,>))])
foreach([LOGICAL_TGT_DEFINE], (product(([int8], [int16], [int32], [int64], [uint8], [uint16], [uint32], [uint64], [float32], [float64]),
                ([reg], [stack]),
                ([imm], [reg], [stack]),
                ([imm], [reg], [stack]))))

# (1=name,2=suffixes,3=code,4=b3,5=b4,6=b5,7=args,8=prep,9=precode,10=conds,11=dispatch)
m4_define([INSTR_JUMP_DEFINE], [
    INSTR_DEFINE($1[_imm]$2,
        CODE(0x04, $3, OLB_CODE_imm, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        [if (1) {
            m4_ifelse([$8], [NO_PREPARATION], [], [$8;
            ])
            if (SHAREMIND_PREPARE_ARG_AS(1,int64) < 0) {
                uint64_t delta_minus_one = (uint64_t) -(SHAREMIND_PREPARE_ARG_AS(1,int64) + 1);
                SHAREMIND_PREPARE_CHECK_OR_ERROR(
                    delta_minus_one < SHAREMIND_PREPARE_CURRENT_I,
                    SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                SHAREMIND_PREPARE_CHECK_OR_ERROR(
                    SHAREMIND_PREPARE_IS_INSTR((uintptr_t) (SHAREMIND_PREPARE_CURRENT_I - 1u - delta_minus_one)),
                    SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
            } else {
                uint64_t delta = (uint64_t) SHAREMIND_PREPARE_ARG_AS(1,int64);
                SHAREMIND_PREPARE_CHECK_OR_ERROR(
                    delta < (size_t) (SHAREMIND_PREPARE_CODESIZE - SHAREMIND_PREPARE_CURRENT_I - 1u),
                    SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
                SHAREMIND_PREPARE_CHECK_OR_ERROR(
                    delta == 0u || SHAREMIND_PREPARE_IS_INSTR((uintptr_t) (SHAREMIND_PREPARE_CURRENT_I + delta)),
                    SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);
            }
        }],
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse([$9], [NO_JUMP_PRECODE], [], [$9;])
            m4_ifelse([$10], [NO_JUMP_CONDITION], [], [if ($10) ]){
            const SharemindCodeBlock * const restrict addr = SHAREMIND_MI_ARG_P(1);
            SHAREMIND_MI_JUMP_REL(addr);
            }]),
        $11, PREPARE_FINISH)
    INSTR_DEFINE($1[_reg]$2,
        CODE(0x04, $3, OLB_CODE_reg, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse([$9], [NO_JUMP_PRECODE], [], [$9;])
            m4_ifelse([$10], [NO_JUMP_CONDITION], [], [if ($10) ]){
            const SharemindCodeBlock * restrict t;
            SHAREMIND_MI_GET_reg(t, SHAREMIND_MI_ARG_AS(1, sizet));
            SHAREMIND_MI_CHECK_JUMP_REL(SHAREMIND_MI_BLOCK_AS(t,int64));
            }]),
        $11, PREPARE_FINISH)
    INSTR_DEFINE($1[_stack]$2,
        CODE(0x04, $3, OLB_CODE_stack, $4, $5, $6, 0x00, 0x00),
        ARGS($7),
        PREPARATION([$8]),
        NO_IMPL_SUFFIX,
        IMPL([
            m4_ifelse([$9], [NO_JUMP_PRECODE], [], [$9;])
            m4_ifelse([$10], [NO_JUMP_CONDITION], [], [if ($10) ]){
            const SharemindCodeBlock * restrict t;
            SHAREMIND_MI_GET_stack(t, SHAREMIND_MI_ARG_AS(1, sizet));
            SHAREMIND_MI_CHECK_JUMP_REL(SHAREMIND_MI_BLOCK_AS(t,int64));
            }]),
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
        m4_ifelse($1, [dnjz],, $1, [dnjnz],, [const]) SharemindCodeBlock * m4_ifelse($5, [imm], [restrict]) c;
        SHAREMIND_MI_GET_[]$5(c, SHAREMIND_MI_ARG_AS(2, sizet))],
        $3, DO_DISPATCH)])

# (name, code, cond, dtb, olb, olb2)
m4_define([INSTR_JUMP_COND_2_DEFINE], [
    INSTR_JUMP_DEFINE(
        jump.$1, _$4_$5_$6,
        $2, DTB_CODE_$4, OLB_CODE_$5, OLB_CODE_$6, 3,
        m4_ifelse([$5], [$7], [SHAREMIND_PREPARE_CHECK_OR_ERROR(SHAREMIND_PREPARE_ARG_AS(1,uint64) != SHAREMIND_PREPARE_ARG_AS(2,uint64),
                                    SHAREMIND_VM_PREPARE_ERROR_INVALID_ARGUMENTS);], [NO_PREPARATION]),
        [
        bool lc;
        const SharemindCodeBlock * m4_ifelse($5, [imm], [restrict]) c1;
        const SharemindCodeBlock * m4_ifelse($6, [imm], [restrict]) c2;
        m4_ifelse([$5], [imm], [],
                  [SHAREMIND_MI_GET_$5(c1, SHAREMIND_MI_ARG_AS(2, sizet));])
        m4_ifelse([$6], [imm], [],
                  [SHAREMIND_MI_GET_$6(c2, SHAREMIND_MI_ARG_AS(3, sizet));])
        m4_ifelse([$5], [imm], [c1 = SHAREMIND_MI_ARG_P(2);])
        m4_ifelse([$6], [imm], [c2 = SHAREMIND_MI_ARG_P(3);])
        {
            const DTB_TYPE_$4 * m4_ifelse($5, [imm], [restrict]) const o1 = SHAREMIND_MI_BLOCK_AS_P(c1,$4);
            const DTB_TYPE_$4 * m4_ifelse($6, [imm], [restrict]) const o2 = SHAREMIND_MI_BLOCK_AS_P(c2,$4);
            $3;
        }],
        [lc], DO_DISPATCH)])

m4_define([INSTR_JUMP_JZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jz],0x01,(SHAREMIND_MI_BLOCK_AS(c,_ARG1$1) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([jnz],0x02,(SHAREMIND_MI_BLOCK_AS(c,_ARG1$1) != 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_JNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjz],0x03,(--(SHAREMIND_MI_BLOCK_AS(c,_ARG1$1)) == 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_DNJNZ_DEFINE],
          [INSTR_JUMP_COND_1_DEFINE([dnjnz],0x04,(--(SHAREMIND_MI_BLOCK_AS(c,_ARG1$1)) != 0),_ARG1$1,_ARG2$1)])
foreach([INSTR_JUMP_DNJNZ_DEFINE], (product(([[uint8]], [[uint16]], [[uint32]], [[uint64]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JEQ_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jeq],0x05,LOG_COMP(_ARG1$1,lc,*o1,*o2,EQ,==),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JEQ_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JNE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jne],0x06,LOG_COMP(_ARG1$1,lc,*o1,*o2,NE,!=),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JNE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jge],0x07,LOG_COMP(_ARG1$1,lc,*o1,*o2,GE,>=),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JGE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JGT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jgt],0x08,LOG_COMP(_ARG1$1,lc,*o1,*o2,GT,>),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JGT_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLE_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jle],0x09,LOG_COMP(_ARG1$1,lc,*o1,*o2,LE,<=),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JLE_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))

m4_define([INSTR_JUMP_JLT_DEFINE],
          [INSTR_JUMP_COND_2_DEFINE([jlt],0x0a,LOG_COMP(_ARG1$1,lc,*o1,*o2,LT,<),_ARG1$1,_ARG2$1,_ARG3$1)])
foreach([INSTR_JUMP_JLT_DEFINE], (product(([[int8]], [[int16]], [[int32]], [[int64]], [[uint8]], [[uint16]], [[uint32]], [[uint64]], [[float32]], [[float64]]),([[imm]], [[reg]], [[stack]]),([[reg]], [[stack]]))))
