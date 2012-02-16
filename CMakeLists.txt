#
# This file is a part of the Sharemind framework.
# Copyright (C) Cybernetica AS
#
# All rights are reserved. Reproduction in whole or part is prohibited
# without the written consent of the copyright owner. The usage of this
# code is subject to the appropriate license agreement.
#

CMAKE_MINIMUM_REQUIRED(VERSION "2.8")
PROJECT("SHAREMIND_VM_M4" "C" "CXX")

SET(SHAREMIND_GEN_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated_sources")

ENABLE_TESTING()

ADD_SUBDIRECTORY("src/sharemind/")
