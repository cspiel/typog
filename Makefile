###  name:      	Makefile
###  synopsis:  	Build `typog' style file, tools, and documentation
###  author:    	Dr. Christoph L. Spiel
###  GNU make version:  4.3


SHELL := /bin/sh


LATEX_PROPER := pdflatex
LATEX := /usr/bin/env max_print_line=2147483647 $(LATEX_PROPER)
LATEX_FLAGS := -file-line-error -halt-on-error -interaction=nonstopmode -output-directory=.
LATEX_RERUN_TRIGGER := '^Package rerunfilecheck Warning: File [^ ]* has changed'
LATEX_WARNING := '^LaTeX (|[A-Za-z0-9_]* )Warning:'

MAKEINDEX := makeindex
MAKEINDEX_FLAGS := -q


MAKEINFO := makeinfo
MAKEINFO_FLAGS := --no-split


METAPOST := mpost
METAPOST_FLAGS := -file-line-error -interaction=nonstopmode -tex=latex


PODCHECKER := podchecker
PODCHECKER_FLAGS := -warnings


define SED_VERSION_REGEXP
^\( *\|\\ProvidesPackage{[^}]*} *\)\[\([0-9][0-9]*/[0-9][0-9]*/[0-9][0-9]*\) *v\([^ ]*\) *\([^]]*\)].*$$
endef

POD2MAN := pod2man
POD2MAN_FLAGS := $$(sed -ne 's,$(SED_VERSION_REGEXP),--date=\2 --release=\3,p' < typog.sty)


POD2TEXI := pod2texi
POD2TEXI_FLAGS :=


GROFF := groff
##  Codes of fonts that work for PDF output as by the contents
##  of "/usr/share/groff/current/font/devpdf".
##
##  Serif
##  	BM: URW Bookman L
##  	N:  URW Century Schoolbook L
##  	P:  URW Palladio L
##  	T:  URW Nimbus Roman No9 L
##
##  Sans Serif
##      A:  Avantgarde
##      H:  Helvetica
##
##  Monospace
##      C:  Courier
GROFF_FLAGS := -Tpdf -dpaper=a4 -fP -man -wall


PROJECT_NAME := typog
SOURCE_FILES := LICENSE Makefile typog.dtx typog.ins
DOCUMENTATION_FILES := typog-example.pdf typog-grep.1.pdf typog.pdf



.PHONY: all
all: sty pdf bin man


.PHONY: sty
sty: typog.sty


.PHONY: pdf
pdf: doc ex test


.PHONY: doc
doc: typog.pdf


.PHONY: ex
ex: typog-example.pdf


.PHONY: test
test: typog-minimal-test.pdf typog-without-microtype-test.pdf


.PHONY: bin
bin: typog-grep


.PHONY: man
man: typog-grep.1


export TEMPORARY_DIRECTORY


.PHONY: dist
dist:
	$(eval TEMPORARY_DIRECTORY := $(shell mktemp -d))
	trap '$(RM) -r $(TEMPORARY_DIRECTORY); exit 1' HUP INT QUIT TERM;  $(MAKE) __dist
	$(RM) -r $(TEMPORARY_DIRECTORY)


.PHONY: __dist
__dist: LATEX_FLAGS += -interaction=batchmode
__dist: $(DOCUMENTATION_FILES)
	test -d '$(TEMPORARY_DIRECTORY)'
	test -w '$(TEMPORARY_DIRECTORY)'
	mkdir $(TEMPORARY_DIRECTORY)/$(PROJECT_NAME)
	cp $(SOURCE_FILES) $(TEMPORARY_DIRECTORY)/$(PROJECT_NAME)
	mkdir $(TEMPORARY_DIRECTORY)/$(PROJECT_NAME)/docs
	cp $(DOCUMENTATION_FILES) $(TEMPORARY_DIRECTORY)/$(PROJECT_NAME)/docs
	tar czf $(PROJECT_NAME).tar.gz -C $(TEMPORARY_DIRECTORY) $(PROJECT_NAME)


.PHONY: distcheck
distcheck: LATEX_FLAGS += -interaction=batchmode
distcheck: dist
	$(eval TEMPORARY_DIRECTORY := $(shell mktemp -d))
	test -d '$(TEMPORARY_DIRECTORY)'
	test -w '$(TEMPORARY_DIRECTORY)'
	tar xzf $(PROJECT_NAME).tar.gz -C $(TEMPORARY_DIRECTORY)
	$(MAKE)  \
            --directory=$(TEMPORARY_DIRECTORY)/$(PROJECT_NAME)  \
            LATEX_FLAGS='$(LATEX_FLAGS) -interaction=batchmode' \
            all
	$(RM) -r $(TEMPORARY_DIRECTORY)
	@printf '\n\ndistcheck passed.\n'


