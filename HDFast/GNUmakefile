###################################################
#  Makefile: General library and executable maker 
#            for HDFast 
#
#
# Created  1998/12/16  eugenio
# Last Modified 29-Mar-2000  eugenio
#
# This makefile is currently working 
# for OSF1 and Linux only. Contact Paul Eugenio (CMU)
# to implement other platforms or see
# the osf implementation which links
# to the root libs
#
# Before making anything; source setup4.4 and
# the standard .halldrc file.  ALSO, you need
# to make libTMCfast.a in the mcroot development
#################################################

#
# ROOT Crap
ObjSuf        = o
SrcSuf        = cxx
ExeSuf        =
DllSuf        = so
MCFASTLIB      = $(TMCFastO)
OutPutOpt     = -o

# root libs for ver 2.22
#ROOTLIBS      = -L$(ROOTSYS)/lib -lNew -lBase -lCint -lClib -lCont -lFunc \
#                -lGraf -lGraf3d -lHist -lHtml -lMatrix -lMeta -lMinuit -lNet \
#                -lPostscript -lProof -lTree -lUnix -lZip
#ROOTGLIBS     = -lGpad -lGui -lGX11 -lX3d

ROOTLIBS      = $(shell root-config --libs)
ROOTGLIBS     = $(shell  root-config --glibs)
    



TMCFAST_INC = -I$(HALLD_HOME)/src/mcroot

#HDFASTLIBS = -L$(HALLD_HOME)/lib/$(UNAME)  -lTMCFast
HDFASTLIBS = $(HALLD_HOME)/lib//Linux/libTMCFast.a

#HDFASTLIBS =    TMCFastHepEvt.o  TMCFastHepEvtDict.o TMCFastTOF.o TMCFastTOFDict.o \
#		TMCFastOfflineTrack.o  TMCFastOfflineTrackDict.o \
#		TMCFastHepParticle.o  TMCFastHepParticleDict.o \
#		TMCFastCalorimeter.o TMCFastCalorimeterDict.o \
#		TMCFastCalorHits.o TMCFastCalorHitsDict.o \
#		TCalHitTracks.o TCalHitTracksDict.o 

#







# Machine dependent stuff.
hostname = $(shell hostname)
MAP = 
COM = g++
F77bb = g77
CFLAG = -g
DPG	:= get_c_dep
FDPG	:= mdep
DEPFILE  := GNUmakefile.depend
FLAGFILE := mcfast_out.flag
#
# some options are untested
ifeq "$(UNAME)" "AIX"
  CFLAG += -DAIX
  FFLAG = -g
  FP_EXCEPTION =
  LOPTION=
  #MAP    = -Wl,-m > $@.map
  LIBS= -lXm -lXt -lX11 -lm -lbsd -lxlf -lxlf90
endif
#ifeq "$(UNAME)" "HP-UX"
#  FFLAG = -g
#  FP_EXCEPTION =
#  LOPTION=
#  MAP    = -Wl,-m > $@.map
#  LIBS= -L /usr/lib/X11R5 -L /usr/lib/Motif1.2 -lm -lXm -lXt -lX11 -lU77 -lcl
#endif
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    FFLAG = -g -n32
    FP_EXCEPTION = -lfpe
    LOPTION = -n32
    LIBS=-lXm -lXt -lX11 -lftn -lsun -lPW -lm
  else
    FFLAG = -g
    FP_EXCEPTION = /usr/lib/libfpe.a
    LOPTION = 
    LIBS=-lXm -lXt -lX11 -lm -lF77 -lI77 -lU77 -lisam -lsun -lPW -lm
  endif
  #MAP    = -Wl,-m > $@.map
  MAP    = 
endif
ifeq "$(UNAME)" "IRIX64"
  FFLAG = -g -n32
  FP_EXCEPTION = -lfpe
  LOPTION= -n32
  #MAP    = -Wl,-m > $@.map
  LIBS=-lXm -lXt -lX11 -lftn -lsun -lPW -lm
