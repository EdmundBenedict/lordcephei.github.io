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
In addition it requires **spectral**{: style="color: blue"} and **lmfgws**{: style="color: blue"}.

This tutorial assumes the GW executables are in **~/bin/code2**.

### _Command summary_
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

QSGW self-consistency (starting from the LDA)

~~~
lmfgwd --jobgw=-1 ctrl.fe
lmgwsc --mpi=6,6 --wt --code2 --sym --metal --tol=1e-5 --getsigp fe > out.lmgwsc
~~~

Making the spectral function (starting from QS<i>GW</i>)


    ... to be finished

[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate QSGW band structure )
[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate LDA band structure )

{::nomarkdown}</div>{:/}


### _Introduction_

This tutorial starts after a QSGW calculation for Fe has been completed, in [this tutorial](xxx).

The QSGW static self-energy was made with the following command:

~~~
$ lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp fe
~~~

_Note:_{: style="color: red"} until that tutorial is written, perform the setup as follows (where **~/lm** is your Questaal source directory)

~~~
~/lm/gwd/test/test.gwd --mpi=#,# fe 4
~~~


This tutorial will do the following:

+ [Generate spectral function](/tutorial/gw/gw-self-energy/#generate-spectral-functions-for-q0) at **q**=0 directly from the _GW_ output
  files _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}.  (For nonmagnetic calculations, only _SEComg.UP_{: style="color: green"} is made).

+ Use **lmfgws**{: style="color: blue"} to generate the interacting density-of-states (DOS) from Im _G_, compares it to the noninteracting
  DOS from Im <i>G</i><sub>0</sub> and to the noninteracting DOS generated as an output of an **lmf** band calculation.

+ Use **lmfgws**{: style="color: blue"} to generate to calculate the spectral function <i>A</i>(<b>k</b>,&omega;) for <b>k</b> near the H point.
  The contribution from band 2 is calculated for spin up; and for spin down, from bands 2 and 3.

### _Theory_
{::comment}
/tutorial/gw/gw-self-energy/#theory
{:/comment}


#### _Z_ factor renormalization

Begin with a noninteracting Green's function <i>G</i><sub>0</sub>, defined through an hermitian, energy-independent exchange-correlation potential
<i>V<sup>j</sup><sub>xc</sub></i>(_k_). &nbsp; _j_ refers to a particular QP state (pole of <i>G</i><sub>0</sub>).  There is also an interacting Green's function, _G_.

The contribution to <i>G</i><sub>0</sub> from QP state _j_ is

$$ G_0^j(k,\omega ) = \frac{1}{\omega  - \omega^j(k)} $$

where $$\omega^j(k)$$ is the pole of _G_<sub>0</sub>.

Write the contribution to _G_ from QP state _j_ as

$$ G^j(k,\omega) = \frac{1}{\omega  - \omega^j - \Sigma (k,\omega ) + V^j_{xc}(k)} $$

Note that this equation is only true if $$\Sigma$$ is
diagonal in the basis of noninteracting eigenstates.  We will
ignore the nondiagonal elements of $$\Sigma(k,\omega)$$.  Note that
if <i>V<sub>xc</sub><sup>j</sup></i> is constructed by QS<i>GW</i>, this is a very good
approximation, since $${\mathrm{Re}\Sigma (k,\omega ){=}V^j_{xc}(k)}$$
at $$\omega{=}\omega^j(k)$$.  Approximate _G_ by its coherent part:

$$
G^{j,\mathrm{coh}}(k,\omega) =
\frac{1}{\omega  - \omega^j - \mathrm{Re} \Sigma (k,\omega^j) +
    V^j_{xc}(k) - (\omega  - \omega^j)(1 - 1/Z^j) - i\mathrm{Im} \Sigma (k,\omega )}
$$

where

$$
1 - 1/{Z^j} = \left. {\partial \Sigma (k,\omega )/\partial \omega } \right|_{\omega ^j } .
$$

defines the _Z_ factor.  The dependence of <i>&omega;<sup>j</sup></i> and  <i>Z<sup>j</sup></i> on _k_ is suppressed.

