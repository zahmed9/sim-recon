#
# new MCFiv makefile
#
# L. Garren 1/5/98    for MCFast
# PLM       10/23/98  adapted for mcfiv
#
MODE = normal
PWD   := $(shell /bin/pwd)
RM    := 'rm' -f
MAKE  := gmake

# compilation definitions
CC	:= ccmcf

# note that, unlike the rest of mcfast, Inventor uses the native C++ compiler
UNAME := $(shell uname)
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    UNAME = IRIX64
  endif
endif
# flags
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  LFLAGS:=  
  SYSTEMLIBS := -lftn -lGL -lXm  -lXt -lX11 -lm
  aropts := rv
  CC := cc
  C++ := CC
  CPP := /usr/lib/cpp
endif
ifeq "$(UNAME)" "IRIX64"
  aropts := rv
  LFLAGS:=  -n32 -mips3
  SYSTEMLIBS := -lftn -lGL -lXm  -lXt -lX11 -lm
  CC := cc
  C++ := CC
  CPP := /usr/lib/cpp
endif
ifeq "$(UNAME)" "OSF1"
  aropts := rvs
  LFLAGS:=  -g -O0 -Wl,-taso
  SYSTEMLIBS := -L/usr/lib -lXm -lXt -lX11 -lm -lfor -lots -lc_r -lUfor -lfor -lutil -lFutil -lm_4sqrt
  CC := cc
  C++ := cxx
  CPP := /usr/lib/cpp
endif

# use relative paths
INCDIR := .
BLDDIR := ../../build/$(UNAME)/simulator/Inventor
LIBDIR := ../../lib.$(UNAME)
BINDIR := ../../bin.$(UNAME)

# executables
MCFEXE  := $(BINDIR)/mcfiv.exe
MCFGEXE := $(BINDIR)/mcfiv_g.exe
MAIN    := $(LIBDIR)/mcfiv.o
MAING   := $(LIBDIR)/mcfiv_g.o

# list of libraries to build
## the print library cannot be built at this time
##MODS := calenergy detector hits mcfastCommon print scene trace ivutil windows
MODS := calenergy detector hits mcfastCommon scene trace ivutil windows
MODLIBS := $(patsubst %,$(LIBDIR)/lib%.a,$(MODS))
MODLIBG := $(patsubst %,$(LIBDIR)/lib%_g.a,$(MODS))
  
# Include directories
incdirs := $(INCDIR) $(INCDIR)/include $(INCDIR)/hepvis \
  $(MCFINC)/event $(OIV_DIR)/include \
  $(MCFSRC)dbin_mcfast/src $(MCFSRC)shower/src $(MCFSRC)dst/src \
  $(MCFIO_DIR)/src $(STDHEP_DIR)/src/inc \
  $(STDHEP_DIR)/src/display $(STDHEP_DIR)/src/display/util
# vpath 
empty   :=
space   := $(empty) $(empty)
incpath := $(subst $(space),:,$(strip $(incdirs)))
vpath %.inc $(incpath)
vpath %.params $(incpath)
vpath %.h $(incpath)
vpath %.hh $(incpath)

# check possible modes (only debug for now)
ifeq "$(MODE)" "debug"
  SUFFIX := _g
  BLDLIBS := glib
else
  SUFFIX :=
  BLDLIBS := production
endif

#
TREES  := $(addprefix $(BLDDIR)/,$(MODS))

