# 
# makefile for StdHepC++
#
UNAME = $(shell uname)
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

CXX = g++
AR=ar
ARFLG = -urs
SLIB = $(STDHEP_DIR)/lib

ifeq "$(UNAME)" "AIX"
    CPP = /lib/cpp
    CPPFLG= -C -P
    F77=xlf
    FFLAG= $(DFLG) -qextname
endif
ifeq "$(UNAME)" "IRIX"
    CPP = /lib/cpp
    CPPFLG= -C -P
    F77=f77
    FFLAG= $(DFLG)
endif
ifeq "$(UNAME)" "IRIX64"
    CPP = /lib/cpp
    CPPFLG= -C -P
    F77 = f77
    FFLAG = $(DFLG) -n32 -mips3
endif
ifeq "$(UNAME)" "Linux"
    CPP = gcc -E
    CPPFLG= -C -P
    F77=g77
    FFLAG= $(DFLG) -fno-second-underscore
    ## setup egcs gets this wrong, so fix it here
    CPLUS_INCLUDE_PATH = $(EGCS_DIR)/include/g++
endif
ifeq "$(UNAME)" "Linux22"
    CPP = /usr/bin/gcc -E
    CPPFLG= -C -P
    F77=/usr/bin/g77
    FFLAG= $(DFLG) -fno-second-underscore
endif
ifeq "$(UNAME)" "OSF1"
    CPP = cpp
    CPPFLG= -C -P
    F77=f77
    FFLAG= $(DFLG) -fpe2 -check underflow -check overflow
endif
ifeq "$(UNAME)" "SunOS"
    CPP = /usr/ccs/lib/cpp
    CPPFLG= -C -P
    F77=f77
    FFLAG= $(DFLG)
endif
ifeq "$(UNAME)" "HP-UX"
    CPP = /lib/cpp
    CPPFLG= -C -P
    F77=f77
    FFLAG= $(DFLG) +ppu
endif

INCS = -I$(STDHEP_DIR)/src/mcfio -I$(CLHEP_DIR)/include -I$(STDHEP_DIR)/src/inc
CXXFLAGS = $(DFLG) $(INCS)

OBJS = $(patsubst %.cc,%$(SFX).o,$(wildcard *.cc))

CPPFLGS = $(CPPFLG) $(INCS)

#------------------------------------------

all: $(SLIB)/libStdHepCXX$(SFX).a

$(SLIB)/libStdHepCXX$(SFX).a: $(OBJS)
	$(AR) $(ARFLG) $@ $(OBJS)

clean:
	rm -f *.o

realclean:
	rm -f *.o
	rm -f $(SLIB)/libStdHepCXX.a $(SLIB)/libStdHepCXX_g.a

#------------------------------------------

.SUFFIXES :             # cancel implicit rules
.SUFFIXES : .o .cc

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $<

%_g.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<