endif
#
#
ifeq "$(UNAME)" "Linux"
  FFLAG = -g 
  FP_EXCEPTION = -L/usr/lib
  LOPTION= -O0 -W1,-taso

# ABLIBS = $(HALLDLIBS)
 F90LIBS = $(HALLD_HOME)/src/f90_libs
  LIBS := -L$(F90LIBS) -lU77 -lV77 -lf77math -lfio    
MEM_CHECK = -lchecker
#  LIBS += -L/usr/local/packages/egcs/lib/gcc-lib/i586-pc-linux-gnu/egcs-2.91.57
  LIBS += -lg2c                                          #g77 runtime
  LIBS += -lm    
                                        #math lib
# More ROOT defines with g++
CXX           = g++
#CXXFLAGS      = -O -I$(ROOTSYS)/include
CXXFLAGS      = -O -g -Wall  -fno-exceptions  -fPIC -I$(ROOTSYS)/include \
		 -I/home/halld/include 
LD            = g++
LDFLAGS       = -g  
SOFLAGS       = -shared
RLIBS          = $(ROOTLIBS) -lm -ldl -rdynamic

GLIBS         = $(ROOTLIBS) $(ROOTGLIBS)  -L/usr/X11R6/lib -lXpm \
		-lX11 -lm -ldl -rdynamic

endif
  
ifeq "$(UNAME)" "OSF1"
  FFLAG = -g
  FP_EXCEPTION = -L/usr/lib
  LOPTION= -O0 -W1,-taso
  LIBS=-lXm -lXt -lX11 -lm -lfor -lots -lc_r -lUfor -lfor -lutil -lFutil
  MAP    = 
# More ROOT Crap for Alpha/OSF with g++
CXX           = g++
#CXXFLAGS      = -O -I$(ROOTSYS)/include
CXXFLAGS      = -O -Wall -fno-rtti -fno-exceptions -fwritable-strings  -fPIC -I$(ROOTSYS)/include -g -mcpu=ev5 -D__osf__ -D__alpha
LD            = g++
LDFLAGS       = -g  
SOFLAGS       = -Wl,-expect_unresolved,* -shared
RLIBS          = $(ROOTLIBS) -lg++ -lm
GLIBS         = $(ROOTLIBS) $(ROOTGLIBS) -lXpm -lX11 -lg++ -lm -lPW
endif

#
#
ifeq "$(UNAME)" "SunOS"
  FFLAG = -g
  FP_EXCEPTION =
  LOPTION=
  #MAP    = -Qoption ld -m > $@.map
  ifeq "$(hostname)" "fsui02"
    LIBS= -L/afs/fnal/products/SunOS+5/SUNWspro4/SC4.0/lib \
       -L/usr/openwin/lib -L/usr/dt/lib -lm -lXm -lXt -lX11 -lgen \
       -lF77 -lM77 -lsunmath -lsocket -lnsl -R /usr/openwin/lib -R /usr/dt/lib \
       -R/afs/fnal/products/SunOS+5/SUNWspro4/SC4.0/lib
  else
    LIBS= -L/usr/openwin/lib -L/usr/dt/lib -lm -lXm -lXt -lX11 -lgen \
       -lF77 -lM77 -lsunmath -lsocket -lnsl -R /usr/openwin/lib -R /usr/dt/lib
  endif
endif

# Include files
incdirs =  $(MCFINC)/event $(MCFINC)/geom $(MCFINC)/trig \
           $(MCFINC)/tracing $(MCFINC)/trig \
           $(MCFAST_DIR)/simulator/showering/src \
           $(MCFAST_DIR)/simulator/tracing/src \
           $(MCFAST_DIR)/simulator/calorimetry/src \
           $(MCFINC)/dst $(MCFINC)/dbin_mcfast \
           $(STDHEP_DIR)/src/inc $(MCFIO_DIR)/src  .

FINC = $(addprefix -I,$(incdirs))

