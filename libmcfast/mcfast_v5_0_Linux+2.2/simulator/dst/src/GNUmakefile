#
#
# source code files in simulator/dst/src are generated from mcfdat.dst
# Use:  $MCFAST_DIR/bin.$UNAME/dbin mcfdat.dst
#
include ../../simulator_arch

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SRCS))
INCDIRS := geom event
INCLIST := -I../dbin $(patsubst %,-I../../pro/inc/%,$(INCDIRS)) -I$(STDHEP_DIR)/src/inc -I$(QQ_DIR)/src/inc -I$(MCFIO_DIR)/src -I../../pro/src/dbin

all: code

code:
	$(MCFAST_DIR)/bin.$(UNAME)/dbin mcfdat.dst

dst: $(OBJS)

%.o: %.F $(INCS)
	@echo Compiling $<; f77 -c -g $(INCLIST) $<
%.o: %.cc $(INCS)
	@echo Compiling $<; CC -c -g $(INCLIST) $<
%.o: %.c $(INCS)
	@echo Compiling $<; cc -c -g $(INCLIST) $<

.PHONY: all dst code
