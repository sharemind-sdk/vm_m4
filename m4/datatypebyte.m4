#
# Copyright (C) 2015 Cybernetica
#
# Research/Commercial License Usage
# Licensees holding a valid Research License or Commercial License
# for the Software may use this file according to the written
# agreement between you and Cybernetica.
#
# GNU General Public License Usage
# Alternatively, this file may be used under the terms of the GNU
# General Public License version 3.0 as published by the Free Software
# Foundation and appearing in the file LICENSE.GPL included in the
# packaging of this file.  Please review the following information to
# ensure the GNU General Public License version 3.0 requirements will be
# met: http://www.gnu.org/copyleft/gpl-3.0.html.
#
# For further information, please contact us at sharemind@cyber.ee.
#

m4_define([DTB_DEFINE], [m4_define(m4_format([[DTB_CODE_%s]], [$1]), [$2])
                         m4_define(m4_format([[DTB_TYPE_%s]], [$1]), [SHAREMIND_T_$1])
                         m4_define(m4_format([[DTB_BITS_%s]], [$1]), [$3])
                         m4_define(m4_format([[DTB_MIN_%s]], [$1]), [SHAREMIND_TMIN_$1])
                         m4_define(m4_format([[DTB_MAX_%s]], [$1]), [SHAREMIND_TMAX_$1])
                         m4_define(m4_format([[DTB_CAT_%s]], [$1]), [$4])])

m4_define([DTB_GET_CODE], [m4_indir([DTB_CODE_$1])])
m4_define([DTB_GET_TYPE], [m4_indir([DTB_TYPE_$1])])
m4_define([DTB_GET_BITS], [m4_indir([DTB_BITS_$1])])
m4_define([DTB_GET_MIN],  [m4_indir([DTB_MIN_$1])])
m4_define([DTB_GET_MAX],  [m4_indir([DTB_MAX_$1])])
m4_define([DTB_GET_CAT],  [m4_indir([DTB_CAT_$1])])


# (name, code, bitwidth, category)
DTB_DEFINE(uint8,   0x01, 8,  unsigned)
DTB_DEFINE(uint16,  0x02, 16, unsigned)
DTB_DEFINE(uint32,  0x03, 32, unsigned)
DTB_DEFINE(uint64,  0x04, 64, unsigned)
DTB_DEFINE(int8,    0x11, 8,  signed)
DTB_DEFINE(int16,   0x12, 16, signed)
DTB_DEFINE(int32,   0x13, 32, signed)
DTB_DEFINE(int64,   0x14, 64, signed)
DTB_DEFINE(float32, 0x23, 32, float)
DTB_DEFINE(float64, 0x24, 64, float)
