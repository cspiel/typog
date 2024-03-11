#  TypoG &ndash; Typographic Fine-Tuning for LaTeX

LaTeX package `typog` provides macros for (micro-)typographic enhancements.


##  Installation

The minimally necessary files to install typog are *typog.ins* and *typog.dtx*.  Running LaTeX
on *typog.ins* in particular produces *typog.sty*:

        latex typog.ins

After extraction from *typog.dtx* place *typog.sty* in a directory mentioned in your TEXINPUTS
paths or copy it into one of the directories for your LaTeX installation's *sty*-files and run
**mktexlsr** or equivalent.

To build the documentation it is easier to use the GNU *Makefile*:

        make

To construct the manual *typog.pdf* or the usage example *typog-example.pdf* a working MetaPost
installation and some POD utilities of a Perl distribution are required.  Cautious users can run

        make tool-check

ahead to verify that the required utilities are installed and working.
For an overview over the most important *Makefile* targets use

        make help


##  Usage

Load the package with the usual incantation

        \usepackage{typog}

See Section 2 of the package documentation for available options.


##  Documentation

The pre-built package documentation can be found in the subdirectory *docs*.


##  Credits

Typog is written by Ch. L. Spiel <cspiel@users.sourceforge.org>.


##  License

Released under the
[LaTeX Project Public License v1.3c](https://www.latex-project.org/lppl.txt)
or later.
