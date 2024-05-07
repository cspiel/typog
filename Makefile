###  name:      	Makefile
###  synopsis:  	Build `typog' style file, tools, and documentation
###  author:    	Dr. Christoph L. Spiel
###  GNU make version:  4.3


SHELL := /bin/sh


LATEX := /usr/bin/env max_print_line=2147483647 pdflatex
LATEX_FLAGS := -file-line-error -halt-on-error -interaction=nonstopmode
LATEX_RERUN_TRIGGER := '^Package rerunfilecheck Warning: File [^ ]* has changed'
LATEX_WARNING := '^LaTeX (|[A-Za-z0-9_]* )Warning:'

MAKEINDEX := makeindex
MAKEINDEX_FLAGS := -q


METAPOST := mpost
METAPOST_FLAGS := -file-line-error -interaction=nonstopmode -tex=latex


PODCHECKER := podchecker
PODCHECKER_FLAGS := -warnings


POD2MAN := pod2man
POD2MAN_FLAGS := $$(sed -ne 's,\\ProvidesPackage{typog}\[\([0-9][0-9]*/[0-9][0-9]*/[0-9][0-9]*\) *v\([^ ]*\) .*$$,--date=\1 --release=\2,p' < typog.sty)


POD2TEXI := pod2texi
POD2TEXI_FLAGS :=


GROFF := groff
##  Codes of serif fonts that work for PDF output
##  	BM: URW Bookman L
##  	N:  URW Century Schoolbook L
##  	P:  URW Palladio L
##  	T:  URW Nimbus Roman No9 L
GROFF_FLAGS := -Tpdf -dpaper=a4 -fP -man -wall


SPELLCHECK := aspell
SPELLCHECK_FLAGS :=  \
    --add-tex-command='citenum p'  --add-tex-command='code p'  \
    --add-tex-command='Cref p' --add-tex-command='cref p'  \
    --add-tex-command='cs p'  \
    --add-tex-command='DescribeEnv p' --add-tex-command='DescribeMacro p'  \
    --add-tex-command='marg p' --add-tex-command='meta p'  \
    --add-tex-command='oarg p'  \
    --lang=en_US --mode=tex


SOURCE_FILES := LICENSE Makefile typog.dtx typog.ins



.PHONY: all
all: sty pdf man


.PHONY: sty
sty: typog.sty


.PHONY: pdf
pdf: doc ex nomt


.PHONY: doc
doc: typog.pdf


.PHONY: ex
ex: typog-example.pdf


.PHONY: nomt
nomt: typog-nomt.pdf


.PHONY: man
man: typog-grep.1


.PHONY: cpio
cpio:
	cd ..;  \
            echo $(addprefix typog/,$(SOURCE_FILES))  |  \
            cpio -o  |  \
            gzip  > "typog-$$(date +%Y-%m-%d).cpio.gz"


.PHONY: tar
tar:
	cd ..;  \
            tar czf "typog-$$(date +%Y-%m-%d).tar.gz" $(addprefix typog/,$(SOURCE_FILES))


.PHONY: clean
clean:
	$(RM) ./*.1 ./*.aux ./*.brf ./*.glg ./*.glo ./*.gls
	$(RM) ./*.hd ./*.idx ./*.ilg ./*.ind ./*.loe ./*.lof ./*.log ./*.lot
	$(RM) ./*.mps ./*.mpx ./*.out ./*.pdf ./*.toc
	$(RM) mptextmp.* mpxerr.tex README README.html


.PHONY: mostlyclean
mostlyclean: clean


.PHONY: maintainer-clean
maintainer-clean: mostlyclean
	$(RM) ./*.ist ./*.mp ./*.pl ./*.pod ./*.sed ./*.sty ./*.tex


.PHONY: tool-check
tool-check:
	@printf '***  LATEX = "%s"\n' '$(LATEX)'
	$(LATEX) --version
	@printf '\n\n***  MAKEINDEX = "%s"\n' '$(MAKEINDEX)'
	$(MAKEINDEX) < /dev/null
	@printf '\n\n***  METAPOST = "%s"\n' '$(METAPOST)'
	$(METAPOST) --version
	@printf '\n***  POD2MAN = "%s"\n' '$(POD2MAN)'
	$(POD2MAN) --help > /dev/null
	@printf '\n\n***  POD2TEXI = "%s"\n' '$(POD2TEXI)'
	$(POD2TEXI) --version
	@printf '\n\nTool check passed.\n'


.PHONY: spell-check
spell-check:
	@sed -e '\#<DISABLE-SPELL-CHECK/>#d'  \
             -e '\#<DISABLE-SPELL-CHECK>#,\#</DISABLE-SPELL-CHECK>#d'  < typog.dtx  |  \
	    sed -e 's/^ *%%*//'  |  \
	    sed -e 's/\\-//g' -e 's/|[^|]*|/ /g'  |  \
	    $(SPELLCHECK) $(SPELLCHECK_FLAGS) list  |  \
	    sort  |  uniq  |  fmt  |  sed -e 's/ /  /g'


.PHONY: update-docs
update-docs: doc ex typog-grep.1.pdf
	cp -f typog.pdf typog-example.pdf typog-grep.1 typog-grep.1.pdf docs


define HELP_SCREEN
Selected Phony Targets
----------------------
all:    Make everything there is to make.  This is the .DEFAULT_GOAL.

clean:  Remove some products.

cpio:   In the parent directory create a cpio(1) archive of the
        project source files whose name is time-stamped.

doc:    Build "typog.pdf" the Typog documentation.

ex:     Build "typog-example.pdf" an example and test file for Typog.

maintainer-clean: Remove every product file that can be rebuilt even
        if uncommon tools are necessary.

mostlyclean: Remove some more products than clean:.

pdf:    Build doc: and gauge:.

sty:    Only extract "typog.sty" from "typog.dtx".  This
        operation requires LaTeX (-> $(LATEX)) and nothing else.

tar:    In the parent directory create a tar(1) file of the project
        source files whose name is time-stamped.

tool-check: Check whether some of the required tools to build the
        project are available.


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
sed -e '/@/d' -e 's/{\\ttfamily /{\\ttfamily\\hskip0pt\\relax /' < $*.idx  > ,$*.idx;  \
mv ,$*.idx $*.idx;  \
$(MAKEINDEX) $(MAKEINDEX_FLAGS) -s typog.ist -t $*.ilg -o $*.ind $*.idx;  \
$(MAKEINDEX) $(MAKEINDEX_FLAGS) -s gglo.ist -t $*.glg -o $*.gls $*.glo
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

%.tex: %.pod | teximan2latex.sed
	$(POD2TEXI) $(POD2TEXI_FLAGS) ./$<  |  sed -f teximan2latex.sed  > $@


%.html: %.md
	markdown $<  > $@

%: %.html
	w3m -cols 79 $<  > $@


crooked-paragraphs.mp slant-angle.mp smooth-parshapes.mp title.mp  \
teximan2latex.sed  \
typog-grep.pl typog-grep typog-grep.pod  \
typog.sty typog.ist typog-example.tex typog-nomt.tex:  \
  typog.ins typog.dtx
	$(LATEX) $(LATEX_FLAGS) $<
	chmod 755 typog-grep.pl
	ln -sf typog-grep.pl typog-grep


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
