#
# Platform independent part of make procedure for Nirvana utilities directory, 
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
    CFLAGS=-O -DUSE_DIRENT
endif
ifeq "$(UNAME)" "IRIX"
    CC=cc
    AR=ar
    CFLAGS=-O -DFUNCPROTO -DXTFUNCPROTO
endif
ifeq "$(UNAME)" "IRIX64"
    CC=cc
    AR=ar
    CFLAGS=-O -n32 -mips3 -DFUNCPROTO -DXTFUNCPROTO
endif
ifeq "$(UNAME)" "Linux"
    CC=gcc
    AR=ar
    CFLAGS=-O -DFUNCPROTO -DXTFUNCPROTO -I/usr/X11/include
endif
ifeq "$(UNAME)" "OSF1"
    CC=cc
    AR=ar
    CFLAGS= -DUSE_DIRENT -DFUNCPROTO -DXTFUNCPROTO
endif
ifeq "$(UNAME)" "SunOS"
    CC=/opt/SUNWspro/bin/cc
    AR=ar
    CFLAGS= -Xa -I/usr/openwin/include -I/usr/dt/include -DUSE_DIRENT \
	    -DMOTIF12
endif
ifeq "$(UNAME)" "HP-UX"
    CC=cc
    AR=ar
    F77=f77
    CFLAGS= -Aa -I/usr/include/X11R5 -I/usr/include/Motif1.2 \
            -D_HPUX_SOURCE -DMOTIF12 -DFUNCPROTO -DXTFUNCPROTO
endif
ifeq "$(UNAME)" "ULTRIX"
    CC=cc
    AR=ar
    CFLAGS=-O -DFUNCPROTO -DXTFUNCPROTO
endif

NLIBDIR = $(STDHEP_DIR)/lib

SRCS = DialogF.c stringUtils.c getfiles.c printUtils.c psUtils.c \
	misc.c fileUtils.c help.c prefFile.c fontsel.c
OBJS = $(patsubst %.c,%$(SFX).o,$(SRCS))
INCLS= DialogF.h getfiles.h stringUtils.h printUtils.h psUtils.h \
	misc.h fileUtils.h help.h prefFile.h fontsel.h
VMSSRCS = vmsUtils.c vmsUtils.h vmsparam.h

all: $(NLIBDIR)/libNUtil$(SFX).a 

$(NLIBDIR)/libNUtil$(SFX).a: $(OBJS)
	$(AR) -urs $(NLIBDIR)/libNUtil$(SFX).a $(OBJS)

printUtils$(SFX).o: printUtils.c
	$(CC) -c $(CFLAGS) $(DFLG) $(PRINTFLAGS) -o $@ printUtils.c

clean:
	rm -f $(OBJS)

realclean:
	rm -f *.o $(NLIBDIR)/libNUtil*.a

depend:
	$(MAKEDEPEND) -fMakefile.common -- $(CFLAGS) -- $(SRCS)
	
#------------------------------------------

.SUFFIXES : 		# cancel implicit rules
.SUFFIXES : .o .c

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%_g.o: %.c
	$(CC) $(CFLAGS) $(DFLG) -c -o $@ $<

# DO NOT DELETE THIS LINE -- make depend depends on it.

DialogF.o: DialogF.h
stringUtils.o: stringUtils.h
getfiles.o: fileUtils.h
getfiles.o: getfiles.h
printUtils.o: DialogF.h
printUtils.o: printUtils.h
psUtils.o: psUtils.h
misc.o: DialogF.h
misc.o: misc.h
fileUtils.o: fileUtils.h
help.o: misc.h
help.o: help.h
DialogF_g.o: DialogF.h
stringUtils_g.o: stringUtils.h
getfiles_g.o: fileUtils.h
getfiles_g.o: getfiles.h
printUtils_g.o: DialogF.h
printUtils_g.o: printUtils.h
psUtils_g.o: psUtils.h
misc_g.o: DialogF.h
misc_g.o: misc.h
fileUtils_g.o: fileUtils.h
help_g.o: misc.h
help_g.o: help.h
