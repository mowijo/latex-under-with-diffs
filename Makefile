# Packages needed:
# gnuplot-nox texlive-bibtex-extra texlive-fonts-extra texlive-lang-cyrillic texlive-latex-base texlive-latex-extra texlive-latex-recommended

SOURCE_TEX        = main.tex
GNUPLOTS          = parabellum.gnuplot.pdf
GRAPHVIZ_GRAPHS   = graph.gv.pdf

ifeq ($(INPUT),)
INPUT := $(SOURCE_TEX)
endif

SOURCE_BASE_NAME= $(shell echo $(INPUT) | sed -e 's/\.tex//')

%.gnuplot.pdf : %.gnuplot
	@echo Generates $@
	gnuplot -c $< > $@

%.gv.pdf : %.gv
	@echo Generates $@
	dot -Tpdf -o $@ $<

current: images
	@make -s texrun
	@make -s texrun
	@make -s texrun
	@make -s bibtexrun
	@make -s texrun
	@make -s texrun
	
gnuplots: $(GNUPLOTS)
	
bibtexrun:
	@echo Runs 'bibtex $(SOURCE_BASE_NAME).aux'
	@bibtex   $(SOURCE_BASE_NAME).aux > $(SOURCE_BASE_NAME).bibtex.log 2>&1  || ( cat $(SOURCE_BASE_NAME).bibtex.log  ; rm -f $(SOURCE_BASE_NAME).bibtex.log  ; exit 1)
	
texrun:
	@echo Runs 'pdflatex $(SOURCE_BASE_NAME).tex'
	@pdflatex  -shell-escape -halt-on-error $(SOURCE_BASE_NAME).tex > /dev/null 2>&1 || ( cat $(SOURCE_BASE_NAME).log ; exit 1)
	
images: gnuplots

releases:
	for r in `git tag -l`; do ./make-revision.sh $$r; done
	
clean:
	@echo Cleans up.
	@rm -f         \
	$(SOURCE_BASE_NAME).aux        \
	$(SOURCE_BASE_NAME).blg        \
	$(SOURCE_BASE_NAME).pdf        \
	$(SOURCE_BASE_NAME)-blx.bib    \
	$(SOURCE_BASE_NAME).bbl        \
	$(SOURCE_BASE_NAME).log        \
	$(SOURCE_BASE_NAME).run.xml    \
	$(SOURCE_BASE_NAME).bibtex.log \
	$(GNUPLOTS)                    \
	$(GRAPHVIZ_GRAPHS)
