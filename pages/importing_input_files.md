---
layout: page-fullwidth
title: "Importing Input files"
breadcrumb: true
permalink: "/tutorial/importing_input/"
header: no
---

### _Purpose_
{:.no_toc}

This tutorial explains how to import input files from various sources,
for use in one or more of the Questaal codes

_____________________________________________________________

### _Command summary_

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

Build a simple input file from an _init_{: style="color: green"} file

    cp ~/lm/testing/init.bi2te3
    blm --express bi2te3 

Input file from _init_{: style="color: green"} file, complex case

    cp ~/lm/testing/init.sbsei .
    blm --gw --addes --fixpos:tol=1e-2 --scalp=1 --xshftx=0,0,-0.0398106/2 --wsitex init.sbsei

Input file from _init_{: style="color: green"} file, magnetic ASA

    cp ~/lm/testing/init.fept .
    blm --mag --asa --gf --nk=10 fept

Input and/or site files from _cif_{: style="color: green"} file

    cp ~/lm/testing/cif2cell.batio3 .
    cif2init cif2cell.batio3
    mv init init.batio3
    blm --noshorten --wsitex batio3
    cp ~/lm/testing/cif2cell.batio3 .
    cif2site cif2cell.batio3

Input and/or site files from _POSCAR_{: style="color: green"} file

    cp ~/lm/testing/POSCAR.zn3as2 POSCAR
	poscar2init > init.zn3as2
	blm --express=0 zn3as2 --fixpos:tol=1e-6 > out.zn3as2
    cp actrl.zn3as2 ctrl.zn3as2
    lmchk ctrl.zn3as2 --fixpos:tol=1e-6 --shell:r=.2 >> out.zn3as2

    cp ~/lm/testing/sitein.fe2p .
	blm fe2p --rdsite --express=1 --mag --findes --asa --omax=.00

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Preliminaries_

