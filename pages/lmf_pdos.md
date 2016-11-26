---
layout: page-fullwidth
title: "Full Potential (lmf) Partial DOS"
permalink: "/tutorial/lmf/pdos/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial demonstrates how to obtain and plot a partial density of states (DOS) using the full potential band code **lmf**{: style="color: blue"}.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the **lm**{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _~/lm_{: style="color: green"} will refer to the location of the cloned repository (_source_ directory). In practice, this directory can be named differently.

All instances of commands assume the starting position is your _build_ directory (this can be checked with the _pwd_{: style="color: blue"} command).  In this tutorial it will be called _~/build/_{: style="color: green"}.

    $ cd ~/build/

with _~/build_{: style="color: green} being the directory the **lm**{: style="color: blue"} repository was built in to.

_Note:_{: style="color: red"} the build directory should be different from the source directory.

### _Tutorial_
_____________________________________________________________
Building a partial DOS using the **lmf**{: style="color: blue"} code is exemplified in two test cases

    $ ~/lm/fp/test/test.fp co 3
    $ ~/lm/fp/test/test.fp gas 2

Should you want a more in depth look, or a practical example, these are good places to start. We will use these as a base and go through the steps required to generate the partial DOS.   

An input file is needed for the material of which the partial DOS should be found. A tutorial detailing the steps required to generate a basic input file can be found [here](https://lordcephei.github.io/tutorial/lmf/ctrlfile/). While this tutorial concerns itself with Cr3Si6, the steps involved are applicable to most other materials.   

In this tutorial we will use the material Gallium Arsenide, GaAs. Our input file, created previously, will be referred to as _ctrl.gas_{: style="color: green"} and should be named as such.

We begin by running **lmfa**{: style="color: blue"} progam which needs to be run before any **lmf**{: style="color: blue"} process in order to generate the free-atom densities which, in our case, is generated in to the file _atm.gas_{: style="color: green"} with the command

    $ lmfa gas

We can now proceed with our **lmf**{: style="color: blue"} commands

    $ lmf gas
    $ lmf gas -vpdos=t --pdos~lcut=2,2,1,1~mode=1 --rs=1,0 -vnit=1

Note that the **lmf**{: style="color: blue"} command is run twice - this is intended; the first run ensures a self-consistent solution. This will generate a variety of files needed to build our partial density of states. Note, this command will generate a _dos.gas_{: style="color: green"} file. This file is _not_ our partial density of states but rather the full density of states file, the next command will overwrite this file.

We then run

    $ lmdos gas -vpdos=t --pdos~lcut=2,2,1,1~mode=1 --dos:npts=1001:window=-1.2,.7

Which makes use of the previously generated files and generates the _dos.gas_{: style="color: green"} file which contains our partial DOS information. This can be plotted with your preferred plotting tool, although some manipulation of the data in the file may be required.
*Note:*{: style="color: red"}: if you include **rdm** in the **\-\-dos** switch, e.g.
**-\-dos:rdm:npts=1001:window=-1.2,.7**, the DOS will be written in the
[Questaal format for two-dimensional arrays](/docs/input/data_format/#standard-data-formats-for-2d-arrays),
which is easily parsed by many graphics packages.

A plotting tool is included in the suite, **fplot**{: style="color: blue"}, which can be used to generate a postscript file. We must first prepare the _dos.gas_{: style="color: green"} file with another program in the suite, _pldos_{: style="color: blue"}, with the command

    $ echo 15 7 -1.2 0.7 | pldos -fplot -lst="1;2;3;4;5;6" dos.gas

Which generates a _plot.dos_{: style="color: green"} file readable by **fplot**{: style="color: blue"}. We follow this with an **fplot**{: style="color: blue"} command

    $ fplot -disp -pr10 -f plot.dos

Which should result in a viewable image of the partial DOS.
