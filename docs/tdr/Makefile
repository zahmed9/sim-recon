 #! gnumake
HEAD = halld_tdr
#
DOC  = *.tex 
#
CNT  = Makefile 
#
FIG  = ch4_taggerplan.eps ch6_cdc_new.eps ch6_hd_pbglass.eps \
               ch6_upv-site.eps ch9_software_systems_small.eps ch6_gluex_detector.eps \
               gluex_det_2.eps hd10.eps start.eps

summary: gluex_tdr

#gluex_tdr: ch4_taggerplan.pdf ch6_cdc_new.pdf ch6_hd_pbglass.pdf \
#               ch6_upv-site.pdf ch9_software_systems_small.pdf ch6_gluex_detector.pdf \
#               gluex_det_2.pdf hd10.pdf start.pdf 
#	pdflatex $(@).tex	
#	pdflatex $(@).tex
gluex_tdr: gluex_tdr.tex ch4_taggerplan.eps ch6_cdc_new.eps ch6_hd_pbglass.eps \
               ch6_upv-site.eps ch9_software_systems_small.eps ch6_gluex_detector.eps \
               gluex_det_2.eps hd10.eps start.eps
	latex $(@).tex	
	latex $(@).tex
	dvips -o $(@).ps  $(@).dvi

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
