###################################################
#  Makefile: General library and executable maker 
###################################################

TOP = ../..

INC1 = $(TOP)/inc/event
INC2 = $(TOP)/inc/geom
INC3 = $(TOP)/inc/trig
INC4 = $(STDHEP_DIR)/src 
LIB = $(TOP)/lib.IRIX

LIST_O = \
gen_to_par.o \
gen_to_w.o \
wtoeta.o 

FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC2) -I$(INC4) 

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/libuser.a

$(LIB)/libuser.a: $(LIST_O)
	ar r libutil.a $(LIST_O);
	mv libutil.a $(LIB)/libutil.a;
	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

















