#
# make procedure for mcfio  - use gmake
# This makefile builds ntuBrowser with histoscope if $HISTO_DIR is defined.
#
# note that this latest version of mcfio only works with stdhep 3.0 or later
#
UNAME := $(shell uname)

SRCDIR = ../src
EXAMS = ../exam.$(UNAME)
BLDDIR = ../build/$(UNAME)/src
LIBDIR = ../lib.$(UNAME)
BINDIR = ../bin.$(UNAME)

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
               
SRCS_RBIO  =   mcfio_FPrintDictionary.f \
               mcf_evt_xdr.c mcfio_FBinding.c mcfio_Util1.c \
               mcfio_Direct.c mcfio_Block.c mcfio_Sequential.c
CL_F_OBJS_RBIO = $(BLDDIR)/mcfio_FPrintDictionary.o $(BLDDIR)/mcf_evt_xdr.o \
                 $(BLDDIR)/mcfio_FBinding.o $(BLDDIR)/mcfio_Util1.o \
                 $(BLDDIR)/mcfio_Direct.o $(BLDDIR)/mcfio_Block.o \
                 $(BLDDIR)/mcfio_Sequential.o
               
#--------------------------

all: $(LIBDIR)/libFmcfio.a $(BINDIR)/ntuBuild $(BINDIR)/ntuBrowser \
            $(EXAMS)/tN1 $(EXAMS)/tN2

examples: $(EXAMS)/tN1 $(EXAMS)/tN2

oldexamples: $(EXAMS)/t1 $(EXAMS)/t2 $(EXAMS)/t3 $(EXAMS)/t4 $(EXAMS)/t5 \
             $(EXAMS)/t6 $(EXAMS)/t7

$(LIBDIR)/libFmcfio.a: $(CL_F_OBJS) 
	$(AR) -urs $(LIBDIR)/libFmcfio.a $(CL_F_OBJS) 
	
$(LIBDIR)/libFmcfioRbio.a: $(CL_F_OBJS_RBIO) 
	$(AR) -urs $(LIBDIR)/libFmcfioRbio.a $(CL_F_OBJS_RBIO) 

$(BINDIR)/ntuBuild: $(CL_NTUBLD_OBJS) $(LIBDIR)/libFmcfio.a \
                 $(BLDDIR)/mcf_BrowseUtil1.o $(BLDDIR)/mcf_nTupleBuild.o
	$(CC) $(CFLAGS) -o $@ \
	$(BLDDIR)/mcf_nTupleBuild.o \
	$(CL_NTUBLD_OBJS) \
	$(BLDDIR)/mcf_BrowseUtil1.o \
	$(LIBDIR)/libFmcfio.a \
        $(MXTLIBS)

$(BINDIR)/ntuBrowser: $(CL_BROWSER_OBJS) $(CL_NTUBLD_OBJS) $(LIBDIR)/libFmcfio.a
	$(CC) $(CFLAGS) -o $@ \
	$(CL_BROWSER_OBJS) \
	$(CL_NTUBLD_OBJS) \
	$(LIBDIR)/libFmcfio.a $(HLIB) \
        $(MXTLIBS)
        
$(EXAMS)/tN1:  $(BLDDIR)/tN1.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/tN1.o \
		$(LIBDIR)/libFmcfio.a $(CFLIBS)

$(EXAMS)/tN2:  $(BLDDIR)/tN2.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/tN2.o \
		$(LIBDIR)/libFmcfio.a $(CFLIBS)

$(EXAMS)/t1:  $(BLDDIR)/t1.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@  $(BLDDIR)/t1.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       

$(EXAMS)/t1_tape:  $(BLDDIR)/t1_tape.o libFmcfioRbio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t1_tape.o libFmcfioRbio.a \
		$(RBIO_DIR)/lib/rbio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t2:  $(BLDDIR)/t2.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t2.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t2_tape:  $(BLDDIR)/t2_tape.o libFmcfioRbio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t2_tape.o libFmcfioRbio.a \
	$(RBIO_DIR)/lib/rbio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t3:  $(BLDDIR)/t3.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t3.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t4:  $(BLDDIR)/t4.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t4.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t5:  $(BLDDIR)/t5.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t5.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t6:  $(BLDDIR)/t6.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t6.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)
	       
$(EXAMS)/t7:  $(BLDDIR)/t7.o $(LIBDIR)/libFmcfio.a
	$(F77) $(FFLAGS) -o $@ $(BLDDIR)/t7.o $(LIBDIR)/libFmcfio.a \
		$(STDHEP_DIR)/lib/libstdhep.a $(CFLIBS)

tree:
	-test -d ../build || mkdir -p ../build
	-test -d ../build/$(UNAME) || mkdir -p ../build/$(UNAME)
	-test -d ../build/$(UNAME)/src || mkdir -p ../build/$(UNAME)/src

cleanobjs:
	rm -f $(BLDDIR)/*.o $(BLDDIR)/t*.f
	       
clean:
	rm -f $(BLDDIR)/*.o $(BLDDIR)/t*.f
	rm -f $(LIBDIR)/libFmcfio.a
	rm -f $(BINDIR)/ntuBuild
	rm -f $(BINDIR)/ntuBrowser
	rm -f $(EXAMS)/tN1
	rm -f $(EXAMS)/tN2
	rm -f $(EXAMS)/t1
	rm -f $(EXAMS)/t2
	rm -f $(EXAMS)/t3
	rm -f $(EXAMS)/t4
	rm -f $(EXAMS)/t5
	rm -f $(EXAMS)/t6
	rm -f $(EXAMS)/t7

glib:
	@echo "libraries are debug by default"

#--------------------------

$(BLDDIR)/%.o: $(SRCDIR)/%.F
	$(BPHYS)/bin.$(UNAME)/f77bb -f77 "$(FFLAGS)" -cpp "$(FINC)" -wdir "$(BLDDIR)" -sdir "$(SRCDIR)" $*.F

$(BLDDIR)/%.o: $(SRCDIR)/%.f
	$(F77) -c -o $(BLDDIR)/$*.o $(FFLAGS) $(SRCDIR)/$*.f

$(BLDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*.o $(CFLAGS) $(CINC) $(SRCDIR)/$*.c

#--------------------------

.PHONY: clean cleanobjs glib tree

.SUFFIXES : .F .f .c .o

#--------------------------

# Fortran dependencies
tN1: mcfio.inc glob22.inc glo23.inc
tN2: mcfio.inc glob22.inc glo23.inc


# DO NOT DELETE THIS LINE -- make depend depends on it.

mcf_evt_xdr.o: mcf_xdr.h
mcfio_Direct.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h
mcfio_SeqDummy.c:mcfio_Sequential.h
mcfio_Util1.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h \
                mcfio_Sequential.h
mcfio_block.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Block.h              

