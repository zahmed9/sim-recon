#!/bin/csh
#
#  compile hwdcle.f separately so HERWIG linking issues can be resolved
#
 set echo
 /usr/bin/g77 -fno-second-underscore -c \
    -DCLEO_TYPECHEK -DCLEO_CDGDOC -DNONCLEO_DOUBLE \
    -o $QQ_DIR/lib/lurobo.o \
     $QQ_DIR/src/qqlib/noncleo/lurobo.F
 /usr/bin/g77 -fno-second-underscore -c \
  -DCLEO_TYPECHEK -DCLEO_CDGDOC -DNONCLEO_DOUBLE \
  -I$QQ_DIR/src/qqlib  -I$QQ_DIR/src -O -fno-automatic \
  -o $QQ_DIR/lib/ranp.o $QQ_DIR/src/qqlib/liburan/ranp.F
