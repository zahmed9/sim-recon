#
# setup environment for building cleo, then type
#     gmake -f Makefile.cleo all
# from $QQ_DIR/src

set UNAME = `uname`
if ( $UNAME != "Linux" ) then
   setup gtools
endif
setup qq v9_2b
set path = ($path $QQ_DIR/src/com)
