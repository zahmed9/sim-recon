#
# GNU makefile for managing the dbin database tool
#   MCFAST version
#
#     Torre Wenaus 8/95
# modified 10/3/95 by Lynn Garren
#
# source code files in simulator/dbin_mcfast/src are generated from template.db
# Use:  $MCFAST_DIR/bin.$UNAME/dbin template.db
#
include ../../simulator_arch

SRCS := $(wildcard *.F)
OBJS := $(patsubst %.F,%.o,$(SRCS))
OBJSG := $(patsubst %.F,%_g.o,$(SRCS))

CCSRCS := $(wildcard mcfast*.c)
CCOBJS := $(patsubst %.c,%.o,$(CCSRCS))
CCOBJSG := $(patsubst %.c,%_g.o,$(CCSRCS))
LIBNAME := ../../lib.$(UNAME)/libdbin_mcfast

all: db template

libdbin_mcfast: $(LIBNAME).a db

libdbin_mcfast_g: $(LIBNAME)_g.a db

db:
	@rm -f db
	@ln -s ../../../db db

template:
	$(MCFAST_DIR)/bin.$(UNAME)/dbin template.db

$(LIBNAME).a: $(CCOBJS) $(OBJS)
	@ar rv $(LIBNAME).a $?

$(LIBNAME)_g.a: $(CCOBJSG) $(OBJSG)
	@ar rv $(LIBNAME)_g.a $?


%.o: %.F mcfast_db.inc
	@echo Compiling $<; f77 -c -g -I../../inc/geom -I$(UTIL_DIR)/dbin $<

%.o: %.c mcfast_db.h
	@echo Compiling $<; cc -c -g -I$(MCFIO_DIR)/src -I$(UTIL_DIR)/dbin $<

test:
	@echo $(CCSRCS)

clean:
	rm -f *.o ../../lib.$(UNAME)/libdbin_mcfast*.a

.PHONY: test libdbin_mcfast template db
