#
# make procedure for mcfio  - use gmake
# This makefile builds ntuBrowser with histoscope if $HISTO_DIR is defined.
#
# note that this latest version of mcfio only works with stdhep 3.0 or later
#
UNAME := $(shell uname)
ifeq "$(UNAME)" "IRIX"
    IRIX6 = $(findstring 6,$(shell uname -r))
    ifeq "$(IRIX6)" "6"
	UNAME=IRIX64
    endif
endif

ifeq "$(UNAME)" "Linux"
    L22 = $(findstring 2.2,$(shell uname -r))
    ifeq "$(L22)" "2.2"
	UNAME=Linux22
    endif
endif

ifndef DEBUG
    DEBUG = none
    DFLG =
    SFX =
else
    DFLG = $(DEBUG)
    SFX = _g
endif

SRCDIR = ../mcfio
BLDDIR = ../mcfio
LIBDIR = $(STDHEP_DIR)/lib
BINDIR = $(STDHEP_DIR)/bin

AR=ar
LIBS=
CCLIBS=
FFLIBS= 

ifeq "$(UNAME)" "AIX"
   CC=cc
   F77=xlf
   CFLAGS= -DAIX
   FFLAGS= -qextname
   CPP = /lib/cpp
   CPPFLG= -C -P
   MXTLIBS= -lXm -lXt -lX11 -lm -lbsd -lxlf
endif
ifeq "$(UNAME)" "HP-UX"
   CC=cc
   F77=fort77
   CFLAGS= -Aa -D_HPUX_SOURCE
   FFLAGS= -DHP-UX +ppu
   CPP = /lib/cpp
   CPPFLG= -C -P
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
endif
ifeq "$(UNAME)" "IRIX"
   CC=cc
   F77=f77
   CPP = /lib/cpp
   CPPFLG= -C -P
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
   CFLAGS= -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS=
   EXES = $(BINDIR)/ntuBuild$(SFX) $(BINDIR)/ntuBrowser$(SFX) 
endif
ifeq "$(UNAME)" "IRIX64"
   CC=cc
   F77=f77
   CPP = /lib/cpp
   CPPFLG= -C -P
   CFLAGS= -n32 -mips3 -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS= -n32 -mips3
   MXTLIBS = -lXm -lXt -lX11 -lPW -lm
   EXES = $(BINDIR)/ntuBuild$(SFX) $(BINDIR)/ntuBrowser$(SFX) 
endif
ifeq "$(UNAME)" "Linux"
   CC=gcc
   F77=g77
   CFLAGS= -I/usr/X11/include
   FFLAGS= -fdebug-kludge -fno-second-underscore
   CPP = gcc -E
   CPPFLG= -C -P
   MXTLIBS = /usr/X11R6/lib/libXm.a -L/usr/X11R6/lib -lX11 -lXt -lXp -lXext -lm
   EXES = $(BINDIR)/ntuBuild$(SFX) $(BINDIR)/ntuBrowser$(SFX) 
endif
ifeq "$(UNAME)" "Linux22"
   CC=/usr/bin/gcc
   F77=/usr/bin/g77
   CFLAGS= -I/usr/X11/include
   FFLAGS= -fdebug-kludge -fno-second-underscore
   CPP = /usr/bin/gcc -E
   CPPFLG= -C -P
   MXTLIBS = /usr/X11R6/lib/libXm.a -L/usr/X11R6/lib -lX11 -lXt -lXp -lXext -lm
endif
ifeq "$(UNAME)" "OSF1"
   CC=cc
   F77=f77
   CFLAGS= -DXTFUNCPROTO -DFUNCPROTO
   FFLAGS=
   CPP = cpp
   CPPFLG= -C -P
   MXTLIBS = -lXm -lXt -lX11 -lm -lfor -lots
   EXES = $(BINDIR)/ntuBuild$(SFX) $(BINDIR)/ntuBrowser$(SFX) 
endif
ifeq "$(UNAME)" "SunOS"
   CC=/opt/SUNWspro/bin/cc
   F77=f77
   CFLAGS= -I/usr/openwin/include -I/usr/dt/include -DMOTIF12
   FFLAGS=
   CPP = /usr/ccs/lib/cpp
   CPPFLG= -C -P
   LIBS+= -L/usr/openwin/lib -L/opt/SUNWmotif/lib -lm -Bstatic -lXm \
	   -Bdynamic -lXt -lX11 -lgen -R /usr/openwin/lib -lF77
   CCLIBS+= -lm -lF77 -lsocket -lnsl
   FFLIBS += -lm -lgen -lF77 -lV77 -lnsl -lm  
   MXTLIBS = -L/usr/openwin/lib -L/usr/dt/lib -lm -lXm -lXt -lX11 -lgen \
	  -lF77 -lM77 -lsunmath -lsocket -lnsl -R /usr/openwin/lib -R /usr/dt/lib
   EXES = $(BINDIR)/ntuBuild$(SFX) $(BINDIR)/ntuBrowser$(SFX) 
endif

FINC = -I$(SRCDIR) -I$(STDHEP_DIR)/src/inc -I$(MCFAST_DIR)/inc/event
CINC = -I$(SRCDIR)
HLIB =
ifdef HISTO_DIR
   CFLAGS += -DHISTO
   CINC += -I$(HISTO_DIR)/include
   HLIB += $(HISTO_DIR)/lib/libCHisto.a
endif
CPPFLGS = $(CPPFLG) -DUNIX $(FINC)

