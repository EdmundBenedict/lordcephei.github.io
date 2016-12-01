---
layout: page-fullwidth
title: "QSGW Tutorial: Optics and resolved DOS in Fe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/fe_optics/"
sidebar: "left"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________

This tutorial shows how to use apply the optics package extract information about
electronic properties of Fe. It builds on the [QSGW Tutorial for Fe](/tutorial/gw/qsgw_fe/).

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}
_____________________________________________________________


### _Preliminaries_
_____________________________________________________________


You should first carry out the LDA self-consistency steps in the [QSGW Tutorial for Fe](/tutorial/gw/qsgw_fe/).
This tutorial is written assuming you stopped at the LDA level (step 1).  However the tutorial equally applies
if you want the same results at the QS<i>GW</i> level (step 2).

To view the postscript file, this document assumes you are using the apple-style **open**{: style="color: blue"} command.

### _Command summary_
[//]: (/tutorial/gw/qsgw_fe/#command-summary)
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

LDA self-consistency (starting from  _init.fe_{: style="color: green"})

~~~
nano init.fe
blm --nit=20 --nk=16 --gmax=7.9 --mag --nkgw=8 --gw fe
cp actrl.fe ctrl.fe
lmfa fe
cat basp0.fe | sed -e 's/\(Fe.*\)/\1 PZ=0 0 4.5'/ > basp.fe
lmf fe > out.lmf
~~~

Edit the ctrl file to add **BZ** and **OPTICS** tags.

    nano ctrl.fe

Total DOS and integrated DOS

~~~
lmf -vnkabc=16 fe --quit=band --dos:rdm
cp dos.fe tdos.fe
lmf -vnkabc=16 fe --quit=band --dos:rdm:idos
~~~

Plot the total DOS and integrated DOS

~~~
fplot -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe
open fplot.ps
fplot -frme:xor=-0.000599:yab=8 0,1,0,1 -lt 1,col=1,0,0 -ord x2+x3 dos.fe
open fplot.ps
~~~

Identify the <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> orbitals

    lmf fe --pr60 --quit=ham

Make the Mulliken <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> majority spin DOS

~~~
lmf fe -vlteto=3 -voptmod=-5 -vnk=16 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
~~~

Compare resolved to total DOS

~~~
fplot -lt 1,col=0,0,0  jdos.fe -lt 1,col=.6,.6,.6 -ord x3+x4 jdos.fe -lt 2,col=1,0,0 -ord x3 jdos.fe -lt 2,col=0,1,0 -ord x4 jdos.fe
~~~

Further resolve the DOS by _k_:

~~~
lmf fe -vlteto=3 -voptmod=-5 -vnk=16 -vlpart=12 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
~~~

{::nomarkdown}</div>{:/}

### _Introduction_

This tutorial is intended to show various ways in which DOS can be decomposed.

### 1. _Self-consistent_ LDA _calculation for Fe_

Do step 1 of the [QSGW Tutorial for Fe](/tutorial/gw/qsgw_fe/#self-consistent-lda-calculation-for-fe).
To follow this tutorial at the QS<i>GW</i> level, also complete step 2.

### 2. _Setup for Optics_

This optics tutorial requires some additional tags to the input file. 
Append the following lines to _ctrl.fe_{: style="color: green"}.

~~~
BZ      NPTS=1001 DOS=-.7 .8 SAVDOS=T
% const optmod=0 lteto=3 lpart=0
% ifdef (optmod==-5|optmod==-6)
OPTICS  MODE={optmod} NPTS=1001 WINDOW=-.7 .8 LTET={lteto}
% else
OPTICS  MODE={optmod} NPTS=301 WINDOW=0 1 LTET={lteto}
%endif
        PART={lpart}
~~~

The reasons for these extra tags will become clear in the tutorial.

### 3. _Total Number and Density of States_

Total DOS are generated automatically when **BZ\_SAVDOS=T**.  With **BZ** added
to the ctrl file, you can generate it immediately.

The following generates the total DOS, saving it into file _tdos.fe_{: style="color: green"}:

    $ lmf -vnkabc=16 fe --quit=band --dos:rdm
    $ cp dos.fe tdos.fe

and the following generates the number-of states (NOS), or integrated DOS:

    $ lmf -vnkabc=16 fe --quit=band --dos:rdm:idos

_Notes:_{: style="color: red"}

+ the Fermi level should come out to **-0.000599**&thinsp;Ry.
+ At the Fermi level the total number of electrons should be 8.
+ the **:rdm** tag is not necessary (DOS will be written wether the entire **\-\-dos** switch is present), 
  but it causes **lmf**{: style="color: blue"} to write the file in 
  an easy to read [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) for 2D arrays.
+ The majority and minority DOS are roughly similar, but spin split by slightly
  less than 0.2&thinsp;Ry, or about 2.2&thinsp;eV, as noted in the 
  [QSGW tutorial](/tutorial/gw/gw_self_energy/#compare-interacting-and-independent-particle-density-of-states-in-fe).

<div onclick="elm = document.getElementById('dos'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here to make or view figures of the DOS and NOS.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="dos">{:/}

The following uses the [**fplot**{: style="color: blue"}](/docs/misc/fplot/) utility to make postscript files.

For the DOS:

    $ fplot -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe
    $ open fplot.ps

For the combined spin&uarr; + spin&darr; NOS:

    $ fplot -frme:xor=-0.000599:yab=8 0,1,0,1 -lt 1,col=1,0,0 -ord x2+x3 dos.fe
    $ open fplot.ps

The figures should look like like those shown below.  In the left figure the vertical
axis is aligned with the Fermi level, and the horizontal axis lies at 8 electrons.
You can confirm that the integrated DOS crosses 8 at <i>E<sub>F</sub></i>.

In the right figure DOS are resolved by spin (red for majority spin, green for minority spin).

![Fe total NOS and DOS](/assets/img/Fe-DOS.svg)
{::nomarkdown}</div>{:/}

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)

### 4. _Resolve DOS into <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> symmetry_
[//]: (/tutorial/gw/fe_optics/#resolve-dos-into-itisub2gsub-and-ieisubgsub-symmetry)

In Fe the <i>d</i> orbitals are of primary interest.  Spherical
harmonics for _l_=2 split under cubic symmetry into
<i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> symmetry.  In
this section we resolve the spin-1 DOS into those symmetries.

Optics [**MODE=-5**](tutorial/application/optics/#further-optics-modes)
generates the spin 1 DOS.  Step 3 already supplied this information,
but the optics **MODE=-5** works in concert with the
**-\-jdos** switch which enables you to project the DOS into orbitals
of your choosing, using a Mulliken analysis.  **-\-jdos** offers a
lot of flexibility, but a bit of extra work is needed to identify
which orbitals in the LMTO basis set are associated with
<i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> symmetry.

Run **lmf**{: style="color: blue"} with a high verbosity, stopping early:

    lmf fe --pr60 --quit=ham

You should see this table:

~~~
 Orbital positions in hamiltonian, resolved by l:
 Site  Spec  Total    By l ...
   1   Fe    1:30   1:1(s)   2:4(p)   5:9(d)   10:16(f) 17:17(s) 18:20(p) 21:25(d) 26:30(d)
~~~

It tells you that channels 5:9 (first kappa), 21:25 (second kappa) and 26:30 (local orbitals)
are associated with the Fe _d_ orbitals.  In each group of 5 orbitals, three three of them
are of <i>t</i><sub>2g</sub> character and two of <i>e</i><sub>g</sub> character.
The <i>t</i><sub>2g</sub> are the _xy_, _xz_, and _yz_, orbitals; the <i>e</i><sub>g</sub> 
have 3_z_<sup>2</sup>&minus;1 and <i>x</i><sup>2</sup>&minus;<i>y</i><sup>2</sup> character.
At the &Gamma; point in the Brillouin zone, the Fe _d_ states are three-fold and two-fold degenerate, 
according to their character.

To know which of the 5 orbitals belong to each class, consult the
[spherical harmonics](/docs/numerics/spherical_harmonics/) page.  The
table indicates that the first, second, and fourth _l_=2 orbitals are
<i>t</i><sub>2g</sub>, and orbitals 3 and 5 are the
<i>e</i><sub>g</sub>.  Since the _d_ orbitals appear three times in the basis,
there are 9 and 6 <i>t</i><sub>2g</sub> and
<i>e</i><sub>g</sub> orbitals, respectively.

Comparing to the table above, channels 5,6,8, 21,22,24, and 26,27,29 can be identified as
<i>t</i><sub>2g</sub> orbitals, and channels 7,9, 23,25, and 28,30 the 
<i>e</i><sub>g</sub>.

Run **lmf**{: style="color: blue"} as follows:

~~~
$ lmf fe -vlteto=3 -voptmod=-5 -vnk=16 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
~~~

_Notes_{: style="color: red"}: 

+ You can project onto one (**-\-jdosw**) or two (**-\-jdosw** and **-\-jdosw2**) combinations of orbitals, 
  using Mulliken projection.
+ This special Mulliken projected DOS **MODE=-5** requires the enhanced tetrahedron integrator (**LTET=3**).
+ You can of course use more or fewer _k_ points.
+ A file _jdos.fe_{: style="color: green"} should be written to disk with total and the two Mulliken-projected DOS in the format 
  described [here](/docs/input/data_format/#file-jdos).
+ **--quit=band** avoids overwriting the density restart file.
+ **lmf**{: style="color: blue"} prints out messages like this:

  ~~~
   optics: restrict transitions to : occ=(1,4) unocc=(2,6)
  ~~~

  This message is not relevant for the DOS.

<div onclick="elm = document.getElementById('pdos'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here to make or view figures that show how the DOS is partitioned into components.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="pdos">{:/}

As a sanity check, the total DOS in _jdos.fe_{: style="color: green"} should match _tdos.fe_{: style="color: green"}

    $ fplot tdos.fe -lt 2,col=1,0,0  jdos.fe

The black and red dashed lines should lie on top of one another.

Make a Figure drawing:

1. the total spin&uar; DOS; 
2. the sum of <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> DOS in light grey;
3. the <i>t</i><sub>2g</sub> DOS in red;
4. the <i>e</i><sub>g</sub> DOS in green

    $ fplot -lt 1,col=0,0,0  jdos.fe -lt 1,col=.7,.7,.7 -ord x3+x4 jdos.fe -lt 2,col=1,0,0 -ord x3 jdos.fe -lt 2,col=0,1,0 -ord x4 jdos.fe

the figure should look similar to this:

![Fe total NOS and DOS](/assets/img/Fe-pDOS.svg)
{::nomarkdown}</div>{:/}

In the interval (&minus;0.35,0)&thinsp;Ry, the grey almost superimposes on the black.  This shows that almost all the
DOS in that interval is of Fe _d_ character.  Below &minus;0.4 and above 0, a difference in the two appears: the _d_ bandwidth has been exhausted and
what remains is mostly of Fe _s_ character.  You can also see that the 
<i>t</i><sub>2g</sub> is a somewhat wider than the <i>e</i><sub>g</sub>.

### 5. _Resolve DOS by_ k
[//]: (/tutorial/gw/fe_optics/#resolve-dos-by-k)

In the previous section the DOS were resolved into <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> character.
Here it is further resolved by k.  To accomplish this use the **OPTICS_PART** tag.
To see its function, look at the [web documentation](/docs/input/inputfile/#optics)
or just do

    lmf --input | grep -A 10 OPTICS_PART

Use **OPTICS_PART=2** to resolve by _k_; we will use
**OPTICS_PART=12** to write the output to a binary file _poptb.fe_{:
style="color: green"}, since resolving DOS into 145 distinct _k_
channels and three kinds of DOS creates a large file.  Column 1 is the energy.
The DOS channels are ordered as

|    -    |   -      | :---:                 | :---:
|         |  total   | <i>t</i><sub>2g</sub> | <i>e</i><sub>g</sub>
 columns  |  2:146   | 147:291               | 292:436

Repeat the previous calculation adding a variable **-vlpart=12**:

~~~
$ lmf fe -vlteto=3 -voptmod=-5 -vlpart=12 -vnk=16 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
~~~

This should create a binary file _poptb.fe_{: style="color: green"}.
To confirm that the _k_ resolved DOS sum to the total DOS, do:

~~~
mc -br poptb.fe -split a 1,nr+1 1,2,'(nc-1)/3'+2,'(nc-1)/3*2'+2,'(nc-1)/3*3'+2 a11 a12 -csum -ccat jdos.fe -coll 1,2 -- -px:5
mc -br poptb.fe -split a 1,nr+1 1,2,'(nc-1)/3'+2,'(nc-1)/3*2'+2,'(nc-1)/3*3'+2 a11 a13 -csum -ccat jdos.fe -coll 1,3 -- -px:5
mc -br poptb.fe -split a 1,nr+1 1,2,'(nc-1)/3'+2,'(nc-1)/3*2'+2,'(nc-1)/3*3'+2 a11 a14 -csum -ccat jdos.fe -coll 1,4 -- -px:5
~~~

#### 5.1 _DOS Heat Maps_
[//]: (/tutorial/gw/fe_optics/#dos-heat-maps)

The _k_ resolved DOS can be used to make a "heat map" of the Fermi surface, that is a tabulation of the 
DOS for all _k_ points in the Brillouin Zone for a specific energy.

This is accomplished with optics editor, which you invoke with **-\---popted** :

    $ lmf fe --rs=1,0 -vlteto=3 -voptmod=-5 -vlpart=12 -vnk=16 --popted

You will be prompted for an instruction:

     Option : 

Typing &nbsp;<b>? \<enter\></b>&nbsp; will give you a menu of options.

As with many of the Questaal editors you can string a sequence of instructions on
the command line: the editor will treat them as though you entered them
interactively.  Separate instructions are delimited by the character immediately following
**-\-popted**.  In the present case, try

    $ lmf fe --rs=1,0 -vlteto=3 -voptmod=-5 -vlpart=12 -vnk=16 '--popted:readb:npol 3:kshowe -0.01 1 sort ds,q3:kmape 0.05 1:saveka:q'

**:**&thinsp; was used as the delimiter.  These instructions do the following:

+ **:readb**&emsp; reads binary file _poptb.ext_{: style="color: green"}
+ **:npol 3**&emsp; tells the editor that the file has three "polarizations."
    In this case "polarizations" refer to total DOS, and first and second Mulliken DOS.
+ **:kshowe -0.01 1 sort ds,q3**&emsp; causes the editor to :
    + print out the DOS at <i>&omega;</i>=&minus;0.01&thinsp;Ry
    + print out the DOS for the first "polarization" (total DOS in this case).
    + sort the list by increasing length, and for two vectors of the same length
      by the third component of **k**.  Results are printed to standard output.
+ **:kmape 0.05 1**&emsp; causes the editor to :
    + Map DOS(_&omega;_=0.05&thinsp;Ry) to each point in the full BZ
    + Maps the first "polarization" (total DOS in this case)
    + Results are kept in an internal array
+ **:saveka**&emsp; saves the internal array generated by **kmape** to an ASCII file, _pka.ext_{: style="color: green"}.
+ **:q**&emsp; quits the editor.

### _Additional exercises_
[//]: (/tutorial/gw/qsgw_fe/#additional-exercises)

{::comment}

First figure
fplot -frme:xor=-0.000599:yab=8 -.3,-.3+.6,1.1,1.6 -lt 1,col=1,0,0 -ord x2+x3 dos.fe -frme .5,1,1.1,1.6 -frmt th=3,1,1 -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe

{:/comment}
