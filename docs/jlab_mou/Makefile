#! gnumake
#
HEAD = gluex_mou
#
#
PDF = *.pdf
#
DOC  = *.tex 
#
CNT  = Makefile

all: gluex_mou_jlab

gluex_mou:
	pdflatex $(HEAD).tex	
	pdflatex $(HEAD).tex	

gluex_mou_jlab:
	pdflatex $@.tex	
	pdflatex $@.tex	

tarball:
	rm -f $(HEAD).tar.gz
	tar cfz $(HEAD).tar.gz $(DOC) $(CNT) $(PDF) 

clean:
	@rm -f *.dvi *.ps *~ *.aux *.log *.lot *.lof *.toc

distclean:
	@rm -f *.dvi *.ps *~ *.aux *.log *.lot *.lof *.toc
	@rm -f $(HEAD).tar.gz
	@rm -f $(HEAD).pdf
	@rm -f $(HEAD)_jlab.pdf
