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
if <i>V<sup>j</sup><sub>xc</sub></i> is defined by QS<i>GW</i>, this is a very good
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
({\omega^*} - \omega^j)/Z^j =  \mathrm{Re} \Sigma(k,\omega^j) - V_{xc}(k) 
$$

and so

$$
 {\omega^*} = \omega^j + Z^j\left( {\mathrm{Re} \Sigma (k,\omega^j) - V_{xc}(k)} \right)
$$

Note that in the QS<i>GW</i> case, the second term on the r.h.s. vanishes by construction: the noninteracting QP peak 
corresponds to the (broadened) pole of _G_.

### _Make the GW self-energy_

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
[Theory section](/tutorial/gw/gw-self-energy/#theory), there is no shift if <i>V<sup>j</sup><sub>xc</sub></i> is the QSGW self-energy; there
remains, however, a reduction in the quasiparticle weight.  This will be apparent when
[comparing the interacting and noninteracting DOS](/tutorial/gw/gw-self-energy/#interacting-density-of-states).

The **spectral**{: style="color: blue"} tool has a limited ability to convert raw files _SEComg.{UP,DN}_{: style="color: green"} into spectral functions,
which this section demonstrates.

Do the following:

~~~
$ spectral --eps=.005 --domg=0.003 --cnst:iq==1&eqp>-10&eqp<30
~~~

Command-line arguments have the following meaning:

+ **--eps=.005** : &nbsp; 0.005 eV is added to the imaginary part of the self-energy. This is needed because as <i>&omega;</i>&rarr;0, Im&Sigma;&rarr;0. Peaks in
  <i>A</i>(<b>k</b>,<i>&omega;</i>) become infinitely sharp for QP levels near the Fermi level.
  
+ **--domg=.003** : &nbsp; interpolates &Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) to a finer frequency mesh.
   <i>&omega;</i> is spaced by 0.003 eV.  The finer mesh is necessary because &Sigma; varies smoothly with <i>&omega;</i>, while <i>A</i> will be sharply
   peaked around QP levels.
   
+ **--cnst:<i>expr</i>** : &nbsp;  acts as a constraint to exclude entries in _SEComg.{UP,DN}_{: style="color: green"} for which **_expr_** is zero.\\
  **<i>expr</i>** is an integer expression that can include the following variables:
  + ib (band index)
  + iq (k-point index)
  + qx,qy,qz,q (components of q, and amplitude)
  + eqp (quasiparticle energy, in eV)
  + spin (1 or 2)

  Thus **iq==1&eqp>-10&eqp<30** \\
  &nbsp;&nbsp; generates spectral functions only for the first _k_ point (the &Gamma; point)\\
  &nbsp;&nbsp; eliminates states below the bottom of the Fe _s_ band (i.e. shallow core levels included in the valence through local orbital)\\
  &nbsp;&nbsp; eliminates states 30 or more eV above the Fermi level.

**spectral**{: style="color: blue"} writes files sec\_ib<i>j</i>\_iq<i>n</i>.up and sec\_ib<i>j</i>\_iq<i>n</i>.dn,
which contain information about the _G_ for band _j_ and the _k_ point <b>k</b><i><sub>n</sub></i>.
The beginning of these files look like:

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

### _Interacting density-of-states_
{::comment}
/tutorial/gw/gw-self-energy/#interacting-density-of-states
{:/comment}

This section uses the self-energy editor, **lmfgws**{: style="color: blue"},
to interpolate &Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) to a fine <b>k</b>- and <i>&omega;</i>- mesh
to obtain a reasonably well converged density-of-states.

#### Dynamical self-energy editor
{::comment}
/tutorial/gw/gw-self-energy/#dynamical-self-energy-editor
{:/comment}


**lmfgws**{: style="color: blue"} contains the dynamical self-energy editor, 
which peforms a variety of manipulations of the _GW_ self-energy
&Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) for different purposes.

It requires the same files as **lmf**{: style="color: blue"}
to compute the QS<i>GW</i> band structure, e.g. _ctrl.ext_{: style="color: green"} and _sigm.ext_{: style="color: green"}.

In addition it requires the dynamical self-energy se.ext_{: style="color: green"}
in special a format written by the **spectral**{: style="color: blue"} tool.

For definiteness this section assumes that _ext_ is _fe_.  Make _se.fe_{: style="color: green"}:

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

