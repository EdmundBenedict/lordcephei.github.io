---
layout: page-fullwidth
title: "Generating a Fermi Surface with LMF"
permalink: "/tutorial/lmf/fermisurface/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial shoulds how to generate a Fermi surface for Iron using _lmf_{: style="color: blue"}. Though, this tutorial can be applied to other materials as long as the general instructions are followed (with special attention paid to the _--band_ flag).

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the _lm_{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _~/lm_{: style="color: green"} will refer to the location of the cloned repository (_source_ directory). In practice, this directory can be named differently.

All instances of commands assume the starting position is your _build_ directory (this can be checked with the _pwd_{: style="color: blue"} command).  In this tutorial it will be called _~/build/_{: style="color: green"}.

    $ cd ~/build/

with _~/build_{: style="color: green} being the directory the _lm_{: style="color: blue"} repository was built in to.

_Note:_{: style="color: red"} the build directory should be different from the source directory.

### _Tutorial_
_____________________________________________________________
To generate a Fermi surface with _lmf_{: style="color: blue"} we first need a _ctrl.*_{: style="color: green"} file. For this tutorial we will use Fe with _ctrl.fe_{: style="color: green"} found in the directory _fp/test/ctrl.fe_{: style="color: green"} in your _lm_{: style="color: green"} directory. You can also take a look at [this tutorial](https://lordcephei.github.io/tutorial/lmf/ctrlfile/) which will detail how to convert the prior mentioned _ctrl.fe_{: style="color: green"} to a simple format. Either way, you should copy your _ctrl.fe_{: style="color: green"} to your working directory:

    $ cp ../lm/fp/test/ctrl.fe .

We then run the _lmfa_{: style="color: blue"} command, which must be run before any _lmf_{: style="color: blue"} calculation:

    $ lmfa fe

We can now run _lmf_{: style="color: blue"}, specifically using a _--band_ tag which tells _lmf_{: style="color: blue"} to generate a _bnds.fe_{: style="color: green"} file that we can use to build our Fermi surface:

    $ lmf fe --iactiv --band~con~fn=fs

With our _bnds.fe_{: style="color: green"} file generated, we can use the _mc_{: style="color: blue"} tool, included in the repo, to parse the _bnds.fe_{: style="color: green"} file and then plot it with fplot:

	$ mc -r:open bnds.fe -shft=0 -w b2 -r:open bnds.fe -shft=0 -w b3 -r:open bnds.fe -shft=0 -w b4 -r:open bnds.fe -shft=0 -w b5
    $ fplot -f plot.fs0

Where the file _plot.fs0_{: style="color: green"} containing the _fplot_{: style="color: blue"} commands:

'''

fplot
% var ef=-0.006661
  -lt 1,col=0,0,.5 -con {ef} b2
  -lt 1,col=0,1,.8 -con {ef} b3
  -lt 1,col=0,1,0 -con {ef} b4
  -lt 1,col=1,0,0 -con {ef} b5

'''

Your Fermi surface can now be found in the _fplot.ps_{: style="color: green"} file.