#
# GNUmakefile for dbin
#
# Just use lex.yy.c from the source code library instead of rebuilding it
#
# A huge number of warning messages are generated if the dbin executable
# is compiled with the -n32 switch for IRIX 6.x.  Therefore, the switch
# is not used.  The switch IS used to compile the dbin library.
#
MAKE=gmake
MAKEFILE=GNUmakefile
UNAME := $(shell uname)
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    UNAME = IRIX64
  endif
endif
#
# allow a hook for forcing use of the absoft compiler
COMPILER = default
ABSOFT = 

SRCDIR = $(MCFAST_DIR)/dbin/src
BLDDIR = $(MCFAST_DIR)/build/$(UNAME)/dbin
FINC = -I$(SRCDIR)

ifeq "$(UNAME)" "AIX"
   CC=cc
   F77=xlf
   CFLAG = -g -DAIX
   FFLAG = -g -qextname -DAIX
   SYSTEMLIBS = -ll -lm
endif
ifeq "$(UNAME)" "HP-UX"
   CC=cc
   F77=fort77
   CFLAG = -Aa -D_HPUX_SOURCE -Dhpux
   FFLAG = -g  +ppu
   SYSTEMLIBS = -ll -lm
endif
ifeq "$(UNAME)" "IRIX"
   CFLAG = -g
   FFLAG = -g -DIRIX
   CC=cc
   F77=f77
   SYSTEMLIBS = -ll -lm
endif
ifeq "$(UNAME)" "IRIX64"
   CC=cc
   F77=f77
   CFLAG = -g -n32 -mips3
   FFLAG = -g -DIRIX -n32 -mips3
   SYSTEMLIBS = -ll -lm
endif
ifeq "$(UNAME)" "Linux"
   CC=gcc
   CFLAG = -g
   ifeq "$(COMPILER)" "absoft"
      F77=/usr/local/bin/f77
      FFLAG = -g
      SYSTEMLIBS += -L/usr/local/packages/egcs/lib/gcc-lib/i586-pc-linux-gnu/egcs-2.91.57
      SYSTEMLIBS += -lg2c                                          #g77 runtime
      SYSTEMLIBS += -lm
   else
      F77=g77
      FFLAG = -g
      SYSTEMLIBS = -lm
   endif
endif	 
ifeq "$(UNAME)" "OSF1"
   CC=cc
   F77=f77
   CFLAG = -g
   FFLAG = -g
   SYSTEMLIBS = -ll -lm
endif
ifeq "$(UNAME)" "SunOS"
   CC=/opt/SUNWspro/bin/cc
   F77=f77
   CFLAG = -g -I/usr/ucbinclude
   FFLAG = -g
   SYSTEMLIBS = -ll -lm
endif


DBIN_SRCS := dbinf freeunit
DBIN_OBJS  = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(DBIN_SRCS)))

DBIN_CCSRCS := dbinc
DBIN_CCOBJS  = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(DBIN_CCSRCS)))

#-----------------
#  Action section 
#-----------------

production: $(MCFLIB)/libdbin.a $(MCFBIN)/dbin
	@echo "finshed building dbin"

$(MCFLIB)/libdbin.a: $(DBIN_CCOBJS) $(DBIN_OBJS)
	ar urs $(MCFLIB)/libdbin.a $(DBIN_CCOBJS) $(DBIN_OBJS)

$(MCFBIN)/dbin: $(BLDDIR)/lex.yy.o
	$(CC) -g -o $@ $<  $(SYSTEMLIBS) && echo dbin built ;

$(BLDDIR)/lex.yy.c: $(SRCDIR)/dbin.lex
#	@echo Running lex on $<; LANG=C; export LANG; lex $<; mv lex.yy.c $(BLDDIR)/lex.yy.c
	@echo Running lex on $<; setenv LANG=C; lex $<; mv lex.yy.c $(BLDDIR)/lex.yy.c


cleanobjs:
	rm -f $(BLDDIR)/*.o
	rm -f $(BLDDIR)/*.f

clean:
	rm -f $(BLDDIR)/*
	rm -f $(MCFLIB)/libdbin.a
	rm -f $(MCFBIN)/dbin

depend:
	@echo "no depend option for util"

glib:
	@echo "no glib option for util"

#--------------------------

$(BLDDIR)/lex.yy.o: $(SRCDIR)/lex.yy.c
ifeq "$(UNAME)" "HP-UX"
	@echo Compiling $<; cc -c -o $(BLDDIR)/lex.yy.o -g -Aa -D_HPUX_SOURCE $<
else
	@echo Compiling $<; $(CC) -c -o $(BLDDIR)/lex.yy.o -g $<
endif

$(BLDDIR)/%.o: $(SRCDIR)/%.F
	f77mcf $(ABSOFT) -f77 "$(FFLAG)" -cpp "$(FINC)" -wdir "$(BLDDIR)" -sdir "$(SRCDIR)" $*.F

$(BLDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*.o $(CFLAG) $(SRCDIR)/$*.c

#--------------------------

.PHONY: clean cleanobjs glib depend

.SUFFIXES : .F .f .c .o

