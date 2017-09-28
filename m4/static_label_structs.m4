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

m4_define([FNSANIT], [m4_patsubst($1, [\.], [___])])

m4_define([DO_INSTR_LABEL], [SHAREMIND_IMPL_LABEL(INSTR_NAME$1[]INSTR_IMPL_SUFFIX$1)])
m4_define([DO_INSTR_LABELS], [m4_ifelse(INSTR_COUNT, [0], [], [foreach([DO_INSTR_LABEL], [(INSTRS)])])])

m4_divert[]m4_dnl

static const ImplLabelType instr_labels[[]]      = { DO_INSTR_LABELS SHAREMIND_NULL };
