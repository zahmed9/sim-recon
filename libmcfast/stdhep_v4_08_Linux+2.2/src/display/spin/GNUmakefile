#
# Platform independent part of make procedure for Nirvana spin widget, 
# included by machine specific makefiles.
#
UNAME = $(shell uname)
ifeq "$(UNAME)" "IRIX"
    IRIX6 = $(findstring 6,$(shell uname -r))
    ifeq "$(IRIX6)" "6"
	UNAME=IRIX64
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

ifeq "$(UNAME)" "AIX"
    CC=cc
    AR=ar
    CFLAGS = -D_BSD
endif
ifeq "$(UNAME)" "IRIX"
    CC=cc
    AR=ar
    CFLAGS = -DSYSV
endif
ifeq "$(UNAME)" "IRIX64"
    CC=cc
    AR=ar
    CFLAGS = -n32 -mips3 -DSYSV
endif
ifeq "$(UNAME)" "Linux"
    CC=gcc
    AR=ar
    CFLAGS= -DFUNCPROTO -DXTFUNCPROTO -I/usr/X11/include
endif
ifeq "$(UNAME)" "OSF1"
    CC=cc
    AR=ar
    CFLAGS= -DUSE_DIRENT -DFUNCPROTO -DXTFUNCPROTO
endif
ifeq "$(UNAME)" "SunOS"
    CC=/opt/SUNWspro/bin/cc
    AR=ar
    CFLAGS= -Xa -I/usr/openwin/include -I/usr/dt/include -DMOTIF12
endif
ifeq "$(UNAME)" "HP-UX"
    CC=cc
    AR=ar
    F77=f77
    CFLAGS=  -Aa -I/usr/include/X11R5 -I/usr/include/Motif1.2 \
            -D_HPUX_SOURCE -DMOTIF12
endif
ifeq "$(UNAME)" "ULTRIX"
    CC=cc
    AR=ar
    CFLAGS = 
endif

OBJS = Spin$(SFX).o geometry$(SFX).o
SRCS = Spin.c geometry.c
INCLS= Spin.h SpinP.h geometry.h

NLIBDIR = $(STDHEP_DIR)/lib

all: $(NLIBDIR)/libSpin$(SFX).a

$(NLIBDIR)/libSpin$(SFX).a: $(OBJS)
	$(AR) -urs $(NLIBDIR)/libSpin$(SFX).a $(OBJS)

clean:
	rm -f $(OBJS)

realclean:
	rm -f *.o $(NLIBDIR)/libSpin*.a

#------------------------------------------

.SUFFIXES : 		# cancel implicit rules
.SUFFIXES : .o .c

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%_g.o: %.c
	$(CC) $(CFLAGS) $(DFLG) -c -o $@ $<

# DO NOT DELETE THIS LINE -- make depend depends on it.

Spin.o: geometry.h
Spin.o: SpinP.h
Spin.o: Spin.h
geometry.o: geometry.h
Spin_g.o: geometry.h
Spin_g.o: SpinP.h
Spin_g.o: Spin.h
geometry_g.o: geometry.h
