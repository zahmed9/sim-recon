#
# MCFIO makefile
#
# Platform independent part of make procedure for mcfast io
# tool, included by machine specific makefiles.
# build MCFio
#
# note that this latest version of mcfio only works with stdhep 3.0 or later
#
UNAME := $(shell uname)
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    UNAME = IRIX64
  endif
endif

SRCDIR = $(MCFAST_DIR)/mcfio/src
BLDDIR = $(MCFAST_DIR)/build/$(UNAME)/mcfio/src
EXAMS =
# allow a hook for forcing use of the absoft compiler
COMPILER = default
ABSOFT = 

AR=ar
LIBS=
CCLIBS=
CFLIBS= $(MCFAST_DIR)/lib.$(UNAME)/libio.a
FFLIBS= 

ifeq "$(UNAME)" "AIX"
   CC=cc
   F77=xlf
   CFLAGS= -g -DAIX
   FFLAGS=-g -qextname
   MXTLIBS= -lXm -lXt -lX11 -lm -lbsd -lxlf
endif
ifeq "$(UNAME)" "HP-UX"
   CC=cc
   F77=fort77
   CFLAGS= -g -Aa -D_HPUX_SOURCE
   FFLAGS=-g -DHP-UX
   CFLIBS+= +U77 +ppu +E1 
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
endif
ifeq "$(UNAME)" "IRIX"
   CC=cc
   F77=f77
   CFLAGS= -g2 -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS=-g2
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
endif
ifeq "$(UNAME)" "IRIX64"
   CC=cc
   F77=f77
   CFLAGS= -g2 -n32 -mips3 -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS=-g2 -n32 -mips3
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
endif
ifeq "$(UNAME)" "Linux"
   CC=cc
   CFLAGS = -g2 -DXTFUNCPROTO -DFUNCPROTO -I/usr/X11/include
   ##MXTLIBS = -L/usr/X11/lib -lXm -lXt -LX11  -lm
   MXTLIBS = /usr/X11R6/lib/libXm.a -L/usr/X11R6/lib -lX11 -lXt -lXp -lXext -lm
   ifeq "$(COMPILER)" "absoft"
      F77=/usr/local/bin/f77
      ABSOFT= -absoft
      CFLIBS += -L$(EGCS_DIR)/lib/gcc-lib/i686-pc-linux-gnu/egcs-2.91.57 -lg2c
      FFLAGS = -g
   else
      F77=g77
      FFLAGS = -g
   endif
endif
ifeq "$(UNAME)" "OSF1"
   CC=cc
   F77=f77
   CFLAGS= -g2 -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS=-g2
   MXTLIBS = -lXm -lXt -lX11 -lm -lfor -lots
endif
ifeq "$(UNAME)" "SunOS"
   CC=/opt/SUNWspro/bin/cc
   F77=f77
   CFLAGS=-g -I/usr/openwin/include -I/usr/dt/include -DMOTIF12
   FFLAGS=-g
   LIBS+= -L/usr/openwin/lib -L/opt/SUNWmotif/lib -lm -Bstatic -lXm \
	   -Bdynamic -lXt -lX11 -lgen -R /usr/openwin/lib -lF77
   CCLIBS+= -lm -lF77 -lsocket -lnsl
   CFLIBS+= -lm -lF77 -lm 
   FFLIBS += -lm -lgen -lF77 -lV77 -lnsl -lm  
   MXTLIBS = -L/usr/openwin/lib -L/usr/dt/lib -lm -lXm -lXt -lX11 -lgen \
	  -lF77 -lM77 -lsunmath -lsocket -lnsl -R /usr/openwin/lib -R /usr/dt/lib
endif

FINC = -I$(SRCDIR) -I$(STDHEP_DIR)/src/inc -I$(MCFAST_DIR)/inc/event
CINC = -I$(SRCDIR)
HLIB =
ifdef HISTO_DIR
   CFLAGS += -DHISTO
   CINC += -I$(HISTO_DIR)/include
   HLIB += $(HISTO_DIR)/lib/libCHisto.a
endif

CL_F_SRC    = mcfio_FPrintDictionary \
               mcf_evt_xdr mcfio_FBinding mcfio_Util1 \
               mcfio_Direct mcfio_SeqDummy mcfio_Block \
               mcf_ntubldInit mcf_ntuBldDbinc \
               mcf_NTuIOFiles  mcf_NTuIOUtils
CL_F_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(CL_F_SRC)))

CL_NTUBLD_SRC  = \
               mcf_NTuBuildWindow mcf_NTuBldMenu \
               mcf_NTuBldHelp mcf_NTuBldFiles \
               mcf_ntubldInit mcf_ntuBldDbinc DialogF misc help \
               getfiles fileUtils
