###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast

INC1 =  .
INC8 = $(MCFAST_DIR)/simulator/Inventor
INC9 = $(MCFAST_DIR)/simulator/Inventor/include

#User .o files are listed here
LIST_O = \
	McFSilDiskHits.o \
	McFSilBarrelHits.o \
	McFSilXYHits.o \
	McFSilZRectHits.o \
	hitsDisplayInfo.o \
	hitsDisplay.o


#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1)  -I$(INC8) -I$(INC9) 
CCFLAG = -g -I$(INC1)  -I$(INC8) -I$(INC9)
CFLAG = -g -I$(INC1)  -I$(INC8) -I$(INC9) 


.SUFFIXES : .C .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr hits.a *.o
	mv hits.a $(IVLIB)

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c  $(CFLAG) $?

.C.o:
	CC -c  $(CCFLAG) $?

.cc.o:
	CC -c  $(CCFLAG) $?
