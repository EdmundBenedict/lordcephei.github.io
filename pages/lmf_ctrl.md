---
layout: page-fullwidth
title: "Building A Simple ctrl File"
permalink: "/tutorial/lmf/ctrlfile/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
The default _ctrl.*_{: style="color: green"} files provided in the repo and used by the test cases can be quite complicated - needlessly complicated for simple tasks. To overcome this, one can use the --express tag to use default values and greatly reduce the size of the _ctrl.*_{: style="color: green"} file. This tutorial will explain the steps needed to create a simple _ctrl.*_{: style="color: green"} for the material GaAs, for use with the _lmf_{: style="color: blue"} program, however it should be mostly applicable to any material.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the _lm_{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _~/lm_{: style="color: green"} will refer to the location of the cloned repository (_source_ directory). In practice, this directory can be named differently.

All instances of commands assume the starting position is your _build_ directory (this can be checked with the _pwd_{: style="color: blue"} command).  In this tutorial it will be called _~/build/_{: style="color: green"}.

    $ cd ~/build/

with _~/build_{: style="color: green} being the directory the _lm_{: style="color: blue"} repository was built in to.

_Note:_{: style="color: red"} the build directory should be different from the source directory.

### _Tutorial_
_____________________________________________________________
First, make sure there are no prior files for GaAs in your build directory (or where ever you are going to be working in). These come in the form of _gas.*_{: style="color: green"} or _*.gas_{: style="color: green"}, such as _ctrl.gas_{: style="color: green"} (note: _gas_ is not a typo of _gaas_).  

We start with copying the more complicated _ctrl.gas_{: style="color: green"} already provided in the repo:

    $ cp ../lm/fp/test/ctrl.gas .

Now we run the _lmchk_{: style="color: blue"} tool, which will generate site data (atom locations) from the _ctrl.gas_{: style="color: green"} file:

    $ lmchk gas --wsitex=site

This generates a site file for gas; _site.gas_{: style="color: green"}. _lmf_{: style="color: blue"} does not need empty spheres like _lm_{: style="color: blue"} does, so we enter the file _site.gas_{: style="color: green"} and remove the lines starting with _EA1_ and _EC1_ and also rename the lines _C1_ and _A1_ to _Ga_ and _As_ respectively. We then copy _site.gas_{: style="color: green"} to _sitein.gas_{: style="color: green"}:

    $ cp site.gas sitein.gas

We can now run the _blm_{: style="color: blue"} tool:

    $ blm --nk=5 --rdsite --wsitex --express gas

Which will create a _actrl.gas_{: style="color: green"} file for us. Copy this to _ctrl.gas_{: style="color: green"}

    $ cp actrl.gas ctrl.gas

Technically this is the express _ctrl.gas_{: style="color: green"} file created, however the file contents are not complete. Specifically, GMAX is not set as _blm_{: style="color: blue"} cannot determine it on its own. To find it, we can use the _lmfa_{: style="color: blue"} tool:

    $ lmfa gas

At the end of this output you will see a output such as

    FREEAT:  estimate HAM_GMAX from RSMH:  GMAX=4.9

Specifically we care about the GMAX=* part. Although we are not done yet: copy the file _lmfa_{: style="color: blue"} generated, _basp0.gas_{: style="color: green"} to _basp.gas_{: style="color: green"} and run _lmfa_{: style="color: blue"} again:

    $ cp basp0.gas basp.gas
	$ lmfa gas

Finally, you will see another _lmfa_{: style="color: blue"} output looking like

    FREEAT:  estimate HAM_GMAX from RSMH:  GMAX=4.9 (valence)  8.1 (local orbitals)

Now we have the value we want, namely the local orbital value (in this example: 8.1). We go back in to our _ctrl.gas_{: style="color: green"} file and find the _gmax=_ flag, which we should set to 8.1. The _ctrl.gas_{: style="color: green"} is now complete!