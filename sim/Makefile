#! gnumake

#---------------------------------------------------
# The D. P. Weygand et. al. Makefile 
#---------------------------------------------------
include Rules.make

INCLUDE := $(INCLUDE) -I$(CLAS_PACK)/libpp
LIBPP= -L$(CLAS_LIB) -lpp

%.h: %.nw
	notangle -L -R$@ $^ | cpif $@

%.cc: %.nw
	notangle -L -R$@ $^ | cpif $@

%.tex: %.nw
	noweave -index -option longchunks -option smallcode  $^ | cpif $@

%.dvi: %.tex
	latex $<
	latex $<

%.ps: %.dvi
	dvips $< -o
	rm $*.dvi

%.html: %.nw
	noweave -filter l2h -index -html $^ | htmltoc > $@

all: libsim.a


SRCS= drift.nw
OBJS= $(patsubst %.nw,$(OBJDIR)/%.o,$(SRCS))

TSRC= dtest.cc
TOBJS= $(patsubst %.cc,$(OBJDIR)/%.o,$(TSRC))

dtest: $(TOBJS)
	$(C++) $^ -o $@ $(CDBG) -L. -lsim $(LIBPP)	

libsim.a: $(OBJS)
	@echo Making libsim.a
	@echo $?
	ar rv libsim.a $?

libpp.a:libpp.a(Vec.o matrix.o lorentz.o particleData.o particle.o tab.o)


clean:
	rm -f $(OBJDIR)/drift.o drift.cc drift.h
	rm -f drift.ps drift.tex
	rm libsim.a

texclean:
	rm -f *.aux *.log

nuke: clean
	rm -f libpp.a *_trip *.dvi *.ps
	
Vec.cc Vec.h: Vec.nw
Vec.o: Vec.cc Vec.h
matrix.cc matrix.h: matrix.nw
matrix.o: matrix.cc matrix.h
lorentz.cc lorentz.h: lorentz.nw
lorentz.o: lorentz.cc lorentz.h Vec.h matrix.h particle.h particleData.h
particleData.cc particleData.h: particleData.nw
particleData.o: particleData.cc particleData.h 
particle.cc particle.h: particle.nw
particle.o: particle.cc particle.h

Vec_trip : Vec_trip.cc libpp.a matrix.h args.h timer.h timer.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) Vec_trip.cc libpp.a timer.o -o Vec_trip

matrix_trip : matrix_trip.cc libpp.a matrix.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) matrix_trip.cc libpp.a -o matrix_trip

lorentz_trip : lorentz_trip.cc libpp.a matrix.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) lorentz_trip.cc -lm libpp.a -o lorentz_trip

particleData_trip : particleData_trip.cc libpp.a
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) particleData_trip.cc -lm libpp.a -o particleData_trip

particle_trip : particle_trip.cc libpp.a
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) particle_trip.cc -lm libpp.a -o particle_trip

doc.dvi: doc.tex Vec.tex matrix.tex lorentz.tex particleData.tex particle.tex

doc.ps: doc.dvi
