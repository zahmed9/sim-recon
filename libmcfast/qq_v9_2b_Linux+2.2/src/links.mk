#!/bin/csh
if ( ! -d $QQ_DIR/lib ) then
  mkdir $QQ_DIR/lib
endif
cd $QQ_DIR/lib
ln -s ../src/Build/`uname`/lib/libcleoks.a libcleoks.a
ln -s ../src/Build/`uname`/lib/libkorb.a libkorb.a
ln -s ../src/Build/`uname`/lib/libkorb_g.a libkorb_g.a
ln -s ../src/Build/`uname`/lib/libqqlib.a libqqlib_noncleo.a
ln -s ../src/Build/`uname`/lib/libqqlib_g.a libqqlib_noncleo_g.a
