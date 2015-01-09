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

m4_define([OLB_CODE_imm],         0x01)
m4_define([OLB_CODE_reg],         0x02)
m4_define([OLB_CODE_stack],       0x04)
m4_define([OLB_CODE_ref],         0x08)
m4_define([OLB_CODE_cref],        0x10)
m4_define([OLB_CODE_mem_imm],     0x20)
m4_define([OLB_CODE_mem_reg],     0x40)
m4_define([OLB_CODE_mem_stack],   0x80)
