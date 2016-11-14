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

This page documents some of the error messages that can appear in the code

### _Table of Contents_
________________________________________________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}

### _Density Functional codes_
________________________________________________________________________________________________


Exit -1 rdsigm: Bloch sum deviates more than allowed tolerance (tol=5e-6)
: Indicates a failure to carry out an inverse Bloch sum of the QS<i>GW</i> self-energy
  
  Solution: increase [**HAM\_RSRNGE**](/docs/input/inputfile/#ham) (at a slight increase in cost) or
  [**HAM\_RSSTOL**](/docs/input/inputfile/#ham) (at an loss in accuracy).