PWD   := $(shell /bin/pwd)
SRCDIR := $(PWD)
BLDDIR := $(PWD)

# User .o files are listed here
USER_OBJ = usr_main.o main_args.o usr_analysis.o usr_init.o usr_fill_event.o \
        usr_summary.o usr_hbsummary.o  usr_dump.o \
        usr_mcfast2root.o usr_lgd.o usr_hits.o usr_dumpCalor.o \
        usr_calor.o  prgeom.o usr_mcfio_out.o

TEST_OBJ = usr_main.o main_args.o usr_test.o

USR_LITE_OBJ = usr_main.o main_args.o usr_analysis_lite.o usr_fill_event.o \
	usr_init.o usr_summary.o prgeom.o usr_mcfio_out.o

# List of files for which to build the depend information: all .c, .cc
# and .F files in this directory.
# NOTE: The depend information will be built even if the file is not
#       in the list of files in USER_OBJ.
CXX_SOURCES=$(wildcard *.cc)
C_SOURCES=$(wildcard *.c)
F_SOURCES=$(wildcard *.F)
CXXDEP = $(addprefix $(BLDDIR)/,$(subst .cc,.d, $(CXX_SOURCES)))
CDEP = $(addprefix $(BLDDIR)/,$(subst .c,.d, $(C_SOURCES)))
FDEP = $(addprefix $(BLDDIR)/,$(subst .F,.d, $(F_SOURCES)))
dependfiles = $(FDEP) $(CDEP) $(CXXDEP)

#next line is needed for histoscope... Add before PACKLIB
HISLIB = $(HISTO_DIR)/lib/libFHistoHB.a $(LIBS)

MCFIO = $(MCFAST_DIR)/lib.$(UNAME)/libFmcfio.a

.PHONY: depend

# Tell gmake to forget about the all implicit rules and then
# define only the ones that we want - all this is to get rid of
# the .f rule, which bites us because f77mcf creates .f files in
# .F.o step ( not the .f.o step ) and these subsequently confuse gmake.
# A corollary is that one cannot make .f files with this GNUmakefile.
.SUFFIXES :
.SUFFIXES : .cc .c .F .o .h .inc .cxx


.$(SrcSuf).o:
	$(CXX) $(TMCFAST_INC) -I. $(FINC)  $(CXXFLAGS) -c $<



#-----------------
#  Action section 
#-----------------
:all

all:  HDFast HDFast_lite db 

HDFast_lite: $(USR_LITE_OBJ)
	make  HDFast_Lite "HDFAST_LITE=on"

HDFast_Lite: $(USR_LITE_OBJ)
	$(COM) $(LOPTION) -fcheck-memory-usage $(LDFLAGS) -o HDFast_lite \
	$(USR_LITE_OBJ)  $(RLIBS) \
        -L$(MCFLIB)  \
	-lgen \
	-ldatafile \
	-ltrig \
	-lgraph \
	-luser \
	-ltracing \
	-lshowering \
	-lcalorimetry \
	-lmuon \
	-lvertex \
	-ltrack \
	-lfitters \
	-lsec_int \
	-lgamma \
	-lshower \
	-lgeom \
	-lio \
	-lutil \
	-ldbin_mcfast \
	-ldbin \
	-ldst -luser \
	-lgeneral \
	-lcmd_parse \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(MCFIO) \
	$(QQLIB) $(TYPSCN) $(QQ_DIR)/lib/ranp.o \
	-L$(CRNLIB) \
	-lpacklib \
	-lmathlib \
	-lpacklib -lnsl \
	$(FP_EXCEPTION) \
	$(LIBS) $(MAP) 


