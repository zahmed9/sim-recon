#!/bin/csh
#
# 
setenv UNAME `uname`
# Note to IRIX users: if necessary, just edit this file to set UNAME appropriately
# which IRIX, anyway
if ( $UNAME == "IRIX" ) then
   if ( `uname -r | grep 6 | wc -c` > 0 ) then
      setenv UNAME 'IRIX64'
   endif
endif
setenv MCFLIB $MCFAST_DIR/lib.$UNAME
setenv MCFBIN $MCFAST_DIR/bin.$UNAME
setenv MCFINC $MCFAST_DIR/inc
setenv MCFSRC $MCFAST_DIR/simulator/
setenv EVGEN_DIR $MCFAST_DIR/evgen
setenv MCFIO_DIR $MCFAST_DIR/mcfio
setenv UTIL_DIR $MCFAST_DIR/util
setenv GLIB $MCFAST_DIR/lib.$UNAME
setenv MCFREL v4_3

#set path=(`dropit -d' ' $MCFAST_DIR/bin`)
set path=($path $MCFAST_DIR/bin)
