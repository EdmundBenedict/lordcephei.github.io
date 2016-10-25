---
layout: page-fullwidth
title: "Making the dynamical GW self energy"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/gw-self-energy/"
sidebar: "left"
header: no
---

### _Purpose_
_____________________________________________________________


This tutorial explains how to make and analyze the dynamical self-energy &Sigma;(<b>k</b>,&omega;) using the GW package.

### _Table of Contents_
_____________________________________________________________

{:.no_toc}
*  Auto generated table of contents
{:toc}


### _Preliminaries_
_____________________________________________________________


This tutorial assumes you have completed a QSGW calculation for Fe, following [this tutorial](xxx),
which requires that the GW script **lmgwsc**{: style="color: blue"} is in your path, along with
the executables it requires.  

This tutorial assumes the GW executables are in **~/bin/code2**.
In addition it requires 

+ **spectral**{: style="color: blue"}
+ **lmfgws**{: style="color: blue"}

### Command summary
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    ... to be finished

[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate QSGW band structure )
[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate LDA band structure )

{::nomarkdown}</div>{:/}


### _Introduction_

This tutorial starts after a QSGW calculation for Fe has been completed, in [this tutorial](xxx).

_Note:_{: style="color: red"} until that tutorial is written, perform the setup

~~~
~/lm/gwd/test/test.gwd --mpi=#,# fe 4
~~~

The QSGW static self-energy was made with the following command:

~~~
$ lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp fe
~~~

This tutorial will do the following:

+ [Generate spectral function](/tutorial/gw/gw-self-energy/#generate-the-spectral-function-for-q0) at **q**=0 directly from the _GW_ output
  files _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}.  (For nonmagnetic calculations, only _SEComg.UP_{: style="color: green"} is made).

+ Use **lmfgws**{: style="color: blue"} to generate the interacting density-of-states (DOS) from Im _G_, compares it to the noninteracting
  DOS from Im <i>G</i><sub>0</sub> and to the noninteracting DOS generated as an output of an **lmf** band calculation.

+ Use **lmfgws**{: style="color: blue"} to generate to calculate the spectral function <i>A</i>(<b>k</b>,&omega;) for <b>k</b> near the H point.
  The contribution from band 2 is calculated for spin up; and for spin down, from bands 2 and 3.

### _Theory_
{::comment}
/tutorial/gw/gw-self-energy/#theory
{:/comment}


We begin with a noninteracting Green's function <i>G</i><sub>0</sub>, defined through an hermitian, energy-independent exchange-correlation potential
<i>V<sup>j</sup><sub>xc</sub></i>(_k_). &nbsp; _j_ refers to a particular QP state (pole of <i>G</i><sub>0</sub>).  There is also an interacting Green's function, _G_.
 
The contribution to <i>G</i><sub>0</sub> from QP state _j_ is

$$ G_0^j(k,\omega ) = \frac{1}{\omega  - \omega^j(k)} $$

where $$\omega^j(k)$$ is the pole of _G_<sub>0</sub>.

Write the contribution to _G_ from QP state _j_ as

$$ G^j(k,\omega) = \frac{1}{\omega  - \omega^j - \Sigma (k,\omega ) + V^j_{xc}(k)} $$

Note that this equation is only true if $$\Sigma$$ is
diagonal in the basis of noninteracting eigenstates.  We will
ignore the nondiagonal elements of $$\Sigma(k,\omega)$$.  Note that
if <i>V<sup>j</sup><sub>xc</sub></i> is defined by QS<i>GW</i>, this is a very good
approximation, since $${\mathrm{Re}\Sigma (k,\omega ){=}V^j_{xc}(k)}$$
at $$\omega{=}\omega^j(k)$$.  Approximate _G_ by its coherent part:

$$
G^{j,\mathrm{coh}}(k,\omega) = 
\frac{1}{\omega  - \omega^j - \mathrm{Re} \Sigma (k,\omega^j) +
    V^j_{xc}(k) - (\omega  - \omega^j)(1 - {Z^j}^{-1}) - i\mathrm{Im} \Sigma (k,\omega )}
$$

where 

$$
1 - ({Z^j})^{-1} = \left. {\partial \Sigma (k,\omega )/\partial \omega } \right|_{\omega ^j } .
$$

defines the _Z_ factor.  The dependence of <i>&omega;<sup>j</sup></i> and  <i>Z<sup>j</sup></i> on _k_ is suppressed.

Define the QP peak as the value of <i>&omega;</i> where the real part of the denominator vanishes.

$$
({\omega^*} - \omega^j){Z^j}^{-1} =  \mathrm{Re} \Sigma(k,\omega^j) - V_{xc}(k) 
$$

and so

$$
 {\omega^*} &=& \omega^j + Z^j\left( {\mathrm{Re} \Sigma (k,\omega^j) - V_{xc}(k)} \right)
$$

Note that in the QS_GW_ case, the second term on the r.h.s. vanishes by construction: the noninteracting QP peak 
corresponds to the (broadened) pole of _G_.

