###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# simplify debug option
DEB=
ifeq "$(DEBUG)" "y"
  DEB=-g
endif

MKLD=NOMKLDEBUG
ifeq "$(MKLDEBUG)" "y"
  MKLD=MKLDEBUG
  DEB=-g
endif

# Machine dependent stuff.
MAP = 
# some options are untested
ifeq "$(UNAME)" "AIX"
  LOPTION=
  MAP    = -Wl,-m > $@.map
  LIBS= -lXm -lXt -lX11 -lm -lbsd -lxlf
endif
ifeq "$(UNAME)" "HP-UX"
  LOPTION=
  MAP    = -Wl,-m > $@.map
  LIBS= -L /usr/lib/X11R5 -L /usr/lib/Motif1.2 -lm -lXm -lXt -lX11 -lU77 -lcl
endif
ifeq "$(UNAME)" "IRIX"
  LOPTION= 
  MAP    = -Wl,-m > $@.map
#mkl
#  LIBS=-lXm -lXt -lX11 -lm -lF77 -lI77 -lU77 -lisam -lsun -lPW -lm
#  GCCDIR = /afs/fnal.gov/products/IRIX+5/gcc/v2_7_2/lib
  GCCDIR = /usr/products/IRIX5/gcc/v2_7_2/lib
  SYSTEMLIBS := -L/usr/lib/X11R4 -lX11 -lm /usr/lib/libfpe.a -lftn -lF77 -lU77 $(GCCDIR)/libg++.a
  MAKEDEPEND = makedepend
  MAKEDEPENDINC = -I. -I$(QQ_DIR)/src/inc -I$(GCCDIR)/g++-include/ 
endif
ifeq "$(UNAME)" "OSF1"
  GCCDIR = /fnal/ups/prod/gcc/v2_7_2_1_1/lib
#  LOPTION= -nofor_main
  LOPTION=
  MAP    = -Wl,-m > $@.map
#  LIBS=-lXm -lXt -lX11 -lm -lfor -lots
  SYSTEMLIBS := -L/usr/lib -lX11 -lm -lc_r -lUfor -lfor -lutil -lFutil -lots $(GCCDIR)/libg++.a
#endmkl
#  MAKEDEPEND = makedepend
  MAKEDEPEND = cleo_makedepend
  MAKEDEPENDINC = -I. -I$(QQ_DIR)/src/inc -I$(GCCDIR)/g++-include/
endif
ifeq "$(UNAME)" "SunOS"
  LOPTION=
  MAP    = -Wl,-m > $@.map
  LIBS= -L/usr/openwin/lib -L/usr/dt/lib -lm -lXm -lXt -lX11 -lgen \
       -lF77 -lM77 -lsunmath -lsocket -lnsl -R /usr/openwin/lib -R /usr/dt/lib
endif

# Include files
MCFINC = ../../../inc
INC1 = $(MCFINC)/event
INC2 = $(MCFINC)/geom
INC3 = $(MCFINC)/trig
INC4 = $(STDHEP_DIR)/src/inc
INC5 = $(MCFIO_DIR)/src
INC6 = $(MCFSRC)/dst
INC7 = .
INC8 = ../inc
INC9 = ../../showering/src

FFLAG = $(DEB) -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) -I$(INC5) \
        -I$(INC6) -I$(INC7) -I$(INC8) -I$(INC9)

CFLAG = $(FFLAG)

MAKEDEPENDINC += $(FFLAG)
LIB = $(MCFAST_DIR)/lib.$(UNAME)


