#!/bin/csh
# **********************************************************************
# * setup    Program Library Installlation ENVironment                 *
# *                                                                    *
# * Garren     3/01/94 Configured for QQ                               *
# **********************************************************************
 
  setenv QQLIB    $QQ_DIR/lib/libqqlib_noncleo.a
  setenv KORB     $QQ_DIR/lib/libkorb.a
  setenv TYPSCN   $QQ_DIR/lib/libcleoks.a
  setenv QQ_DECAY_FILE   $QQ_DIR/decay.dec
#
# add the executables to path (needed for building only)
  set path=($path $QQ_DIR/bin)
