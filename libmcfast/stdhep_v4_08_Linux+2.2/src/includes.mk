#!/bin/csh
# extract necessary isajet sequences as include files
# also copy herwig include file as herwig.inc
# be sure to setup stdhep, isajet, herwig, and cern first
#
## cpp -C -P $CERN_DIR/src/packlib/zebra/zebra/quest.inc > quest.inc
set echo
 $CERN_DIR/bin/yexpand $STDHEP_DIR/src/car/isainc.cra
 ypatchy - isainc.inc isainc tty :go
 cd inc
 fcasplit ../isainc.inc
 rm isainc*
 cp $HERWIG_DIR/src/her*.inc herwig.inc
 cd ..
 rm isainc*