The input file structure is briefly described in [this lmf tutorial for Pbte](https://lordcephei.github.io/lmf_tutorial/), which you may wish to go through first.

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path. 

_____________________________________________________________

### _Tutorial_

#### 1. _Basic input file from init file_

Cut and past the box below into _init.bi2te3_{: style="color: green"},
or copy _~/lm/testing/init.bi2te3_{: style="color: green"} into your working directory

~~~
# from http://cst-www.nrl.navy.mil/lattice/struk/c33.html
# Bi2Te3 from Wyckoff
% const a=4.3835 c=30.487 uTe=0.788 uBi=0.40
LATTICE
   SPCGRP=R-3M
   UNITS=A
   A={a} C={c}
SITE
    ATOM=Te X=0     0    0
    ATOM=Te X=0     0   {uTe}
    ATOM=Bi X=0     0   {uBi}
~~~

Create a simple skeleton input file

    blm --express bi2te3

#### 2. _Input file from init file, complex case_
First obtain your input file, which for this example will be _init.sbsei_{: style="color: green"}, which can be found in the _/testing/_{: style="color: green"} directory within your _lm_{: style="color: blue"} repository. Copy this file in to your working directory and run:

    blm --gw --express --addes --fixpos:tol=1e-2 --scalp=1 --xshftx=0,0,-0.0398106/2 --wsitex init.sbsei

Where, for _sbsei_ in particular, we use _--gw_ to add GW related tags, _--addes_ to add tags used for empty spheres later on and the rest to modify values in the input file as needed. We then do the general steps to complete our _ctrl_{: style="color: green"} file:

    cp actrl.sbsei ctrl.sbsei
    lmfa sbsei
    cp basp0.sbsei basp.sbsei
    lmfa sbsei

Then copy the resulting _GMAX_ (the higher, if there are two) output in to the relevant field in your _ctrl.sbsei_{: style="color: green"}.

#### 3. _Input file for magnetic ASA from init file_
First obtain your input file, which for this example will be _init.fept_{: style="color: green"}, which can be found in the _/testing/_{: style="color: green"} directory within your _lm_{: style="color: blue"} repository. Copy this file in to your working directory and run:

    blm --mag --asa --gf --nk=10 --express fept

Specifically, the _--mag_ and _--asa_ switches to _blm_{: style="color: blue"} tell it to prepare for a spin polarized calculation and generate the input file for ASA. We then run the commands needed to finalize the  _ctrl_{: style="color: green"} file: 

    cp actrl.fept ctrl.fept
    lmfa fept
    cp basp0.fept basp.fept
    lmfa fept

Then copy the resulting _GMAX_ (the higher, if there are two) output in to the relevant field in your _ctrl.fept_{: style="color: green"}.

#### 4. _Input file and/or site from cif file_
First you must obtain or generate your cif2cell file. In this tutorial we will use an example cif2cell file, _ciff2cell.batio3_{: style="color: green"}, generated with the **ciff2cell**{: style="color: blue"} tool for converting CIF files to cif2cell files. You can find this file in the _lm_{: style="color: blue"} in the _/testing/_{: style="color: green"} folder.    

We then generate the init file from the cif2cell:

    cif2init cif2cell.batio3

Which generates our _init.batio3_{: style="color: green"} file. We can use this to generate the actrl file with **blm**{: style="color: blue"}:

    blm --noshorten --wsitex batio3

Generating a _actrl.batio3_{: style="color: green"} file. From this we can follow the steps outlined in (1) or (2) of this tutorial to get a _ctrl.batio3_{: style="color: green"} file.    

To generate a site file from the same cif2cell file, we use a similar command:

    cif2site cif2cell.batio3

Which generates our _site.batio3_{: style="color: green"} file. From this you may have a use for the site file directly, or you can use a site file to generate a _ctrl.batio3_{: style="color: green"} file, (7) explains this.

#### 5. _Input file from POSCAR file_
For this input file we need a POSCAR file. We will use the example POSCAR file for _Zn3As2_ found in _/testing/POSCAR.zn3as2_{: style="color: green"} in the _lm_{: style="color: blue"} repository. We copy this to our working directory and name it _POSCAR_{: style="color: green"}.

We then convert the POSCAR file to an init file with the command:

    poscar2init

Notice the lack of command line switches - this tool only takes files named _POSCAR_{: style="color: green"} and does not differentiate whether they are _POSCAR.[material]_{: style="color: green"}. We can then use the **blm**{: style="color: blue"} tool to translate this _init.zn3as2_{: style="color: green"} file to an _actrl.zn3as2_{: style="color: blue"} file:

    blm --express=0 zn3as2 --fixpos:tol=1e-6

And then follow steps shown in (1) or (2).

#### 6. _Site file from POSCAR file_
For this input file we need a POSCAR file. We will use the example POSCAR file for _Zn3As2_ found in _/testing/POSCAR.zn3as2_{: style="color: green"} in the _lm_{: style="color: blue"} repository. We copy this to our working directory and name it _POSCAR_{: style="color: green"}.

We then convert the POSCAR file to an site file with the command:

    poscar2site

Notice the lack of command line switches - this tool only takes files named _POSCAR_{: style="color: green"} and does not differentiate whether they are _POSCAR.[material]_{: style="color: green"}. This generates our _site.zn3as2_{: style="color: green"} file. From this you may have a use for the site file directly, or you can use a site file to generate a _ctrl.zn3as2_{: style="color: green"} file, (7) explains this.

#### 7. _input file file from site file_
This tutorial will look at the material _fe2p_. We will need a site file, which we shall find in _/testing/sitein.fe2p_{: style="color: green"} in the _lm_{: style="color: blue"} repository. We copy this to our working directory and run:

    blm $ext --rdsite --express=1 --mag --findes --asa --omax=.00

Which generates an _actrl.fe2p_{: style="color: green"} file, follow the steps in (2) to fully complete the _ctrl.fe2p_{: style="color: green"} file.
