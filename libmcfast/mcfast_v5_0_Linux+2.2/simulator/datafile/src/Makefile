###################################################
#  Makefile: General library and executable maker 
###################################################

TOP = ../..
INC1 = $(TOP)/inc/event
INC2 = $(TOP)/inc/geom
INC3 = $(TOP)/inc/trig
LIB = $(TOP)/lib.IRIX

LIST_O = \
dtf_addfile.o \
dtf_getcurrent.o \
dtf_getnext.o \
dtf_init.o \
dtf_insert.o \
dtf_list.o \
dtf_number.o \
dtf_open.o \
dtf_putcurrent.o \
dtf_setdone.o

FLAG  = -g
FFLAG = -g -I$(INC1)

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/main_args.o $(LIB)/libdatafile.a

$(LIB)/libdatafile.a: $(LIST_O)
	ar r libdatafile.a $(LIST_O);
	mv libdatafile.a $(LIB);
	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