### _Make the GW self-energy_

+ If you have removed intemediate files, you must remake them up to the point where the self-energy is made with:

~~~
$ lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp --stop=sig fe
~~~

This step is not necessary if you have completed the [QSGW Fe tutorial](xxx) without removing any files.

+ With your text editor, modify _GWinput_{: style="color: green"}.  Change these two lines:

~~~
 --- Specify qp and band indices at which to evaluate Sigma

~~~

into these four lines:

~~~
***** ---Specify the q and band indices for which we evaluate the omega dependence of self-energy ---
   0.01 2   (Ry) ! dwplot omegamaxin(optional)  : dwplot is mesh for plotting.
                   : this omegamaxin is range of plotting -omegamaxin to omegamaxin.
                   : If omegamaxin is too large or not exist, the omegarange of W by hx0fp0 is used.
~~~

The next step will make &Sigma;(<b>k</b>,&omega;) on a uniform energy mesh &minus;2 Ry < &omega; < 2 Ry, spaced by 0.01 Ry.  This is a
fairly fine spacing so the calculation is somewhat expensive.

+ Use **hsfp0\_om**{: style="color: blue"} (or better **hsfp0\_om**{: style="color: blue"}) in a special mode **-job=4** to make the dynamical self-energy.

~~~
export OMP_NUM_THREADS=12
export MPI_NUM_THREADS=12
~/bin/code2/hsfp0_om --job=4 > out.hsfp0
~~~
	
This step should make _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}.  These files contain &Sigma;(<b>k</b>,&omega;), but 
in a not particularly readable format.

### _Generate the spectral function for q=0_
{::comment}
/tutorial/gw/gw-self-energy/#generate-the-spectral-function-for-q0
{:/comment}

_SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"} contain the diagonal matrix element &Sigma;<sub><i>jj</i></sub>(<b>k</b>,&omega;)
 for each QP level <i>j</i>, for each irreducible point <b>k</b> in the Brillouin zone, on a uniform mesh of points &omega; as specified in
the _GWinput_{: style="color: green"} file of the last section.  If the absence of interactions, &Sigma;<sub><i>ii</i></sub>(<b>k</b>,&omega;)=0
so the spectral function would be proportional to &delta;(&omega;&minus;&omega<sup>*</sup>), where &omega<sup>*</sup> is the QP level (see [Theory](/tutorial/gw/gw-self-energy/#theory)).
Interactions give &Sigma;<sub><i>ii</i></sub>(<b>k</b>,&omega;) an imaginary part which broadens out the level, and 
and in general, Re&Sigma;<sub><i>ii</i></sub>(<b>k</b>,&omega;) shifts and renormalizes the QP level.  As noted in the 
[Theory](/tutorial/gw/gw-self-energy/#theory) section, there is no shift if <i>V<sup>j</sup><sub>xc</sub></i> is the QSGW self-energy.

The **spectral**{: style="color: blue"} tool has a limited ability to convert raw files _SEComg.{UP,DN}_{: style="color: green"} into spectral functions,
which this section demonstrates.

Do the following:


~~~
$ spectral --eps=.005 --domg=0.003 --cnst:iq==1&eqp>-10&eqp<30
~~~

Command-line arguments have the following meaning:

+ **--eps=.005** : &nbsp; 0.005 eV is added to the imaginary part of the self-energy. This is needed because as &omega;&rarr;0, Im&Sigma;&rarr;0. Peaks in
  <i>A</i>(<b>k</b>,&omega;) become infinitely sharp for QP levels near the Fermi level.
  
+ **--domg=.003** : &nbsp; interpolates &Sigma;(<b>k</b>,&omega;) to a finer frequency mesh.
   &omega; is spaced by 0.003 eV.  The finer mesh is necessary because &Sigma; varies smoothly with &omega;, while <i>A</i> will be sharply
   peaked around QP levels.
   
+ **--cnst:<i>expr</i>** : &nbsp;  acts as a constraint to exclude entries in _SEComg.{UP,DN}_{: style="color: green"} for which **_expr_** is zero.\\
  **<i>expr</i>** is an integer expression that can include the following variables:
  + ib (band index)
  + iq (k-point index)
  + qx,qy,qz,q (components of q, and amplitude)
  + eqp (quasiparticle energy, in eV)
  + spin (1 or 2)

  Thus **iq==1&eqp>-10&eqp<30** 
  + generates spectral functions only for the first _k_ point (the &Gamma; point)
  + eliminates states below the bottom of the Fe _s_ band (i.e. shallow core levels included in the valence through local orbital)
  + eliminates states 30 or more eV above the Fermi level.

**spectral**{: style="color: blue"} writes files sec\_ib_j__iq_n_.up and sec\_ib_j__iq_n_.dn,
which contain <i>A<sup>j</sup></i>(<b>k</b><i><sub>n</sub>,&omega;) and <i>A<sup>j</sup></i><sub>0</sub>(<b>k</b><i><sub>n</sub>,&omega;).

