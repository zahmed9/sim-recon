#
# StdHep makefile
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

SLIB = $(STDHEP_DIR)/lib
SBIN = $(STDHEP_DIR)/bin

ifeq "$(UNAME)" "AIX"
    CC=cc
    AR=ar
    F77=xlf
    CPP = /lib/cpp
    CFLG=
    FFLAG= $(DFLG) -qextname
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "IRIX"
    CC=cc
    AR=ar
    F77=f77
    CPP = /lib/cpp
    CPPFLG= -C -P
    CFLG=
    FFLAG= $(DFLG)
endif
ifeq "$(UNAME)" "IRIX64"
    CC=cc
    AR=ar
    F77=f77
    CPP = /lib/cpp
    CFLG= -n32 -mips3
    FFLAG= $(DFLG) -n32 -mips3
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "Linux"
    CC=gcc
    AR=ar
    F77=g77
    CPP = gcc -E
    CFLG=
    FFLAG= $(DFLG) -fno-second-underscore
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "Linux22"
    CC=/usr/bin/gcc
    AR=ar
    F77=/usr/bin/g77
    CPP = /usr/bin/gcc -E
    CFLG=
    FFLAG= $(DFLG) -fno-second-underscore
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "OSF1"
    CC=cc
    AR=ar
    F77=f77
    CPP = cpp
    CFLG=
    FFLAG= $(DFLG) -fpe2 -check underflow -check overflow
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "SunOS"
    CC=/opt/SUNWspro/bin/cc
    F77=f77
    AR=ar
    CPP = /usr/ccs/lib/cpp
    CFLG= -I/usr/openwin/include
    FFLAG= $(DFLG)
    CPPFLG= -C -P
endif
ifeq "$(UNAME)" "HP-UX"
    CC=cc
    AR=ar
    F77=f77
    CPP = /lib/cpp
    CFLG=-Aa -D_HPUX_SOURCE
    FFLAG= $(DFLG) +ppu
    CPPFLG= -C -P
endif

INCS = -I$(STDHEP_DIR)/src/inc -I$(LUND_DIR)/src/inc -I$(HERWIG_DIR)/src \
        -I$(QQ_DIR)/src/inc -I$(STDHEP_DIR)/src/mcfio
CFLAGS = $(CFLG) $(DFLG) -I$(STDHEP_DIR)/src/inc -I$(STDHEP_DIR)/src/mcfio
CPPFLGS = $(CPPFLG) -DUNIX $(INCS)

FOBJS =	$(patsubst %.F,%$(SFX).o,$(wildcard *.F))
COBJS =	$(patsubst %.c,%$(SFX).o,$(wildcard *.c))

#------------------------------------------

all: $(SLIB)/libstdhep$(SFX).a $(SLIB)/libstdhepC$(SFX).a

$(SLIB)/libstdhep$(SFX).a:	$(FOBJS) \
          mcf_Stdhep_xdr$(SFX).o sum_4vec_d$(SFX).o sum_4vec_f$(SFX).o
	$(AR) -urs $(SLIB)/libstdhep$(SFX).a $(FOBJS) \
		mcf_Stdhep_xdr$(SFX).o sum_4vec_d$(SFX).o sum_4vec_f$(SFX).o

$(SLIB)/libstdhepC$(SFX).a:	$(COBJS)
	$(AR) -urs $(SLIB)/libstdhepC$(SFX).a $(COBJS)

clean:
	rm -f *$(SFX).o *$(SFX).a *$(SFX).f

realclean:
	rm -f $(SLIB)/libstdhep*.a
	rm -f *.o *.a *.f

#------------------------------------------

.SUFFIXES : 		# cancel implicit rules
.SUFFIXES : .o .c .F

%.o: %.F
	$(CPP) $(CPPFLGS) $< > $*.f
	$(F77) $(FFLAG) -c $*.f

%_g.o: %.F
	$(CPP) $(CPPFLGS) $< > $*.f
	$(F77) $(FFLAG) -c -o $@ $*.f

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%_g.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<
