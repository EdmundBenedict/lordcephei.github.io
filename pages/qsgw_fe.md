---
layout: page-fullwidth
title: "QSGW Tutorial for magnetic bcc Fe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/qsgw_fe/"
sidebar: "left"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________

This tutorial begins with with a self-consistent LDA calculation for Fe, a bcc magnetic metal, and follows it with a QSGW calculation.

It proceeds in a manner similar to the [basic QSGW tutorial](/tutorial/gw/qsgw_si);
it also forms a starting point for other tutorials, for example
the calculation of the [dynamical self-energy](/tutorial/gw/gw_self_energy/).

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}
_____________________________________________________________


### _Preliminaries_
_____________________________________________________________


Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path;
similarly for the QSGW script **lmgwsc**{: style="color: blue"}; and the binaries it requires should be in subdirectory **code2**.

When a text editor is required, the tutorial uses the [**nano**{: style="color: blue"} text editor](https://en.wikipedia.org/wiki/GNU_nano).

The band-plotting part uses the [**plbnds**{: style="color: blue"}](/docs/misc/plbnds) tool
and to make the figure, the [**fplot**{: style="color: blue"}](/docs/misc/fplot/) graphics tool.

To view the postscript file, this document assumes you are using the apple-style **open**{: style="color: blue"} command.

### _Command summary_
{::comment}
/tutorial/gw/qsgw_fe/#command-summary
{:/comment}
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

LDA self-consistency (starting from  _init.fe_{: style="color: green"})

~~~
nano init.fe
blm --nit=20 --nk=16 --gmax=7.9 --mag --nkgw=8 --gw fe
cp actrl.fe ctrl.fe
lmfa fe
cp basp0.fe basp.fe
nano basp.fe
lmf fe > out.lmf
~~~

Make the energy bands and save in _bnds.lda_{: style="color: green"}:

~~~
nano syml.fe
lmf fe --quit=band
lmf fe --band:fn=syml
cp bnds.fe bnds.lda
~~~

QSGW self-consistency

~~~
lmfgwd --jobgw=-1 ctrl.fe
nano GWinput
lmgwsc --mpi=6,6 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
grep more out.lmgwsc 
~~~

Make the energy bands and save in _bnds.gw_{: style="color: green"}:

~~~
lmf fe --quit=band
lmf fe --band:fn=syml
cp bnds.fe bnds.gw
~~~

Draw the energy bands using [**plbnds**{: style="color: blue"}](/docs/misc/plbnds) and
[**fplot**{: style="color: blue"}](/docs/misc/fplot/).

~~~
echo -2,2 /  | plbnds -wscl=1,.8 -fplot -ef=0 -scl=13.6 --nocol -dat=gw -spin2 bnds.gw
echo -2,2 /  | plbnds -wscl=1,.8 -fplot -ef=0 -scl=13.6 --nocol -lbl=H,N,G,P,H,G -spin2 -dat=lda bnds.lda

rm -f plot.2bands
echo "% char0 colr=3,bold=5,clip=1,col=1,.2,.3" >>plot.2bands
echo "% char0 colb=2,bold=4,clip=1,col=.2,.3,1" >>plot.2bands
awk '{if ($1 == "-colsy") {sub("-qr","-lt {colg} -qr");sub("lda","green");sub("green","gw");sub("colg","colr");print;sub("gw","lda");sub("colr","colb");print} else {print}}' plot.plbnds >> plot.2bands
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

### _Self-consistent_ LDA _calculation for Fe_

QS<i>GW</i> requires a starting point.  The LDA is a reasonably accurate, and convenient starting point, indeed it is good enough in its own
right for many magnetic systems.

Following [other LDA tutorials](/tutorial/lmf/lmf_pbte_tutorial/), the input file is built with the **blm**{: style="color: blue"} tool, which
requires file _init.fe_{: style="color: green"}.

#### Input file setup

Fe is a bcc metal with a lattice constant 5.408&thinsp;<i>a</i><sub>0</sub>
and a magnetic moment of 2.2&thinsp;<i>&mu;<sub>B</sub></i>.
The LDA needs some breaking of the symmetry to stabilize a nonzero magnetic moment, so we supply
a trial moment of 2<i>&mu;<sub>B</sub></i>.

Cut and paste the contents in the box below into _init.fe_{: style="color: green"}.

~~~
# Init file for Fe
LATTICE
  SPCGRP=Im-3m  A=5.408
# ALAT=5.408 PLAT= -0.5 0.5 0.5   0.5 -0.5 0.5   0.5 0.5 -0.5

SPEC
   ATOM=Fe MMOM=0,0,2     # Trial spin moment on the d channel
SITE
   ATOM=Fe X=0 0 0
~~~

Supply either the space group ([Im-3m](http://www.periodictable.com/Properties/A/SpaceGroupName.html))
or the bcc lattice vectors.

The input file setup and self-consistent cycle are very similar to [the PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/); review it first if
you are not familiar with the structure of [input file](/docs/input/inputfile/), _ctrl.fe_{: style="color: green"}, or how to set up an LDA
calculation from structural information.

Run **blm**{: style="color: blue"} this way:

~~~
$ blm --nit=20 --mag --gw --nk=16 --nkgw=8 --gmax=7.9 fe
$ cp actrl.fe ctrl.fe
~~~

The switches do the following:

+ **\-\-nit=20**   &emsp;&thinsp; : sets the [maximum number of iterations](/docs/input/inputfile/#iter) in **lmf**{: style="color: blue"} self-consistency cycle.\\
                   Not required, the default (10 iterations) is about how many are needed are needed to make it self-consistent
+ **\-\-mag**      &emsp;&emsp;&nbsp; : tells **blm**{: style="color: blue"} that you want to do a spin-polarized calculation.
+ **\-\-gw**       &emsp;&emsp;&ensp;&nbsp; : tells **blm**{: style="color: blue"} to prepare for a _GW_ calculation.  The effect is to make the basis set a bit larger
                   than usual and sets the basis Hankel energies deeper than is needed for LDA.  This is to make the basis short enough ranged so
                   that the [quasiparticlized self-energy](/tutorial/gw/qsgw_si/#qsgw-summary) &Sigma;<sup>0</sup> can be smoothly interpolated between _k_ points.
+ **\-\-nk=16**    &emsp;&nbsp;&thinsp; : sets the _k_ mesh.  You [must supply the mesh](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).\\
                   We use a rather fine mesh here, because Fe is a transition metal with a high density-of-states near the Fermi level.
+ **\-\-nkgw=8**   &ensp;&nbsp;&thinsp; : the _k_ mesh for _GW_.  If you do not supply this mesh, it will use the **lmf**{: style="color: blue"} mesh.
                   The self-energy varies much more smoothly with _k_ than does the kinetic energy; 16 divisions is expensive and overkill.
+ **\-\-gmax=7.9** : Plane-wave cutoff. You [must supply this number](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).
                   It is difficult to determine in advance; however you can leave it out at first and run **lmfa**{: style="color: blue"}.
                   You sometimes need to run **lmfa**{: style="color: blue"} twice anyway, since it may find some local orbitals and
                   change the valence-core partitioning.  (See the [LDA tutorial for PbTe](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency)).

_Note:_{: style="color: red"} **blm**{: style="color: blue"} writes the input file template to _actrl.fe_{: style="color: green"},
to avoid overwriting a the _ctrl.fe_{: style="color: green"}, which you may want to preserve.

#### Free atom density

Generate the free atom density and copy the basis set information it generates to
_basp.fe_{: style="color: green"}.  See the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#initial-setup)
for further explanation.

~~~
$ lmfa fe
$ cp basp0.fe basp.fe
~~~

In this case no local orbitals were generated (inspect _basp.fe_{: style="color: green"} for any **PZ** present).
**lmfa**{: style="color: blue"} does not need to be run a second time.

#### The Fe 4_d_ state

We could proceed directly to making a self-consistent LDA density with the setup as given.  But when later proceeding to the _GW_ part, it
turns out the the high-lying Fe 4_d_ state affects the _GW_ potential slightly, enough to affect states near the Fermi level by 0.05-0.1 eV.
(In contrast to the LDA, both occupied and unoccupied states contribute to the _GW_ self-energy.)
Anticipating that the GW code will need these states for a good description of the Fermi surface, edit _basp.fe_{: style="color: green"}:

~~~
$ nano basp.fe
~~~

You should see a line beginning with **Fe**.  Append **PZ=0 0 4.5** to the line so that it looks similar to

~~~
 Fe RSMH= 1.561 1.561 1.017 1.561 EH= -0.3 -0.3 -0.3 -0.3 RSMH2= 1.561 1.561 1.017 EH2= -1.1 -1.1 -1.1 P= 4.738 4.538 3.892 4.148 5.102 PZ=0 0 4.5
~~~

This adds a 4_d_ state (local orbital) to the basis.

#### Self-consistency in the LDA

Make the LDA density self-consistent:

~~~
$ lmf fe > out.lmf
~~~

This step overlaps the atomic density taken from file _atm.fe_{: style="color: green"} generated by **lmfa**{: style="color: blue"},
generates an output density, and iterates the until the input and output densities are the same (self-consistency).

**lmf**{: style="color: blue"} should converge in 12 iterations, with the self-consistency density in _rst.fe_{: style="color: green"}.
Inspect  _save.fe_{: style="color: green"}:

~~~
h mmom=2.0619193 ehf=-2541.0404251 ehk=-2541.0266951
i mmom=2.173571 ehf=-2541.0406411 ehk=-2541.0395501
...
c mmom=2.2003534 ehf=-2541.0405422 ehk=-2541.0405455
~~~

The first line prints what is obtained from the trial Mattheis construction that overlaps free atomic densities.
The moment gradually increases from 2.0 (the guessed moment) to 2.20.

At self-consistency, the [Harris-Foulkes](/tutorial/lmf/lmf_tutorial/#faq) Kohn-Sham total energies
are nearly identical.  (If they are not, something is wrong with the calculation!)
Note that the magnetic moment (2.20&thinsp;<i>&mu;<sub>B</sub></i>), is very close to the 
experimental value.

#### LDA Energy bands

In this section we compute the energy bands, which we will compare later with the QSGW result.
For this tutorial use symmetry lines given in the box below.  Copy its contents 
into _syml.fe_{: style="color: green"}.

~~~
51   0   0   0      1   0   0             Gamma to H   (Delta)
51   1   0   0     .5  .5   0             H to N       (G)
51   0  .5  .5     .5  .5  .5             N to P       (D)
51  .5  .5  .5      0   0   0             P to Gamma   (Lambda)
0    0 0 0  0 0 0
~~~

To get the Fermi level corresponding to the density _rst.fe_{: style="color: green"} without overwriting it, do:

~~~
$ lmf fe --quit=band
~~~
Note that the Fermi level is **-0.000599**, very close to the last iteration in the self-consistency cycle.
You can find this doing

~~~
$ grep Fermi out.lmf
~~~

The Fermi level is saved in file _wkp.fe_{: style="color: green"}. Make the energy bands with

~~~
$ lmf fe --band:fn=syml
$ cp bnds.fe bnds.lda
~~~

The latter command renames _bnds.fe_{: style="color: green"} for future use.

### QSGW _calculation for Fe_

#### Setup: the _GWinput_ file

The GW codes require a separate _GWinput_{: style="color: green"} file.
Create a template with:

~~~
$ lmfgwd --jobgw=-1 ctrl.fe
~~~

We are particularly interested in Fermi liquid properties, involving states near the Fermi surface.  The raw _GWinput_{: style="color: green"}
template will generate a reasonable self-energy, but the 3_s_ and 3_p_ core levels affect the Fermi surface enough that we need to treat
them at a little better level of approximation than the template gives you.

Edit  _GWinput_{: style="color: green"}:

~~~
$ nano GWinput
~~~

In the core part of the product basis you should see these lines:

~~~
  atom   l    n  occ unocc   ForX0 ForSxc :CoreState(1=yes, 0=no)
    1    0    1    0    0      0    0    ! 1S *
    1    0    2    0    0      0    0    ! 2S
    1    0    3    0    0      0    0    ! 3S
    1    1    1    0    0      0    0    ! 2P
    1    1    2    1    0      0    0    ! 3P
~~~

With switches as given, no core level participates in the product basis, polarizability or self energy, except that the 3_p_ is included in
the product basis (**occ=1**).  For accurate description of the Fermi surface the 3_s_ also needs to be included; moreover, both 3_s_ and
3_p_ need to be included in the polarization (**ForX0** and self-energy (**ForSxc**).

**Caution:**{: style="color: red"} core levels are calculated indpendently of the valence levels, and there is a slight residual
nonorthogonality that can cause problems if the core levels are too shallow.  This can be a serious issue and a safer approach is to include
these levels in the valence through local orbitals, though in this case the levels are deep enough that the present treatment is adequate.

Change the 3_s_ and 3_p_ lines as follows:

~~~
  atom   l    n  occ unocc   ForX0 ForSxc :CoreState(1=yes, 0=no)
  ...
    1    0    3    1    0      1    1    ! 3S
  ...
    1    1    2    1    0      1    1    ! 3P
~~~

#### QSGW self-consistency

Run the QS<i>GW</i> script as follows:

~~~
$ rm mixm.fe
$ lmgwsc --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

or faster

~~~
$ lmgwsc --mpi=6,6 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

The QSGW cycle should complete in a couple of hours, after 9 iterations.  When it is finished, do

~~~
$ grep more out.lmgwsc 
~~~

You should see the following:

~~~
    lmgwsc : completed iteration 0 of 999  more=T Mon Oct 31 09:05:33 GMT 2016 elapsed wall time 15.4m (0.3h) phpdl1
    lmgwsc : iter 1 of 999  RMS change in sigma = 5.57E-03  Tolerance = 1e-5  more=T Mon Oct 31 09:22:09 GMT 2016 elapsed wall time 32.0m (0.5h) phpdl1
    lmgwsc : iter 2 of 999  RMS change in sigma = 2.32E-03  Tolerance = 1e-5  more=T Mon Oct 31 09:38:12 GMT 2016 elapsed wall time 48.0m (0.8h) phpdl1
    lmgwsc : iter 3 of 999  RMS change in sigma = 4.91E-04  Tolerance = 1e-5  more=T Mon Oct 31 09:54:15 GMT 2016 elapsed wall time 64.0m (1.1h) phpdl1
    lmgwsc : iter 4 of 999  RMS change in sigma = 9.56E-04  Tolerance = 1e-5  more=T Mon Oct 31 10:11:04 GMT 2016 elapsed wall time 80.9m (1.3h) phpdl1
    lmgwsc : iter 5 of 999  RMS change in sigma = 6.64E-04  Tolerance = 1e-5  more=T Mon Oct 31 10:28:16 GMT 2016 elapsed wall time 98.1m (1.6h) phpdl1
    lmgwsc : iter 6 of 999  RMS change in sigma = 8.96E-05  Tolerance = 1e-5  more=T Mon Oct 31 10:45:00 GMT 2016 elapsed wall time 114.8m (1.9h) phpdl1
    lmgwsc : iter 7 of 999  RMS change in sigma = 7.11E-05  Tolerance = 1e-5  more=T Mon Oct 31 11:01:18 GMT 2016 elapsed wall time 131.1m (2.2h) phpdl1
    lmgwsc : iter 8 of 999  RMS change in sigma = 9.82E-06  Tolerance = 1e-5  more=F Mon Oct 31 11:18:00 GMT 2016 elapsed wall time 147.8m (2.5h) phpdl1
~~~

The self-consistent cycle ends when the RMS change in &Sigma;<sup>0</sup> falls below the 
specified tolerance (**--tol=1e-5**).


#### QSGW Energy bands

&Sigma;<sup>0</sup> is an effective non interacting potential with one-particle levels, similar to Hartree Fock or the LDA.
The band structure can be drawn in the same way as in the LDA.  First, find the Fermi level:

~~~
$ lmf fe --quit=band
~~~

You should get a table like this one:

~~~
 BZINTS: Fermi energy:      0.056498;   8.000000 electrons;  D(Ef):   16.413
         Sum occ. bands:   -0.6890437  incl. Bloechl correction:   -0.000979
         Mag. moment:       2.269378
~~~

The Fermi level is higher than in the LDA value (-0.000599); it suggests that the work function would be somewhat smaller.
The magnetic moment (2.27&thinsp;<i>&mu;<sub>B</sub></i>) comes out slightly larger as well.
A better converged QSGW calculation (calculating &Sigma;<sup>0</sup> with more _k_ divisions) reduces 
this value to about (2.2&thinsp;<i>&mu;<sub>B</sub></i>), very similar to what the LDA gets.

Generate the band structure, and copy the file to _bnds.gw_{: style="color: green"}

~~~
$ lmf fe --band:fn=syml
$ cp bnds.fe bnds.gw
~~~

#### Compare QSGW and LDA energy bands

At this point the LDA (_bnds.lda_{: style="color: green"}) and QSGW (_bnds.gw_{: style="color: green"}) energy bands should in your working directory,
containing bands along four symmetry lines (&Gamma;-H; H-N, N-P, and P-&Gamma;)

Use the [**plbnds**{: style="color: blue"}](/docs/misc/plbnds) tool render both sets into files
(_bnd[1234].lda_{: style="color: green"}) for the four panels of LDA bands, and
(_bnd[1234].gw_{: style="color: green"}) for the four panels of QSGW bands.

We will be concerned with the bands near the Fermi level
Restrict the range to <i>E<sub>F</sub></i>&pm;2&thinsp;eV, and focus on the minority spin bands:

~~~
echo -2,2 /  | plbnds -wscl=1,.8 -fplot -ef=0 -scl=13.6 --nocol -dat=gw -spin2 bnds.gw
echo -2,2 /  | plbnds -wscl=1,.8 -fplot -ef=0 -scl=13.6 --nocol -lbl=H,N,G,P,H,G -spin2 -dat=lda bnds.lda
~~~

Each of these commands generated an [**fplot**{: style="color: blue"}](/docs/misc/fplot/) script,
(_plot.plbnds_{: style="color: green"}).

We can edit the latter to combine the bands from the two calculations, and use 
[**fplot**{: style="color: blue"}](/docs/misc/fplot/) to make the picture.

First we need to select colors.  We can make convenient use of the
file preprocessor's [variables substitution](/docs/input/preprocessor/) capabilities
With **fplot**{: style="color: blue"}, you choose the line type and colors
with the [**-lt**](/docs/misc/fplot/#data-switches) instruction
Use two character variables **colr** and **colb** to contain information about
the line types; see [here](/docs/misc/fplot/#line-types) for a quick reference.

Start by creating a new file _plot.2bands_{: style="color: green"}, which
will become the **fplot**{: style="color: blue"} script.

~~~
rm -f plot.2bands
echo "% char0 colr=3,bold=5,clip=1,col=1,.2,.3" >>plot.2bands
echo "% char0 colb=2,bold=4,clip=1,col=.2,.3,1" >>plot.2bands
~~~

Next, modify _plot.plbnds_{: style="color: green"}.  This could be done with
a text editor, but it is convenient to accomplish the same with an **awk** command:

~~~
awk '{if ($1 == "-colsy") {sub("-qr","-lt {colg} -qr");sub("dat","green");sub("green","gw");sub("colg","colr");print;sub("gw","lda");sub("colr","colb");print} else {print}}' plot.plbnds >> plot.2bands
~~~

Compare _plot.plbnds_{: style="color: green"} and _plot.2bands_{: style="color: green"}.

~~~
diff plot.plbnds plot.2bands
~~~

Character variables are declared at the top; and each line drawing bands from bnd_n_.lda
gets converted to two lines, one for bnd_n_.lda with line type modifier **{colb}**
and another for bnd_n_.gw with line type modifier **{colr}**.

<div onclick="elm = document.getElementById('figb'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Run the commands in the box below to create and view the postscript file, or click here to see the figure.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="figb">{:/}
![Particle in a Box Example](/assets/img/box.svg)
{::nomarkdown}</div>{:/}

~~~
$ fplot -f plot.2bands
$ open fplot.ps
~~~

The shifts relative to the LDA are substantial.  Both disagree somewhat with experiment,
because the QSGW potential isn't quite converged.  When well converged, agreement
with the available experimental data in the Fermi liquid regime is excellent.
A considerable discrepancy with LDA remains.
