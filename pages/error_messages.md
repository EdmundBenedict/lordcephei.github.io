---
layout: page-fullwidth
title: "Error Messages"
permalink: "/docs/error_messages/"
sidebar: "left"
header: no
---

### _Purpose_
________________________________________________________________________________________________
{:.no_toc}

This page documents some of the error messages that can appear in the Questaal suite.

Fatal errors typically begin with a message  **Exit -1 _routine-name_ ...** indicating where the program failed.

Sometimes non-fatal, warning messages are given.  Usually the message has &thinsp;"**(warning)**"&thinsp; or something similar.

### _Table of Contents_
________________________________________________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}

### _lmf code_
________________________________________________________________________________________________


{::nomarkdown} <a name="nonintegraln"></a> {:/}
{::comment}
(/docs/error_messages/#nonintegraln)
{:/comment}


 (warning): non-integral number of electrons --- possible band crossing at E_f
: _Problem_: In finding a Fermi level the integrator assigns weights to each state.  This message is prineted when the sum of weights don't
  add up to an integral number of electrons.  This can happen when using the tetrahedron method and two bands cross near the Fermi level.
  The tetrahdron integrator doesn't know how to smoothly interpolate the bands and mixes them up.  The larger the system with a denser mesh
  of bands, the likely this problem appears.
  
  It can also appear if you use a non-integral nuclear charge, or add background charge to the system.  This is not an error, and you can disregard the warning.

  _Solution_:  As you proceed to self-consistency it may go away. If not, you need to modify your **k** mesh, or switch to sampling.
  It is important the the number of electrons be correctly counted.

{::nomarkdown} <a name="rdsigrange"></a> {:/}
{::comment}
(/docs/error_messages/#rdsigrange)
{:/comment}

Exit -1 rdsigm: Bloch sum deviates more than allowed tolerance
: _Problem_: A failure to carry out an inverse Bloch sum of the QS<i>GW</i> self-energy to sufficient accuracy.

  _Example_:

  ~~~
     i   j      diff              bloch sum                file value
     1   1    0.000133      0.059085   -0.000000      0.059218    0.000000

   Exit -1 rdsigm: Bloch sum deviates more than allowed tolerance (tol=5e-6)
  ~~~

  If the [range](/docs/outputs/lmf_output/#reading-qsgw-self-energies) for inverse Bloch-summed &Sigma;<sup>0</sup>(<b>q</b>)
  is not sufficiently large, not enough pairs needed to recover all the Fourier components of the 
  will found.  It will be indicated from some preceding output:

  ~~~
  hft2rs: found 479 connecting vectors out of 512 possible for FFT
  ~~~

  When the first number (**479**) is less than the number of _k_ points,
  the inverse Bloch transform is inexact.

  _Solution_: increase [**HAM\_RSRNGE**](/docs/input/inputfile/#ham) (at a slight increase in cost) or
  [**HAM\_RSSTOL**](/docs/input/inputfile/#ham) (at an loss in accuracy).\\
  **HAM\_RSRNGE** defaults to 5 (in units of the lattice constant); **HAM\_RSSTOL** defaults to 5&times;10<sup>&minus;6</sup>.
