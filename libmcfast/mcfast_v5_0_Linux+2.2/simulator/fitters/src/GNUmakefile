###################################################
#  Makefile: General library and executable maker 
###################################################

BPHYS = /afs/fnal.gov/files/home/room1/bphyslib

INC1 = $(MCFAST_DIR)/inc/event
INC2 = $(MCFAST_DIR)/inc/geom
INC3 = $(MCFAST_DIR)/inc/trig
INC4 = $(STDHEP_DIR)/src
LIB = $(MCFAST_DIR)/lib.IRIX

FLIST = $(wildcard *.f)
OLIST = $(patsubst %.f,%.o,$(FLIST))
LIST_O = $(OLIST)


FLAG  = -g
FFLAG = -g -C -I$(INC1) -I$(INC2) -I$(INC4)

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/libfitters.a

$(LIB)/libfitters.a: $(LIST_O)
	ar r libfitters.a $(LIST_O);
	mv libfitters.a $(LIB);
#	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