The editor operates interactively. It reads a command from standard input, executes the command, and returns to prompt 
waiting for additional instructions.  The editor will print a short summary of instructions if you type &nbsp;**? <RET>**.

For the tutorial, just exit the editor by typing &nbsp;**q <RET>**.

Here is a summary of instructions the editor knows about

+ **readsek [<i>fn</i>]**\\
  reads the self-energy from an ASCII file.
+ **readsekb [<i>fn</i>]**\\
  reads the self-energy from a binary file.  In the absence **<i>fn</i>**, the file name defaults to _seb.ext_{: style="color: green"}.

+ **evsync**\\
  replace quasiparticle levels read from _se.ext_{: style="color: green"} by recalculating them
  with the same algorithm **lmf**{: style="color: blue"} uses.

+ **eps <i>val</i>**\\
   add a constant **<i>val</i>** to Im&Sigma;, needed to broaden spectral functions so that integrations are tractable.
   
+ **ef _ef_**\\
  Use **_ef_** for Fermi level, overriding internally calculated value.
  
+ **dos [nq=#1,#2,#3] [ib=#1,#2] [nw=#|domg=#] [range=#1,#2] [isp=#]**\\
  Integrate spectral function to make QP and spectrum DOS.  Options are:
  + nq    interpolate A(w) new mesh for q-integration
  + ib    restrict A(w) to QP state(s) #1[,#2]
  + nw    refine DOS to multiple of given energy mesh
  + range generate dos in in specified energy window
  
+ **se  iq=#|q=#1,#2,#3 ib=# [getev[=#1,#2,#3]] [nw=#|domg=#] [isp=#] [range=#1,#2]**\\
  Make sigma(omega) and A(omega) for given q and band.\\
  Required arguments are:
  + iq|q  qp index, or q in Cartesian coordinates (units of 2&pi;/alat)
  _ ib    band index
  Options are:
  + getev Do not interpolate energy but calculate it at q.
  + getev=#1,#2,#3 generates evals on independent mesh with nq=#1,#2,#3 divisions
  + nw    interpolate DOS to multiple of given energy mesh
  + isp   functions for given spin (default=1)
  + range generate sigma, A in specified energy window
  
+ **pe|peqp  iq=#|q=#1,#2,#3 ib=# [getev[=#1,#2,#3]] [nw=#|domg=#] [nqf=#] [ek0=#] [isp=#] [range=#1,#2]**\\
  Model ARPES for given q and band(s).\\
  Required arguments are:
  + iq|q  qp index, or q in Cartesian coordinates (units of 2pi/alat)
  + ib    band index
  Options are:
  +getev Do not interpolate energy but calculate it at q.
  + getev=#1,#2,#3 generates evals on independent mesh with nq=#1,#2,#3 divisions
  + nw    interpolate DOS to multiple of given energy mesh
  + isp   functions for given spin (default=1)
  + nqf   no. mesh points for final state intg (def=200)
  + ke0   KE+V0=hbar*omega-phis+V0  KE of emitted electron
  + range generate sigma, A in specified energy window

+ **savesea [fn]**\\
  saves q-interpolated self-energy, ASCII format.  In the absence **<i>fn</i>**, the file name defaults to _seia.ext_{: style="color: green"}.
+ **savese  [fn]**\\
  saves q-interpolated self-energy, binary format.  In the absence **<i>fn</i>**, the file name defaults to _seib.ext_{: style="color: green"}.

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
unless the editor encounters "quit" instruction `a` or `q` first.


#### Compare interacting and independent-particle density-of-states in Fe
{::comment}
/tutorial/gw/gw-self-energy/#compare-interacting-and-independent-particle-density-of-states-in-fe
{:/comment}


~~~
lmfgws fe `cat switches-for-lm` '--sfuned~units eV~readsek~eps .030~dos isp=1 range=-10,10 nq=32 nw=30~savesea~q' > out.lmfgws
~~~

The last argument `--sfuned...` invokes the dynamical self-energy editor, which peforms a variety of manipulations
&Sigma;(<b>k</b><i><sub>n</sub></i>,<i>&omega;</i>) for different purposes.

The editor can be

+ **--sfuned~units eV~readsek~eps .030~dos isp=1 range=-10,10 nq=32 nw=30~savesea~q' > out.lmfgws