CL_NTUBLD_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(CL_NTUBLD_SRC)))

CL_BROWSER_SRC = mcf_BrowseMainPanel mcf_BrowseMainMenu \
               mcf_BrowseHelp  mcf_BrowseMainProgram \
               mcf_BrowseUtil1 mcf_BrowseUtil2
CL_BROWSER_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(CL_BROWSER_SRC)))
               
#--------------------------

production: $(MCFLIB)/libFmcfio.a $(MCFBIN)/ntuBuild $(MCFBIN)/ntuBrowser

all: $(MCFLIB)/libFmcfio.a $(MCFBIN)/ntuBuild $(MCFBIN)/ntuBrowser 

examples: $(EXAMS)/tN1 $(EXAMS)/tN2

$(MCFLIB)/libFmcfio.a: $(CL_F_OBJS) 
	$(AR) -urs $(MCFLIB)/libFmcfio.a $(CL_F_OBJS)

$(MCFBIN)/ntuBuild: $(CL_NTUBLD_OBJS) $(MCFLIB)/libFmcfio.a \
                 $(BLDDIR)/mcf_BrowseUtil1.o $(BLDDIR)/mcf_nTupleBuild.o
	$(CC) $(CFLAGS) -o $@ \
	$(BLDDIR)/mcf_nTupleBuild.o \
	$(CL_NTUBLD_OBJS) \
	$(BLDDIR)/mcf_BrowseUtil1.o \
	$(MCFLIB)/libFmcfio.a $(HLIB) \
        $(MXTLIBS)

$(MCFBIN)/ntuBrowser: $(CL_BROWSER_OBJS) $(CL_NTUBLD_OBJS) $(MCFLIB)/libFmcfio.a
	$(CC) $(CFLAGS) -o $@ \
	$(CL_BROWSER_OBJS) \
	$(CL_NTUBLD_OBJS) \
	$(MCFLIB)/libFmcfio.a $(HLIB) \
        $(MXTLIBS)
        
$(EXAMS)/tN1:  $(BLDDIR)/tN1.o $(MCFLIB)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/tN1.o \
		$(MCFLIB)/libFmcfio.a $(CFLIBS)

$(EXAMS)/tN2:  $(BLDDIR)/tN2.o $(MCFLIB)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/tN2.o \
		$(MCFLIB)/libFmcfio.a $(CFLIBS)

cleanobjs:
	rm -f  $(CL_F_OBJS) $(CL_NTUBLD_OBJS) $(CL_BROWSER_OBJS) \
		$(BLDDIR)/tN1.o $(BLDDIR)/tN2.o $(BLDDIR)/tN1.f \
		$(BLDDIR)/tN2.f $(BLDDIR)/mcf_nTupleBuild.o
	       
clean:
	rm -f  $(CL_F_OBJS) $(CL_NTUBLD_OBJS) $(CL_BROWSER_OBJS) \
		$(BLDDIR)/tN1.o $(BLDDIR)/tN2.o $(BLDDIR)/tN1.f \
		$(BLDDIR)/tN2.f $(BLDDIR)/mcf_nTupleBuild.o
	rm -f $(MCFLIB)/libFmcfio.a
	rm -f $(MCFBIN)/ntuBuild
	rm -f $(MCFBIN)/ntuBrowser
	rm -f $(MCFBIN)/ntuBrowserHisto
	rm -f $(EXAMS)/tN1
	rm -f $(EXAMS)/tN2

glib:
	@echo "libraries are debug by default"

#--------------------------

$(BLDDIR)/%.o: $(SRCDIR)/%.F
	$(MCFAST_DIR)/bin/f77mcf $(ABSOFT) -f77 "$(FFLAGS)" -cpp "$(FINC)" -wdir "$(BLDDIR)" -sdir "$(SRCDIR)" $*.F

$(BLDDIR)/%.o: $(SRCDIR)/%.f
	$(F77) -c -o $(BLDDIR)/$*.o $(FFLAGS) $(SRCDIR)/$*.f

$(BLDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*.o $(CFLAGS) $(CINC) $(SRCDIR)/$*.c

#--------------------------

.PHONY: clean cleanobjs glib

.SUFFIXES : .F .f .c .o


#--------------------------

# Fortran dependencies
tN1: mcfio.inc glob22.inc glo23.inc
tN2: mcfio.inc glob22.inc glo23.inc


# DO NOT DELETE THIS LINE -- make depend depends on it.
depend:

mcf_evt_xdr.o: mcf_xdr.h
mcfio_Direct.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h
mcfio_SeqDummy.c:mcfio_Sequential.h
mcfio_Util1.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h \
                mcfio_Sequential.h
mcfio_block.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Block.h              

