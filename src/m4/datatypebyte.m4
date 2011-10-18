#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

m4_define([DTB_DEFINE], [m4_define(m4_format([[DTB_CODE_%s]], [$1]), [$2])
                         m4_define(m4_format([[DTB_TYPE_%s]], [$1]), [$3])
                         m4_define(m4_format([[DTB_BITS_%s]], [$1]), [$4])])

m4_define([DTB_GET_CODE], DTB_CODE_$1)
m4_define([DTB_GET_TYPE], DTB_TYPE_$1)
m4_define([DTB_GET_BITS], DTB_BITS_$1)


# (name, code, type, bitwidth)
DTB_DEFINE(uint8,   0x01, uint8_t,      8)
DTB_DEFINE(uint16,  0x02, uint16_t,     16)
DTB_DEFINE(uint32,  0x03, uint32_t,     32)
DTB_DEFINE(uint64,  0x04, uint64_t,     64)
DTB_DEFINE(int8,    0x11, int8_t,       8)
DTB_DEFINE(int16,   0x12, int16_t,      16)
DTB_DEFINE(int32,   0x13, int32_t,      32)
DTB_DEFINE(int64,   0x14, int64_t,      64)
DTB_DEFINE(float32, 0x23, smvm_float32, 32)
