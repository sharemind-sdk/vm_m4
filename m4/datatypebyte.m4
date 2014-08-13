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
                         m4_define(m4_format([[DTB_BITS_%s]], [$1]), [$4])
                         m4_define(m4_format([[DTB_MIN_%s]], [$1]), [$5])
                         m4_define(m4_format([[DTB_MAX_%s]], [$1]), [$6])
                         m4_define(m4_format([[DTB_CAT_%s]], [$1]), [$7])])

m4_define([DTB_GET_CODE], [m4_indir([DTB_CODE_$1])])
m4_define([DTB_GET_TYPE], [m4_indir([DTB_TYPE_$1])])
m4_define([DTB_GET_BITS], [m4_indir([DTB_BITS_$1])])
m4_define([DTB_GET_MIN],  [m4_indir([DTB_MIN_$1])])
m4_define([DTB_GET_MAX],  [m4_indir([DTB_MAX_$1])])
m4_define([DTB_GET_CAT],  [m4_indir([DTB_CAT_$1])])


# (name, code, C type, bitwidth, C min, C max, category)
DTB_DEFINE(uint8,   0x01, uint8_t,          8,  0u,        UINT8_MAX,  unsigned)
DTB_DEFINE(uint16,  0x02, uint16_t,         16, 0u,        UINT16_MAX, unsigned)
DTB_DEFINE(uint32,  0x03, uint32_t,         32, 0u,        UINT32_MAX, unsigned)
DTB_DEFINE(uint64,  0x04, uint64_t,         64, 0u,        UINT64_MAX, unsigned)
DTB_DEFINE(int8,    0x11, int8_t,           8,  INT8_MIN,  INT8_MAX,   signed)
DTB_DEFINE(int16,   0x12, int16_t,          16, INT16_MIN, INT16_MAX,  signed)
DTB_DEFINE(int32,   0x13, int32_t,          32, INT32_MIN, INT32_MAX,  signed)
DTB_DEFINE(int64,   0x14, int64_t,          64, INT64_MIN, INT64_MAX,  signed)
DTB_DEFINE(float32, 0x23, SharemindFloat32, 32, FLT_MIN,   FLT_MAX,    float)
DTB_DEFINE(float64, 0x24, SharemindFloat64, 64, DBL_MIN,   DBL_MAX,    float)
