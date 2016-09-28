---
layout: page-fullwidth
title: "Jigsaw Puzzle Orbitals"
permalink: "/docs/code/jpos/"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________

To describe a some of the properties of Jigsaw Puzzle orbitals.
They form the next-generation basis set of the **lmf**{: style="color: blue"} code.

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### *Special properties of Jigsaw Puzzle Orbitals*
________________________________________________________________
{::comment}
/docs/code/jpos/#special-properties-of-jigsaw-puzzle-orbitals
{:/comment}

Jigsaw Puzzle Orbitals (<b>JPO</b>s) have many highly desirable
properties of a basis set.

 + They are short ranged and atom centered.
 + They are smooth everywhere.
 + They have an exponentially decying asymptotic form.
 + They are tailored to the potential.
   Inside or near an augmentation site, almost the entire solution of the Schr&ouml;dinger equation is carried by
   a single function. Thus they form a nearly optimal basis set for the Schr&ouml;dinger equation over a given energy window.

We now move away from exact solutions and build up a procedure to construct
basis functions $\phi(\varepsilon,x)$, that solve the SE approximately.
Our starting point is to select energy-dependent envelope functions
$E(\varepsilon,x)$, and augment them by exact solutions inside each
potential well.  The augmented parts are called partial waves, because they
solve the SE exactly but only in some region of space (or, more generally,
channel).  [DISCUSS EARLIER] In the 3D case partial waves are solutions of
of a spherical potential subject to being regular at the origin and a
boundary condition at the spher surface, i.e. orbitals of $s$, $p$, $d$,
\dots\ character.  In preparation for that 3D case where exact solutions
are not available, we want to solve the problem approximately, in a minimal,
but intelligently chosen set basis set of functions.


![s and p JPO's for a 1d 2-centers model](/assets/img/jpo2c.svg)

### _Other Resources_
______________________________________________________________
{::comment}
/docs/code/jpos/#other-resources/
{:/comment}

1. Many mathematical properties of smoothed Hankel functions and the $$H_{kL}$$ family
are described in this paper:  
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
_Nonsingular Hankel functions as a new basis for electronic structure calculations_,
[J. Math. Phys. 39, 3393 (1998)](http://dx.doi.org/10.1063/1.532437)
