#
# new MCFast (simulator) makefile
#
# L. Garren 1/5/98
#
MODE = normal
PWD   := $(shell /bin/pwd)
RM    := 'rm' -f
MAKE  := gmake

# compilation definitions
FC      := f77mcf
CCB	:= ccmcf
C++CB	:= c++mcf
DPG	:= get_c_dep
FDPG	:= mdep
mangle  := get_outlib
# allow a hook for forcing use of the absoft compiler
COMPILER = absoft    # simulator must use absoft

# platform-specific information
include simulator_arch

# use relative paths
INCDIR := ../inc
BLDDIR := ../build/$(UNAME)/simulator
LIBDIR := ../lib.$(UNAME)
BINDIR := ../bin.$(UNAME)

# executables
MCFEXE  := $(BINDIR)/mcfast.exe
MCFGEXE := $(BINDIR)/mcfast_g.exe
MAIN    := $(LIBDIR)/main_args.o
MAING   := $(LIBDIR)/main_args_g.o

#mcfast_out
force.F := $(BLDDIR)/mcfast_out.F
force.o := $(LIBDIR)/mcfast_out.o
force_g.o := $(LIBDIR)/mcfast_out_g.o

# list of libraries to build
MODS := gen user graph trig muon vertex track fitters shower gamma geom \
  sec_int tracing showering calorimetry io datafile dbin_mcfast dst util
FILTER := CVS Flags Explorer Inventor main_args.c GNUmakefile README doc example
LIBLIST := $(filter-out $(FILTER),$(wildcard *))
#
MODDIRS := $(addsuffix /src,$(MODS))
MODLIBS := $(patsubst %,$(LIBDIR)/lib%.a,$(MODS))
MODLIBG := $(patsubst %,$(LIBDIR)/lib%_g.a,$(MODS))
  
# Include directories
incdirs := $(MODDIRS) $(INCDIR)/event $(INCDIR)/geom $(INCDIR)/trig \
  tracing/inc calorimetry/inc \
  $(STDHEP_DIR)/src/inc $(QQ_DIR)/src/inc $(MCFIO_DIR)/src ../dbin/src

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

# other libraries
PACKLIB = $(CRNLIB)/libpacklib.a 
MATHLIB = $(CRNLIB)/libmathlib.a 
#
TREES  := $(addprefix $(BLDDIR)/,$(MODS)) $(BLDDIR)/Flags

