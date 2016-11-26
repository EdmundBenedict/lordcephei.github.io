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

Edit the ctrl file to add extra BZ and OPTICS tags.

    nano ctrl.fe

Total DOS and integrated DOS

~~~
lmf -vnkabc=16 fe --quit=band --dos:rdm
cp dos.fe tdos.fe
fplot -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe
lmf -vnkabc=16 fe --quit=band --dos:rdm:idos
fplot -frme:xor=-0.0006:yab=8 0,1,0,1 -lt 1,col=1,0,0 -ord x2+x3 dos.fe
~~~

Identify the <i>t</i><sub>2g</sub></i> and <i>e</i><sub>g</sub></i> orbitals

    lmf fe --pr60 --quit=ham

Make the 

~~~
lmf fe -vlteto=3 -voptmod=-5 -vnk=16 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
fplot tdos.fe -lt 2,col=1,0,0  jdos.fe
fplot -lt 1,col=0,0,0  jdos.fe -lt 1,col=.7,.7,.7 -ord x3+x4 jdos.fe -lt 2,col=1,0,0 -ord x3 jdos.fe -lt 2,col=0,1,0 -ord x4 jdos.fe
~~~

{::nomarkdown}</div>{:/}

### _Introduction_

This tutorial carries out a QS<i>GW</i> calculation for Fe, a ferromagnet with a fairly large moment of 2.2<i>&mu;<sub>B</sub></i>.

Quasiparticle Self-Consistent _GW_ (QS<i>GW</i>) is a special form of self-consistency within _GW_.  Its advantages are briefly described in
the [overview](/docs/code/gwoverview/), and also in the summary of the [basic QSGW tutorial](/tutorial/gw/qsgw_si/#qsgw-summary).
Self-consistency is rather necessary in magnetic systems, because the magnetic moment is not reliably described by 1-shot GW, and is
somewhat ill-defined.  For the most part magnetic moments predicted by QSGW are significantly better than the LDA.  Moments in itinerant
magnets,  however, tend to be overestimated because diagrams with spin fluctuations (absent in _GW_) tend to reduce the magnetic
moment. This is true for both QS_GW_ and _LDA_.

This tutorial proceeds in a manner similar to the [basic QSGW tutorial](/tutorial/gw/qsgw_si).

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
OPTICS  MODE={optmod} NPTS=1001 WINDOW=-.7 .8 ESCISS=0 LTET={lteto}
% else
OPTICS  MODE={optmod} NPTS=301 WINDOW=0 1 ESCISS=0 LTET={lteto} ALLTRANS=T # ESMR=.1
%endif
        PART={lpart}
~~~

### 3. _Total Number and Density of States_

Total DOS are generated automatically when **BZ\_SAVDOS=T**.  With **BZ** added
to the ctrl file, you can generate it immediately.

The following generates the DOS, and uses the the 
[**fplot**{: style="color: blue"}](/docs/misc/fplot/) utility to make a picture
(red for majority spin, green for minority spin):

    lmf -vnkabc=16 fe --quit=band --dos:rdm
    cp dos.fe tdos.fe

and the following generates the number-of states (NOS), or
integrated DOS, with a picture of the combined spin&uarr;+spin&darr; NOS:

    lmf -vnkabc=16 fe --quit=band --dos:rdm:idos

_Notes:_{: style="color: red"}

+ the Fermi level should come out to **-0.000599**&thinsp;Ry.
+ At the Fermi level the total number of electrons should be 8.
+ The majority and minority DOS are roughly similar, but spin split by slightly
  less than 0.2&thinsp;Ry, or about 2.2&thinsp;eV, as noted in the 
  [QSGW tutorial](/tutorial/gw/gw_self_energy/#compare-interacting-and-independent-particle-density-of-states-in-fe).

<div onclick="elm = document.getElementById('bnds'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here to make or view figures of the DOS and NOS.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="bnds">{:/}

For the DOS:

    fplot -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe
    open fplot.ps

for the NOS:

    fplot -frme:xor=-0.000599:yab=8 0,1,0,1 -lt 1,col=1,0,0 -ord x2+x3 dos.fe
    open fplot.ps

The figures should look like like those shown below.  In the left figure the vertical
axis is aligned with the Fermi level, and the horizontal axis lies at 8 electrons.
You can confirm that the integrated DOS crosses 8 at <i>E<sub>F</sub></i>.

![Fe total NOS and DOS](/assets/img/Fe-DOS.svg)
{::nomarkdown}</div>{:/}

### 4. _Resolve DOS into <i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> symmetry_

In Fe the <i>d</i> orbitals are of primary interest.  Spherical
harmonics for _l_=2 split under cubic symmetry into
<i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> symmetry.  In
this section we resolve the spin-1 DOS into those symmetries.

[Optics **MODE=-5**](tutorial/application/optics/#further-optics-modes)
generates the spin 1 DOS.  Step 3 already supplied this information,
but the optics **MODE=-5** branch works in concert with the
**-\-jdos** switch which enables you to project the DOS into orbitals
of your choice, using a Mulliken analysis.  **-\-jdos** offers you a
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
lmf fe -vlteto=3 -voptmod=-5 -vnk=16 --quit=band --jdosw=5,6,8,21,22,24,26,27,29 --jdosw2=7,9,23,25,28,30
~~~

_Notes_{: style="color: red"}: 

+ You can Mulliken-project one (**-\-jdosw**) or two (**-\-jdosw** and **-\-jdosw2**) combinations of orbitals.
+ This special Mulliken projected DOS **MODE=-5** requires the enhanced tetrahedron integrator (**LTET=3**).
+ You can of course use more or fewer _k_ points.
+ A file _jdos.fe_{: style="color: green"} should be written to disk.
  _jdos.fe_{: style="color: green"} will contain 2 columns, 3 if (**-\-jdosw**) is used, 
  and 4 if (**-\-jdosw2**) is also used.  Columns 1 and 2 are the total DOS; columns 3 and 4 are the 
  Mulliken projected DOS from orbitals in (**-\-jdosw**) and (**-\-jdosw2**).
+ **--quit=band** avoids overwriting the density restart file.
+ **lmf**{: style="color: blue"} prints out messages like this:

  ~~~
   optics: restrict transitions to : occ=(1,4) unocc=(2,6)
  ~~~

  This message is not relevant for the DOS.



### _Additional exercises_
[//]: (/tutorial/gw/qsgw_fe/#additional-exercises)



{::comment}

First figure
fplot -frme:xor=-0.000599:yab=8 -.3,-.3+.6,1.1,1.6 -lt 1,col=1,0,0 -ord x2+x3 dos.fe -frme .5,1,1.1,1.6 -frmt th=3,1,1 -lt 1,col=1,0,0 -colsy 2 tdos.fe -lt 1,col=0,1,0 -colsy 3 tdos.fe

{:/comment}
