#
# MCFAST master makefile -- builds mcfast and associated libraries
#
MAKE=gmake
MAKEFILE=GNUmakefile

# allow a hook for forcing use of the absoft compiler
COMPILER = default

SUBNAMES = util mcfio evgen simulator

PWD=$(shell pwd)
UNAME=$(shell uname)
ifeq "$(UNAME)" "IRIX"
  IRIX6 = $(findstring 6,$(shell uname -r))
  ifeq "$(IRIX6)" "6"
    UNAME = IRIX64
  endif
endif

WORK=$(MCFAST_DIR)/build/$(UNAME)

#.PHONY:$(SUBNAMES)

mklib production depend glib ::
	$(MAKE) -f $(MAKEFILE) $(SUBNAMES) "TARGET=$@" "COMPILER=$(COMPILER)"

all ::
	$(MAKE) -f $(MAKEFILE) tree
	$(MAKE) -f $(MAKEFILE) dbin
	$(MAKE) -f $(MAKEFILE) depend production

tree ::
	-test -d build || mkdir -p build
	-test -d build/$(UNAME) || mkdir -p build/$(UNAME)
	-test -d bin.$(UNAME) || mkdir -p bin.$(UNAME)
	-test -d lib.$(UNAME) || mkdir -p lib.$(UNAME)
	-test -d build/$(UNAME)/dbin || mkdir -p build/$(UNAME)/dbin
	-test -d build/$(UNAME)/util || mkdir -p build/$(UNAME)/util
	-test -d build/$(UNAME)/util/general || mkdir -p build/$(UNAME)/util/general
	-test -d build/$(UNAME)/util/cmd_parse || mkdir -p build/$(UNAME)/util/cmd_parse
	-test -d build/$(UNAME)/mcfio || mkdir -p build/$(UNAME)/mcfio
	-test -d build/$(UNAME)/mcfio/src || mkdir -p build/$(UNAME)/mcfio/src
	-test -d build/$(UNAME)/evgen || mkdir -p build/$(UNAME)/evgen
	-test -d build/$(UNAME)/evgen/src || mkdir -p build/$(UNAME)/evgen/src
	-test -d build/$(UNAME)/simulator || mkdir -p build/$(UNAME)/simulator
	-test -L doc/simulator || ln -s ../simulator/doc doc/simulator
	-test -L doc/evgen || ln -s ../evgen/doc doc/evgen
	-test -L doc/mcfio || ln -s ../mcfio/doc doc/mcfio
	-test -L doc/dbin || ln -s ../dbin/doc doc/dbin
	-test -L example/evgen || ln -s ../evgen/example example/evgen
	-test -L inc/evgen || ln -s ../evgen/inc inc/evgen
	-test -L inc/tracing || ln -s ../simulator/tracing/inc inc/tracing
	-test -L inc/calorimetry || ln -s ../simulator/calorimetry/src inc/calorimetry
	-test -L inc/dst || ln -s ../simulator/dst/src inc/dst
	-test -L inc/dbin_mcfast || ln -s ../simulator/dbin_mcfast/src inc/dbin_mcfast
	-(cd simulator; $(MAKE) tree)
	-(cd simulator/Inventor; $(MAKE) tree)

dbin ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $@; pwd; $(MAKE) COMPILER=$(COMPILER) production) > $(WORK)/$@.production.log_$$$$ 2>&1

util ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $@; pwd; $(MAKE) COMPILER=$(COMPILER) $(TARGET)) > $(WORK)/$@.$(TARGET).log_$$$$ 2>&1

mcfio ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $@; pwd; $(MAKE) COMPILER=$(COMPILER) $(TARGET)) > $(WORK)/$@.$(TARGET).log_$$$$ 2>&1

evgen ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $@; pwd; $(MAKE) COMPILER=$(COMPILER) $(TARGET)) > $(WORK)/$@.$(TARGET).log_$$$$ 2>&1

simulator ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $@; pwd; $(MAKE) COMPILER=$(COMPILER) $(TARGET)) > $(WORK)/$@.$(TARGET).log_$$$$ 2>&1

mcfiv ::
	@echo ""; echo "Building $@"; echo ""
	-(cd simulator/Inventor; pwd; $(MAKE) -f $(MAKEFILE) depend) > $(WORK)/$@.depend.log_$$$$ 2>&1
	-(cd simulator/Inventor; pwd; $(MAKE) -f $(MAKEFILE) production) > $(WORK)/$@.production.log_$$$$ 2>&1

cleanobjs ::
	-(cd mcfio; $(MAKE) cleanobjs) > $(WORK)/mcfio.clean.log_$$$$ 2>&1
	-(cd util; $(MAKE) cleanobjs) > $(WORK)/util.clean.log_$$$$ 2>&1
	-(cd dbin; $(MAKE) cleanobjs) > $(WORK)/dbin.clean.log_$$$$ 2>&1
	-(cd evgen; $(MAKE) cleanobjs) > $(WORK)/evgen.clean.log_$$$$ 2>&1
	-(cd simulator; $(MAKE) cleanobjs) > $(WORK)/simulator.clean.log_$$$$ 2>&1

# cleanup for distribution
dist-clean ::
	@echo deleting all dependency, .o, and .f files        
	find build -name "*.d" -exec rm {} \;
	find build -name "*.o" -exec rm {} \;
	find build -name "*.f" -exec rm {} \;
	find build -name "*.bak" -exec rm {} \;
