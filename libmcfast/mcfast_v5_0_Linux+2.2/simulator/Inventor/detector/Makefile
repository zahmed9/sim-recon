###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast

INC1 =  .
INC3 = $(MCFIO_DIR)/src
INC4 = $(STDHEP_DIR)/src/inc
INC7 = $(MCFSRC)/shower
INC8 = $(MCFAST_DIR)/simulator/Inventor
INC9 = $(MCFAST_DIR)/simulator/Inventor/include
INC10 = $(STDHEP_DIR)/src/display

#User .o files are listed here
LIST_O = \
	CalDetector.o \
	McFBarrelCal.o \
	McFDetectorTreeList.o \
	McFForwardCal.o \
	McFProjectiveCal.o \
	detectorDisplay.o \
	threeDDetPlot.o \
	ivFileDetPlot.o \
	Detector.o \
	McFSilBarrel.o \
	McFSilDisk.o \
	McFSilXY.o\
	McFSilXYLayer.o\
	McFFtrk.o \
	McFCylDrift.o \
	absZRectWafer.o \
	allZRectWafer.o \
	spcZRectWafer.o \
	absZRectLayer.o \
	oneZRectPlane.o \
	twoYZRectPlanes.o \
	twoXZRectPlanes.o \
	ZRectWithHole.o \
	McFZRect.o


#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC8) -I$(INC9) -I$(INC10)
CCFLAG = -g -I$(INC1) -I$(INC8) -I$(INC9) -I$(INC10)
CFLAG = -g -I$(INC1)  -I$(INC8) -I$(INC9) -I$(INC10)


.SUFFIXES : .C .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr detector.a *.o
	mv detector.a $(IVLIB)

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
