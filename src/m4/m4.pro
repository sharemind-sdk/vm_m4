TEMPLATE = lib
TARGET =
CONFIG += no_link target_predeps staticlib

QMAKE_POST_LINK = $(MAKE) -f Makefile_for_m4
QMAKE_CLEAN += *.h *.m4f *.test