#mkl
#MAKEDEPEND=/usr/bin/X11/makedepend
srcdir=.
CXX_SOURCES=$(wildcard $(srcdir)/*.cc)
C_SOURCES=$(wildcard $(srcdir)/*.c)
F_SOURCES=$(wildcard $(srcdir)/*.F)
NOTDIR_CXX_SOURCES=$(notdir $(CXX_SOURCES))
NOTDIR_C_SOURCES=$(notdir $(C_SOURCES))
NOTDIR_F_SOURCES=$(notdir $(F_SOURCES))
#User .o files are listed here
#USER_OBJ = usr_analysis.o usr_init.o
USER_OBJ=$(NOTDIR_CXX_SOURCES:%.cc=%$(DEB).o)
USER_OBJ+=$(NOTDIR_C_SOURCES:%.c=%.o)
USER_OBJ+=$(NOTDIR_F_SOURCES:%.F=%.o)
#USER_OBJ = $(shell echo *.cc | sed -g "s/\.cc/\.o/" )
#USER_OBJ += $(shell echo *.F | sed -g "s/\.F/\.o/" )
#USER_OBJ += $(shell echo *.c | sed -g "s/\.c/\.o/" )
#endmkl

#next line is needed for histoscope... Add before PACKLIB
HISLIB = $(HISTO_DIR)/lib/libFHistoHB.a $(LIBS)

# deal with differences between product and ~bphyslib
ifdef MCFREL
  MCFIO = $(MCFAST_DIR)/lib.$(UNAME)/libFmcfio.a
else
  MCFIO = $(MCFIO_DIR)/lib.$(UNAME)/libFmcfio.a
endif

.PHONY: depend
	@@
.SUFFIXES: .cc .c .F .f .o .h .inc

#-----------------
#  Action section 
#-----------------

# mkl
#all: depend mcfast db
all: depend mcfast$(DEB)

MODS := gen user graph trig muon vertex track fitters shower gamma geom \
  sec_int tracing showering io datafile dbin_mcfast dst util
FILTER := CVS Flags Explorer Inventor main_args.c GNUmakefile README doc example
LIBLIST := $(filter-out $(FILTER),$(wildcard *))
#
MODDIRS := $(addsuffix /src,$(MODS))
MODLIBS := $(patsubst %,-l%,$(MODS))

# other libraries
PACKLIB = $(CRNLIB)/libpacklib.a 
MATHLIB = $(CRNLIB)/libmathlib.a 
KERNLIB = $(CRNLIB)/libkernlib.a

#	/home/sim2/mkl/work/mcfast/lib/libtracing.a
#	../../track/src/libtrack.a \
#	-lgen -luser -lgraph -ltrig -lmuon -lvertex \
#	-ltrack \
#	-lfitters -lshower -lgamma -lgeom \
#	-lsec_int -ltracing -lshowering -lio \
#	-ldatafile -ldbin_mcfast -ldst -lutil \
#	$(MODLIBS)
#	-Wl,-yusr_siz_rect_res_
mcfast$(DEB): $(USER_OBJ) main/main_args.o ../../showering/src/libshowering.a
	g++ $(DEB) $(LOPTION) -o mcfast$(DEB) \
	main/main_args.o \
	$(USER_OBJ) \
	../../showering/src/libshowering.a \
        -L$(LIB)  \
        -L$(GLIB)  \
	$(MODLIBS) \
	-luser \
	-lFmcfio \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(QQLIB) $(QQ_DIR)/lib/ranp.o \
	-ldbin \
	-lcmd_parse \
	-lgeneral \
	$(MCFIO) \
	$(PACKLIB) \
	$(MATHLIB) \
	$(TYPSCN) \
	$(PACKLIB) \
	$(SYSTEMLIBS)
#	-Wl,-m > mcfast$(DEB).map 2>&1

db:
	@ln -s ../db db

clean: 
	rm -f *.o

#mkl
main/main_args.o:
	g++ $(DEB) -c $(CFLAG) main/main_args.cc -o $@

depend: cc_depend c_depend fort_depend
#endmkl

#mkl
.F.o:
	f77 -c $(FFLAG) -I$(QQ_DIR)/src/inc $<
#	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $<
#	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $<
#	cc -c $(CFLAG) $?

%${DEB}.o: %.cc
	g++ -O3 -D$(MKLD) -c $(CFLAG) $*.cc -o $*${DEB}.o
#.cc.o:
#	g++ -c $(CFLAG) $<
##	g++ -c $(CFLAG) $?
#endmkl

#mkl
fort_depend: $(F_SOURCES)
	@test -z "$(F_SOURCES)" || $(MAKEDEPEND) -ff.depend -o.o $(MAKEDEPENDINC) $(FFLAG) $(F_SOURCES)

c_depend: $(C_SOURCES)
	@test -z "$(C_SOURCES)" || $(MAKEDEPEND) -fc.depend -o.o $(MAKEDEPENDINC) $(CFLAG) $(C_SOURCES)

cc_depend: $(CXX_SOURCES)
	@test -z "$(CXX_SOURCES)" || $(MAKEDEPEND) -fcc$(DEB).depend -o$(DEB).o $(MAKEDEPENDINC) $(CFLAG) $(CXX_SOURCES)


# include dependency files
-include cc.depend
-include cc-g.depend
-include c.depend
-include f.depend
#endmkl
