###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################
ROOTLIBS      = -L$(ROOTSYS)/lib -lNew -lBase -lCint -lClib -lCont -lFunc \
                -lGraf -lGraf3d -lHist -lHtml -lMatrix -lMeta -lMinuit -lNet \
                -lPostscript -lProof -lTree -lUnix -lZip
ROOTGLIBS     = -lGpad -lGui -lGX11 -lX3d

# Alpha/OSF with g++
CXX           = g++
#CXXFLAGS      = -O -I$(ROOTSYS)/include
CXXFLAGS      = -O -Wall -fno-rtti -fno-exceptions -fPIC -I$(ROOTSYS)/include -g
LD            = g++
LDFLAGS       = -g
SOFLAGS       = -Wl,-expect_unresolved,* shared
RLIBS          = $(ROOTLIBS) -lg++ -lm


#############################
hostname = $(shell hostname)
# Machine dependent stuff.
MAP = 
F77 = f77 
#F77bb = f77
#F77bb = f77mcf
CC=gcc
CCxx=g++
CFLAG =
CRNLIB= /usr/local/lib
# some options are untested
ifeq "$(UNAME)" "AIX"
  FFLAGS = -g
  FP_EXCEPTION =
  LOPTION=
  MAP    = -Wl,-m > $@.map
  LIBS= -lXm -lXt -lX11 -lm -lbsd -lxlf
endif
ifeq "$(UNAME)" "HP-UX"
  FFLAGS = -g 
  FP_EXCEPTION =
  LOPTION=
  MAP    = -Wl,-m > $@.map
  LIBS= -L /usr/lib/X11R5 -L /usr/lib/Motif1.2 -lm -lXm -lXt -lX11 -lU77 -lcl
endif
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    FFLAGS = -g -n32
    FP_EXCEPTION = -lfpe
    LIBS=-lXm -lXt -lX11 -lftn -lsun -lPW -lm
  else
    FFLAGS = -g 
    FP_EXCEPTION = /usr/lib/libfpe.a
    LIBS=-lXm -lXt -lX11 -lm -lF77 -lI77 -lU77 -lisam -lsun -lPW -lm
  endif
  LOPTION= 
  MAP    = -Wl,-m > $@.map
endif
ifeq "$(UNAME)" "IRIX64"
  FFLAGS = -g -n32
  FP_EXCEPTION = -lfpe
  LOPTION= 
  MAP    = -Wl,-m > $@.map
  LIBS=-lXm -lXt -lX11 -lftn -lsun -lPW -lm
endif
ifeq "$(UNAME)" "OSF1"
  CFLAG= -fno-builtin -ieee
  FFLAGS = -g
  FP_EXCEPTION = -L/usr/lib
  LOPTION= -nofor_main  
  MAP    = -Wl,-m > $@.map
  LIBS=-lXm -lXt -lX11 -lm -lfor -lots 
endif
ifeq "$(UNAME)" "SunOS"
  FFLAGS = -g 
  FP_EXCEPTION =
  LOPTION=
  MAP    = -Qoption ld -m > $@.map
  LIBS= -L/vol/pub/X11R5/lib -lX11 -lm -lsocket -lnsl -lV77
endif

# Include files
INC1 = $(MCFINC)/event
INC2 = $(MCFINC)/geom
INC3 = $(MCFINC)/trig
INC4 = $(STDHEP_DIR)/src/inc
INC5 = $(MCFIO_DIR)/src
INC6 = $(MCFSRC)/dst
INC7 = $(MCFSRC)/dbin_mcfast
INC8 = .

# Include path.  
FINC = -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) -I$(INC5) \
           -I$(INC6) -I$(INC7) -I$(INC8)

LIB = $(MCFAST_DIR)/lib.$(UNAME)

#User .o files are listed here
USER_OBJ = main_args.o usr_analysis.o usr_init.o usr_fill_event.o \
	usr_summary.o usr_hbsummary.o usr_mcfio_out.o usr_dump.o usr_output.o 


