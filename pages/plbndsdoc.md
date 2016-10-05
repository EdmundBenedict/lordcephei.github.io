---
layout: page-fullwidth
title: "The plbnds program"
permalink: "/docs/misc/plbnds/"
header: no
---
_____________________________________________________________


### _Purpose_
{:.no_toc}

**plbnds**{: style="color: blue"} is designed to generate data to make
figures of energy bands along specified symmetry lines.

_____________________________________________________________

### _Preliminaries_

Executables **plbnds**{: style="color: blue"} and **fplot**{: style="color: blue"} are required and are assumed to be in your path. 
You will also need a postscript viewer.  This document assumes you are using the generic apple-style **open**{: style="color: blue"} command to view postscript files.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}


### 1. _Introduction_

Energy bands provide a great deal of information, and the Questaal codes provide a fair amount of flexibility in generating
them.  Drawing bands with color weights is a particularly useful feature,
as shown in Section 2

You must choose the symmetry lines yourself but [prepackaged symmetry line
files](https://lordcephei.github.io/docs/input/symfile/) are available that greatly facilitate the selection and labelling.

Three Questaal tools can make energy bands along symmetry lines you specify: **lmf**{: style="color: blue"}, **lm**{:
style="color: blue"}, and **tbe**{: style="color: blue"}. They share a common input and output format.  Bands are
written to file _bnds.ext_{: style="color: green"}.  This file is not written in a friendly
format; but it is often the case that you need only a subset of the bands or to provide extra information such as data for color weights.
**plbnds**{: style="color: blue"} can efficiently convert data in _bnds.ext_{: style="color: green"} to a friendly format in a variety of circumstances.
Data for each symmetry line is kept in a separate file.

**plbnds**{: style="color: blue"} may be used in one of several contexts:

1. To make postscript files of bands directly, without other software.  Quick and dirty:  no easy way to modify the figure.
2. To generate a script and formated files for use with **fplot**{: style="color: blue"}, a plotting package built into Questaal.
3. Same as 2, but format files ready for use with **gnuplot**{: style="color: blue"}, **xmgrace**{: style="color: blue"}, or another graphics package.

Tutorials show how to draw figures with **fplot**{: style="color: blue"}; however
**plbnds**{: style="color: blue"} makes suitable files you can easily use **gnuplot**{: style="color: blue"} or some other package.
**plbnds**{: style="color: blue"} and **fplot**{: style="color: blue"} write postscript files to _fplot.ps_{: style="color: green"}.

**plbnds**{: style="color: blue"} will print information about its usage by typing

    $ plbnds --h

Section 2 gives you an intuitive feel of how **plbnds**{: style="color: blue"} operates by working through an example (the energy bands of Co).

Section 3 is an operations manual.

_____________________________________________________________


### 2. _Examples_

Copy an already prepared bands file for Co, [_bnds.co_{: style="color: green"}](/assets/download/inputfiles/bnds.co) to your working directory.
It contains energy bands connecting the symmetry lines M, &Gamma;, A, L, &Gamma;, K (5 panels).
Bands were computed in the LDA with spin-orbit coupling; thus both spin-up and spin-down bands are present.

The first line of the file

    36  -0.02136     2  col= 5:9,14:18  col2= 23:27,32:36

contains essential information about the contents.  It says that:

+ the file contains 36 bands
+ the Fermi level is -0.02136 Ry
+ the file contains two sets of color weights

Strings **col=** and following are not used; they are there for record-keeping.

##### Example 1
Enter the following to make and view the postscript file:

    $ echo -0.8,0.6,10,15 | plbnds -lbl=M,G,A,L,G,K bnds.co
    $ open fplot.ps

Note the following:

+ The energy bands are plotted in an energy window `-0.8,0.6` Ry, in 5 panels.
+ Arguments `10,15` specify the width and height of the entire figure (approximately in cm).
+ The symmetry labels M, &Gamma;, A, L, &Gamma;, K, were extracted from `-lbl=M,G,A,L,G,K`.
  G is turned into &Gamma;.
+ Energy bands are in Ry.
+ The Fermi level is drawn as a dashed line at -0.02136 Ry.
+ Bands are plotted as fat dots at the points where they are generated.
+ It is easy to distinguish the dense tangle of flat _d_ bands approximately between -0.3 and +0.1 Ry.  
  The _sp_ bands are highly dispersive and approximately quadratic; see particularly below -0.4 and above +0.1

##### Example 2

For a better and more modifiable figure, run **plbnds**{: style="color: blue"} again with:

    $ echo -10,8 / | plbnds -fplot -ef=0 -scl=13.6 -nocol -lbl=M,G,A,L,G,K bnds.co

<div onclick="elm = document.getElementById('stdout'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to show stdout from plbnds.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="stdout">{:/} 

~~~
 plbnds : bands file contains two sets of color weights
 plbnds: 36 bands  fermi=-0.02136  scaled by 13.6  shifted to 0
 panel 1  nq=25  ebot=-9.232224  etop=33.866176  delta q=0.577353
 panel 2  nq=21  ebot=-9.232224  etop=33.235136  delta q=0.30619
 panel 3  nq=41  ebot=-7.005904  etop=29.214976  delta q=0.57735
 panel 4  nq=45  ebot=-9.232224  etop=33.503056  delta q=0.653518
 panel 5  nq=41  ebot=-9.232224  etop=33.603696  delta q=0.666665
 nq=173  npan=5  emin=-9.232224  ef=0  emax=33.866176  sum dq=2.781075
 emin, emax, width(cm), height(cm) ?
 write file bnd1.dat, bands 1 - 26
 write file bnd2.dat, bands 1 - 26
 write file bnd3.dat, bands 1 - 26
 write file bnd4.dat, bands 1 - 26
 write file bnd5.dat, bands 1 - 26
  ... to plot, invoke:
  fplot -disp -f plot.plbnds
~~~

{::nomarkdown}</div>{:/}

The new switches indicate the following:

+ `-fplot` tells **plbnds**{: style="color: blue"} to generate data files for each of the five panels, and also a script for the [fplot](/docs/misc/fplot) tool.\\
   The fplot script is written to a file, _plot.plbnds_{: style="color: green"}.\\
   The five panels are written to files (_bnd_[1-5]_.dat_{: style="color: green"}) (see standard output). They take a standard Questaal format, which is easily read by other packages.\\
   The first column is a fractional distance along the symmetry line (0 for starting point, 1 for ending point).\\
   The remaining 26 columns comprise energy bands in the window (-10,8) eV.
+ `-ef=0` tells **plbnds**{: style="color: blue"} to shift the bands by a constant so the Fermi energy falls at 0.\\
   _Note:_{: style="color: red"} in an infinite periodic system the energy zero is ill defined; it can be chosen arbitrarily.
+ `-scl=13.6` scales the energy bands by this factor, converting the raw bands (in Ry) to eV.
+ `-nocol` tells **plbnds**{: style="color: blue"} to ignore information about color weights.

The energy window is now `-10,8` eV. The last two arguments from **stdin** (formerly `10,15`) are not used in this mode since **plbnds**{: style="color: blue"} makes no figure.

Make and view a postscript file with

    $ fplot -f plot.plbnds
    $ open fplot.ps 

This figure is much closer to publication quality.  You can of course customize the figure by editing _plot.plbnds_{: style="color: green"}.
To interpret and customize the script, see the [fplot manual](/docs/misc/fplot).

##### Example 3

This example illustrates a very useful feature of the Questaal band plotting capabilities.
It uses two color weights to distinguish spin-up and spin-down bands.
The first color selects out the majority bands of _d_ character, the second the minority _d_ bands.

Consider orbital component _i_ of band _n_.  Its wave function has eigenvector element <i>z<sub>in</sub></i>.  The wave function is normalized, and so

$$  \sum_i z^{-1}_{ni} z_{in} = 1 $$
  
The sum runs over all of the orbitals in the basis. By "decomposing the norm" of _z_, that is summing over a subset of orbitals _i_, the result is less than unity and is a measure of the contribution of that subset to the unit norm.  _Note:_{: style="color: red"} this decomposition is essentially like a Mulliken analysis.

_bnds.co_{: style="color: green"} was generated with two color weights: all _d_ orbitals in the Co majority spin channel were combined for
the first weight, and the corresponding _d_ orbitals in the Co minority channel the second.
Thus the first color weight is zero if there is no projection of the eigenfunction onto majority _d_ channel, and 1 if the entire
eigenfunction is of majority _d_ character.  The same applies for the second weight, but for the minority _d_ channel.

_Note:_{: style="color: red"} _bnds.co_{: style="color: green"} was generated from one of the validation scripts in the Questaal source directory.

<div onclick="elm = document.getElementById('cotest'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to see how to run and interpret the script.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="cotest">{:/} 

Assuming your source directory is **~/lm**, you can do the test yourself running this script:

    $ ~/lm/fp/test/test.fp co 1

The script runs **lmf**{: style="color: blue"} as:

~~~
lmf  co -vmet=4 -vlmf=1 -vnk=8 -vnit=10 --pr31,20 --no-iactiv -vso=t --band~col=5:9,dup=9~col2=18+5:18+9,dup=9~fn=syml
~~~
`-vmet=4 -vlmf=1 -vnk=8 -vnit=10` [assign algebraic variables](/docs/input/preprocessor/#variables) which will modify _ctrl.co_{: style="color: green"} when
run through the [preprocessor](/docs/input/preprocessor).  They are of secondary interest here. `-vso=t` does the same, but is important in this context because the input file contains

~~~
HAM   ...  SO={so} 
~~~

`-vso=t` sets variable **so** to **true** (or **1**). The proprocessor [transforms](/docs/input/preprocessor/#curly-brackets-contain-expressions) `SO={so}` into `SO=1`.
Token **SO** controls spin orbit coupling (the input file's construction is described [here](/docs/input/inputfile)).

`--band~col=5:9,dup=9~col2=18+5:18+9,dup=9~fn=syml` tells **lmf**{: style="color: blue"} to draw energy bands with two color weights (`col=..` and `col2=..`)
Orbitals **5-9** comprise the majority spin _d_ orbitals of the first Hankel energy;, **14-8** those of the second.  
_Note:_{: style="color: red"} `dup=9` replicates the existing list, adding 9 to each element in the list.)  

States **23-27** are the corresponding _d_ orbital in the minority channel.  The five _d_ states are
expressed conveniently as **18+5:18+9**.  These are the minority spin counterparts since the entire hamiltonian basis consists of 18 orbitals.
When the hamiltonian is treated relativistically the Hamiltonian is doubled into a 2&times;2 supermatrix; with spin 1 orbitals occuring first.

{::nomarkdown}</div>{:/}

Run **plbnds**{: style="color: blue"} as before, except eliminating `-nocol` and adding a line type:

    $ echo -10,8 / | plbnds -fplot -ef=0 -scl=13.6 -lt=1,bold=3,col=0,0,0,colw=.7,0,0,colw2=0,.7,0 -lbl=M,G,A,L,G,K bnds.co
    $ fplot -f plot.plbnds
    $ open fplot.ps 

The line type specifes a solid line (`-lt=1`), the line thickness (`bold=3`); the default line color (`col=0,0,0`) which is the color when
the first and second weights vanish; colors of the first weight (`colw=.7,0,0`) and second weight `colw2=0,.7,0`), respectively.
The three numbers correspond to fractions of (red, green, blue).  Thus, if a band has no _d_ character it will be black;
it will be red with 100% majority _d_ character and green with 100% minority _d_ character.

Colors provide an extremely helpful guide to interpret the bands.  It shows clearly which bands have majority and minority _d_ character.

<div onclick="elm = document.getElementById('cocolorbands'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to view and interpret the figure</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="cocolorbands">{:/} 

Your postscript file should like like the figure below.

![Energy bands for Co](/assets/img/bnds-co.svg)

Note the following points:

+ the highly dispersive band between &Gamma; and A in the window (-2,0) eV, is black, indicating its _sp_ character.
  You can see traces of it near &Gamma; at around -0.5 eV, it increases as _k_ moves away from &Gamma;.
+ The majority and minority _d_ bands are quite distinct.  This means that <i>s_<sub>z</sub></i> is almost a good quantum number.
  In the absence of spin-orbit coupling it is a good quantum number.
+ The majority and minority _d_ bands are approximatey the same shape, but split by approximately 1.6 eV.  This is as expected, since in simple models the splitting a simple constant value of <i>I</i>&times;<i>M</i>, where <i>I</i> and <i>M</i> are respectively the Stoner parameter and the magnetic moment.  In 3_d_ transition metals, <i>I</i> is close to 1 eV, and for Co, <i>M</i>=1.6 <i>&mu;</i><sub>B</sub>.

{::nomarkdown}</div>{:/}

### 3. _plbnds manual_

<pre>
plbnds [-switches] <i>filename</i>
</pre>

_filename_{: style="color: green"} is the file name (_bnds.co_{: style="color: green"} in this case).  You can also use just the extension
(_co_{: style="color: green"}).

**plbnds**{: style="color: blue"} reads four numbers from **stdin**:\\
 `emin, emax, width(cm), height(cm)`

`emin` and `emax` comprise the lower and upper bounds of figure.  Data is written
only for bands that fall in this range.  The third and fourth arguments, which indicate the size of the figure,
are used only when **plbnds**{: style="color: blue"} makes a postscript file ([Example 1](/docs/misc/plbnds/#example-1)).

Optional switches perform the following functions:

+ -help | --help | --h \\
  prints out a help message and exits
+ -ef=<i>expr</i>\\
  shifts the energy bands so that the Fermi energy lies at <i>expr</i>
+ -scl=<i>expr</i>\\
  scales bands by <i>expr</i>
+ -wscl=<i>w</i>[,<i>h</i>]\\
  scales the default figure size by _w_.  _w_ is a number or expression.\\
  If the second argument is present the width is scaled by _w_, the height by _h_.
+ -lbl=_a_,_b_,_c_,_d_,...\\
  Supply _k_ point (symmetry) labels at the points where panels meet.  For now, labels must be one character each.
  You should supply _n_+1 labels, where _n_ is the number of panels.\\
  _Note:_{: style="color: red"} Note: G is turned into the Greek &Gamma;.
+ -tl=<i>title</i>\\
   Adds a title to appear at the top of the figure.
+ -merge=file2[,file3] or  -mergep=file2[,file3]\\
   merges two bands file, one for each spin (spin-pol case)\\
   Optional **file3** causes plbnds to write merged file to _file3_{: style="color: green"}.\\
   `-mergep` pads a file containing fewer bands so that the number of bands in the merged file is fixed.
+ -spin1 or -spin2\\
  plots only bands of first or second spin (spin polarized calculations only)
+ -skip=_lst_\\
   skip panels in list, e.g. `-skip=1,3` . [This page](/docs/misc/integerlists) documents integer list syntax.
+ -col3:<i>bnds2</i>,<i>fnout</i>\\
   combines the color weights in _bnds.ext_{: style="color: green"} and _bnds2_{: style="color: green"}.\\
   _bnds.ext_{: style="color: green"} should contain two color weights; _bnds2_{: style="color: green"} one color weight.\\
   The two files should contain identical bands generated for the same _k_ points.

+ -fplot[:s] causes **plbnds**{: style="color: blue"} to create input for another 
  graphics package.  The optional **:s** tells plbnds that your bands file has two spins, and to
  draw bands for both spins (to draw spin1 or spin2 only use `-spin1` or `-spin2`).\\
  `-fplot` does the following:
  1. Writes energy bands to files _bnd1.dat_{: style="color: green"}, _bnd2.dat_{: style="color: green"}, ...
     (one file for every panel).
  2. generates a script _plot.plbnds_{: style="color: green"}.

  You can make and view a postscript figure of the bands with
      $ fplot -f plot.plbnds
      $ open fplot.ps
  To interpret or customize _plot.plbnds_{: style="color: green"}, see the [fplot manual](/docs/misc/fplot).

The following switches may be used in conjunction with `-fplot`.

+ -dat=<i>ext</i>\\
   Substitute _.ext_ for .dat when writing data files.\\
   Very useful when merging data from two bands into one figure.
+ -nocol or --nocol\\
  Ignore information about color weights
  
_____________________________________________________________

### 4. _Other resources_

See the documentation for [fplot](/docs/misc/fplot/) and [pldos](/docs/misc/pldos/).

