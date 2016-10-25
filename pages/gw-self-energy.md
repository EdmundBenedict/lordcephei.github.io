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


This tutorial shows how to make the dynamical self-energy using the GW package.

### _Table of Contents_
_____________________________________________________________

{:.no_toc}
*  Auto generated table of contents
{:toc}


### _Preliminaries_
_____________________________________________________________


This tutorial assumes you have completed a QSGW calculation for Fe, following [this tutorial](xxx).

It assumes you have all the GW executables in your path, i.e.  **lmgwsc**{: style="color: blue"} and
the executables it requires.  This tutorial assumes the GW executables are in **~/bin/code2**.

In addition this tutorial requires 
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


### 1. _Introduction_

This tutorial starts after a QSGW calculation for Fe has been completed, in [this tutorial](xxx).

The QSGW static self-energy was made with the following command:

~~~
$ lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp fe
~~~

This tutorial will do the following

1. Generates spectral functions directly from the _GW_ output.

2. Uses **lmfgws**{: style="color: blue"} to generate spectral DOS from Im _G_, compares it to the noninteracting DOS from Im <i>G<sub>0</sub> and to
the noninteracting DOS generated as an output of an **lmf** band calculation

3. Uses **lmfgws**{: style="color: blue"} to generate to calculate the spectral function <i>A</i>(<b>k</b>,&omega;) for <b>k</b> near the H point.
  Contributions from band 2 is calculated for spin up and from bands 2,3 for spin down.

### 2. _Make the GW self-energy_

1.	If you have removed intemediate files, you must remake them up to the point where the self-energy is made with:

	~~~
	$ lmgwsc --wt --code2 --sym --metal --tol=1e-5 --getsigp --stop=sig fe
	~~~

	This step is not necessary if you have completed the [QSGW tutorial](xxx) without removing any files.

2.	With your text editor, modify _GWinput_{: style="color: green"}.

	Change these two lines:
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

3.  Use **hsfp0\_om**{: style="color: blue"} (or better **hsfp0\_om**{: style="color: blue"}) in a special mode **-job=4** to make the dynamical self-energy.

        export OMP\_NUM\_THREADS=12
        export MPI\_NUM\_THREADS=12
        ~/bin/code2/hsfp0_om --job=4 > out.hsfp0
	
    This step should make _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}

### 3. _Generate the spectral function for q=0_

~~~
spectral --eps=.005 --domg=0.003 --cnst:iq==1&eqp>-10&eqp<30 > out.spectral
~~~

The command-line arguments have the following meaning

+ **--eps=.005** &nbsp; : 0.005 eV is added to the imaginary part of the self-energy. This is needed because as &omega;&rarr;0 Im&Simga;&rarr;0 and the peaks in
  <i>A</i>(<b>k</b>,&omega;) become infinitely sharp for QP levels near the Fermi level.
  
++ **--domg=.003** &nbsp; : interpolates &Sigma;(<b>k</b>,&omega;) to finer mesh, with
   &omega; spaced by 0.003 eV. &Sigma; varies smoothly where <i>A</i> can be sharply
   peaked around QP levels, so the finer mesh is necessary.
   
++ **--cnst:iq==1&eqp>-10&eqp<30** &nbsp; : Exclude entries in _SEComg.UP_{: style="color: green"} and _SEComg.DN_{: style="color: green"}
,DN) for which expr is nonzero.