# dependency definitions
CCDEP := \
  $(addprefix $(BLDDIR)/calenergy/,$(subst .cc,.d, $(notdir $(wildcard calenergy/*.cc)))) \
  $(addprefix $(BLDDIR)/detector/,$(subst .cc,.d, $(notdir $(wildcard detector/*.cc)))) \
  $(addprefix $(BLDDIR)/hits/,$(subst .cc,.d, $(notdir $(wildcard hits/*.cc)))) \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(subst .cc,.d, $(notdir $(wildcard mcfastCommon/*.cc)))) \
  $(addprefix $(BLDDIR)/scene/,$(subst .cc,.d, $(notdir $(wildcard scene/*.cc)))) \
  $(addprefix $(BLDDIR)/trace/,$(subst .cc,.d, $(notdir $(wildcard trace/*.cc)))) \
  $(addprefix $(BLDDIR)/ivutil/,$(subst .cc,.d, $(notdir $(wildcard ivutil/*.cc)))) \
  $(addprefix $(BLDDIR)/windows/,$(subst .cc,.d, $(notdir $(wildcard windows/*.cc)))) 
  ## $(addprefix $(BLDDIR)/print/,$(subst .cc,.d, $(notdir $(wildcard print/*.cc)))) \
CDEP := \
  $(addprefix $(BLDDIR)/calenergy/,$(subst .c,.d, $(notdir $(wildcard calenergy/*.c)))) \
  $(addprefix $(BLDDIR)/detector/,$(subst .c,.d, $(notdir $(wildcard detector/*.c)))) \
  $(addprefix $(BLDDIR)/hits/,$(subst .c,.d, $(notdir $(wildcard hits/*.c)))) \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(subst .c,.d, $(notdir $(wildcard mcfastCommon/*.c)))) \
  $(addprefix $(BLDDIR)/scene/,$(subst .c,.d, $(notdir $(wildcard scene/*.c)))) \
  $(addprefix $(BLDDIR)/trace/,$(subst .c,.d, $(notdir $(wildcard trace/*.c)))) \
  $(addprefix $(BLDDIR)/ivutil/,$(subst .c,.d, $(notdir $(wildcard ivutil/*.c)))) \
  $(addprefix $(BLDDIR)/windows/,$(subst .c,.d, $(notdir $(wildcard windows/*.c)))) 
  ## $(addprefix $(BLDDIR)/print/,$(subst .c,.d, $(notdir $(wildcard print/*.c)))) 

DEPFILE  := $(BLDDIR)/GNUmakefile.depend
dependfiles := $(CDEP) $(CCDEP)


CPPFLAGS := $(addprefix -I, $(incdirs))
MAKELIB  = [ -n "$<" ] && ar $(aropts) $@ $?

#---------------------------------------------------
# begin execution area

all: tree depend $(BLDLIBS)

#-------------
# one library at a time

calenergy: $(LIBDIR)/libcalenergy$(SUFFIX).a

detector: $(LIBDIR)/libdetector$(SUFFIX).a

hits: $(LIBDIR)/libhits$(SUFFIX).a

mcfastCommon: $(LIBDIR)/libmcfastCommon$(SUFFIX).a

print: $(LIBDIR)/libscene$(SUFFIX).a

trace:$(LIBDIR)/libtrace$(SUFFIX).a

ivutil: $(LIBDIR)/libivutil$(SUFFIX).a

windows: $(LIBDIR)/libwindows$(SUFFIX).a


#-------------
# create necessary subdirectories

tree:   $(TREES)
	@echo mcfiv directory tree is built

$(TREES):
	-test -d $@ || mkdir -p $@

#-------------
# dependencies

depend: $(DEPFILE)
	@echo Finished rebuilding dependencies

$(DEPFILE): $(dependfiles)
	@echo finished building $(DEPFILE)

#-------------
# production libraries

production:   $(MODLIBS) $(MCFEXE)
	@echo finished building regular libraries

mcfiv:   $(MODLIBS) $(MCFEXE)
	@echo finished building regular libraries

$(LIBDIR)/mcfiv.o:    mcfiv.cc
	@echo Compiling $<; $(C++) -c  $(LFLAGS) $(CPPFLAGS) -o $@ $<
$(LIBDIR)/libcalenergy.a:  \
  $(addprefix $(BLDDIR)/calenergy/,$(subst .c,.o, $(notdir $(wildcard calenergy/*.c)))) \
  $(addprefix $(BLDDIR)/calenergy/,$(subst .cc,.o, $(notdir $(wildcard calenergy/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdetector.a:  \
  $(addprefix $(BLDDIR)/detector/,$(subst .c,.o, $(notdir $(wildcard detector/*.c)))) \
  $(addprefix $(BLDDIR)/detector/,$(subst .cc,.o, $(notdir $(wildcard detector/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libhits.a:  \
  $(addprefix $(BLDDIR)/hits/,$(subst .c,.o, $(notdir $(wildcard hits/*.c)))) \
  $(addprefix $(BLDDIR)/hits/,$(subst .cc,.o, $(notdir $(wildcard hits/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libmcfastCommon.a:  \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(subst .c,.o, $(notdir $(wildcard mcfastCommon/*.c)))) \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(subst .cc,.o, $(notdir $(wildcard mcfastCommon/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libprint.a: \
  $(addprefix $(BLDDIR)/print/,$(subst .c,.o, $(notdir $(wildcard print/*.c)))) \
  $(addprefix $(BLDDIR)/print/,$(subst .cc,.o, $(notdir $(wildcard print/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libscene.a: \
  $(addprefix $(BLDDIR)/scene/,$(subst .c,.o, $(notdir $(wildcard scene/*.c)))) \
  $(addprefix $(BLDDIR)/scene/,$(subst .cc,.o, $(notdir $(wildcard scene/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrace.a:  \
  $(addprefix $(BLDDIR)/trace/,$(subst .c,.o, $(notdir $(wildcard trace/*.c)))) \
  $(addprefix $(BLDDIR)/trace/,$(subst .cc,.o, $(notdir $(wildcard trace/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libivutil.a:   \
  $(addprefix $(BLDDIR)/ivutil/,$(subst .c,.o, $(notdir $(wildcard ivutil/*.c)))) \
  $(addprefix $(BLDDIR)/ivutil/,$(subst .cc,.o, $(notdir $(wildcard ivutil/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libwindows.a:  \
  $(addprefix $(BLDDIR)/windows/,$(subst .c,.o, $(notdir $(wildcard windows/*.c)))) \
  $(addprefix $(BLDDIR)/windows/,$(subst .cc,.o, $(notdir $(wildcard windows/*.cc))))
	@$(MAKELIB)

$(MCFEXE): $(MODLIBS) $(MAIN)
	@echo Generating program $@
	$(C++) $(LFLAGS) -o $@ \
	$(MAIN) \
	-L$(LIBDIR) \
	-lwindows \
	-ldetector \
	-lcalenergy \
	-ltrace \
	-lscene \
	-lwindows \
	-ldetector \
	-lhits \
	-lmcfastCommon \
	-livutil \
        -lio -ldbin_mcfast -ldst -lshower -lgeom -ldbin \
	$(STDHEP_DIR)/lib/libstdhep.a \
        $(STDHEP_DIR)/lib/libNUtil.a \
        $(STDHEP_DIR)/lib/libPhaseStdHep.a \
        -lgeneral -lFmcfio \
	$(OIVLIBS) \
	$(CRNLIB)/libpacklib.a \
	$(SYSTEMLIBS) \
	; true
	echo Finished program $@

#-------------
# debug libraries

glib:   $(MODLIBG)  $(MCFGEXE)
	@echo finished building debug libraries

$(LIBDIR)/mcfiv_g.o:    mcfiv.cc
	@echo Compiling $< debug; $(C++) -c -g $(LFLAGS) $(CPPFLAGS) -o $@ $<
$(LIBDIR)/libcalenergy_g.a: \
  $(addprefix $(BLDDIR)/calenergy/,$(patsubst %.c,%_g.o, $(notdir $(wildcard calenergy/*.c)))) \
  $(addprefix $(BLDDIR)/calenergy/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard calenergy/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdetector_g.a:  \
  $(addprefix $(BLDDIR)/detector/,$(patsubst %.c,%_g.o, $(notdir $(wildcard detector/*.c)))) \
  $(addprefix $(BLDDIR)/detector/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard detector/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libhits_g.a:  \
  $(addprefix $(BLDDIR)/hits/,$(patsubst %.c,%_g.o, $(notdir $(wildcard hits/*.c)))) \
  $(addprefix $(BLDDIR)/hits/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard hits/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libmcfastCommon_g.a:  \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(patsubst %.c,%_g.o, $(notdir $(wildcard mcfastCommon/*.c)))) \
  $(addprefix $(BLDDIR)/mcfastCommon/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard mcfastCommon/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libprint_g.a:  \
  $(addprefix $(BLDDIR)/print/,$(patsubst %.c,%_g.o, $(notdir $(wildcard print/*.c)))) \
  $(addprefix $(BLDDIR)/print/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard print/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libscene_g.a: \
  $(addprefix $(BLDDIR)/scene/,$(patsubst %.c,%_g.o, $(notdir $(wildcard scene/*.c)))) \
  $(addprefix $(BLDDIR)/scene/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard scene/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrace_g.a:  \
  $(addprefix $(BLDDIR)/trace/,$(patsubst %.c,%_g.o, $(notdir $(wildcard trace/*.c)))) \
  $(addprefix $(BLDDIR)/trace/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard trace/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libivutil_g.a:   \
  $(addprefix $(BLDDIR)/ivutil/,$(patsubst %.c,%_g.o, $(notdir $(wildcard ivutil/*.c)))) \
  $(addprefix $(BLDDIR)/ivutil/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard ivutil/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libwindows_g.a:  \
  $(addprefix $(BLDDIR)/windows/,$(patsubst %.c,%_g.o, $(notdir $(wildcard windows/*.c)))) \
  $(addprefix $(BLDDIR)/windows/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard windows/*.cc))))
	@$(MAKELIB)

$(MCFGEXE): $(MODLIBSG) $(MAING)
	@echo Generating program $@
	$(C++) -g $(LFLAGS) -o $@ \
	$(MAING) \
	-L$(LIBDIR) \
	-lwindows_g \
	-ldetector_g \
	-lcalenergy_g \
	-ltrace_g \
	-lscene_g \
	-lwindows_g \
	-ldetector_g \
	-lhits_g \
	-lmcfastCommon_g \
	-livutil_g \
        -lio_g -ldbin_mcfast_g -ldst_g -lshower_g -lgeom_g -ldbin \
	$(STDHEP_DIR)/lib/libstdhep.a \
        $(STDHEP_DIR)/lib/libNUtil.a \
        $(STDHEP_DIR)/lib/libPhaseStdHep.a \
        -lgeneral -lFmcfio \
	$(OIVLIBS) \
	$(CRNLIB)/libpacklib.a \
	$(SYSTEMLIBS) \
	; true
	echo Finished program $@

#---------------------------------------------------
# cleanup

clean:
	@echo deleting all libraries
	@$(RM) $(MODLIBS) $(MODLIBG)
	@$(RM) $(LIBDIR)/mcfiv*.o
	@echo deleting all executable code
	@$(RM) $(MCFEXE)
	@echo deleting all dependency files        
	find $(BLDDIR) -name "*.d" -exec rm {} \;
	@echo deleting all .o files
	find $(BLDDIR) -name "*.o" -exec rm {} \;
	@$(RM) $(BLDDIR)/mcfiv* $(LIBDIR)/mcfiv*.o $(DEPFILE)* $(FLAGFILE)

cleanobj:
	@echo deleting all libraries
	@$(RM) $(MODLIBS) $(MODLIBG)
	@$(RM) $(LIBDIR)/mcfiv*.o
	@echo deleting all executable code
	@$(RM) $(MCFEXE)
	@echo deleting all .o files
	find $(BLDDIR) -name "*.o" -exec rm {} \;

clean_glib:
	@echo deleting all debug libraries
	@$(RM) $(MODLIBG)
	@$(RM) $(LIBDIR)/mcfiv_g.o
	@echo deleting all debug executable code
	@$(RM) $(LIBDIR)/mcfiv_g.exe
	@echo deleting all _g.o files
	find $(BLDDIR) -name "*_g.o" -exec rm {} \;

clean.depend:
	@echo deleting all dependency files        
	find $(BLDDIR) -name "*.d" -exec rm {} \;
	$(RM) $(DEPFILE)* $(FLAGFILE)

#---------------------------------------------------
# rules

$(BLDDIR)/%.o: %.c
	@echo Compiling $<; $(CC) -c $(LFLAGS) $(CPPFLAGS) -o $@ $<

$(BLDDIR)/%_g.o: %.c
	@echo Compiling $< debug; $(CC) -g -c $(LFLAGS) $(CPPFLAGS) -o $@ $<

$(BLDDIR)/%.o: %.cc
	@echo Compiling $<; $(C++) -c  $(LFLAGS) $(CPPFLAGS) -o $@ $<

$(BLDDIR)/%_g.o: %.cc
	@echo Compiling $< debug; $(C++) -c -g $(LFLAGS) $(CPPFLAGS) -o $@ $<

$(BLDDIR)/%.d: %.c
	@echo get dependencies for $< 
	@$(CPP) -MM $(CPPFLAGS) $< > $@
	@add_dep $@ $(DEPFILE)

$(BLDDIR)/%.d: %.cc
	@echo get dependencies for $< 
	@$(C++) -c $(LFLAGS) -M $(CPPFLAGS) $< > $@
	@add_dep $@ $(DEPFILE)

#---------------------------------------------------
# test area 

test:
	@echo $(CDEP)
	@echo 
	@echo $(CCDEP)
	@echo 
	@echo $(incdirs)
	@echo 
	@echo "dependencies in "$(DEPFILE)

#---------------------------------------------------
# delete some useless implicit rules

%::%,v
%::RCS/%,v
%::s.%
%::SCCS/s.%

.PHONY: all depend clean clean.depend cleanobj test
.SUFFIXES: .cc .h .c .inc .d .depend .incdirs null

#---------------------------------------------------
#####
##### external dependency files
#####
##### /dev/null is a trick in case none of the dependency files exist
##### without this trick gmake prints a warning and stops.

include /dev/null $(wildcard $(DEPFILE))

