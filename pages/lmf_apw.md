---
layout: page-fullwidth
title: "Adding Augmented Plane Waves To A lmf Basis"
permalink: "/tutorial/lmf/apw/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial demonstrates how to add Augmented Plane Waves (APWs) to a **lmf**{: style="color: blue"} basis set.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the **lm**{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _~/lm_{: style="color: green"} will refer to the location of the cloned repository (_source_ directory). In practice, this directory can be named differently.

All instances of commands assume the starting position is your _build_ directory (this can be checked with the _pwd_{: style="color: blue"} command).  In this tutorial it will be called _~/build/_{: style="color: green"}.

    $ cd ~/build/

with _~/build_{: style="color: green} being the directory the **lm**{: style="color: blue"} repository was built in to.

_Note:_{: style="color: red"} the build directory should be different from the source directory.

### _Tutorial_
_____________________________________________________________
Adding APWs to **lmf**{: style="color: blue"} is exemplified in these test cases

    $ fp/test/test.fp srtio3
    $ fp/test/test.fp cu

Should you want a more in depth look, or a practical example, these are good places to start. We will use these as a base and go through the steps required to add the APWs.

For APWs the important points are in the tokens used (tokens, of course, can be added either in the _ctrl_{: style="color: green"} file or as part of the command line arguments, see [here](/docs/input/inputfile/) and [here](/docs/commandline/general/), for this tutorial we will use the command line argument method).   

The tokens of importance are (these can be seen in detail [here](/docs/input/inputfile/#ham))

    PWMODE=#
    PWEMIN=#
    PWEMAX=#
    OVEPS=#

Specifically, _PWMODE_ tells **lmf**{: style="color: blue"} how to add APWs to the basis. For our example we will use 11 (default=0), see the link above for a detailed description of the options. _PWEMAX_ is the upper cutoff energy in Rydbergs, only G-vectors whose energy falls below this value will be included. Similarly, _PWEMIN_ is the lower cutoff energy.   

_OVEPS_, if its value is positive, tells **lmf**{: style="color: blue"} to diagonalise the overlap matrix and eliminate the subspace which has eigenvalues smaller than #. Necessary, as using many APWs can cause the overlap matrix to become nearly singular and thus unstable. A good value for _OVEPS_ is 1E-7.

To continue our tutorial, we will focus on _cu_. First you must copy your _ctrl.cu_{: style="color: green"} and _syml.cu_{: style="color: green"} files to your working directory. Tutorials and documentation on these files can be found [here](/tutorial/lmf/ctrlfile/) and [here](/docs/input/symfile/) respectively. Stock files can be found, in your **lm**{: style="color: blue"} repository, at:

    fp/test/ctrl.cu
    fp/test/syml.cu

To be used as references in building your more personally tailored files, or as a way to quickly jump in to the simulations. First, as with all **lmf**{: style="color: blue"} simulations, we must run **lmfa**{: style="color: blue"} to generate the free atom densities

    lmfa --no-iactiv cu -vnk=8 -vbigbas=f

This runs **lmfa**{: style="color: blue"}, _vnk=8_ (which sets _BZ\_NKABC_) telling it to use 8 divisions in the three directions (all 8) of the reciporcal lattice vectors. We then run our **lmf**{: style="color: blue"} command:

    lmf  --no-iactiv cu -vnk=8 -vbigbas=t -vpwmode=11 -voveps=0d-7 --band:fn=syml

Breaking this command down: _vnk=8_ is as described above. _-vpwmode=11_, which sets _HAM\_PWMODE_ to 11, specifically tells **lmf**{: style="color: blue"} to use a _LMTO_{: style="color: blue"} basis only, and to fix the basis (read more [here](/docs/input/inputfile/#ham)). _-voveps=0d-7_, being a positive value, works as described above. Finally, _--band_ tells **lmf**{: style="color: blue"} to generate a _bnds.cu_{: style="color: green"} file which is important for plotting our energy bands.   

We now have our _bnds.cu_{: style="color: green"} and the simulation is complete. You can plot this file with your preffered plotting software, although some data manipulaton may be required. Instructions for fplot are provided below:

    cp bnds.cu bnds.lapw
    echo -10 40 5 10 | plbnds -lbl=L,G,X,W,G,K -ef=0 -scl=13.6 -fplot -dat=apw bnds.lapw
    cp bnds.cu bnds.lmto
    echo -10 40 5 10 | plbnds -lbl=L,G,X,W,G,K -ef=0 -scl=13.6 -fplot -dat=lmto bnds.lmto
    awk 'BEGIN {print "%char0 lta=2,bold=3,col=1,0,0"} {if ( = "-colsy") {print; sub("lmto","apw"); sub("ltb","lta");print} else {print}}' plot.plbnds > plot.plbnds~
    fplot -disp -f plot.plbnds~