# dependency definitions
FDEP := \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .F,.d, $(notdir $(wildcard datafile/src/*.F)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .F,.d, $(notdir $(wildcard dbin_mcfast/src/*.F)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .F,.d, $(notdir $(wildcard dst/src/*.F)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .F,.d, $(notdir $(wildcard fitters/src/*.F)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .F,.d, $(notdir $(wildcard gamma/src/*.F)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .F,.d, $(notdir $(wildcard gen/src/*.F)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .F,.d, $(notdir $(wildcard geom/src/*.F)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .F,.d, $(notdir $(wildcard graph/src/*.F)))) \
  $(addprefix $(BLDDIR)/io/src/,$(subst .F,.d, $(notdir $(wildcard io/src/*.F)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .F,.d, $(notdir $(wildcard muon/src/*.F)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .F,.d, $(notdir $(wildcard shower/src/*.F)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .F,.d, $(notdir $(wildcard showering/src/*.F)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .F,.d, $(notdir $(wildcard sec_int/src/*.F)))) \
  $(addprefix $(BLDDIR)/track/src/,$(subst .F,.d, $(notdir $(wildcard track/src/*.F)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .F,.d, $(notdir $(wildcard tracing/src/*.F)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .F,.d, $(notdir $(wildcard calorimetry/src/*.F)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .F,.d, $(notdir $(wildcard trig/src/*.F)))) \
  $(addprefix $(BLDDIR)/user/src/,$(subst .F,.d, $(notdir $(wildcard user/src/*.F)))) \
  $(addprefix $(BLDDIR)/util/src/,$(subst .F,.d, $(notdir $(wildcard util/src/*.F)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .F,.d, $(notdir $(wildcard vertex/src/*.F))))
CDEP := \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .c,.d, $(notdir $(wildcard datafile/src/*.c)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .c,.d, $(notdir $(wildcard dbin_mcfast/src/*.c)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .c,.d, $(notdir $(wildcard dst/src/*.c)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .c,.d, $(notdir $(wildcard fitters/src/*.c)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .c,.d, $(notdir $(wildcard gamma/src/*.c)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .c,.d, $(notdir $(wildcard gen/src/*.c)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .c,.d, $(notdir $(wildcard geom/src/*.c)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .c,.d, $(notdir $(wildcard graph/src/*.c)))) \
  $(addprefix $(BLDDIR)/io/src/,$(subst .c,.d, $(notdir $(wildcard io/src/*.c)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .c,.d, $(notdir $(wildcard muon/src/*.c)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .c,.d, $(notdir $(wildcard shower/src/*.c)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .c,.d, $(notdir $(wildcard showering/src/*.c)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .c,.d, $(notdir $(wildcard sec_int/src/*.c)))) \
  $(addprefix $(BLDDIR)/track/src/,$(subst .c,.d, $(notdir $(wildcard track/src/*.c)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .c,.d, $(notdir $(wildcard tracing/src/*.c)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .c,.d, $(notdir $(wildcard calorimetry/src/*.c)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .c,.d, $(notdir $(wildcard trig/src/*.c)))) \
  $(addprefix $(BLDDIR)/user/src/,$(subst .c,.d, $(notdir $(wildcard user/src/*.c)))) \
  $(addprefix $(BLDDIR)/util/src/,$(subst .c,.d, $(notdir $(wildcard util/src/*.c)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .c,.d, $(notdir $(wildcard vertex/src/*.c))))
CCDEP := \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .cc,.d, $(notdir $(wildcard datafile/src/*.cc)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .cc,.d, $(notdir $(wildcard dbin_mcfast/src/*.cc)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .cc,.d, $(notdir $(wildcard dst/src/*.cc)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .cc,.d, $(notdir $(wildcard fitters/src/*.cc)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .cc,.d, $(notdir $(wildcard gamma/src/*.cc)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .cc,.d, $(notdir $(wildcard gen/src/*.cc)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .cc,.d, $(notdir $(wildcard geom/src/*.cc)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .cc,.d, $(notdir $(wildcard graph/src/*.cc)))) \
  $(addprefix $(BLDDIR)/io/src/,$(subst .cc,.d, $(notdir $(wildcard io/src/*.cc)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .cc,.d, $(notdir $(wildcard shower/src/*.cc)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .cc,.d, $(notdir $(wildcard showering/src/*.cc)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .cc,.d, $(notdir $(wildcard muon/src/*.cc)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .cc,.d, $(notdir $(wildcard sec_int/src/*.cc)))) \
  $(addprefix $(BLDDIR)/track/src/,$(subst .cc,.d, $(notdir $(wildcard track/src/*.cc)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .cc,.d, $(notdir $(wildcard tracing/src/*.cc)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .cc,.d, $(notdir $(wildcard calorimetry/src/*.cc)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .cc,.d, $(notdir $(wildcard trig/src/*.cc)))) \
  $(addprefix $(BLDDIR)/user/src/,$(subst .cc,.d, $(notdir $(wildcard user/src/*.cc)))) \
  $(addprefix $(BLDDIR)/util/src/,$(subst .cc,.d, $(notdir $(wildcard util/src/*.cc)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .cc,.d, $(notdir $(wildcard vertex/src/*.cc))))
DEPFILE  := $(BLDDIR)/GNUmakefile.depend
FLAGFILE := $(BLDDIR)/mcfast_out.flag
dependfiles := $(FDEP) $(CDEP) $(CCDEP)
DBIN1 := dbin_mcfast/src/mcfast_init.F dbin_mcfast/src/mcfast_read.F 
DBIN2 := dst/src/mcfdatXDR.c dst/src/mcfdatXDRall.c dst/src/mcfdatXDRmgr.c

CPPFLAGS := $(addprefix -I, $(incdirs))
FFLAGS += $(addprefix -I, $(incdirs))
MAKELIB  = [ -n "$<" ] && ar $(aropts) $@ $?

#---------------------------------------------------
# begin execution area

all: tree depend $(BLDLIBS)

#-------------
# one library at a time

datafile: $(LIBDIR)/libdatafile$(SUFFIX).a

dbin_mcfast: $(LIBDIR)/libdbin_mcfast$(SUFFIX).a

dst: $(LIBDIR)/libdst$(SUFFIX).a

fitters: $(LIBDIR)/libfitters$(SUFFIX).a

gamma: $(LIBDIR)/libgamma$(SUFFIX).a

geom:$(LIBDIR)/libgeom$(SUFFIX).a

gen: $(LIBDIR)/libgen$(SUFFIX).a

graph: $(LIBDIR)/libgraph$(SUFFIX).a

io: $(LIBDIR)/libio$(SUFFIX).a

muon: $(LIBDIR)/libmuon$(SUFFIX).a

shower: $(LIBDIR)/libshower$(SUFFIX).a

showering: $(LIBDIR)/libshowering$(SUFFIX).a

tracing: $(LIBDIR)/libtracing$(SUFFIX).a

calorimetry: $(LIBDIR)/libcalorimetry$(SUFFIX).a

sec_int: $(LIBDIR)/libsec_int$(SUFFIX).a

track: $(LIBDIR)/libtrack$(SUFFIX).a

trig: $(LIBDIR)/libtrig$(SUFFIX).a

user: $(LIBDIR)/libuser$(SUFFIX).a

util: $(LIBDIR)/libutil$(SUFFIX).a

vertex: $(LIBDIR)/libvertex$(SUFFIX).a

#-------------
# create necessary subdirectories

tree:   $(TREES)
	@echo mcfast directory tree is built

$(TREES):
	-test -d $@ || mkdir -p $@/src

#-------------
# dependencies

depend: $(DEPFILE)
	@echo Finished rebuilding dependencies

$(DEPFILE): $(DBIN1) $(DBIN2) $(dependfiles)
	@echo finished building $(DEPFILE)

#-------------
# production libraries

production:   $(DBIN1) $(DBIN2) $(MODLIBS) $(force.o) $(MCFEXE)
	@echo finished building regular libraries

$(LIBDIR)/main_args.o:    main_args.c
	@echo Compiling $< ; $(CCB) -cpp "$(CPPFLAGS)" -outfile "$@" $<
$(LIBDIR)/libdatafile.a: \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .F,.o, $(notdir $(wildcard datafile/src/*.F)))) \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .c,.o, $(notdir $(wildcard datafile/src/*.c)))) \
  $(addprefix $(BLDDIR)/datafile/src/,$(subst .cc,.o, $(notdir $(wildcard datafile/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdbin_mcfast.a:  \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .F,.o, $(notdir $(wildcard dbin_mcfast/src/*.F)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .c,.o, $(notdir $(wildcard dbin_mcfast/src/*.c)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(subst .cc,.o, $(notdir $(wildcard dbin_mcfast/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdst.a:  \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .F,.o, $(notdir $(wildcard dst/src/*.F)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .c,.o, $(notdir $(wildcard dst/src/*.c)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(subst .cc,.o, $(notdir $(wildcard dst/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libfitters.a:  \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .F,.o, $(notdir $(wildcard fitters/src/*.F)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .c,.o, $(notdir $(wildcard fitters/src/*.c)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(subst .cc,.o, $(notdir $(wildcard fitters/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgamma.a:  \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .F,.o, $(notdir $(wildcard gamma/src/*.F)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .c,.o, $(notdir $(wildcard gamma/src/*.c)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(subst .cc,.o, $(notdir $(wildcard gamma/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgen.a: \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .F,.o, $(notdir $(wildcard gen/src/*.F)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .c,.o, $(notdir $(wildcard gen/src/*.c)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(subst .cc,.o, $(notdir $(wildcard gen/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgeom.a: \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .F,.o, $(notdir $(wildcard geom/src/*.F)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .c,.o, $(notdir $(wildcard geom/src/*.c)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(subst .cc,.o, $(notdir $(wildcard geom/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgraph.a:  \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .F,.o, $(notdir $(wildcard graph/src/*.F)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .c,.o, $(notdir $(wildcard graph/src/*.c)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(subst .cc,.o, $(notdir $(wildcard graph/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libio.a:   \
  $(addprefix $(BLDDIR)/io/src/,$(subst .F,.o, $(notdir $(wildcard io/src/*.F)))) \
  $(addprefix $(BLDDIR)/io/src/,$(subst .c,.o, $(notdir $(wildcard io/src/*.c)))) \
  $(addprefix $(BLDDIR)/io/src/,$(subst .cc,.o, $(notdir $(wildcard io/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libmuon.a:  \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .F,.o, $(notdir $(wildcard muon/src/*.F)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .c,.o, $(notdir $(wildcard muon/src/*.c)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(subst .cc,.o, $(notdir $(wildcard muon/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libshower.a:  \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .F,.o, $(notdir $(wildcard shower/src/*.F)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .c,.o, $(notdir $(wildcard shower/src/*.c)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(subst .cc,.o, $(notdir $(wildcard shower/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libshowering.a:  \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .F,.o, $(notdir $(wildcard showering/src/*.F)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .c,.o, $(notdir $(wildcard showering/src/*.c)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(subst .cc,.o, $(notdir $(wildcard showering/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libsec_int.a:   \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .F,.o, $(notdir $(wildcard sec_int/src/*.F)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .c,.o, $(notdir $(wildcard sec_int/src/*.c)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(subst .cc,.o, $(notdir $(wildcard sec_int/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrack.a:   \
  $(addprefix $(BLDDIR)/track/src/,$(subst .F,.o, $(notdir $(wildcard track/src/*.F)))) \
  $(addprefix $(BLDDIR)/track/src/,$(subst .c,.o, $(notdir $(wildcard track/src/*.c)))) \
  $(addprefix $(BLDDIR)/track/src/,$(subst .cc,.o, $(notdir $(wildcard track/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtracing.a:   \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .F,.o, $(notdir $(wildcard tracing/src/*.F)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .c,.o, $(notdir $(wildcard tracing/src/*.c)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(subst .cc,.o, $(notdir $(wildcard tracing/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libcalorimetry.a:   \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .F,.o, $(notdir $(wildcard calorimetry/src/*.F)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .c,.o, $(notdir $(wildcard calorimetry/src/*.c)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(subst .cc,.o, $(notdir $(wildcard calorimetry/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrig.a:   \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .F,.o, $(notdir $(wildcard trig/src/*.F)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .c,.o, $(notdir $(wildcard trig/src/*.c)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(subst .cc,.o, $(notdir $(wildcard trig/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libuser.a:  \
  $(addprefix $(BLDDIR)/user/src/,$(subst .F,.o, $(notdir $(wildcard user/src/*.F)))) \
  $(addprefix $(BLDDIR)/user/src/,$(subst .c,.o, $(notdir $(wildcard user/src/*.c)))) \
  $(addprefix $(BLDDIR)/user/src/,$(subst .cc,.o, $(notdir $(wildcard user/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libutil.a:  \
  $(addprefix $(BLDDIR)/util/src/,$(subst .F,.o, $(notdir $(wildcard util/src/*.F)))) \
  $(addprefix $(BLDDIR)/util/src/,$(subst .c,.o, $(notdir $(wildcard util/src/*.c)))) \
  $(addprefix $(BLDDIR)/util/src/,$(subst .cc,.o, $(notdir $(wildcard util/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libvertex.a:  \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .F,.o, $(notdir $(wildcard vertex/src/*.F)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .c,.o, $(notdir $(wildcard vertex/src/*.c)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(subst .cc,.o, $(notdir $(wildcard vertex/src/*.cc))))
	@$(MAKELIB)

$(MCFEXE): $(MODLIBS) $(force.o) $(MAIN)
	@echo Generating program $@
	$(LINKER) $(LFLAGS) -o $@ \
	$(MAIN) \
	$(force.o) \
	$(MODLIBS) \
	$(LIBDIR)/libuser.a \
	$(MCFLIB)/libFmcfio.a \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(QQLIB) \
	$(MCFLIB)/libgen.a \
	$(MCFLIB)/libdbin.a \
	$(MCFLIB)/libcmd_parse.a $(MCFLIB)/libgeneral.a \
	$(PACKLIB) \
	$(MATHLIB) \
	$(TYPSCN) \
	$(PACKLIB) \
	$(SYSTEMLIBS) \
	; true
	echo Finished program $@

#-------------
# debug libraries

glib:   $(DBIN1) $(DBIN2) $(MODLIBG) $(force_g.o) $(MAING)
	@echo finished building debug libraries

$(LIBDIR)/main_args_g.o:    main_args.c
	@echo Compiling $< debug ; $(CCB) -debug -cpp "$(CPPFLAGS)" -outfile "$@" $<
$(LIBDIR)/libdatafile_g.a: \
  $(addprefix $(BLDDIR)/datafile/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard datafile/src/*.F)))) \
  $(addprefix $(BLDDIR)/datafile/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard datafile/src/*.c)))) \
  $(addprefix $(BLDDIR)/datafile/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard datafile/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdbin_mcfast_g.a:  \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard dbin_mcfast/src/*.F)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard dbin_mcfast/src/*.c)))) \
  $(addprefix $(BLDDIR)/dbin_mcfast/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard dbin_mcfast/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libdst_g.a:  \
  $(addprefix $(BLDDIR)/dst/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard dst/src/*.F)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard dst/src/*.c)))) \
  $(addprefix $(BLDDIR)/dst/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard dst/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libfitters_g.a:  \
  $(addprefix $(BLDDIR)/fitters/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard fitters/src/*.F)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard fitters/src/*.c)))) \
  $(addprefix $(BLDDIR)/fitters/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard fitters/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgamma_g.a:  \
  $(addprefix $(BLDDIR)/gamma/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard gamma/src/*.F)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard gamma/src/*.c)))) \
  $(addprefix $(BLDDIR)/gamma/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard gamma/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgen_g.a: \
  $(addprefix $(BLDDIR)/gen/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard gen/src/*.F)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard gen/src/*.c)))) \
  $(addprefix $(BLDDIR)/gen/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard gen/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgeom_g.a: \
  $(addprefix $(BLDDIR)/geom/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard geom/src/*.F)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard geom/src/*.c)))) \
  $(addprefix $(BLDDIR)/geom/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard geom/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libgraph_g.a:  \
  $(addprefix $(BLDDIR)/graph/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard graph/src/*.F)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard graph/src/*.c)))) \
  $(addprefix $(BLDDIR)/graph/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard graph/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libio_g.a:   \
  $(addprefix $(BLDDIR)/io/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard io/src/*.F)))) \
  $(addprefix $(BLDDIR)/io/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard io/src/*.c)))) \
  $(addprefix $(BLDDIR)/io/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard io/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libmuon_g.a:  \
  $(addprefix $(BLDDIR)/muon/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard muon/src/*.F)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard muon/src/*.c)))) \
  $(addprefix $(BLDDIR)/muon/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard muon/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libshower_g.a:  \
  $(addprefix $(BLDDIR)/shower/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard shower/src/*.F)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard shower/src/*.c)))) \
  $(addprefix $(BLDDIR)/shower/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard shower/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libshowering_g.a:  \
  $(addprefix $(BLDDIR)/showering/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard showering/src/*.F)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard showering/src/*.c)))) \
  $(addprefix $(BLDDIR)/showering/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard showering/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libsec_int_g.a:   \
  $(addprefix $(BLDDIR)/sec_int/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard sec_int/src/*.F)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard sec_int/src/*.c)))) \
  $(addprefix $(BLDDIR)/sec_int/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard sec_int/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrack_g.a:   \
  $(addprefix $(BLDDIR)/track/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard track/src/*.F)))) \
  $(addprefix $(BLDDIR)/track/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard track/src/*.c)))) \
  $(addprefix $(BLDDIR)/track/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard track/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtracing_g.a:   \
  $(addprefix $(BLDDIR)/tracing/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard tracing/src/*.F)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard tracing/src/*.c)))) \
  $(addprefix $(BLDDIR)/tracing/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard tracing/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libcalorimetry_g.a:   \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard calorimetry/src/*.F)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard calorimetry/src/*.c)))) \
  $(addprefix $(BLDDIR)/calorimetry/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard calorimetry/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libtrig_g.a:   \
  $(addprefix $(BLDDIR)/trig/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard trig/src/*.F)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard trig/src/*.c)))) \
  $(addprefix $(BLDDIR)/trig/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard trig/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libuser_g.a:  \
  $(addprefix $(BLDDIR)/user/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard user/src/*.F)))) \
  $(addprefix $(BLDDIR)/user/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard user/src/*.c)))) \
  $(addprefix $(BLDDIR)/user/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard user/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libutil_g.a:  \
  $(addprefix $(BLDDIR)/util/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard util/src/*.F)))) \
  $(addprefix $(BLDDIR)/util/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard util/src/*.c)))) \
  $(addprefix $(BLDDIR)/util/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard util/src/*.cc))))
	@$(MAKELIB)
$(LIBDIR)/libvertex_g.a:  \
  $(addprefix $(BLDDIR)/vertex/src/,$(patsubst %.F,%_g.o, $(notdir $(wildcard vertex/src/*.F)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(patsubst %.c,%_g.o, $(notdir $(wildcard vertex/src/*.c)))) \
  $(addprefix $(BLDDIR)/vertex/src/,$(patsubst %.cc,%_g.o, $(notdir $(wildcard vertex/src/*.cc))))
	@$(MAKELIB)

#---------------------------------------------------
# run dbin where necessary

templates: 
	@echo force rebuild of files in dbin_mcfast
	@$(RM) $(wildcard dbin_mcfast/src/*.F)
	@$(RM) $(wildcard dbin_mcfast/src/*.inc)
	@$(RM) $(wildcard dbin_mcfast/src/*.c)
	@$(RM) $(wildcard dbin_mcfast/src/*.h)
	@$(RM) dbin_mcfast/src/db
	$(MAKE) $(DBIN1)

$(DBIN1): dbin_mcfast/src/template.db $(wildcard dbin_mcfast/src/db/*.db)
	@echo rebuilding $@
	@cd dbin_mcfast/src; $(MAKE) all

$(DBIN2): dst/src/mcfdat.dst
	@echo rebuilding $@
	@cd dst/src; $(MAKE) all

#-------------
# mcfast_out

$(force.F):
	@echo Remaking $@
	@$(RM) $@
	@$(mangle) $(FLAGFILE) $@

$(force.o): $(force.F)
	@echo Compiling $<
	@$(FC) $(ABSOFT)  -nodebug -f77 "$(FFLAGS)" -cpp "$(CPPFLAGS)" -wdir $(<D) -sdir $(<D) $(<F)
	@mv $(<D)/$(@F) $@

$(force_g.o): $(force.F)
	@echo Compiling $< debug
	@$(FC) $(ABSOFT) -debug -f77 "$(FDBGFLAG)" -cpp "$(CPPFLAGS)" -wdir $(<D) -sdir $(<D) -outfile $(@F) $(<F)
	@mv $(<D)/$(@F) $@

#---------------------------------------------------
# cleanup

clean:
	@echo deleting all libraries
	@$(RM) $(MODLIBS) $(MODLIBG)
	@$(RM) $(LIBDIR)/main_args*.o
	@$(RM) $(LIBDIR)/mcfast*.o
	@echo deleting all executable code
	@$(RM) $(MCFEXE)
	@echo deleting all dependency files        
	find $(BLDDIR) -name "*.d" -exec rm {} \;
	@echo deleting all .o files
	find $(BLDDIR) -name "*.o" -exec rm {} \;
	@echo deleting all .f files
	find $(BLDDIR) -name "*.f" -exec rm {} \;
	@$(RM) $(BLDDIR)/mcfast*.F $(DEPFILE)* $(FLAGFILE) $(force.F)

cleanobjs:
#	@echo deleting all libraries
#	@$(RM) $(MODLIBS) $(MODLIBG)
#	@$(RM) $(LIBDIR)/main_args*.o
#	@$(RM) $(LIBDIR)/mcfast*.o
	@echo deleting all executable code
	@$(RM) $(MCFEXE)
	@echo deleting all .o files
	find $(BLDDIR) -name "*.o" -exec rm {} \;
	@echo deleting all .f files
	find $(BLDDIR) -name "*.f" -exec rm {} \;

clean_glib:
	@echo deleting all debug libraries
	@$(RM) $(MODLIBG)
	@$(RM) $(LIBDIR)/*_g.o
	@echo deleting all _g.o files
	find $(BLDDIR) -name "*_g.o" -exec rem_dep {} $(DEPFILE) \; -exec rm {} \; 

clean.depend:
	@echo deleting all dependency files        
	find $(BLDDIR) -name "*.d" -exec rm {} \;
	@$(RM) $(DEPFILE)* $(FLAGFILE)

#---------------------------------------------------
# rules

$(BLDDIR)/%.o: %.F
	@echo Compiling $<; $(FC) $(ABSOFT) -nodebug -f77 "$(FFLAGS)" -cpp "$(CPPFLAGS)" -wdir $(@D) -sdir $(<D) $(<F)

$(BLDDIR)/%_g.o: %.F
	@echo Compiling $< debug; $(FC) $(ABSOFT) -debug -f77 "$(FDBGFLAG)" -cpp "$(CPPFLAGS)" -wdir $(@D) -sdir $(<D) -outfile $(@F) $(<F)

$(BLDDIR)/%.o: %.c
	@echo Compiling $<; $(CCB) -nodebug -cpp "$(CPPFLAGS)" -outfile "$@" $<

$(BLDDIR)/%_g.o: %.c
	@echo Compiling $< debug; $(CCB) -debug -cpp "$(CPPFLAGS)" -outfile "$@" $<

$(BLDDIR)/%.o: %.cc
	@echo Compiling $<; $(C++CB) -nodebug -cpp "$(CPPFLAGS) -O3" -outfile "$@" $<

$(BLDDIR)/%_g.o: %.cc
	@echo Compiling $< debug; $(C++CB) -debug -cpp "$(CPPFLAGS) -O3" -outfile "$@" $<

$(BLDDIR)/%.d: %.F
	@echo get dependencies for $< 
	@$(FDPG) -inc "$(incdirs)" -flagfile $(FLAGFILE) -outfile "$@" $<
	@add_dep $@ $(DEPFILE)

$(BLDDIR)/%.d: %.c
	@echo get dependencies for $< 
	@$(DPG) -cpp "$(CPPFLAGS)" $< $@
	@add_dep $@ $(DEPFILE)

$(BLDDIR)/%.d: %.cc
	@echo get dependencies for $< 
	@$(DPG) -cpp "$(CPPFLAGS)" $< $@
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
	@echo $(force.F)
	@echo 
	@echo $(LIBLIST)
	@echo $(MODDIRS)

#---------------------------------------------------
# delete some useless implicit rules

%::%,v
%::RCS/%,v
%::s.%
%::SCCS/s.%

.PHONY: all depend clean clean.depend cleanobj clean_glib test templates $(force.F)
.SUFFIXES: .cc .h .c .inc .F .d .f .depend .incdirs null

#---------------------------------------------------
#####
##### external dependency files
#####
##### /dev/null is a trick in case none of the dependency files exist
##### without this trick gmake prints a warning and stops.

include /dev/null $(wildcard $(DEPFILE))

