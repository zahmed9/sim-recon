###################################################
#  Makefile: General library and executable maker 
###################################################

TOP = $(MCFAST_DIR)
INC1 = $(TOP)/inc/event
INC2 = $(TOP)/inc/geom
INC3 = $(TOP)/src/dst
INC4 = $(TOP)/src/geom
INC5 = $(TOP)/src/io
INC6 = $(STDHEP_INC)
INC7 = $(EXPLORER_INC)
INC8 = $(MCFIO_DIR)/src
INC9 = $(MCFAST_DIR)/src/dbin_mcfast
LIB = .

LIST_O = \
get_commons.o\
McfGeomIO.o\
McfShapeFill.o\
Mcf_ReadEvent.o
FLAG  = -g
FFLAG = -g -I -I$(INC1) -I$(INC2) -I$(INC4) -I$(INC3) -I$(INC5) -I$(INC6) \
-I$(INC7) -I$(INC8) -I$(INC9)
CFLAG = -g -I/home/sim1/bphyslib/mcfio/v1.3/src -I$(MCFAST_DIR)/src/dst\
  -I$(MCFAST_DIR)/src/io -I$(STDHEP_INC) -I$(MCFAST_DIR)/inc/event\
  -I$(MCFAST_DIR)/src/dbin_mcfast -I../

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/libgraph.a

$(LIB)/libgraph.a: $(LIST_O)
	ar r libgraph.a $(LIST_O);
#	mv libgraph.a $(LIB);
#	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

