###################################################
#  Makefile: General library and executable maker 
#      ---> uses default user routines 
###################################################

# setup mcfast with ~bphyslib/setup_files/mcenv.$SITE_NAME

INC1 = $(MCFAST_DIR)/simulator/Inventor/include


#User .o files are listed here
LIST_O = mcfiv.o 

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

mcfiv: $(LIST_O)
	CC -g -o mcfiv_x  mcfiv.o                \
	$(IVLIB)/windows.a \
	$(IVLIB)/detector.a \
	$(IVLIB)/calenergy.a \
	$(IVLIB)/trace.a \
	$(IVLIB)/scene.a \
	$(IVLIB)/windows.a \
	$(IVLIB)/detector.a \
	$(IVLIB)/hits.a \
	$(IVLIB)/mcfastCommon.a \
	$(IVLIB)/util.a \
	$(LIST_O) \
	$(MCFLIB)/libdbin_mcfast.a \
	$(MCFLIB)/libio.a \
	$(STDHEP_DIR)/lib/libstdhep.a \
	$(MCFLIB)/libdst.a \
	$(MCFLIB)/libdbin_mcfast.a\
	$(MCFLIB)/libshower.a\
	$(MCFLIB)/libgeom.a\
	$(GLIB)/libdbin.a \
	$(STDHEP_DIR)/lib/libNUtil.a \
	$(STDHEP_DIR)/lib/libPhaseStdHep.a \
	$(GLIB)/libgeneral.a \
	$(MCFLIB)/libFmcfio.a -lInventor -lInventorXt \
	$(CRNLIB)/libpacklib.a \
	/usr/lib/libftn.so $(GLP) -lGL -lXm  -lXt -lX11 -lm
#	mv mcfast $(BIN)

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c  $(CFLAG) $?

.C.o:
	CC -c  $(CCFLAG) $?

.cc.o:  
	CC -c $(CCFLAG) $?
