###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast

INC1 = $(MCFAST_DIR)/simulator/Inventor/include


#User .o files are listed here
LIST_O = glpr.o 


#compile debug
FLAG  = -g
FFLAG = -g -I$(INC1)  
CCFLAG = -g -I$(INC1)
CFLAG = -g -I$(INC1)  


.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------
# for OSF1 use -nofor_main

testGui: $(LIST_O)
	CC -g -o glpr                    \
	$(LIST_O) \
	$(IVLIB)util.a \
	$(STDHEP_DIR)/lib/libNUtil.a \
	 -lInventor -lInventorXt \
	 $(GLP) -lGL -lGLU -lXm  -lXt -lX11 -lm

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c  $(CFLAG) $?

.C.o:
	CC -c  $(CCFLAG) $?

