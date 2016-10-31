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

It proceeds in a manner similar to the [basic QSGW tutorial](/tutorial/gw/qsgw_si),
and forms a starting point for other tutorials, for example
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

For parts where a text editor is required, the tutorial uses the **nano**{: style="color: blue"} editor.

### _Command summary_
{::comment}
/tutorial/gw/qsgw_fe/#command-summary
{:/comment}
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

LDA self-consistency (starting from  _init.fe_{: style="color: green"})

~~~
blm --nit=20 --nk=16 --gmax=7.9 --mag --nkgw=8 --gw fe
cp actrl.fe ctrl.fe
lmfa fe
cp basp0.fe basp.fe
lmf fe > out.lmf
~~~

~~~
lmfgwd --jobgw=-1 ctrl.fe
nano GWinput
lmgwsc --mpi=6,6 --wt --code2 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

{::nomarkdown}</div>{:/}

### _Introduction_

This tutorial carries out a QS<i>GW</i> calculation for Fe, a ferromagnet with a fairly large moment of 2.2<i>&mu;<sub>B</sub></i>.

Quasiparticle Self-Consistent _GW_ (QS<i>GW</i>) is a special form of self-consistency within _GW_.
Its advantages are briefly described in the [overview](/docs/code/gwoverview/), and also in the summary of the
[basic QSGW tutorial](/tutorial/gw/qsgw_si/#qsgw-summary).
Self-consistency rather necessary in magnetic systems, because the magnetic moment is not reliably described by 1-shot GW.
For the most part magnetic moments predicted by QSGW are significantly better than the LDA, but they tend to be overestimated for
itinerant magnets because diagrams with spin fluctuations, absent in _GW_, tend to reduce the magnetic moment.

This tutorial proceeds in a manner similar to the [basic QSGW tutorial](/tutorial/gw/qsgw_si/#qsgw-summary).

### _Self-consistent_ LDA _calculation for Fe_

QS<i>GW</i> requires a starting point.  We use LDA as it a reasonably
accurate, and convenient one.

Following [other tutorials](/tutorial/lmf/lmf_pbte_tutorial/) we build
the input files using the **blm**{: style="color: blue"} tool, which
requires file _init.fe_{: style="color: green"}.

#### Input file setup

Fe is a bcc metal with a lattice constant 5.408<i>a</i><sub>0</sub>
and a magnetic moment of 2.2<i>&mu;<sub>B</sub></i>.
The LDA needs some breaking of the symmetry to stabilize a nonzero magnetic moment, so we supply
a trial moment of 2<i>&mu;<sub>B</sub></i>.

Cut and paste the contents in the box below into _init.fe_{: style="color: green"}.

~~~
# Init file for Fe
LATTICE
  SPCGRP=Im-3m  A=5.408
# ALAT=5.408 PLAT= -0.5 0.5 0.5   0.5 -0.5 0.5   0.5 0.5 -0.5

SPEC
   ATOM=Fe MMOM=0,0,2
SITE
   ATOM=Fe X=0 0 0
~~~

Supply either the space group ([Im-3m](http://www.periodictable.com/Properties/A/SpaceGroupName.html))
or the bcc lattice vectors.

The input file setup and self-consistent cycle are very similar to [the PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/); review
it first if you are not familiar with the structure of input file, _ctrl.fe_{: style="color: green"}, or how to set up an LDA
calculation from structural information.

Run **blm**{: style="color: blue"} this way:

~~~
blm --nit=20 --mag --gw --nk=16 --nkgw=8 --gmax=7.9 fe
cp actrl.fe ctrl.fe
~~~

The switches do the following:

+ **--nit=20**   : sets the [maximum number of iterations](/docs/input/inputfile/#iter) in **lmf**{: style="color: blue"} self-consistency cycle.\\
                   Not rquired, the default (10 iterations) is about how many are needed are needed to make it self-consistent
+ **--mag**      : tells **blm**{: style="color: blue"} that you want to do a spin-polarized calculation.
+ **--gw**       : tells **blm**{: style="color: blue"} to prepare for a _GW_ calculation.  The effect is to make the basis set a bit larger
                   than usual and sets the basis Hankel energies deeper than is needed for LDA.  This is to make the basis short enough ranged
                 : that the self-energy can be smoothly inteperpolated between _k_ points.
+ **--nk=16**    : sets the _k_ mesh.  You [must supply the mesh](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).\\
                   We use a rather fine mesh here, because Fe is a transition metal with a high density-of-states near the Fermi level.
+ **--nkgw=8**   : the _k_ mesh for _GW_.  If you do not supply this mesh, it will use the **lmf**{: style="color: blue"} mesh.
                   The self-energy varies much more smoothly with _k_ than does the kinetic energy; 16 divisions is expensive and overkill.
+ **--gmax=7.9** : Plane-wave cutoff. You [must supply this number](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).
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
lmfa fe
cp basp0.fe basp.fe
~~~

In this case no local orbitals were generated (inspect _basp.fe_{: style="color: green"} for and **PZ** it has),
**lmfa**{: style="color: blue"} does not need to be run a second time.

#### Self-consistency in the LDA

We could proceed directly to making a self-consistent LDA density with the setup as given.  But when proceeding to the _GW_ part, it turns
out the the high-lying Fe 4_d_ state affects the _GW_ potential slightly, enough to affect states near the Fermi level by 0.05-0.1 eV.
Anticipating that the GW code will need these states for a good description of the Fermi surface, edit _basp.fe_{: style="color: green"}:

~~~
$ nano bsap.fe
~~~

You should see a line beginning with **Fe**.  Append to the line **PZ=0 0 4.5** so that it looks similar to

~~~
 Fe RSMH= 1.561 1.561 1.017 1.561 EH= -0.3 -0.3 -0.3 -0.3 RSMH2= 1.561 1.561 1.017 EH2= -1.1 -1.1 -1.1 P= 4.738 4.538 3.892 4.148 5.102 PZ=0 0 4.5
~~~

Make the LDA density self-consistent:

~~~
$ lmf fe > out.lmf
~~~

This step overlaps the atomic density, taken from file _atm.fe_{: style="color: green"} generated by **lmfa**{: style="color: blue"}
and iterates the density until it is self-consistent.

### QSGW _calculation for Fe_

#### Setup: the _GWinput_ file

The GW codes require a separate _GWinput_{: style="color: green"} file.
Create a template with:

~~~
$ lmfgwd --jobgw=-1 ctrl.fe
~~~

We are particularly interested in Fermi liquid properties, states near the Fermi surface.  The raw _GWinput_{: style="color: green"}
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
3_p_ need to be included in the polarization (**ForX0** and self-energy (**ForSxc**).  Change the 3_s_ and 3_p_ lines as follows:

~~~
  atom   l    n  occ unocc   ForX0 ForSxc :CoreState(1=yes, 0=no)
  ...
    1    0    3    1    0      1    1    ! 3S
  ...
    1    1    2    1    0      1    1    ! 3P
~~~

**Caution**{: style="color: red"} these core levels are calculated indpendently of the valence levels, and there is a slight residual
nonorthogonality that can cause problems if the core levels are too shallow.  A safer approach is to include these levels in the valence
through local orbitals, though in this case the levels are deep enough that the present treatment is adequate.

#### QSGW self-consistency

Run the QSGW script as follows:

~~~
lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

or faster
~~~
lmgwsc --mpi=6,6 --wt --code2 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

QSGW should complete in a couple of hours, after 9 iterations.  When it is finished, do

~~~
grep more out.lmgwsc 
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
specified tolerance, **--tol=1e-5**.


