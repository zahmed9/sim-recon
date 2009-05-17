SOURCE = hddm_s.h hddm_s.c
PACKAGES = JANA:ROOT

all: lib

$(SOURCE): event.xml
	hddm-c $<

lib: $(SOURCE)
	make -f $(HALLD_HOME)/src/BMS/Makefile.lib
