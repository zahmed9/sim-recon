##################################################
#
# Source this file after modifying below
#
#################################################

# Set YOUR cern lib location
# below is the location on jlabs2 
#setenv CRNLIB /apps/cernlib/sun4_solaris2/97a/lib
#setenv CRNLIB /usr/local/lib

# The first 2 packages below can be obtained from the Halld CVS repository
# now set these locations
export HDFAST_DIR=$HALLD_HOME/src/HDFast
export STDHEP_TRANS_DIR=$HALLD_HOME/src/stdhep_translators


# below are fermi lab products (See above about fermi lab products)
# and finally  set these locations
export MCFAST_DIR=$HALLD_HOME/src/mcfast_v5_2_Linux+2.4+GCC3_2_1
export STDHEP_DIR=$HALLD_HOME/src/stdhep_v5_01_Linux+2.4
export QQ_DIR=$HALLD_HOME/src/qq_v9_2b_Linux+2.4
##########################################
#
# Now edit HDMS.cmd and change the  HDMS_MCFAST_DIR location 
#
#############################################
# Modify the above and do not change anything below
#
# pulled out of $MCFAST_DIR/setup.csh and modified for our use
export UNAME=`uname`
export MCFLIB=$MCFAST_DIR/lib.$UNAME
export MCFBIN=$MCFAST_DIR/bin.$UNAME
export MCFINC=$MCFAST_DIR/inc
#setenv MCFSRC $MCFAST_DIR/mcfast/src
export EVGEN_DIR=$MCFAST_DIR/evgen
export MCFIO_DIR=$MCFAST_DIR/mcfio
export UTIL_DIR=$MCFAST_DIR/util
export GLIB=$MCFAST_DIR/lib.$UNAME
export MCFREL=v4_4
export PATH=$PATH:$MCFAST_DIR/bin
#
# now source stdhep and qq setup
source $STDHEP_DIR/ups/setup.sh
source $QQ_DIR/ups/setup.sh
#
# 

