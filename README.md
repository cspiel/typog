![distcheck status](https://github.com/cspiel/typog/actions/workflows/distcheck.yml/badge.svg)


#  TypoG &ndash; Typographic Fine-Tuning for LaTeX

LaTeX package `typog` provides macros for (micro-)typographic enhancements;
it covers a variety of topics:

* Precise hyphenation control
* Disable/break ligatures
* Manual italic correction
* Extra kerning for slash and hyphen
* Raising selected characters (e.g. hyphen, en-dash, and em-dash)
* Adjusting the vertical position of `itemize`'s labels
* Aligning of the last line of a paragraph
* Filling of the last line last line of a paragraph
* Word spacing control
* [Microtype](https://github.com/schlcht/microtype) front-end
* Slightly sloppy paragraphs
* Vertically partially-tied paragraphs
* Breakable displayed equations
* Setspace front-end
* Smooth ragged-right paragraphs

Moreover `typog` provides an environment to flag interesting parts of
the information deluge typically accumulating in a LaTeX *log*-file
and an associated tool, **typog-grep**, that selectively retrieves
these parts.


##  Installation

The minimally necessary files to install typog are *typog.ins* and *typog.dtx*.  Running LaTeX
on *typog.ins* in particular produces *typog.sty*:

        latex typog.ins

After extraction from *typog.dtx* place *typog.sty* in a directory mentioned in your TEXINPUTS
paths or copy it into one of the directories for your LaTeX installation's *sty*-files and run
**mktexlsr** or equivalent.

To build the documentation it is easier to use the GNU *Makefile*:

        make

To construct the manual *typog.pdf* or the usage example *typog-example.pdf* a working
[MetaPost](https://tug.org/metapost.html) installation and some
[POD](https://perldoc.perl.org/perlpod) utilities of a [Perl](https://www.perl.org/)
distribution are required.  Cautious users can run

        make tool-check

ahead to verify that the required utilities are installed and working.
For an overview over the most important *Makefile* targets use

        make help


##  Usage

Load the package with the usual incantation

        \usepackage{typog}

See Section 2 of the package documentation for available options.


##  Documentation

The package documentation can be found
[online](https://cspiel.github.io/typog/).


##  Credits

Typog is written by Ch. L. Spiel <cspiel@users.sourceforge.org>.


##  License

Released under the
[LaTeX Project Public License v1.3c](https://www.latex-project.org/lppl.txt)
or later.
