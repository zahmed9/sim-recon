#!/bin/tcsh

setenv JAVAROOT /apps
setenv HALLD_EXTERNALPACKAGES /group/halld/Software/ExternalPackages
setenv XERCESCROOT ${HALLD_EXTERNALPACKAGES}/xerces-c-src_2_5_0
setenv XERCES_INCLUDE ${HALLD_EXTERNALPACKAGES}/include
setenv XERCES_LIB ${HALLD_EXTERNALPACKAGES}/lib/${OSNAME}
setenv PERL5LIB ${HALLD_EXTERNALPACKAGES}/perl_mods/lib/site_perl/5.8.2/i686-linux
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${XERCES_LIB}
setenv PATH ${HALLD_EXTERNALPACKAGES}/bin:${HALLD_EXTERNALPACKAGES}/bin/${OSNAME}:${PATH}
setenv MCFAST_DIR ${HALLD_EXTERNALPACKAGES}/mcfast_v5_2_Linux+2.4+GCC3_2_1
setenv STDHEP_DIR ${HALLD_EXTERNALPACKAGES}/stdhep_v5_01_Linux+2.4
setenv MCFIO_DIR ${MCFAST_DIR}/mcfio
setenv QQ_DIR ${HALLD_EXTERNALPACKAGES}/qq_v9_2b_Linux+2.4

# ROOT
setenv ROOTSYS /apps/root/PRO/root
setenv PATH ${ROOTSYS}/bin:${PATH}
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH ${ROOTSYS}/lib
else
	setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ROOTSYS}/lib
endif

# MySQL
if ( ! $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH /apps/mysql/lib/mysql
else
	setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/apps/mysql/lib/mysql
endif

# CERNLIB
if ( $OSNAME == 'Linux' ) then
	setenv CERN /apps/cernlib/i386_rhel3
	setenv CERN_LEVEL 2003
else if  ( $OSNAME == 'SunOS' ) then
	setenv CERN /site/cernlib/sun4_solaris8
	setenv CERN_LEVEL 2001
else
	setenv CERN /usr/local/cern
	setenv CERN_LEVEL PRO
endif

setenv CERN_ROOT ${CERN}/${CERN_LEVEL}