#next line is needed for histoscope... Add before PACKLIB
HISLIB = $(HISTO_DIR)/lib/libFHistoHB.a $(LIBS)

# deal with differences between product and ~bphyslib
ifdef MCFREL
  MCFIO = $(MCFAST_DIR)/lib.$(UNAME)/libFmcfio.a
else
  MCFIO = $(MCFIO_DIR)/lib.$(UNAME)/libFmcfio.a
endif


# Tell gmake to forget about the all implicit rules and then 
# define only the ones that we want - all this is to get rid of
# the .f rule, which bites us because f77mcf creates .f files in
# .F.o step ( not the .f.o step ) and these subsequently confuse gmake.
# A corollary is that one cannot make .f files with this GNUmakefile.
.SUFFIXES : 
.SUFFIXES : .c .F .o .h .inc .hh

#-----------------
#  Action section        removed      main_cxx.o main_args.o   usr_2root.o TMCFastHepEvt.o   $(RLIBS)  $(GLIB)/main_args.o
#-----------------



all: mcfast db

mcfast: $(USER_OBJ) 
	$(F77)  $(LOPTION)  $(FFLAGS) -o mcfast   $(USER_OBJ)   -L$(LIB)  -L$(GLIB)  -lgen -ldatafile -ltrig -lgraph -luser -lmuon -lvertex -ltrack -lsec_int -lgamma -lshower -lgeom -lio -lutil -ldbin_mcfast -ldbin -ldst -lgeneral -lcmd_parse $(STDHEP_DIR)/lib/libstdhep.a $(STDHEP_DIR)/lib/libstdhepC.a $(MCFIO) $(QQLIB) $(TYPSCN) -L$(CRNLIB) -lpacklib -lmathlib -lkernlib $(FP_EXCEPTION) $(LIBS)  

main_cxx.o: main_cxx.cxx
	g++ -O -Wall -fno-rtti -fno-exceptions -fPIC -I/usr/local/root/include -g -c main_cxx.cxx

read_output: read_output.c
	gcc -I/dsk19/halld/source/stdhep/src/inc/ -I. -g -fno-builtin -ieee read_output.c -o read_output


# removed $(MAP) from above
#

db:
ifdef MCFREL
	@ln -s $(MCFAST_DIR)/mcfast/db db
else
	@ln -s ../db db
endif

clean:
	rm -f db
	rm -f mcfast
	rm -f mcfast.map
	rm -f $(patsubst %.F,%.f,$(wildcard *.F))
	rm -f *.o

.F.o:
	$(F77bb) -f77 $(FFLAGS)  -cpp $(FINC) -c $?

.c.o:
	$(CC) -I/dsk19/halld/source/stdhep/src/inc/ -I. -g -c $(CFLAG) $?

#
#$Id$
#
#$Log$
#Revision 1.3  1998/11/19 00:14:53  eugenio
#Added some more usr_code
#
#Revision 1.2  1998/10/10 18:06:46  eugenio
#Added usr_mcfio_out.F
#
#Revision 1.1.1.1  1998/10/08 05:19:53  eugenio
#MCFast for HallD
#
#Revision 1.1.1.1  1998/10/04 21:20:47  eugenio
#Hall D source for MCFast
#
# Revision 1.8.2.3.4.7  1998/06/10  19:08:05  kutschke
# Remove redundant -lgeom.
#
# Revision 1.8.2.3.4.6  1998/05/21  21:35:08  garren
# Fix for IRIX+6 when uname is IRIX
#
# Revision 1.8.2.3.4.5  1998/05/18  20:18:43  kutschke
# Fix LIBS for SUNOS
#
# Revision 1.8.2.3.4.4  1998/05/11  18:19:46  kutschke
# Use @ to define map file.  Reformat long line.
#
# Revision 1.8.2.3.4.3  1998/03/17  22:31:37  kutschke
# remove .f from suffix list. Add Id and Log
#
#
