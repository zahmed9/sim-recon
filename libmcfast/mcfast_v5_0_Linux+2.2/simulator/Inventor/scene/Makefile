###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast 

INC1 =  .
INC9 = $(MCFAST_DIR)/simulator/Inventor
INC8 = $(MCFAST_DIR)/simulator/Inventor/include

#User .o files are listed here
LIST_O =SoDetectorTreeKit.o \
	SoMcFSilStripHitKit.o \
	SoG4Cons.o \
	SoMcFCalBlockKit.o \
	SoMcFCalCellKit.o \
	SoMcFCalEnergyKit.o \
	SoMcFConsKit.o \
	SoMcFDetectorTreeKit.o \
	SoXtAngleSlider.o \
	SoMcFBoxWithGap.o \
	SoMcFXYPlaneKit.o \
	SoMcFCons.o \
	SoMcFXYSilKit.o \
	SoMcFCirDiskWedge.o \
	SoMcFTraceKit.o\
	SoD0Circle.o \
	SoHandleBoxKit.o \
	SoMcFZRectWaferKit.o \
	resetPickParameters.o


#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC8) -I$(INC9)
CCFLAG = -g -I$(INC1) -I$(INC8) -I$(INC9)
CFLAG = -g -I$(INC1) -I$(INC8) -I$(INC9)


.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr scene.a *.o
	mv scene.a $(IVLIB)

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
