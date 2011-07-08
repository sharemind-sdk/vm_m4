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