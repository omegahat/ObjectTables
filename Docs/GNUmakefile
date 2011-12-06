RObjectTables.ps:

%.dvi: %.tex
	(TEXINPUTS=.:$(OMEGA_HOME)/Docs:: ; export TEXINPUTS ; latex $<)

%.ps: %.dvi
	dvips -o $@ $<

%.pdf: %.tex
	pdflatex $<



