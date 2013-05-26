# TARGET has to be specified

PDFLATEX    ?= pdflatex
BIBTEX      ?= bibtex
PDFVIEWER   ?= xdg-open

ifneq ($(strip $(TARGET)),)
PDFTARGETS  += $(TARGET).pdf
endif

INCLUDEDIR   := $(shell git rev-parse --show-toplevel)/common

#=================================
# grep bibtex dependencies
#---------------------------------
ifneq ($(strip $(TARGET)),)
BIBFILES = $(patsubst %,%.bib,\
		$(shell grep '^[^%]*\\bibliography{' $(TARGET).tex | \
			sed -e 's/^[^%]*\\bibliography{\([^}]*\)}.*/\1/' \
			    -e 's/, */ /g'))
endif


#=================================
# \input and \include dependencies
#---------------------------------
ifneq ($(strip $(TARGET)),)
INCLUDEDTEX := $(patsubst %,%.tex,\
		$(shell sed -rn 's/^[^%]*\\(input|include)\{([^\.\}]*)(\.tex)?\}/\2/p' $(TARGET).tex))
# second depth
ifneq ($(strip $(INCLUDEDTEX)),)
INCLUDEDTEX += $(foreach INCFILE,$(INCLUDEDTEX),$(patsubst %,%.tex,\
		$(shell sed -rn 's/^[^%]*\\(input|include)\{([^\.\}]*)(\.tex)?\}/\2/p' $(INCFILE))))
endif
endif
# quick-hack to get sty dependency (TODO: a clean solution)
INCLUDEDPKG = $(wildcard $(INCLUDEDIR)/*.sty) $(wildcard $(INCLUDEDIR)/*.cls)
#=================================

AUXFILES = $(PDFTARGETS:.pdf=.aux)
AUXFILES += $(INCLUDEDTEX:.tex=.aux)
LOGFILES = $(AUXFILES:.aux=.log)

# short git revision
REVISION := $(shell git rev-parse --short HEAD)

.PHONY: all clean distclean pdf view

all: pdf $(AFTERALL)

pdf: $(PDFTARGETS)

view: $(PDFTARGETS)
	$(PDFVIEWER) $(PDFTARGETS)

# to generate aux but not pdf from pdflatex, use -draftmode
.SECONDARY: $(AUXFILES)
%.aux: %.tex
	$(PDFLATEX) -draftmode $*

# introduce BibTeX dependency if we found a \bibliography
ifneq ($(strip $(BIBFILES)),)
BIBDEPS = %.bbl
%.bbl: %.aux $(BIBFILES)
	$(BIBTEX) $*
endif

#$(PDFTARGETS): %.pdf: %.tex %.aux $(BIBDEPS) $(INCLUDEDTEX)
$(PDFTARGETS): %.pdf: %.tex $(BIBDEPS) $(INCLUDEDTEX) $(INCLUDEDPKG)
	(TEXINPUTS=.:$(INCLUDEDIR):$(TEXINPUTS) $(PDFLATEX) $*)
ifneq ($(strip $(BIBFILES)),)
	@if grep -q "undefined references" $*.log; then \
		$(BIBTEX) $* && $(PDFLATEX) $*; fi
endif
	@while grep -q "Rerun to" $*.log; do \
		(TEXINPUTS=.:$(INCLUDEDIR):$(TEXINPUTS) $(PDFLATEX) $*); done

clean:
	rm -f $(foreach T,$(PDFTARGETS:.pdf=), \
		$(T).out $(T).thm $(T).blg $(T).bbl \
		$(T).lof $(T).lot $(T).toc $(T).idx \
		$(T).nav $(T).snm $(T)-pics.pdf) \
		$(AUXFILES) $(LOGFILES)

distclean: clean
	rm -f $(PDFTARGETS)
