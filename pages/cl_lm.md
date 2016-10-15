---
layout: page-fullwidth
title: "lm Command Line Options"
permalink: "/docs/commandline/lm/"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________
This page serves to document the command line switches specifically applicable to the _lm_{: style="color: blue"} program.

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Preliminaries_
_____________________________________________________________
You should familiarize yourself with the contents of the [general command line options](/docs/commandline/general/) documentation and be aware of the capabilities of the _lm_{: style="color: blue"} program in order to fully understand the options available.

It would also be wise to read up on the different input sources that _lm_{: style="color: blue"} can read as some input options will pertain to specific input data. Details on these input sources can be found in the [Input file guide.](/docs/input/inputfile/)

### _Documentation_
_____________________________________________________________

    --rs=#1,#2       Causes lm to read from a rst file. By default the ASA writes potential information,
                     e.g. (P,Q) for each class to a separate file. 
                     If #1 is nonzero, data is read from file rsta.ext, superseding information in class files. 
					 If #2 is nonzero, lm will write to that file.
					 
    --band[~option~option...] Tells lm to generate energy bands instead of making a self-consistent calculation.
	                 The energy bands can be generated in one of several formats.
                     See "Drawing Energy Bands" in the Functionality -> Physical Application
                     tab for a detailed description of the available options.
					 
    --pdos[:options] Tells lm to generate weights for density-of-states resolved into partial waves,
                     See "Density Of States" in the Functionality -> Physical Application
                     tab for a detailed description of the available options.

    --mull[:options] Tells lm to generate weights for Mulliken analysis.
                     See "Density Of States" in the Functionality -> Physical Application
                     tab for a detailed description of the available options.
	
    --mix=#          Start the density mixing at rule ``#''
                     (See ITER_MIX in tokens.html
                     for a description of mixing rules).
					 
    --onesp          In the spin-polarized collinear case, tells the program that
                     the spin-up and spin-down hamiltonians are equivalent
                     (special antiferromagnetic case).
					 
    -sh=cmd          Invoke the shell ``cmd'' after every iteration.
