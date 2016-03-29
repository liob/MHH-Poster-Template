PDFLATEX = pdflatex
LATEXOPTS = --file-line-error --shell-escape
PDFINFO = pdfinfo
BIBTEX = bibtex
CONVERT = convert
texes := $(wildcard *.tex)
bibs := $(wildcard *[^-blx].bib)
main = sample


.PHONY: all clean clean-all

all: $(main).pdf $(main).png clean

$(main).pdf: $(texes) $(main).bbl
	$(PDFLATEX) $(LATEXOPTS) $(main)

$(main).bbl: $(bibs)
	$(PDFLATEX) $(LATEXOPTS) $(main)
	$(BIBTEX) $(main)
	$(PDFLATEX) $(LATEXOPTS) $(main)

$(main).png: $(main).pdf
	$(CONVERT) $(main).pdf -quality 80 -resize 512x512 $(main).png

clean:
	$(RM) *.aux *.bbl *.blg *.bcf *-blx.bib *.dvi *.ilg *.ind *.lof *.lol *.log *.out *.run.xml *.toc *.acn *.glo *.ist *.acr *.alg *.lot *.gls *.upb *.upa *.synctex.gz *.fdb_latexmk *.fls

clean-all: clean
	$(RM) $(main).pdf $(main).png
