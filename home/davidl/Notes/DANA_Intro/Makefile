

DANA_Intro.pdf:DANA_Intro.ps
	ps2pdf DANA_Intro.ps

DANA_Intro.ps:DANA_Intro.dvi
	dvips -o DANA_Intro.ps DANA_Intro.dvi

DANA_Intro.dvi:DANA_Intro.tex expand_src
	latex DANA_Intro.tex
	latex DANA_Intro.tex

expand_src:
	expand -3 $(HALLD_HOME)/src/programs/Analysis/hd_ana/hd_ana.cc > hd_ana.cc
	expand -3 $(HALLD_HOME)/src/programs/Analysis/hd_ana/MyProcessor.cc > MyProcessor.cc
	expand -3 $(HALLD_HOME)/src/programs/Analysis/hd_ana/MyProcessor.h > MyProcessor.h

clean:
	rm -f DANA_Intro.log DANA_Intro.aux DANA_Intro.dvi DANA_Intro.pdf DANA_Intro.ps DANA_Intro.toc

