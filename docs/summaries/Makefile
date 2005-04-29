 #! gnumake
HEAD = summary
#
DOC  = *.tex 
#
CNT  = Makefile 
#
FIG  = ch6_gluex_detector.eps

summary: Summary_cover

all: CDC_summary LGD_summary FDC_summary CD_summary BCAL_summary DAQ_summary TOF_summary \
	Computing_summary Software_summary Start_summary Tagger_summary \
	Electronics_summary Online_summary Solenoid_summary UPV_summary \
	Summary_cover

Summary_cover: ch6_gluex_detector.pdf
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Tagger_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Solenoid_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

CDC_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

LGD_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

FDC_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

CD_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

BCAL_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

UPV_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Start_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

DAQ_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

TOF_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Electronics_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Computing_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Online_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex	

Software_summary:
	pdflatex $(@).tex	
	pdflatex $(@).tex

%.pdf : %.eps
	epstopdf $*.eps	

tarball:	
	rm -f   $(HEAD).tar.gz
	tar cfz $(HEAD).tar.gz $(DOC) $(CNT) $(FIG)
clean:
	@rm -f *.dvi *.ps *~ *.aux *.log *.lot *.lof *.toc

distclean:
	@rm -f *.dvi *.ps *~ *.aux *.log *.lot *.lof *.toc
	@rm -f $(HEAD).tar.gz
	@rm -f *.pdf
