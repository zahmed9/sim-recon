###################################################
#  Makefile: General library and executable maker 
###################################################

TOP =  $(MCFAST_DIR)
INC1 = $(TOP)/inc/event
INC2 = $(TOP)/inc/geom
INC3 = $(TOP)/inc/trig
INC4 = $(STDHEP_INC)
LIB =  $(TOP)/lib.IRIX

LIST_O = \
usr_analysis.o \
usr_before_trigger.o \
usr_command.o \
usr_filter.o \
usr_generate_event.o \
usr_hbinit.o \
usr_hbsummary.o \
usr_hsinit.o \
usr_init.o \
usr_mcfio_out.o \
usr_summary.o

FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC4)

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/libuser.a

$(LIB)/libuser.a: $(LIST_O)
	ar r libuser.a $(LIST_O);
	mv libuser.a $(LIB);
	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

