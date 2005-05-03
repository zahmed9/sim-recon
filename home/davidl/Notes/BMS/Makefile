

BMS.pdf:BMS.ps
	ps2pdf BMS.ps

BMS.ps:BMS.dvi
	dvips -o BMS.ps BMS.dvi

BMS.dvi:BMS.tex
	latex BMS.tex
	latex BMS.tex

clean:
	rm -f BMS.log BMS.aux BMS.dvi BMS.pdf BMS.ps

