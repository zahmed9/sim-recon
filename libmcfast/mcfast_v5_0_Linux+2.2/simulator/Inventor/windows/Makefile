###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast with ~bphyslib/setup_files/mcenv.$SITE_NAME

INC1 =  .
INC7 = $(STDHEP_DIR)/src/display/util
INC8 = $(MCFAST_DIR)/simulator/Inventor
INC9 = $(MCFAST_DIR)/simulator/Inventor/include
INC10 = $(STDHEP_DIR)/src/display

#User .o files are listed here
LIST_O = \
	McfMainMenu.o \
	displayTypes.o \
	McfUtilities.o \
	eventInformation.o \
	mcfCalModifyWindow.o \
	mcfDisplay.o \
	mcfDisplayList.o \
	mcfEnergyScaleWindow.o \
	mcfFile.o \
	mcfMainPanel.o \
	mcfPickInfoWindow.o \
	mcfPlotDefine.o \
	mcfPlotWindow.o \
	mcfTraceModifyWindow.o \
	mcfDetectorModify.o \
	mcfWindow.o 

#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1)  \
 -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10) 
CCFLAG = -g -I$(INC1) \
  -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10)
CFLAG = -g -I$(INC1)  \
 -I$(INC7) -I$(INC8) -I$(INC9) -I$(INC10) 


.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

trace: $(LIST_O)
	ar vr windows.a *.o
	mv windows.a $(IVLIB)

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
