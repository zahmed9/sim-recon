#
# GNUmakefile for all util libraries
#
MAKE=gmake
MAKEFILE=GNUmakefile
UNAME := $(shell uname)
# allow a hook for forcing use of the absoft compiler
COMPILER = default
ABSOFT = 
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    UNAME = IRIX64
  endif
endif

PBLD = $(MCFAST_DIR)/build/$(UNAME)/util/cmd_parse
GBLD = $(MCFAST_DIR)/build/$(UNAME)/util/general
ifdef SUBDIR
   SRCDIR = $(MCFAST_DIR)/util/$(SUBDIR)/src
   BLDDIR = $(MCFAST_DIR)/build/$(UNAME)/util/$(SUBDIR)
   FINC = -I$(SRCDIR)
endif

ifeq "$(UNAME)" "AIX"
   CC=cc
   F77=xlf
   CFLAG = -g -DAIX
   FFLAG = -g -qextname -DAIX
endif
ifeq "$(UNAME)" "HP-UX"
   CC=cc
   F77=fort77
   CFLAG = -Aa -D_HPUX_SOURCE -Dhpux
   FFLAG = -g  +ppu
endif
ifeq "$(UNAME)" "IRIX"
   CFLAG = -g
   FFLAG = -g -DIRIX
   CC=cc
   F77=f77
endif
ifeq "$(UNAME)" "IRIX64"
   CC=cc
   F77=f77
   CFLAG = -g -n32 -mips3
   FFLAG = -g -DIRIX -n32 -mips3
endif
ifeq "$(UNAME)" "Linux"
   CC=cc
   CFLAG = -g -DLinux
   ifeq "$(COMPILER)" "absoft"
      F77=/usr/local/bin/f77 #absoft
      FFLAG = -g
      ABSOFT = -absoft	
   else
      F77=g77
      FFLAG = -g
   endif
endif
ifeq "$(UNAME)" "OSF1"
   CC=cc
   F77=f77
   CFLAG = -g
   FFLAG = -g
endif
ifeq "$(UNAME)" "SunOS"
   CC=/opt/SUNWspro/bin/cc
   F77=f77
   CFLAG = -g -I/usr/ucbinclude
   FFLAG = -g
endif

PARSE_SRC = \
cmd_close \
cmd_downcase \
cmd_dump \
cmd_getitems \
cmd_getlun \
cmd_hex \
cmd_init \
cmd_integer \
cmd_keyword \
cmd_lenstr \
cmd_logical \
cmd_match \
cmd_octal \
cmd_open \
cmd_parse \
cmd_prompt \
cmd_readline \
cmd_readterm \
cmd_real \
cmd_string \
cmd_strip \
cmd_upcase \
cmd_asynck \
cstring_to_fstring \
fstring_to_cstring
PARSE_O  = $(addprefix $(PBLD)/,$(addsuffix .o,$(PARSE_SRC)))

GENERAL_SRC = \
format_float \
fp_exception \
get_cputime \
get_ctime \
get_gauss \
get_lun \
get_ranseed_from_time \
get_ranseeds \
get_time \
int_to_char \
rann \
set_ranseeds \
sifileops \
sortdn_float \
sortup_float \
sortdn_int \
sortup_int \
upper_case
GENERAL_O  = $(addprefix $(GBLD)/,$(addsuffix .o,$(GENERAL_SRC)))

#-----------------
#  Action section 
#-----------------

production:
	$(MAKE) -f $(MAKEFILE) "SUBDIR=cmd_parse" cmd_parse
	$(MAKE) -f $(MAKEFILE) "SUBDIR=general" general

cmd_parse: $(MCFLIB)/libcmd_parse.a
	@echo "finshed building cmd_parse"

general: $(MCFLIB)/libgeneral.a
	@echo "finshed building general"

$(MCFLIB)/libcmd_parse.a:   $(PARSE_O)
	ar urs $(MCFLIB)/libcmd_parse.a $(PARSE_O)
	rm -f $(PARSE_O)

$(MCFLIB)/libgeneral.a:   $(GENERAL_O)
	ar urs $(MCFLIB)/libgeneral.a $(GENERAL_O)
	rm -f $(GENERAL_O)

cleanobjs:
	rm -f $(PARSE_O)
	rm -f $(GENERAL_O)
	rm -f $(subst .o,.f,$(PARSE_O))
	rm -f $(subst .o,.f,$(GENERAL_O))

clean:
	rm -f $(PARSE_O)
	rm -f $(GENERAL_O)
	rm -f $(subst .o,.f,$(PARSE_O))
	rm -f $(subst .o,.f,$(GENERAL_O))
	rm -f $(MCFLIB)/libcmd_parse.a
	rm -f $(MCFLIB)/libgeneral.a

depend:
	@echo "no depend option for util"

glib:
	@echo "no glib option for util"

#--------------------------
#
#  Use f77mcf to do the compile
#
$(BLDDIR)/%.o: $(SRCDIR)/%.F
	f77mcf $(ABSOFT) -f77 "$(FFLAG)" -cpp "$(FINC)" -wdir "$(BLDDIR)" -sdir "$(SRCDIR)" $*.F
#
$(BLDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*.o $(CFLAG) $(SRCDIR)/$*.c

#--------------------------

.PHONY: clean cleanobjs glib production depend

.SUFFIXES : .F .c .o

