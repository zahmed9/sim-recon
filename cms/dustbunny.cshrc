#
# Place these enviroment variable definitions in your .cshrc
# NOTE: to toggle between PRODUCTION and DEVELOPMENT you need to
#       redefine CLAS_LEVEL to your choice
#
setenv OSCLAS "`uname`"
setenv POSIX_SHELL /usr/bin/sh

# change the username to your username on JLABS1

# define the top of the "clas" tree on your local box


setenv CLAS_CMS /manak/halld/cms

setenv CLAS_ROOT  $CLAS_LOCATION
setenv BUILDS     $CLAS_ROOT/builds/
setenv CLAS_PROD  $BUILDS/PRODUCTION
setenv CLAS_DEVEL $BUILDS/DEVELOPMENT







