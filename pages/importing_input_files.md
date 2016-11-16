---
layout: page-fullwidth
title: "Importing Input files"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/importing_input/"
header: no
---

### _Purpose_

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

    ... to be finished

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

    $ blm --express bi2te3

#### 2. _Input file from init file, complex case_

Document ~/lm/testing/test.blm 2


#### 3. _Input file for magnetic ASA from init file_

Document ~/lm/testing/test.blm 3

#### 4. _Input file and/or site from cif file_

Document ~/lm/testing/test.blm 4 and ~/lm/testing/test.blm 5

#### 5. _Input file from POSCAR file_

Document ~/lm/testing/test.blm 6

#### 6. _Site file from POSCAR file_

Document ~/lm/testing/test.blm 7

#### 7. _input file file from site file_

Document ~/lm/testing/test.blm 8