CL_F_SRC    = mcfio_FPrintDictionary \
               mcf_evt_xdr mcfio_FBinding mcfio_Util1 \
               mcfio_Direct mcfio_SeqDummy mcfio_Block \
               mcf_ntubldInit mcf_ntuBldDbinc \
               mcf_NTuIOFiles  mcf_NTuIOUtils
CL_F_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix $(SFX).o,$(CL_F_SRC)))

CL_NTUBLD_SRC  = \
               mcf_NTuBuildWindow mcf_NTuBldMenu \
               mcf_NTuBldHelp mcf_NTuBldFiles \
               mcf_ntubldInit mcf_ntuBldDbinc DialogF misc help \
               getfiles fileUtils
CL_NTUBLD_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix $(SFX).o,$(CL_NTUBLD_SRC)))

CL_BROWSER_SRC = mcf_BrowseMainPanel mcf_BrowseMainMenu \
               mcf_BrowseHelp  mcf_BrowseMainProgram \
               mcf_BrowseUtil1 mcf_BrowseUtil2
CL_BROWSER_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix $(SFX).o,$(CL_BROWSER_SRC)))
               
SRCS_RBIO  =   mcfio_FPrintDictionary.F \
               mcf_evt_xdr.c mcfio_FBinding.c mcfio_Util1.c \
               mcfio_Direct.c mcfio_Block.c mcfio_Sequential.c
CL_F_OBJS_RBIO = $(BLDDIR)/mcfio_FPrintDictionary$(SFX).o $(BLDDIR)/mcf_evt_xdr$(SFX).o \
                 $(BLDDIR)/mcfio_FBinding$(SFX).o $(BLDDIR)/mcfio_Util1$(SFX).o \
                 $(BLDDIR)/mcfio_Direct$(SFX).o $(BLDDIR)/mcfio_Block$(SFX).o \
                 $(BLDDIR)/mcfio_Sequential$(SFX).o
               
#--------------------------

all: $(LIBDIR)/libFmcfio$(SFX).a $(EXES) 

$(LIBDIR)/libFmcfio$(SFX).a: $(CL_F_OBJS) 
	$(AR) -urs $(LIBDIR)/libFmcfio$(SFX).a $(CL_F_OBJS) 
	
$(LIBDIR)/libFmcfioRbio$(SFX).a: $(CL_F_OBJS_RBIO) 
	$(AR) -urs $(LIBDIR)/libFmcfioRbio$(SFX).a $(CL_F_OBJS_RBIO) 

$(BINDIR)/ntuBuild$(SFX): $(CL_NTUBLD_OBJS) $(LIBDIR)/libFmcfio$(SFX).a \
                 $(BLDDIR)/mcf_BrowseUtil1$(SFX).o $(BLDDIR)/mcf_nTupleBuild$(SFX).o
	$(CC) $(CFLAGS) -o $@ \
	$(BLDDIR)/mcf_nTupleBuild$(SFX).o \
	$(CL_NTUBLD_OBJS) \
	$(BLDDIR)/mcf_BrowseUtil1$(SFX).o \
	$(LIBDIR)/libFmcfio$(SFX).a $(HLIB) \
        $(MXTLIBS)

$(BINDIR)/ntuBrowser$(SFX): $(CL_BROWSER_OBJS) $(CL_NTUBLD_OBJS) \
                            $(LIBDIR)/libFmcfio$(SFX).a
	$(CC) $(CFLAGS) -o $@ \
	$(CL_BROWSER_OBJS) \
	$(CL_NTUBLD_OBJS) \
	$(LIBDIR)/libFmcfio$(SFX).a $(HLIB) \
        $(MXTLIBS)
        
clean:
	rm -f $(BLDDIR)/*$(SFX).o $(BLDDIR)/*.f
	       
realclean:
	rm -f $(BLDDIR)/*.o
	rm -f $(LIBDIR)/libFmcfio*.a
	rm -f $(BINDIR)/ntuBuild*
	rm -f $(BINDIR)/ntuBrowser*

#--------------------------

$(BLDDIR)/%.o: $(SRCDIR)/%.F
	$(CPP) $(CPPFLGS) $< > $*.f
	$(F77) -c -o $(BLDDIR)/$*.o $(FFLAGS) $(SRCDIR)/$*.f

$(BLDDIR)/%_g.o: $(SRCDIR)/%.F
	$(CPP) $(CPPFLGS) $< > $*.f
	$(F77) -c -o $(BLDDIR)/$*_g.o $(FFLAGS) $(DFLG) $(SRCDIR)/$*.f

$(BLDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*.o $(CFLAGS) $(CINC) $(SRCDIR)/$*.c

$(BLDDIR)/%_g.o: $(SRCDIR)/%.c
	$(CC) -c -o $(BLDDIR)/$*_g.o $(CFLAGS) $(DFLG) $(CINC) $(SRCDIR)/$*.c

#--------------------------

.PHONY: realclean clean

.SUFFIXES : 		# cancel implicit rules
.SUFFIXES : .o .c .F

#--------------------------


# DO NOT DELETE THIS LINE -- make depend depends on it.

mcf_evt_xdr.o: mcf_xdr.h
mcfio_Direct.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h
mcfio_SeqDummy.c:mcfio_Sequential.h
mcfio_Util1.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h \
                mcfio_Sequential.h
mcfio_block.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Block.h              
mcf_evt_xdr_g.o: mcf_xdr.h
mcfio_Direct_g.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h
mcfio_SeqDummy_g.c:mcfio_Sequential.h
mcfio_Util1_g.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Direct.h \
                mcfio_Sequential.h
mcfio_block_g.o: mcf_xdr.h mcfio_Dict.h mcfio_Util1.h mcfio_Block.h              

