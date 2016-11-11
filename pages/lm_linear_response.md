---
layout: page-fullwidth
title: "Self-Consistency With Approximate Linear Response"
permalink: "/lm/tutorials/linear_response/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial, which also acts as documentation, outlines the steps needed to estimate the self-consistent density given some dielectric response function. The codes have some capability to generate this dielectric response function approximately however this is less good than when calculated explicitly - this tutorial will detail both the explicit steps you can perform yourself and the commands required for the suite to calculate it for you.

### _Preliminaries_
_____________________________________________________________

### _Tutorial_
_____________________________________________________________
First, you need to care the ASA bare response function $P^{0}$, which will be defined as:

$$dq_{RL} = P^{0}_{RL,R'L'}dv_{R'L'}$$

$dv_{R'L'}$ is the constant potential shift in the channel $L'$ of sphere $R'$, and $dq_{RL}$ is the induced change in the 0th moment in channel _L_ of sphere _R_, without taking into account interactions between electrons (noninteracting susceptibility). The static dielectric response function is:

$$\eta^{-1} = (1-M'P^{0})^{-1}$$

where

$M'=M$ + (on-site term = something like the intraatomic U)

and

$M =$ Madelung Matrix

**lm**{: style="color: blue"} and **lmgf**{: style="color: blue"} can both generate $P^{0}$, and store it on the disk. If you have generated $P^{0}$, you can have the mxing precedure construct $\eta^{-1}$ and then screen $(q^{out}-q^{in})$ by $\eta^{-1}$. More exactly, it replaces the raw _qout_ (generated by **lm**{: style="color: blue"} or **lmgf**{: style="color: blue"}) by:

$$qout*=qin+\eta^{-1}(qout-qin)$$

and then it proceeds with self-consistency in the usual way, using _quot*_ in place of the usual _qout_. It is not difficult to show that if $\eta^{-1}$ is the exact inverse dielectric function, _qout*_ is the RPA estimate of the self-consistent density. See, for example, Richard Martin's book, _Electronic Structure_. Indeed, $\eta$ is sometimes called the "density-density response function".    

To tell the code to do this screening, set _OPTIONS\_SC_=2. The program will crash if it can't read $P^{0}$ from the disk ($P^{0}$ is stored in the file _psta.ext_{: style="color: green"}). You can create $P^{0}$ either with the band program **lm**{: style="color: blue"} or the Green's function code **lmgf**{: style="color: blue"}. Since the metals treatment of $P^{0}$ is very primitive in the **lm**{: style="color: blue"} coce, it is better to use the **lmgf**{: style="color: blue"} to create $P^{0}$ for metals. **lmgf**{: style="color: blue"} can also make $P^{0}$ for the noncollinear case. To run **lmgf**{: style="color: blue"}, you need to add a couple of tokens to the _ctrl_{: style="color: green"} file. For either program, set _OPTIONS\_SCR_=1 to create $P^{0}$.   

The intraatomic _U_ is esimated from the second derivative of the sphere total energy wrt to charge. You can update it every $k^{th}$ iteration by adding _10*k_ to the token _SCR=_... thus _SCR_=52 will update the _U_ each $5^{th}$ iteration in the sphere program.    

If you don't want to make $P^{0}$, you can let the codes make a model estimate for you. It saves you the trouble of making $P^{0}$, but it is less good than when $P^{0}$ is calculated explicitly.   

All of these functionalities can be enabled through the _OPTIONS\_SCR_ token:

    OPTIONS_SCR       opt    i4       1,  1          default = 0
        Use scr to accelerate convergence:
        0 do nothing
        1 Make ASA static response function (see documentation)
        2 Use response to screen output q and ves
        4 Use model response to screen output q
        6 Use response to screen output ves only
          Add 1 to combine mode 1 with another mode
          Add 10*k to compute intra-site contribution to vbare each kth iteration
          Add 100*k to compute response function on every kth iteration