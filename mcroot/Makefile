#
#  WARNING This makefile is currently only setup for Alpha/OSF with g++
#
 

ObjSuf        = o
SrcSuf        = cxx
ExeSuf        =
DllSuf        = so
MCFASTLIB      = $(TMCFastO)
OutPutOpt     = -o

ROOTLIBS      = -L$(ROOTSYS)/lib -lNew -lBase -lCint -lClib -lCont -lFunc \
                -lGraf -lGraf3d -lHist -lHtml -lMatrix -lMeta -lMinuit -lNet \
                -lPostscript -lProof -lTree -lUnix -lZip
ROOTGLIBS     = -lGpad -lGui -lGX11 -lX3d

ROOTLIBS      = $(shell root-config --libs)
ROOTGLIBS     = $(shell  root-config --glibs)   

LIBPP = -L$(PWA2000_ROOT)/lib -lpp 

#
# Machine dependent stuff.
#


ifeq "$(UNAME)" "Linux"
# Linux with egcs
CXX           = g++
CXXFLAGS      = -O2 -g -Wall -fno-exceptions -fPIC -I$(ROOTSYS)/include -I/home/halld/include  -I$(PWA2000_ROOT)/include
LD            = g++
LDFLAGS       = -g
SOFLAGS       = -shared
LIBS          = $(ROOTLIBS) -lm -ldl -rdynamic
GLIBS         = $(ROOTLIBS) $(ROOTGLIBS) -L/usr/X11R6/lib \
                -lXpm -lX11 -lm -ldl -rdynamic
endif



#------------------------------------------------------------------------------

TMCFastO        = TMCFastHepEvt.o TMCFastTOF.o \
		   TMCFastOfflineTrack.o TMCFastHepParticle.o \
                TMCFastHepEvtDict.o TMCFastTOFDict.o \
		TMCFastOfflineTrackDict.o TMCFastHepParticleDict.o\
		TMCFastCalorimeter.o TMCFastCalorimeterDict.o \
		TMCFastCalorHits.o TMCFastCalorHitsDict.o \
		TCalHitTracks.o  TCalHitTracksDict.o \
		TLGDsmears.o TLGDsmearsDict.o \
		TLGDparticle.o TLGDparticleDict.o \
		TMCesr.o TMCesrDict.o TMCParticle.o TMCParticleDict.o \
		TMCFastHits.o TMCFastHitsDict.o TMCFastHit.o TMCFastHitDict.o \
		TMCFastTrace.o TMCFastTraceDict.o \
		TMCFastCerenTrace.o TMCFastCerenTraceDict.o \
		TMCFastCerenkov.o TMCFastCerenkovDict.o


TMCFastS        = TMCFastHepEvt.cxx TMCFastTOF.cxx \
		TMCFastOfflineTrack.cxx TMCFastHepParticle.cxx\
                TMCFastHepEvtDict.cxx TMCFastTOFDict.cxx \
		TMCFastOfflineTrackDict.cxx TMCFastHepParticleDict.cxx \
		TMCFastCalorimeter.cxx TMCFastCalorimeterDict.cxx \
		TMCFastCalorHits.cxx TMCFastCalorHitsDict.cxx \
		TCalHitTracks.cxx  TCalHitTracksDict.cxx \
		TLGDsmears.cxx TLGDsmearsDict.cxx \
		TLGDparticle.cxx TLGDparticleDict.cxx \
		TMCesr.cxx TMCesrDict.cxx TMCParticle.cxx TMCParticleDict.cxx \
		TMCFastHits.cxx TMCFastHitsDict.cxx TMCFastHit.cxx \
		TMCFastHitDict.cxx TMCFastTrace.cxx TMCFastTraceDict.cxx \
		TMCFastCerenTrace.cxx TMCFastCerenTraceDict.cxx \
		TMCFastCerenkov.cxx TMCFastCerenkovDict.cxx

TMCFast_LIB       = libTMCFast.a


MAIN1O    = mcfast2root.o
MAIN1S    = mcfast2root.cxx

