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
shw_init.o \
shw_make_offline.o \
shw_summary.o

FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC2) -I$(INC4)

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/libshower.a

$(LIB)/libshower.a: $(LIST_O)
	ar r libshower.a $(LIST_O);
	mv libshower.a $(LIB);
	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