.PHONY: clean
clean:
	$(RM) ./*.1 ./*.aux ./*.brf ./*.dvi ./*.glg ./*.glo ./*.gls
	$(RM) ./*.hd ./*.idx ./*.ilg ./*.ind ./*.info ./*.loe ./*.lof ./*.log ./*.lot
	$(RM) ./*.mps ./*.mpx ./*.out ./*.pdf ./*.pl.in ./*.toc
	$(RM) mptextmp.* mpxerr.tex
	$(RM) README README.html RELEASE-HOWTO RELEASE-HOWTO.html
	$(RM) typog-grep typog-grep.version.sed
	$(RM) $(PROJECT_NAME).tar.gz


.PHONY: mostlyclean
mostlyclean: clean
	$(RM) ./*.texi


.PHONY: maintainer-clean
maintainer-clean: mostlyclean
	$(RM) ./*.gst ./*.ist ./*.mp ./*.pl ./*.pod ./*.sed ./*.sty ./*.tex


.PHONY: tool-check
tool-check:
	@printf '***  LATEX_PROPER = "%s"\n' '$(LATEX_PROPER)'
	$(LATEX_PROPER) --version
	@printf '\n\n***  MAKEINDEX = "%s"\n' '$(MAKEINDEX)'
	$(MAKEINDEX)  < /dev/null
	@printf '\n\n***  METAPOST = "%s"\n' '$(METAPOST)'
	$(METAPOST) --version
	@printf '\n***  POD2MAN = "%s"\n' '$(POD2MAN)'
	$(POD2MAN) --help > /dev/null
	@printf '\n\n***  POD2TEXI = "%s"\n' '$(POD2TEXI)'
	$(POD2TEXI) --version
	@printf '\n\ntool check passed.\n'


.PHONY: update-docs
update-docs: doc ex typog-grep.1.pdf
	cp -f typog.pdf typog-example.pdf typog-grep.1 typog-grep.1.pdf docs


define HELP_SCREEN
Selected Phony Targets
----------------------
all:    Make everything there is to make.  This is the .DEFAULT_GOAL.

bin:    Build typog-grep (which is not a binary, but executable).

clean:  Remove some products.

dist:   Create a tar file of the project source files and the PDF
        documentation files.  The archive is in the form and has a
        name that CTAN prefers.

distcheck: Create a tar file of the project source files, unpack it in
        a different location and build all targets.

doc:    Build "typog.pdf" the Typog documentation.

ex:     Build "typog-example.pdf" an example and test file for Typog.

maintainer-clean: Remove every product file that can be rebuilt even
        if uncommon tools are necessary.

mostlyclean: Remove some more products than clean:.

pdf:    Build doc: and gauge:.

sty:    Only extract "typog.sty" from "typog.dtx".  This
        operation requires LaTeX (-> $(LATEX)) and nothing else.

test:   Run some tests.

tool-check: Check whether some of the required tools to build the
        project are available.

update-docs: Copy the documentation files into the "docs"
        sub-directory.


Selected Implicit Rules
-----------------------
%.pdf: %.dtx
        Run LaTeX or pdfLaTeX (-> $(LATEX)) on dtx source until a
        fix-point is reached.

%.pdf: %.tex
        Run LaTeX or pdfLaTeX (-> $(LATEX)) on tex file until a
        fix-point is reached.

%.1: %.pod
        Create a manual page from plain old documentation format.
        Requires podchecker (-> $(PODCHECKER)) and pod2man
        (-> $(POD2MAN)).

%.1.pdf: %.1
        Convert a manual page into a pdf file.  Requires groff
        (-> $(GROFF)).


Some Explicit Rules
-------------------
README.html:
        Convert "README.md" to html.  Requires markdown(1).

README: Convert "README.html" to plain text.  Requires w3m(1).

endef


.PHONY: help
help:
	$(info $(HELP_SCREEN))



.PRECIOUS: %.mps



define MAKE_INDEX_AND_GLOSSARY
sed -e '/@/d' -e 's/{\\ttfamily /{\\ttfamily\\hskip0pt\\relax /'  < $*.idx  > ,$*.idx;  \
mv ,$*.idx $*.idx;  \
$(MAKEINDEX) $(MAKEINDEX_FLAGS) -s $*.ist -t $*.ilg -o $*.ind $*.idx;  \
$(MAKEINDEX) $(MAKEINDEX_FLAGS) -s $*.gst -t $*.glg -o $*.gls $*.glo
endef

define GREP_LATEX_WARNINGS
test -e $*.log  &&  grep -E $(LATEX_WARNING) $*.log  |  uniq
endef

%.pdf: %.dtx
	$(RM) ./$*.aux ./$*.ind ./$*.idx ./$*.gls ./$*.glo ./$*.lot ./$*.toc
	$(LATEX) $(LATEX_FLAGS) -draftmode $<
	$(MAKE_INDEX_AND_GLOSSARY)
	$(LATEX) $(LATEX_FLAGS) $<
	$(MAKE_INDEX_AND_GLOSSARY)
	while test -e $*.log  &&  grep -q $(LATEX_RERUN_TRIGGER) $*.log;  \
        do  \
	    $(LATEX) $(LATEX_FLAGS) $<;  \
	    $(MAKE_INDEX_AND_GLOSSARY);  \
	done
	$(GREP_LATEX_WARNINGS)


%.pdf: %.tex
	$(RM) ./$*.aux ./$*.ind ./$*.idx ./$*.lot ./$*.toc
	$(LATEX) $(LATEX_FLAGS) -draftmode $<
	$(LATEX) $(LATEX_FLAGS) $<
	while test -e $*.log  &&  grep -q $(LATEX_RERUN_TRIGGER) $*.log;  \
        do  \
	    $(LATEX) $(LATEX_FLAGS) $<;  \
	done
	$(GREP_LATEX_WARNINGS)


%-1.mps %-2.mps %-3.mps %-4.mps: %.mp
	$(METAPOST) -s 'outputtemplate="%j-%c.mps"' $(METAPOST_FLAGS) $<


%.1: %.pod
	$(PODCHECKER) $(PODCHECKER_FLAGS) $<
	$(POD2MAN) $(POD2MAN_FLAGS) $< $@

%.1.pdf: %.1
	$(GROFF) $(GROFF_FLAGS) ./$<  > $@

%.texi: %.pod
	$(POD2TEXI) $(POD2TEXI_FLAGS) --output=$@ ./$<

%.info: %.texi
	$(MAKEINFO) $(MAKEINFO_FLAGS) --output=$@ $<

%.info.pdf: %.texi
	$(MAKEINFO) $(MAKEINFO_FLAGS) --pdf --output=$@ $<

%.tex: %.pod | teximan2latex.sed
	$(POD2TEXI) $(POD2TEXI_FLAGS) ./$<  |  sed -f teximan2latex.sed  > $@


%.html: %.md
	markdown $<  > $@

%: %.html
	w3m -cols 79 $<  > $@


crooked-paragraphs.mp slant-angle.mp smooth-parshapes.mp title.mp  \
teximan2latex.sed  \
typog-grep.pl.in typog-grep.pod  \
typog.sty typog.ist typog-example.tex  \
typog-minimal-test.tex typog-without-microtype-test.tex:  \
  typog.ins typog.dtx
	$(LATEX) $(LATEX_FLAGS) $<


crooked-paragraphs-1.mps crooked-paragraphs-2.mps  \
crooked-paragraphs-3.mps crooked-paragraphs-4.mps: crooked-paragraphs.mp

smooth-parshapes-1.mps smooth-parshapes-2.mps smooth-parshapes-3.mps: smooth-parshapes.mp

slant-angle-1.mps: slant-angle.mp

title-1.mps: title.mp

typog.pdf: typog.dtx  \
           crooked-paragraphs-1.mps crooked-paragraphs-2.mps  \
           crooked-paragraphs-3.mps crooked-paragraphs-4.mps  \
           slant-angle-1.mps title-1.mps  \
           smooth-parshapes-1.mps smooth-parshapes-2.mps smooth-parshapes-3.mps  \
           typog-grep.tex  \
           | typog.sty


typog-grep.pl: typog-grep.pl.in typog.sty
	sed -ne 's,$(SED_VERSION_REGEXP),s#@DATE@#\2#g\ns#@RELEASE@#\3#g\ns#@TITLE@#\4#g,p'  \
          < typog.sty  \
          > typog-grep.version.sed
	sed -f typog-grep.version.sed  < $<  > $@
	chmod 755 $@

typog-grep: typog-grep.pl
	ln -sf $< $@