Define the QP peak as the value of <i>&omega;</i> where the real part of the denominator vanishes.

$$
({\omega^*} - \omega^j)/Z^j =  \mathrm{Re} \Sigma(k,\omega^j) - V^j_{xc}(k)
$$

and so

$$
 {\omega^*} = \omega^j + Z^j\left( {\mathrm{Re} \Sigma (k,\omega^j) - V^j_{xc}(k)} \right)
$$

Note that in the QS<i>GW</i> case, the second term on the r.h.s. vanishes by construction: the noninteracting QP peak
corresponds to the (broadened) pole of _G_.

The group velocity is <i>d&omega;</i>/<i>dk</i>.  For the interacting case it reads

$$
\frac{d\omega^*}{dk} = \frac{d\omega ^j }{dk} + \frac{d}{dk}Z^j \left( {\text{Re}\Sigma(k,\omega^j) - V_{xc}^j (k)} \right)
$$

Use the ratio of noninteracting and interacting group velocities as a definition of the ratio of inverse masses.  From the chain rule

$$
\frac{m_0}{m^*} \equiv \frac{d\omega^*}{dk}/\frac{d\omega^j}{dk} = 
1 + Z^j \left( \frac{\partial}{\partial\omega}
\left. \text{Re}\Sigma (k,\omega ^j ) \right|_{\omega^j} \frac{d\omega ^j }{dk} + \frac{\partial}{\partial k}\left. \text{Re}\Sigma(k,\omega^j) \right|_{\omega ^j } 
 - \frac{\partial }{\partial k}V_{xc}^j (k) \right)
 + \left(\frac{dZ^j}{dk}\right) \left(\text{Re}\Sigma(k,\omega^j) - V_{xc}^j (k) \right)
$$

Ignore the dependence of _Z_<sup>j</sup> on _k_.
Write <i>d&omega;<sup>j</sup></i>/<i>dk</i> as $v_0^j$, and use the definition of
_Z_ to get

$$
\frac{m_0}{m^*} = 1 + \frac{1}{v_0^j}Z^j \left( {\left( {1 - 1/{Z^j}} \right) v_0^j  + 
\frac{\partial}{\partial k} \left.\text{Re}\Sigma(k,\omega^j) \right|_{\omega^j} - \frac{\partial }{\partial k}V_{xc}^j(k)} \right)
$$

So
\frac{m_0}{m^*} = 
Z^j  + \frac{Z^j}{v_0^j }\left( {\frac{\partial}{\partial k}\left. \text{Re}\Sigma (k,\omega^j) \right|_{\omega ^j }  - \frac{\partial }{\partial k}V_{xc}^j (k)} \right)

In the QS<i>GW</i> case the quantity in parenthesis vanishes.

#### Coherent part of the spectral function

Write $$G^{j,\mathrm{coh}}(k,\omega)$$ as

$$
G^{j,\mathrm{coh}}(k,\omega) = \left[(\omega  - \omega^j){Z^j}^{-1} - \mathrm{Re} \Sigma (k,\omega^j) + {V_{xc}}(k) - i\mathrm{Im} \Sigma (k,\omega )\right]^{-1}
$$

Rewrite as

$$
G^{j,\mathrm{coh}}(k,\omega) 
= \frac{Z^j}{\omega  - \omega^* - iZ\mathrm{Im} \Sigma (k,\omega )}
= Z^j\frac{\omega  - \omega^* + iZ\mathrm{Im} \Sigma (k,\omega )}{(\omega - {\omega^*})^2 + (Z^j\mathrm{Im} \Sigma (k,\omega ))^2}
$$

Using the standard definition of the spectral function, e.g. Hedin 10.9:

$$
A(\omega ) = {\pi ^{ - 1}}\left| {\operatorname{Im} G(\omega )} \right|
$$

the approximate spectral function is

which shows that the spectral weight of the coherent part is reduced by _Z_.



#### _Simulation of Photoemission_

_Energy conservation_ : It requires 

$$\hbar\omega=E_{kin}+{\varphi_s}-E_b$$

