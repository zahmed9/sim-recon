#
# Makefile to latex document, uncompress .ps files etc...
# original version : Mark Ito
# modified:
#     use for dc nim paper - D Tedeschi 4/28/98
#     html output de-activated for now
#     changed for tof nim paper - Elton Oct/98
#     updated for tof online doc - Elton Mar/99
#     updated for e1-6 summary - Elton Feb/02
#     updated for tof_rates - Elton Feb/02
#     updated for eg3_beamtest - Elton Aug/04
#     updated for eg3_target - Elton Sep/04
#     updated for detector_issues - Elton Oct/05
#     updated for Electronics_plan/DAQ_plan - Elton Oct/05
#
#
TEX_FILES_0 = detector_issues
TEX_FILES = $(addsuffix .tex,$(TEX_FILES_0)) # add .tex suffix

PS_FILES_0 = 
PS_FILES = $(addsuffix .ps,$(PS_FILES_0)) # add .ps suffix

EPS_FILES_0 = 
EPS_FILES = $(addsuffix .eps,$(EPS_FILES_0)) # add .eps suffix

all: detector_issues detector_issues.ps

Electronics_plan: Electronics_plan.ps

DAQ_plan: DAQ_plan.ps

detector_issues.dvi : $(TEX_FILES) $(PS_FILES) $(EPS_FILES) # make the dvi file
	latex detector_issues
	latex detector_issues

Electronics_plan.dvi : Electronics_plan.tex Electronics_plan.eps 
	latex Electronics_plan.tex
	latex Electronics_plan.tex

DAQ_plan.dvi : DAQ_plan.tex GluexDAQ.eps
	latex DAQ_plan.tex
	latex DAQ_plan.tex

%.ps : %.dvi
	dvips -o $*.ps $*
	dvipdf $*.dvi $*.pdf

%.dvi : %.tex
	latex $*
	latex $*

%.ps : %.ps.gz
	gunzip -l $*.ps.gz
	rm -f $*.ps
	gunzip -c $*.ps.gz > $*.ps

%.eps : %.eps.gz
	gunzip -l $*.eps.gz
	rm -f $*.eps
	gunzip -c $*.eps.gz > $*.eps

#
#
% : %.dvi
	'rm' -rf $*
#	latex2html $*      # produce html pages

