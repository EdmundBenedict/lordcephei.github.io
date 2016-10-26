---
layout: page-fullwidth
title: "Full Potential (lmf) Core-Level Spectroscopy"
permalink: "/tutorial/lmf/cls/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial demonstrates how to obtain and plot a core level spectroscopy density of states (DOS) using the full potential band code **lmf**{: style="color: blue"}.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the **lm**{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _~/lm_{: style="color: green"} will refer to the location of the cloned repository (_source_ directory). In practice, this directory can be named differently.

All instances of commands assume the starting position is your _build_ directory (this can be checked with the _pwd_{: style="color: blue"} command).  In this tutorial it will be called _~/build/_{: style="color: green"}.

    $ cd ~/build/

with _~/build_{: style="color: green} being the directory the **lm**{: style="color: blue"} repository was built in to.

_Note:_{: style="color: red"} the build directory should be different from the source directory.

### _Tutorial_
_____________________________________________________________
Performing core level spectroscopy using the **lmf**{: style="color: blue"} code is exemplified in these test cases

    $ fp/test/test.fp fe 2
    $ fp/test/test.fp cr3si6 2
    $ fp/test/test.fp crn with a core hole

Should you want a more in depth look, or a practical example, these are good places to start. We will use these as a base and go through the steps required to generate the partial DOS.   

An input file is needed for the material of which the partial DOS should be found. A tutorial detailing the steps required to generate a basic input file can be found [here](https://lordcephei.github.io/tutorial/lmf/ctrlfile/). While this tutorial concerns itself with CrN, the steps involved are applicable to most other materials.   

In this tutorial we will use the material Chromium Nitrate, CrN. Our input file, created previously, will be referred to as _ctrl.crn_{: style="color: green"} and should be named as such.

We begin by running **lmfa**{: style="color: blue"} progam which needs to be run before any **lmf**{: style="color: blue"} process in order to generate the free-atom densities which, in our case, is generated in to the file _atm.crn_{: style="color: green"} with the command

    $ lmfa gas

We can now proceed with our **lmf**{: style="color: blue"} commands

    $ lmf crn
    $ lmf crn --rs=1,0 --cls:5,0,1 -vnit=1 -vmetal=2

Note that the **lmf**{: style="color: blue"} command is run twice - this is intended; the first run ensures a self-consistent solution. Particular attention should be paid to the _--cls_ flag - the flag which tells **lmf**{: style="color: blue"} to perform core level spectroscopy on CrN. This will generate a variety of files needed to build to perform our core level spectroscopy.

We then run

    $ lmdos --dos:cls:window=0,1:npts=101 --cls crn

Again, note the use of the _--cls_ flag. This makes use of the previously generated files and generates the _dos.crn_{: style="color: green"} file which contains our partial DOS information. This can be plotted with your preferred plotting tool, although some manipulation of the data in the file may be required.   

A plotting tool is included in the suite, **fplot**{: style="color: blue"}, which can be used to generate a postscript file. We must first prepare the _dos.crn_{: style="color: green"} file with another program in the suite, _pldos_{: style="color: blue"}, with the command

    $ echo .25 10 0 1 | pldos -fplot -lst="1;3;5" -lst2="2;4;6" dos.crn

Which generates a _plot.dos_{: style="color: green"} file readable by **fplot**{: style="color: blue"}. We follow this with an **fplot**{: style="color: blue"} command

    $ fplot -disp -pr10 -f plot.dos

Which should result in a viewable image of the CLS DOS.