MAIN2O        = dumpRdt.o
MAIN2S        = dumpRdt.cxx

TOF2O           = tof2.o
TOF2S           = tof2.C

NTP_MAKERO      = ntp_maker.o TNtupleUtil.o

TMCFast         = mcfast2root
TMCFast2         = dumpRdt
TMCFastSO       = libTMCFast.so


OBJS          = $(TMCFastO) $(MAIN2O) $(TOF2O) $(NTP_MAKERO) 

PROGRAMS      = dumpRdt  
lib:	$(TMCFast_LIB)

all:            $(PROGRAMS) lib



install: $(TMCFast_LIB) $(PROGRAMS) 
	mv $(TMCFast_LIB)  $(HALLD_HOME)/lib/$(UNAME)/$(TMCFast_LIB)
	mv dumpRdt $(HALLD_HOME)/bin/$(UNAME)/.

install-ntp_maker: ntp_maker
	mv ntp_maker $(HALLD_HOME)/bin/$(UNAME)/.    


$(TMCFast_LIB): $(TMCFastO)
	ar -r  $(TMCFast_LIB) $(TMCFastO) 
	$(LD) $(SOFLAGS) $(LDFLAGS) $(TMCFastO) $(OutPutOpt) $(TMCFastSO)



TMCFast_LIBS =  $(HALLD_HOME)/lib/$(UNAME)/$(TMCFast_LIB)

dumpRdt:       $(TMCFastO) $(MAIN2O)
		$(LD) $(LDFLAGS) $(MAIN2O) $(MCFASTLIB) $(LIBS) $(OutPutOpt) $(TMCFast2)
		@echo "$(TMCFast2) done"

tof2:     $(TMCFastO) $(TOF2O) 
		$(LD) $(LDFLAGS) $(TOF2O)  $(TMCFast_LIBS) $(GLIBS) $(OutPutOpt) tof2
		@echo "tof2 done"

ntp_maker:     $(TMCFastO) $(NTP_MAKERO) $(TMCFastO)
		$(LD) $(LDFLAGS) $(NTP_MAKERO) $(TMCFastO)  $(LIBS) $(OutPutOpt) ntp_maker
		@echo "ntp_maker done"




clean:
		@rm -f *.o *Dict.* core

.SUFFIXES: .cxx .C

###
ntp_maker.o: TNtupleUtil.h 
TNtupleUtil.o: TNtupleUtil.h
TMCFastHepEvt.o: TMCFastHepEvt.h
TMCFastTOF.o: TMCFastTOF.h
TMCFastOfflineTrack.o: TMCFastOfflineTrack.h
TMCFastHepParticle.o: TMCFastHepParticle.h
mcfast2root.o: TMCFastHepEvt.h TMCFastHepParticle.h  TMCFastTOF.h TMCFastOfflineTrack.h TMCFastHepParticle.h
dumpRdt.o: TMCFastHepEvt.h TMCFastHepParticle.h  TMCFastTOF.h TMCFastOfflineTrack.h
TMCFastCalorimeter.o: TMCFastCalorimeter.h
TMCFastCalorHits.o: TMCFastCalorHits.h
TLGDsmears.o:TLGDsmears.h
TLGDparticle.o:TLGDparticle.h
TMCesr.o:TMCesr.h
TMCParticle.o:TMCParticle.h
TMCFastHits.o:TMCFastHits.h
TMCFastHit.o:TMCFastHit.h
TMCFastTrace.o:TMCFastTrace.h
TMCFastCerenTrace.o:TMCFastCerenTrace.h
TMCFastCerenkov.o:TMCFastCerenkov.h

###########################################################
#
# Tell make how to parse the C++ code using rootcint
#
###########################################################
TMCFastHepEvtDict.cxx: TMCFastHepEvt.h TMCFastHepEvtLinkDef.h
	@echo "Generating dictionary TMCFastHepEvtDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastHepEvtDict.cxx -c TMCFastHepEvt.h TMCFastHepEvtLinkDef.h

