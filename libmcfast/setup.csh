#!/bin/csh
#
# 
setenv UNAME `uname`


#
# edit this line to point to your libmcfast path
#setenv LIBMCFAST_DIR /home/halld/src/libmcfast

#lines below should not need editing
#
if($?LIBMCFAST_DIR) then
    setenv QQ_DIR $LIBMCFAST_DIR/qq_v9_2b_Linux+2.2
    setenv STDHEP_DIR $LIBMCFAST_DIR/stdhep_v4_08_Linux+2.2
    setenv MCFAST_DIR $LIBMCFAST_DIR/mcfast_v5_0_Linux+2.2
    source $QQ_DIR/setup.csh
    source $STDHEP_DIR/setup.csh
    source $MCFAST_DIR/setup.csh
else
    echo YOU MUST SET THE EVN \$LIBMCFAST ! ! ! ! 
    echo "\n"
endif
