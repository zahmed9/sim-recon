#############################################################
#
# Makefile for converting Root macros into executables
#                     
# 
# Created by Paul M Eugenio 17-Feb-1999 CMU

#------------------------------------------------------------------------------



MCROOT        =  /home/halld/src/mcroot

ROOTLIBS      = -L$(ROOTSYS)/lib -lNew -lBase -lCint -lClib -lCont -lFunc \
                -lGraf -lGraf3d -lHist -lHtml -lMatrix -lMeta -lMinuit -lNet \
                -lPostscript -lProof -lTree -lUnix -lZip
ROOTGLIBS     = -lGpad -lGui -lGX11 -lX3d

##############################################################################
# Machine dependent stuff.
#
ifeq "$(UNAME)" "OSF1"
# Alpha/OSF with egcs -fwritable-strings
CXX           = g++
CXXFLAGS      = -O -g -I$(ROOTSYS)/include -fPIC -fno-rtti -fno-exceptions \
                -fwritable-strings -mcpu=ev5 -D__osf__ -D__alpha
LD            = g++
LDFLAGS       = -g -fwritable-strings
SOFLAGS       = -Wl,-expect_unresolved,* -shared
LIBS          = $(ROOTLIBS) -lg++ -lm
GLIBS         = $(ROOTLIBS) $(ROOTGLIBS) -lXpm -lX11 \
	        -lg++ -lm -lPW
endif 

ifeq "$(UNAME)" "Linux"
# Linux with egcs
CXX           = g++
CXXFLAGS      = -O2 -g -Wall -fno-rtti -fno-exceptions -fPIC -I$(ROOTSYS)/include -I$(MCROOT)
LD            = g++
LDFLAGS       = -g
SOFLAGS       = -shared
LIBS          = $(ROOTLIBS) -lm -ldl -rdynamic
GLIBS         = $(ROOTLIBS) $(ROOTGLIBS) -L/usr/X11R6/lib \
                -lXpm -lX11 -lm -ldl -rdynamic
endif
##############################################################################

OBJS          =   main2_tof.o  main3_tof.o
PROGRAMS      =   main2_tof    main3_tof
all:             $(PROGRAMS)
TMCFast_LIB =    $(HALLD_HOME)/lib/$(UNAME)/libTMCFast.a

#------------------------------------------------------------------------------




main2_tof:      main2_tof.o 
		$(LD) $(LDFLAGS) main2_tof.o  $(TMCFast_LIB) $(GLIBS) -o main2_tof
		@echo "main2_tof done"

main3_tof:	main3_tof.o
		$(LD) $(LDFLAGS) main3_tof.o  $(TMCFast_LIB) $(GLIBS) -o main3_tof
		@echo "main3_tof done"

#------------------------------------------------------------------------------
clean:
		@rm -f $(OBJS) *Dict.* core *~ 

.SUFFIXES: .cxx .C

###

.cxx.o:
	$(CXX) $(CXXFLAGS) -c $<







