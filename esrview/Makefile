#! gnumake

#---------------------------------------------------
# The D. P. Weygand et. al. Makefile 
#---------------------------------------------------
include $(BUILDS)/cms/Rules.make


INCLUDE := -I../../include $(INCLUDE) 


TESTLIBS = -L$(TOP_DIR)/lib/$(OS_NAME) -L$(HALLDLIB) -ldata -lkine_c -lc_cern

MISCLIB_SunOS :=  -L/usr/lib -lm -lc -lnsl -lsocket
MISCLIB_HP-UX :=  -L/usr/lib -lm -lc -lf
MISCLIB_AIX :=  -L/usr/lib -lxlf90 -lm -lc 
MISCLIB_Linux :=  -L/usr/lib  -lm -lc /usr/lib/libf2c.a
MISCLIB_OSF1 :=  -L/usr/lib -lm -lc -lfor -lUfor
MISCLIB_IRIX64 := -L/usr/lib64 -lm
MISCLIB_IRIX := -L/usr/lib -lm -lc -lF77 

MISCLIB := $(MISCLIB_$(OS_NAME))


CERNLIB_IRIX = -L/share/cern/97a/lib -lpacklib

CERNLIB := $(CERNLIB_$(OS_NAME))

XLIB= -L/lib 
RPCLIB= -L/usr/lib -lrpcsvc
TCLLIB= -L/usr/local/lib -ltcl

LIBS= $(TESTLIBS) $(CERNLIB) $(STDLIBS) $(MISCLIB) 

PROGRAM= esrview

exe: esrview

SRCS= esrview.c
FSRC= 

FOBJ =${FSRC:.F=.o}
OBJS= $(patsubst %.c,$(OBJDIR)/%.o,$(SRCS))

$(PROGRAM): $(OBJS)
	$(FC) -v -o $@ $(CDBG) $(FINCLUDE) $^ $(FOBJ) $(LIBS)

install: esrview
	mv -f esrview $(TOP_DIR)/bin/$(OS_NAME)

env:
	@echo CC $(CC)
	@echo INCLUDE $(INCLUDE)
	@echo BOSPATH $(BOSPATH)
	@echo FLIB $(FLIB)
	@echo FINCLUDE $(FINCLUDE)
	@echo LIBS $(LIBS)
	@echo OBJS $(OBJS)
	@echo OBJDIR $(OBJDIR)
	@echo FOBJ $(FOBJ)
	@echo FLIB $(FLIB)
	@echo RECLIB $(RECLIB)
	@echo TCLLIB $(TCLLIB)
	@echo CDBG $(CDBG)
	@echo CFLAGS $(CFLAGS)
	@echo CERN_ROOT $(CERN_ROOT)
	@echo CERNLIB $(CERNLIB)


















