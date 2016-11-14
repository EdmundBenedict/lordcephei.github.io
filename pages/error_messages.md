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

### _Table of Contents_
________________________________________________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}

### _lmf_
________________________________________________________________________________________________

{::nomarkdown} <a name="rdsigrange"></a> {:/}
{::comment}
(/docs/error_messages/#rdsigrange)
{:/comment}

Fatal: Bloch sum deviates more than allowed tolerance
: _Problem_: A failure to carry out an inverse Bloch sum of the QS<i>GW</i> self-energy.

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
  [](/docs/input/inputfile/#ham) (at an loss in accuracy).  
  **HAM\_RSRNGE** defaults to 5 (in units of the lattice constant); **HAM\_RSSTOL** defaults to 5&times;10&middot;<sup>&minus;6</sup>.