TMCFastTOFDict.cxx: TMCFastTOF.h TMCFastTOFLinkDef.h
	@echo "Generating dictionary TMCFastTOFDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastTOFDict.cxx -c TMCFastTOF.h TMCFastTOFLinkDef.h

TMCFastOfflineTrackDict.cxx: TMCFastOfflineTrack.h TMCFastOfflineTrackLinkDef.h
	@echo "Generating dictionary TMCFastOfflineTrackDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastOfflineTrackDict.cxx -c TMCFastOfflineTrack.h TMCFastOfflineTrackLinkDef.h

TMCFastHepParticleDict.cxx: TMCFastHepParticle.h TMCFastHepParticleLinkDef.h
	@echo "Generating dictionary TMCFastHepParticleDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastHepParticleDict.cxx -c TMCFastHepParticle.h TMCFastHepParticleLinkDef.h

TMCFastCalorimeterDict.cxx: TMCFastCalorimeter.h TMCFastCalorimeterLinkDef.h
	@echo "Generating dictionary TMCFastCalorimeterDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastCalorimeterDict.cxx -c TMCFastCalorimeter.h TMCFastCalorimeterLinkDef.h

TMCFastCalorHitsDict.cxx: TMCFastCalorHits.h TMCFastCalorHitsLinkDef.h
	@echo "Generating dictionary TMCFastCalorHitsDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastCalorHitsDict.cxx -c TMCFastCalorHits.h TMCFastCalorHitsLinkDef.h

TCalHitTracksDict.cxx: TCalHitTracks.h TCalHitTracksLinkDef.h
	@echo "Generating dictionary TCalHitTracksDict..."
	@$(ROOTSYS)/bin/rootcint -f TCalHitTracksDict.cxx -c TCalHitTracks.h TCalHitTracksLinkDef.h

TLGDsmearsDict.cxx: TLGDsmears.h TLGDsmearsLinkDef.h
	@echo "Generating dictionary TLGDsmearsDict..."
	@$(ROOTSYS)/bin/rootcint -f TLGDsmearsDict.cxx -c TLGDsmears.h TLGDsmearsLinkDef.h

TLGDparticleDict.cxx: TLGDparticle.h TLGDparticleLinkDef.h
	@echo "Generating dictionary TLGDparticleDict..."
	@$(ROOTSYS)/bin/rootcint -f TLGDparticleDict.cxx -c TLGDparticle.h TLGDparticleLinkDef.h

TMCParticleDict.cxx: TMCParticle.h TMCParticleLinkDef.h
	@echo "Generating dictionary TMCParticleDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCParticleDict.cxx -c TMCParticle.h TMCParticleLinkDef.h

TMCesrDict.cxx: TMCesr.h TMCesrLinkDef.h
	@echo "Generating dictionary TMCesrDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCesrDict.cxx -c TMCesr.h 

TMCFastTraceDict.cxx: TMCFastTrace.h TMCFastTraceLinkDef.h
	@echo "Generating dictionary TMCFastTraceDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastTraceDict.cxx -c TMCFastTrace.h  TMCFastTraceLinkDef.h

TMCFastCerenTraceDict.cxx: TMCFastCerenTrace.h TMCFastCerenTraceLinkDef.h
	@echo "Generating dictionary TMCFastCerenTraceDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastCerenTraceDict.cxx -c TMCFastCerenTrace.h 

TMCFastHitsDict.cxx: TMCFastHits.h TMCFastHitsLinkDef.h
	@echo "Generating dictionary TMCFastHitsDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastHitsDict.cxx -c TMCFastHits.h 

TMCFastHitDict.cxx: TMCFastHit.h TMCFastHitLinkDef.h
	@echo "Generating dictionary TMCFastHitDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastHitDict.cxx -c TMCFastHit.h 

TMCFastCerenkovDict.cxx: TMCFastCerenkov.h 
	@echo "Generating dictionary TMCFastCerenkovDict..."
	@$(ROOTSYS)/bin/rootcint -f TMCFastCerenkovDict.cxx -c TMCFastCerenkov.h 


.cxx.o:
	$(CXX) $(CXXFLAGS) -c $<
