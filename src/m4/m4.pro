#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

TEMPLATE = lib
TARGET =
CONFIG += no_link target_predeps staticlib

QMAKE_POST_LINK = $(MAKE) -f Makefile_for_m4
QMAKE_CLEAN += *.h *.m4f *.test

OTHER_FILES += \
    Makefile_for_m4 \
    datatypebyte.m4 \
    dispatches.m4 \
    foreach.m4 \
    forloop.m4 \
    instr.m4 \
    instruction_from_code_cases.m4 \
    instruction_from_name_cases.m4 \
    instruction_structs.m4 \
    operandlocationbyte.m4 \
    preprocess_pass1_cases.m4 \
    preprocess_pass2_cases.m4 \
    product.m4 \
    static_label_structs.m4