mctest: $(TEST_OBJ)
	$(COM) $(LOPTION) $(LDFLAGS) -o mctest \
	$(TEST_OBJ)  $(RLIBS) \
        -L$(MCFLIB)  \
	-lgen \
	-ldatafile \
	-ltrig \
	-lgraph \
	-luser \
	-ltracing \
	-lshowering \
	-lcalorimetry \
	-lmuon \
	-lvertex \
	-ltrack \
	-lfitters \
	-lsec_int \
	-lgamma \
	-lshower \
	-lgeom \
	-lio \
	-lutil \
	-ldbin_mcfast \
	-ldbin \
	-ldst -luser \
	-lgeneral \
	-lcmd_parse \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(MCFIO) \
	$(QQLIB) $(TYPSCN) $(QQ_DIR)/lib/ranp.o \
	-L$(CRNLIB) \
	-lpacklib \
	-lmathlib \
	-lpacklib -lnsl \
	$(FP_EXCEPTION) \
	$(LIBS) $(MAP)



HDFast: $(USER_OBJ)
	$(COM) $(LOPTION) $(LDFLAGS) -o HDFast \
	$(USER_OBJ) $(HDFASTLIBS) $(RLIBS)\
        -L$(MCFLIB)  \
	-lgen \
	-ldatafile \
	-ltrig \
	-lgraph \
	-luser \
	-ltracing \
	-lshowering \
	-lcalorimetry \
	-lmuon \
	-lvertex \
	-ltrack \
	-lfitters \
	-lsec_int \
	-lgamma \
	-lshower \
	-lgeom \
	-lio \
	-lutil \
	-ldbin_mcfast \
	-ldbin \
	-ldst -luser \
	-lgeneral \
	-lcmd_parse \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(MCFIO) \
	$(QQLIB) $(TYPSCN) $(QQ_DIR)/lib/ranp.o \
	-L$(CRNLIB) \
	-lpacklib \
	-lmathlib \
	-lpacklib -lnsl \
	$(FP_EXCEPTION) \
	$(LIBS) $(MAP)

install: HDFast HDFast_lite
	mv HDFast $(HALLD_HOME)/bin/$(UNAME)/.
	mv HDFast_lite $(HALLD_HOME)/bin/$(UNAME)/.     
	cp run_hdfast  $(HALLD_HOME)/bin/.
	cp run_hdfast_lite  $(HALLD_HOME)/bin/.

db:
	@rm -f db
	@ln -s $(MCFAST_DIR)/db db

clean:
	rm -f HDFast HDFast_lite mctest
	rm -f mcfast.map
	rm -f $(patsubst %.F,%.f,$(wildcard *.F))
	rm -f $(USER_OBJ) $(USR_LITE_OBJ) $(TEST_OBJ)
	rm -f *.d $(DEPFILE)

depend: $(DEPFILE)
	@echo Finished rebuilding dependencies

$(DEPFILE): $(dependfiles)
	@echo finished building $(DEPFILE)

test:
	@echo $(dependfiles)

### rules

.F.o:
	f77  $(FFLAG) -fno-second-underscore  -c -g $(FINC) -I. $<

.c.o:
	gcc -c -I.  $(FINC) $(CFLAG) $<

.cc.o:
	g++ -c $(CFLAG) $<

$(BLDDIR)/%.d: $(SRCDIR)/%.F
	@echo get dependencies for $< 
	@$(FDPG) -inc "$(incdirs)" -flagfile $(FLAGFILE) -outfile "$@" $<
	@add_dep $@ $(DEPFILE)

$(BLDDIR)/%.d: $(SRCDIR)/%.c
	@echo get dependencies for $< 
	@$(DPG) -cpp "$(FINC)" $< $@
	@add_dep $@ $(DEPFILE)

$(BLDDIR)/%.d: $(SRCDIR)/%.cc
	@echo get dependencies for $< 
	@$(DPG) -cpp "$(FINC)" $< $@
	@add_dep $@ $(DEPFILE)

.PHONY: all depend clean test db
.SUFFIXES: .cc .h .c .inc .F .d .depend

# include dependency files
#####
##### /dev/null is a trick in case none of the dependency files exist
##### without this trick gmake prints a warning and stops.

include /dev/null $(wildcard $(DEPFILE))

