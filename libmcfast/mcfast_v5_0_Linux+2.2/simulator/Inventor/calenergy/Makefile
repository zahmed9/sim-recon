###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast with ~bphyslib/setup_files/mcenv.$SITE_NAME

INC1 =  .
INC2 = $(MCFAST_DIR)/simulator/Inventor/hepvis
INC3 = $(MCFAST_DIR)/simulator/Inventor
INC4 = $(MCFAST_DIR)/simulator/Inventor/include
INC5 = 
INC6 = $(STDHEP_DIR)/src/inc
INC7 = $(MCFSRC)/shower/src
INC8 = $(MCFAST_DIR)/simulator/Inventor
INC9 = $(MCFAST_DIR)/simulator/Inventor/include


#User .o files are listed here
LIST_O = Calorimeter.o \
	calDisplay.o \
	calDisplayInfo.o \
	calPlot.o \
	calPlotManager.o \
	etaCalPlot.o \
	mcfCalEtaEnergy.o \
	mcfCalPhiEnergy.o \
	phiCalPlot.o \
	threeDPlot.o 



#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) 
CCFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) 
CFLAG = -g -I$(INC1) -I$(INC2) -I$(INC3) -I$(INC4) 


.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr calenergy.a *.o
	mv calenergy.a $(IVLIB)

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