where <i>E<sub>b</sub></i> is the binding energy and
$$E_{kin}+{\varphi_s}$$ is the energy of the electron after being ejected.

_Momentum conservation_ : The final wave vector $$\mathbf{k}_f$$ of the
ejected electron must be equal to its initial wave vector, apart from shortening
by a reciprocal lattice vector to keep $$\mathbf{k}_f$$ in the first Brillouin zone.
Marder Eq. (23.58) then reads
\[-E_b(\mathbf{k}_f){=}\hbar\omega-E_{kin}-{\varphi_s}\]



### _Make the GW self-energy_
{::comment}
/tutorial/gw/gw-self-energy/#make-the-gw-self-energy

{:/comment}

+ If you have removed intermediate files, you must remake them up to the point where the self-energy is made.  Do:

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

The next step will make &Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) on a uniform energy mesh &minus;2 Ry < <i>&omega;</i> < 2 Ry, spaced by 0.01 Ry
at irreducible points <b>k</b><i><sub>n</sub></i>, for QP levels specified in _GWinput_{: style="color: green"}.  This is a
fairly fine spacing so the calculation is somewhat expensive.

+ Run **hsfp0**{: style="color: blue"} (or better **hsfp0\_om**{: style="color: blue"}) in a special mode **\-\-job=4** to make the dynamical self-energy.

~~~
export OMP_NUM_THREADS=8
export MPI_NUM_THREADS=8
~/bin/code2/hsfp0_om --job=4 > out.hsfp0
~~~

This step should create _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}.  These files contain
&Sigma;(<b>k</b>,<i>&omega;</i>), albeit in a not particularly readable format.

### _Generate spectral functions for q=0_
{::comment}
/tutorial/gw/gw-self-energy/#generate-spectral-functions-for-q0
{:/comment}

_SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"} contain the diagonal matrix element
 &Sigma;<sub><i>jj</i></sub>(<b>k</b>,<i>&omega;</i>) for each QP level <i>j</i>, for each irreducible point <b>k</b><i><sub>n</sub></i> in the Brillouin zone, on a
 uniform mesh of points <i>&omega;</i> as specified in the _GWinput_{: style="color: green"} file of the last section.  If the absence of
 interactions, &Sigma;<sub><i>ii</i></sub>(<b>k</b>,<i>&omega;</i>)=0 so the spectral function would be proportional to
 &delta;(<i>&omega;</i>&minus;<i>&omega;</i><sup>\*</sup>), where <i>&omega;</i>\* is the QP level (see [Theory section](/tutorial/gw/gw-self-energy/#theory)).

Interactions give &Sigma;<sub><i>ii</i></sub>(<b>k</b>,<i>&omega;</i>) an imaginary part which broadens out the level, and in general,
Re&Sigma;<sub><i>ii</i></sub>(<b>k</b>,<i>&omega;</i>) shifts and renormalizes the quasiparticle weight by _Z_.  As noted in the
[Theory section](/tutorial/gw/gw-self-energy/#theory), there is no shift if <i>V<sub>xc</sub><sup>j</sup></i> is the QS<i>GW</i> self-energy; there
remains, however, a reduction in the quasiparticle weight.  This will be apparent when
[comparing the interacting and noninteracting DOS](/tutorial/gw/gw-self-energy/#interacting-density-of-states).

The **spectral**{: style="color: blue"} tool has a limited ability to convert raw files _SEComg.{UP,DN}_{: style="color: green"} into spectral functions,
which this section demonstrates.

Do the following:

~~~
$ spectral --eps=.005 --domg=0.003 --cnst:iq==1&eqp>-10&eqp<30
~~~

Command-line arguments have the following meaning:

+ **--eps=.005** : &nbsp; 0.005 eV is added to the imaginary part of the self-energy. This is needed because as <i>&omega;</i>&rarr;0, Im &Sigma;&rarr;0. Peaks in
  <i>A</i>(<b>k</b>,<i>&omega;</i>) become infinitely sharp for QP levels near the Fermi level.

+ **--domg=.003** : &nbsp; interpolates &Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) to a finer frequency mesh.
   <i>&omega;</i> is spaced by 0.003 eV.  The finer mesh is necessary because &Sigma; varies smoothly with <i>&omega;</i>, while <i>A</i> will be sharply
   peaked around QP levels.

+ **--cnst:<i>expr</i>** : &nbsp;  acts as a constraint to exclude entries in _SEComg.{UP,DN}_{: style="color: green"} for which **_expr_** is zero.\\
  **<i>expr</i>** is an integer expression using standard [Questaal syntax for algebraic expressions](/docs/input/preprocessor/#syntax-of-algebraic-expressions).
  It can that can include the following variables:
  + ib (band index)
  + iq (k-point index)
  + qx,qy,qz,q (components of q, and amplitude)
  + eqp (quasiparticle energy, in eV)
  + spin (1 or 2)

  The expression in this example, **iq==1&eqp>-10&eqp<30**, does the following: \\
  &nbsp;&nbsp; generates spectral functions only for the first _k_ point (the first k point is the &Gamma; point)\\
  &nbsp;&nbsp; eliminates states below the bottom of the Fe _s_ band (i.e. shallow core levels included in the valence through local orbital)\\
  &nbsp;&nbsp; eliminates states 30 eV or more above the Fermi level.



**spectral**{: style="color: blue"} writes files <i>sec\_ib</i>j<i>\_iq</i>n<i>.up</i>{: style="color: green"}
 and sec\_ib<i>j</i>\_iq<i>n</i>.dn,
which contain information about the _G_ for band _j_ and the _k_ point <b>k</b><i><sub>n</sub></i>.
The top of sec\*\* files look like the following:

~~~
# ib=   5  iq=   1  Eqp=   -0.797925  q=   0.000000   0.000000   0.000000
#     omega         omega-Eqp     Re sigm-vxc    Im sigm-vxc      int A(w)      int A0(w)       A(w)           A0(w)
  -0.2721160D+02 -0.2641368D+02 -0.6629516D+01  0.1519810D+02  0.2350291D-04  0.6897219D-08  0.7774444D-02  0.2281456D-05
  -0.2720858D+02 -0.2641065D+02 -0.6629812D+01  0.1520157D+02  0.4701215D-04  0.1379602D-07  0.7776496D-02  0.2281979D-05
~~~

**spectral**{: style="color: blue"} also makes the _k_-integrated DOS.  However, the _k_ mesh is rather coarse and a
[better DOS](/tutorial/gw/gw-self-energy/#interacting-density-of-states) can be made using **lmfgws**{: style="color: blue"}.

________________________________________________________________________________________________
<div onclick="elm = document.getElementById('spectral'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show the standard output from the spectral tool </button></div>
{::nomarkdown}<div style="display:none;margin:0px 0px 0px 0px;"id="spectral">{:/}

~~~
 spectral: read 29 qp from QIBZ
 Dimensions from file(s) SEComg.(UP,DN):
 nq=1  nband=9  nsp=2  omega interval (-27.2116,27.2116) eV with (-200,200) points
 Energy mesh spacing = 136.1 meV ... interpolate to target spacing 3 meV.  Broadening = 5 meV
 Spectral functions starting from band 1, spin 1, for 9 QPs

          file            Eqp      int A(G)   int A(G0) rat[G] rat[G0]
      sec_ib1_iq1.up   -8.760788     0.8610     0.9998     T     T
      sec_ib2_iq1.up   -1.666774     0.8394     0.9999     T     T
      sec_ib3_iq1.up   -1.666703     0.8394     0.9999     T     T
      sec_ib4_iq1.up   -1.666635     0.8394     0.9999     T     T
      sec_ib5_iq1.up   -0.797925     0.8451     0.9999     T     T
      sec_ib6_iq1.up   -0.797795     0.8451     0.9999     T     T
      sec_ib7_iq1.up   25.315312     0.7142     0.9992     T     T
      sec_ib8_iq1.up   25.315316     0.7142     0.9992     T     T
      sec_ib9_iq1.up   25.315318     0.7142     0.9992     T     T

 writing q-integrated dos to file dos.up ...
 Spectral functions starting from band 1, spin 2, for 9 QPs

          file            Eqp      int A(G)   int A(G0) rat[G] rat[G0]
      sec_ib1_iq1.dn   -8.488402     0.8576     0.9998     T     T
      sec_ib2_iq1.dn   -0.006985     0.8805     0.9999     T     T
      sec_ib3_iq1.dn   -0.006625     0.8823     0.9999     T     T
      sec_ib4_iq1.dn   -0.006271     0.8836     0.9999     T     T
      sec_ib5_iq1.dn    1.530201     0.8499     0.9999     T     T
      sec_ib6_iq1.dn    1.530937     0.8499     0.9998     T     T
      sec_ib7_iq1.dn   25.497064     0.7042     0.9991     T     T
      sec_ib8_iq1.dn   25.497074     0.7042     0.9991     T     T
      sec_ib9_iq1.dn   25.497083     0.7042     0.9991     T     T

 writing q-integrated dos to file dos.dn ...
~~~

{::nomarkdown}</div>{:/}

### _Dynamical self-energy editor_
{::comment}
/tutorial/gw/gw-self-energy/#dynamical-self-energy-editor
{:/comment}


**lmfgws**{: style="color: blue"} contains the dynamical self-energy editor,
which peforms a variety of manipulations of the _GW_ self-energy
&Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) for different purposes.
It requires the same files **lmf**{: style="color: blue"} needs
to compute the QS<i>GW</i> band structure, e.g. _ctrl.ext_{: style="color: green"} and _sigm.ext_{: style="color: green"}.

In addition it requires the dynamical self-energy se.ext_{: style="color: green"}
in special a format written by the **spectral**{: style="color: blue"} tool.

For definiteness this section assumes that _ext_ is _fe_.
Starting from _SEComg.UP_{: style="color: green"} (and in the magnetic case _SEComg.DN_{: style="color: green"})
[generated by the _GW_ code](/tutorial/gw/gw-self-energy/#make-the-gw-self-energy), use
**spectral**{: style="color: blue"} to generate _se.fe_{: style="color: green"}:

~~~
$ spectral --ws --nw=1
$ mv se se.fe
~~~

+ **--ws** tells **spectral**{: style="color: blue"} to write the self-energy
to file _se_{: style="color: green"} for all _k_ points, in a special format
designed for **lmfgws**{: style="color: blue"}.  Individual files are not writen.
+ **--nw=1** tells **spectral**{: style="color: blue"} to write the self-energy
on the frequency mesh it was generated; no interpolation takes place.


Try starting the dynamical self-energy editor:

~~~
$ lmfgws ctrl.fe `cat switches-for-lm` --sfuned
~~~

You should see:

~~~
 Welcome to the spectral function file editor.  Enter '?' to see options.

 Option :
~~~

The editor operates interactively. It reads a command from standard input, executes the command, and returns to the
&nbsp;<b>Options</b> prompt waiting for another instruction.  The editor will print a short summary of instructions if you type &nbsp;<b>? \<RET></b>.

#### Editor instructions
{::comment}
/tutorial/gw/gw-self-energy/#editor-instructions
{:/comment}

The following summarizes the instruction set of the dynamical self-energy editor.

+ **readsek [<i>fn</i>]**\\
  reads the self-energy from an ASCII file. In the absence **<i>fn</i>**, the file name defaults to _se.ext_{: style="color: green"}.
+ **readsekb [<i>fn</i>]**\\
  reads the self-energy from a binary file.  In the absence **<i>fn</i>**, the file name defaults to _seb.ext_{: style="color: green"}.

+ units Ry\\
  select Rydberg units for which data is to be output
+ units eV\\
  select electron vole units for which data is to be output

+ **evsync**\\
  replace quasiparticle levels read from _se.ext_{: style="color: green"} by recalculating them
  with the same algorithm **lmf**{: style="color: blue"} uses.

+ **eps <i>val</i>**\\
   add a constant **<i>val</i>** to Im &Sigma;, needed to broaden spectral functions so that integrations are tractable.

+ **ef _ef_**\\
  Use **_ef_** for Fermi level, overriding internally calculated value.

+ **dos [nq=#1,#2,#3] &nbsp; [nw=#|domg=#] &nbsp; [range=#1,#2] &nbsp; [isp=#]**\\
  Integrate spectral function to make both the QP and spectrum DOS.  Options are:
  + **nq=#1,#2,#3**    &nbsp;&nbsp;&nbsp;
                       Interpolate &Sigma;<i><sub>j</sub></i>(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) to a new uniform mesh of **k** points, defined by (**#1,#2,#3**) divisions.
  + **nw=_n_**         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Refine the given energy mesh by interpolating &Sigma; to an _n_ multiple of the given energy mesh.
                       _n_ must be an integer.
  + **range=#1,#2**    &nbsp;&nbsp;&nbsp;
                       Generate DOS in a specified energy window (**#1,#2**), in eV.
  + **isp=_i_**        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Generate DOS for spin **_i_** (1 or 2).  Default value is 1.

+ **se  iq=_n_|q=#1,#2,#3 &nbsp; ib=_list_ &nbsp; [getev[=#1,#2,#3]] &nbsp; [nw=_n_|domg=#] &nbsp; [isp=#] &nbsp; [range=#1,#2]**\\
  Make &Sigma;(<i>&omega;</i>) and <i>A</i>(<i>&omega;</i>) for given **q** and range of bands.\\
  &nbsp;&nbsp;&nbsp;&nbsp; Required arguments are:
  + **iq=_n_**         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       index to <b>q</b><i><sub>n</sub></i>, from list in _QIBZ_{: style="color: green"}.  Alternatively specify **q** by:
  + **q=#1,#2,#3**     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       **q**-point in units of 2<i>&pi;</i>/alat.  **lmfgws**{: style="color: blue"} will interpolate &Sigma;(<b>q</b><i><sub>n</sub></i>) to any **q**.
  + **ib=_list_**      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Sum together <i>A<sup>j</sup></i>(<i>&omega;</i>) derived from QP states <i>j</i> in **_list_**.
                       See [here](/docs/misc/integerlists/) for the syntax of integer lists.\\
  Options are:
  + **getev**          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Do not interpolate energy but calculate it at **q**.
  + **getev=#1,#2,#3** Generate evals on independent mesh with **#1,#2,#3** divisions of uniformly spaced points.
  + **nw=_n_**         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Refine the given energy mesh by interpolating &Sigma; to an _n_ multiple of the given energy mesh.
                       _n_ must be an integer.
  + **range=#1,#2**    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Generate spectral function in a specified energy window (**#1,#2**)

+ **pe|peqp  iq=_n_|q=#1,#2,#3 &nbsp; ib=# &nbsp; [getev[=#1,#2,#3]] &nbsp; [nw=#|domg=#] &nbsp; [nqf=#] &nbsp; [ke0=#] &nbsp; [isp=_i_] &nbsp; [range=#1,#2]**\\
  Model ARPES for given q and band(s).\\
  &nbsp;&nbsp;&nbsp;&nbsp; Required arguments are:
  + **iq=_n_**         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       index to <b>q</b><i><sub>n</sub></i>, from list in _QIBZ_{: style="color: green"}.  Alternatively specify **q** by:
  + **q=#1,#2,#3**     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       **q**-point in units of 2<i>&pi;</i>/alat.  **lmfgws**{: style="color: blue"} will interpolate &Sigma;(<b>q</b><i><sub>n</sub></i>) to any **q**.
  + **ib=_list_**      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Sum together PE spectrum derived from QP states <i>j</i> in **_list_**.
                       See [here](/docs/misc/integerlists/) for the syntax of integer lists.\\
  Options are:
  + **getev**          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Do not interpolate energy but calculate it at **q**.
  + **getev=#1,#2,#3** Generate evals on independent mesh with **#1,#2,#3** divisions of uniformly spaced points.
  + **nw=_n_**         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Refine the given energy mesh by interpolating &Sigma; to an _n_ multiple of the given energy mesh.
                       _n_ must be an integer.
  + **isp=_i_**        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       Generate spectra for spin **_i_** (1 or 2).  Default value is 1.
  + **nqf=_n_**        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       number of mesh points for final state integration.  Default is 200.
  + **ke0=#**          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       kinetic energy of emitted electron.  KE+V0=&#8463;<i>&omega;&minus;&phi;<sub>s</sub>+V<sub>0</sub>
  + **range=#1,#2**    &nbsp;&nbsp;&nbsp;&nbsp;
                       Generate spectral function in a specified energy window (**#1,#2**)

+ **savesea [fn]**\\
  saves spectrum DOS or self-energy + spectral function, in ASCII format.  In the absence **<i>fn</i>**, the file name defaults to _seia.ext_{: style="color: green"}
  or _seia2.ext_{: style="color: green"} when writing band and _k_-resolved spectral functions (**se** or **pe**) 
  and to _sdos.ext_{: style="color: green"} or _sdos2.ext_{: style="color: green"} when writing spectrum dos (**dos**).

+ **savese  [fn]**\\
  saves q-interpolated self-energy + spectral function in binary format.  In the absence **<i>fn</i>**, the file name defaults to _seib.ext_{: style="color: green"}.

+ **q**\\
  quits the editor unless information has generated that has not been saved.  Program terminates.
+ **a**\\
  (abort) unconditionally quits the editor.  Program terminates.

You can also use the editor in a batch mode by stringing commands together:

~~~
$ lmfgws ctrl.fe `cat switches-for-lm` '--sfuned~first command~second command~...'
~~~

**\~**&nbsp; is the delimiter separating instructions (you can use another character).
**lmfgws**{: style="color: blue"} will parse through all the commands given, and return to the &nbsp;**Option**&nbsp; prompt,
unless the editor encounters "quit" instruction `a` or `q`.


### _Compare interacting and independent-particle density-of-states in Fe_
{::comment}
/tutorial/gw/gw-self-energy/#compare-interacting-and-independent-particle-density-of-states-in-fe
{:/comment}

This section uses the self-energy editor, **lmfgws**{: style="color: blue"},
to interpolate &Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) to a fine <b>k</b>- and <i>&omega;</i>- mesh
to obtain a reasonably well converged density-of-states.

~~~
$ lmfgws fe `cat switches-for-lm` '--sfuned~units eV~readsek~eps .030~dos isp=1 range=-10,10 nq=32 nw=30~savesea~q'
~~~

This invocation runs **lmfgws**{: style="color: blue"} in batch mode.  Instructions do the following (as explained [here](/tutorial/gw/gw-self-energy/#editor-instructions):

+ units eV\\
  Set units to eV; spectrum DOS will be written in eV.
+ readsek\\
  Read _se.fe_{: style="color: green"}
+ eps .030\\
  Add 30 meV smearing to Im &Sigma;
+ dos isp=1 range=-10,10 nq=32 nw=30\\
  Make the DOS for spin 1, in the energy range (-10,10) eV, interpolating &Sigma; to a **k** mesh 32&times;32&times;32 divisions, and refining the energy mesh by a factor of 30.
  The as-given **k** mesh is 8&times;8&times;8 divisions.
+ savesea\\
  Write the DOS.
+ q\\
  Exit the editor.
  
_Notes:_{: style="color: red"}

+ The mesh is very fine, so the interpolation takes a little while (2 to 3 minutes).  The frequency and **k** meshes are both pretty fine and the DOS is 
  rather well converged, as the figure below demonstrates.
+ The spectrum DOS is written to file _sdos.fe_{: style="color: green"}.
  Columns 1,2,3 are <i>&omega;</i>, <i>A</i>(<i>&omega;</i>), and <i>A</i><sub>0</sub>(<i>&omega;</i>), respectively.
+ <i>A</i><sub>0</sub>(<i>&omega;</i>) should compare directly to the DOS calculated as a byproduct of **lmf**{: style="color: blue"}.

_Note:_{: style="color: red"} for now, copy the **lmf**{: style="color: blue"}-generated DOS to your working directory.

~~~
cp ~/lm/gwd/test/fe/dosp.fe dosp.fe
~~~

The following draws a figure comparing the DOS generated three different ways.  It uses the [**fplot**{: style="color: blue"} tool](/docs/misc/fplot/).
Cut and paste the contents of the box below into script file _plot.dos_{: style="color: green"}.

~~~
%char0 ltdos="1,bold=3,col=0,0,0"
% var ymax=1.4 dy=0.4 dw=.00 ymax+=dy emin=-10 emax=5 ef=0
fplot

% var ymax-=dy+dw dy=0.4 dmin=0 dmax=3
 -frme 0,1,{ymax-dy},{ymax} -p0 -x {emin},{emax} -y {dmin},{dmax} -tmy 1 -1p
 -colsy 3 -lt 1,bold=3,col=.5,.5,.5 -qr sdos.fe
 -colsy 2 -lt {ltdos} -ord y -qr dosp.fe
 -colsy 2 -lt 1,bold=3,col=1,0,0 -qr sdos.fe
 -lt 2,bold=3,col=0,0,0,2,.5,.05,.5 -tp 2~{ef},{dmin},{ef},{dmax}
~~~

<div onclick="elm = document.getElementById('figd'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Run the commands in the box below to create and view the postscript file, or click here to see the figure.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="figd">{:/}
![k-integrated spectral function in Fe](https://lordcephei.github.io/assets/img/fedos.svg)
{::nomarkdown}</div>{:/}

~~~
$ fplot -f plot.dos
$ open fplot.ps   [choose your postscript file viewer]
~~~

_Notes on the figure:_{: style="color: red"}

+ The [black line](/docs/misc/fplot/#color-specification) (**col=0,0,0**) is the noninteracting DOS generated by **lmf**{: style="color: blue"}.
+ The [grey line](/docs/misc/fplot/#color-specification) (**col=.5,.5,.5**) is the _noninteracting_ DOS <i>A</i><sub>0</sub>(<i>&omega;</i>), 
  generated by **lmfgws**{: style="color: blue"}
+ The [red line](/docs/misc/fplot/#color-specification) (**col=1,0,0**) is the _interacting_ DOS <i>A</i>(<i>&omega;</i>), generated by **lmfgws**{: style="color: blue"}
+ Grey and black lines nearly coincide, as they should if the DOS is well converged. Note that the black line was generated from energy bands with the tetrahedron method,
  the other effectively by integrating <i>G</i><sub>0</sub>(<b>k</b>,<i>&omega;</i>) by sampling with a smearing of 30 meV.
+ The noninteracting DOS at the Fermi level is <i>D</i>(<i>E<sub>F</sub></i>)&cong;1/eV (one spin).  The Stoner criterion for the onset of
   ferromagnetism is <i>I</i>&times;<i>D</i>(<i>E<sub>F</sub></i>)&gt;1.  <i>I</i> is the Stoner parameter, and DFT predicts to be
   approximately 1 eV for 3_d_ transition metals. Combining DOS for the two spins would indicate that the Stoner criterion is well satisfied.

+ The interacting DOS is smoothed out, and and is roughly half the amplitude of the noninteracting DOS.  This is also expected: the _Z_ factor for the _d_ states is about 0.5.

### _Spectral Function of Fe near the H point_
{::comment}
/tutorial/gw/gw-self-energy/#spectral-function-of-fe-near-the-h-point
{:/comment}

This example computes the self-energy for a **q** point near the H point.  It is calculated from band 2 for the majority spin and bands 2,3 for the minority spin.
These bands were chosen because of their close proximity to the Fermi level.

~~~
$ lmfgws fe `cat switches-for-lm` '--sfuned~units=eV~eps .01~readsek~evsync~se q=1.05,2.91,1.01 ib=2 nw=10 getev=12 isp=1~savesea~q' 
$ lmfgws fe `cat switches-for-lm` '--sfuned~units=eV~eps .01~readsek~evsync~se q=1.05,2.91,1.01 ib=2,3 nw=10 getev=12 isp=2~savesea~q'
~~~

