---
layout: page-fullwidth
title: "1-shot GW tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/gw1shot/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />

### _Purpose_
{:.no_toc}
_____________________________________________________________


This tutorial carries out a 1-shot GW calculation for silicon. 

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Preliminaries_
_____________________________________________________________


Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path;
similarly for the GW script **lmgw1-shot**{: style="color: blue"}; and the binaries it requires should be in subdirectory **code2**.

### _Introduction to a QSGW calculation_
________________________________________________________________________________________________

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a 1-shot GW calculation. Click on the 'GW' dropdown menu below for a brief description of the GW scheme. A complete summary of the commands used throughout is provided in the 'Commands' dropdown menu. Theory for GW and QSGW, and its implementation in the Questaal suite, can be found in [Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106).


<div onclick="elm = document.getElementById('qsgwsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Click for description.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgwsummary">{:/}

Each iteration of a QSGW calculation has two main parts: a section that uses effective one-body hamiltonians to makes the density _n_, and
the _GW_ code that makes the self-energy &Sigma;(<i>&omega;</i>) of an interacting hamiltonian.  For quaisparticle self-consistency, the
_GW_ code makes a "quasiparticlized" self-energy &Sigma;<sup>0</sup>, which is used to construct the effective one-body hamiltonian for the
next cycle.  The process is iterated until the change in &Sigma;<sup>0</sup> becomes small.

The one-body executable is **lmf**{: style="color: blue"}.  **lmfgwd**{: style="color: blue"} is similar
to **lmf**{: style="color: blue"}, but it is a driver whose purpose is to set up inputs for the _GW_ code.
&Sigma;<sup>0</sup> is made by a shell script **lmgw**{: style="color: blue"}.  The entire cycle is managed
by a shell script **lmgwsc**{: style="color: blue"}.

Before any self-energy &Sigma;<sup>0</sup> exists, it is assumed to be zero.  Thus the one-body hamiltonian is usually the LDA, though it can be something else, e.g. LDA+U.\\
_Note:_{: style="color: red"} in some circumstances, e.g. to break time reversal symmetry inherent the LDA, you need to start with LDA+U.

Thus, there are two self-energies and two corresponding Green's functions: the interacting _G_[&Sigma;(<i>&omega;</i>)] and noninteracting
_G_<sup>0</sup>[&Sigma;<sup>0</sup>].  At self-consistency the poles of _G_ and _G_<sup>0</sup> coincide: this is a unique and very
advantageous feature of QSGW.  It means that there is no "mass renormalization" of the bandwidth --- at least at the _GW_ level.

Usually the interacting &Sigma;(<i>&omega;</i>) isn't made explicitly, but you can do so, as explained in [this tutorial](/tutorial/gw/gw_self_energy/).

In short, a QSGW calculation consists of the following steps. The starting point is a self-consistent DFT calculation (usually LDA). The DFT
eigenfunctions and eigenvalues are used by the GW code to construct a self-energy &Sigma;<sup>0</sup>.  This is called the "0<sup>th</sup> iteration."
If the diagonal parts only of &Sigma;<sup>0</sup> is kept, the "0<sup>th</sup> corresponds to what is sometimes called _GW_, or as
_G_<sup>LDA</sup>W<sup>LDA</sup>.

In the next iteration, &Sigma;<sup>0</sup>&minus;_V_<sub>xc</sub><sup>LDA</sup> is added to the LDA hamiltonian.  The density is made
self-consistent, and control is handed over to the _GW_ part.  (Note that for a fixed density _V_<sub>xc</sub><sup>LDA</sup> cancels the exchange
correlation potential from the LDA hamiltonian.)  This process is repeated until the RMS change in &Sigma;<sup>0</sup> falls below a certain
tolerance value.  The final self-energy (QSGW potential) is an effectively an exchange-correlation functional, tailored to the system, that can
be conveniently used analogously to the standard DFT setup to calculate properties such as the band structure.

{::nomarkdown}</div>{:/} 

