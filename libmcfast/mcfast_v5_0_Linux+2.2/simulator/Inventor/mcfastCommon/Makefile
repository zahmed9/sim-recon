###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast

INC1 =  .
INC2 = $(MCFSRC)/dbin_mcfast/src
INC3 = $(MCFIO_DIR)/src
INC4 = $(STDHEP_DIR)/src/inc
INC5 = $(MCFSRC)/io/src
INC6 = $(MCFSRC)/dst/src
INC7 = $(MCFSRC)/shower/src
INC8 = $(MCFAST_DIR)/simulator/Inventor
INC9 = $(MCFAST_DIR)/simulator/Inventor/include
INC10 = $(STDHEP_DIR)/src/display

#User .o files are listed here
LIST_O = \
	muonCommon.o \
	muonPrint.o \
	solenoidCommon.o \
	solenoidPrint.o \
	beampipeCommon.o \
	beampipePrint.o \
	absorberCommon.o \
	absorberPrint.o \
 	absorberBoxCommon.o\
	absorberBoxPrint.o \
	calorBoxCommon.o \
	calorBoxPrint.o \
	calorCommon.o \
	calorPrint.o \
	dipoleCommon.o \
	dipolePrint.o \
	drftCommon.o \
	drftPrint.o \
	siXYCommon.o \
	siXYPrint.o \
	SiBarrelCommon.o \
	SiBarrelPrint.o \
	SiDiskCommon.o \
	SiDiskPrint.o \
	SiZRectCommon.o \
	SiZRectPrint.o \
	ftrkCommon.o\
	ftrkPrint.o \
	traceCommon.o\
        hitsCommon.o \
        detectorPrint.o \
        calCellPrint.o \
        mcfCalEnergy.o 

#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) -I$(INC5) -I$(INC6) \
 -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10)
CCFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) -I$(INC5) -I$(INC6)\
  -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10)
CFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) -I$(INC5) -I$(INC6) \
 -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10)


.SUFFIXES : .C .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr mcfastCommon.a *.o
	mv mcfastCommon.a $(IVLIB)

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
