#
# main StdHep makefile
#
MAKE=gmake

ifdef DEBUG
  DMAKE = "DEBUG=$(DEBUG)"
endif
#------------------------------------------

##all: binlib mcfio stdhep spin util display stdhepcxx
all: binlib mcfio stdhep stdhepcxx

binlib:
	-test -d $(STDHEP_DIR)/bin || mkdir -p $(STDHEP_DIR)/bin
	-test -d $(STDHEP_DIR)/lib || mkdir -p $(STDHEP_DIR)/lib

mcfio:
	(cd mcfio; $(MAKE) $(DMAKE) all) > log.mcfio_all.$$$$ 2>&1

stdhep:
	(cd stdhep; $(MAKE) $(DMAKE) all) > log.stdhep_all.$$$$ 2>&1

stdhepcxx:
	(cd StdHepC++; $(MAKE) $(DMAKE) all) > log.stdhepcxx_all.$$$$ 2>&1

spin:
	(cd display/spin; $(MAKE) $(DMAKE) all) > log.spin_all.$$$$ 2>&1

util:
	(cd display/util; $(MAKE) $(DMAKE) all) > log.util_all.$$$$ 2>&1

display:
	(cd display; $(MAKE) $(DMAKE) all) > log.display_all.$$$$ 2>&1

clean:
	cd mcfio; $(MAKE) $(DMAKE) clean
	cd stdhep; $(MAKE) $(DMAKE) clean
	cd StdHepC++; $(MAKE) $(DMAKE) clean
	cd display; $(MAKE) $(DMAKE) clean
	cd display/spin; $(MAKE) $(DMAKE) clean
	cd display/util; $(MAKE) $(DMAKE) clean

realclean:
	cd mcfio; $(MAKE) realclean
	cd stdhep; $(MAKE) realclean
	cd StdHepC++; $(MAKE) $(DMAKE) realclean
	cd display; $(MAKE) realclean
	cd display/spin; $(MAKE) realclean
	cd display/util; $(MAKE) realclean


#------------------------------------------

.PHONY: all clean realclean mcfio stdhep spin util display StdHepData
