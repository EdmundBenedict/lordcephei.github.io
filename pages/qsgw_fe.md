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
_____________________________________________________________

This tutorial carries out a QSGW calculation for Fe, a bcc magnetic metal,
beginning with a self-consistent LDA calculation.

It proceeds in a manner similar to the [basic QSGW tutorial](/tutorial/gw/qsgw_si)
see in particular the [flowchart](/tutorial/gw/qsgw_si/#qsgw-summary).

This tutorial is a starting point for other tutorials; see for example
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

Quasiparticle Self-Consistent _GW_ (QS<i>GW</i>) is a special form of self-consistency within _GW_.  Its advantages are briefly described in the [overview](/docs/code/gwoverview/).

This tutorial carries out a QS<i>GW</i> calculation for Fe, a ferromagnet with a fairly large moment of 2.2<i>&mu;<sub>B</sub></i>.
Self-consistency rather necessary in magnetic systems, because the magnetic moment is not reliably described by 1-shot GW.

### _Self-consistent_ LDA _calculation for Fe_

QS<i>GW</i> requires a starting point.  We use LDA as it a reasonably
accurate, and convenient one.

Following [other tutorials](/tutorial/lmf/lmf_pbte_tutorial/) we build
the input files using the **blm**{: style="color: blue"} tool, which
requires file _init.fe_{: style="color: green"}.

Fe is a bcc metal with a lattice constant 5.408<i>a</i><sub>0</sub>
and a magnetic moment of 2.2<i>&mu;<sub>B</sub></i>.
The LDA needs some breaking of the symmetry to stabilize the magnetic moment, so we supply
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

Supply either the space group [Im-3m](http://www.periodictable.com/Properties/A/SpaceGroupName.html)
or the bcc lattice vectors.

The first steps are very similar to [the PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/);
go through that tutorial first if you are not familiar with
the structure of input file, _ctrl.fe_{: style="color: green"},
or how to set up an LDA calculation from structural information.

Run **blm**{: style="color: blue"} this way:

~~~
blm --nit=20 --mag --gw --nk=16 --nkgw=8 --gmax=7.9 fe
cp actrl.fe ctrl.fe
~~~

The switches do the following:

+ --nit=20     : sets the [maximum number of iterations](/docs/input/inputfile/#iter) in **lmf**{: style="color: blue"} self-consistency cycle.\\
                 Not rquired, the default (10 iterations) is about how many are needed are needed to make it self-consistent
+ --mag        : tells **blm**{: style="color: blue"} that you want to do a spin-polarized calculation.
+ --gw         : tells **blm**{: style="color: blue"} to prepare for a _GW_ calculation.  The effect is to make the basis set a bit larger
                 than usual and sets the basis Hankel energies deeper than is needed for LDA.  This is to make the basis short enough ranged
			   : that the self-energy can be smoothly inteperpolated between _k_ points.
+ --nk=16      : sets the _k_ mesh.  You [must supply the mesh](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).\\
                 We use a rather fine mesh here, because Fe is a transition metal with a high density-of-states near the Fermi level.
+ --nkgw=8     : the _k_ mesh for _GW_  If you do not supply this mesh, it will use the **lmf**{: style="color: blue"} mesh.
               	 The self-energy varies much more smoothly with _k_ than does the kinetic energy, and 16 divisions is overkill.
+ --gmax=7.9   : Plane-wave cutoff. You [must supply this number](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency).
                 It is difficult to determine in advance; however you can leave it out at first and run **lmfa**{: style="color: blue"}.
               	 You typically need to run **lmfa**{: style="color: blue"} twice anyway, since it may find some local orbitals and
                 change the valence-core partitioning.  (See the [LDA tutorial for PbTe](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency.)

_Note:_{: style="color: red"} **blm**{: style="color: blue"} writes the input file template to _actrl.fe_{: style="color: green"},
to avoid overwriting a the _ctrl.fe_{: style="color: green"}, which you may want to preserve.

Generate the free atom density and copy the basis set information it generates to 
_basp.fe_{: style="color: green"}.  See the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#initial-setup)
for further explanation.

~~~
lmfa fe
cp basp0.fe basp.fe
~~~

In this case no local orbitals were generated (inspect _basp.fe_{: style="color: green"} for and **PZ** it has),
**lmfa**{: style="color: blue"} does not need to be run a second time.

Make the density self-consistent:

~~~
lmf fe > out.lmf
~~~

### QSGW _calculation for Fe_


The GW codes require a separate _GWinput_{: style="color: green"} file.
Create a template with:

~~~
lmfgwd --jobgw=-1 ctrl.fe
~~~

lmgwsc --mpi=6,6 --wt --code2 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc



