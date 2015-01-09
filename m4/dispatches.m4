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

m4_define([INSTR_DISPATCH],
          [SHAREMIND_IMPL(INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1,
    {
        INSTR_IMPL$1;
    }
    m4_ifelse(INSTR_NEED_DISPATCH$1, [DO_DISPATCH], [SHAREMIND_MI_DISPATCH(ip += m4_eval(INSTR_ARGS$1 + 1));], []))
])
m4_define([INSTR_DISPATCH_EMPTY_IMPL],
       [SHAREMIND_IMPL(EMPTY_IMPL_LABEL$1,
    {
        EMPTY_IMPL_CODE$1;
    }
    m4_ifelse(EMPTY_IMPL_NEED_DISPATCH$1, [DO_DISPATCH], [SHAREMIND_MI_DISPATCH(ip += m4_eval(EMPTY_IMPL_ARGS$1 + 1));], []))
])

m4_define([DO_INSTRS_DISPATCH_SECTIONS],
          [m4_ifelse(INSTR_COUNT, [0], [], [foreach([INSTR_DISPATCH], (INSTRS))])
m4_ifelse(EMPTY_IMPL_COUNT, [0], [], [foreach([INSTR_DISPATCH_EMPTY_IMPL], (EMPTY_IMPLS))])])

m4_divert[]m4_dnl
DO_INSTRS_DISPATCH_SECTIONS()
