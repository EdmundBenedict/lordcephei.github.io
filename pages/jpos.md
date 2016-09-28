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
{::comment}
/docs/code/smhankels/#special-properties-of-jigsaw-puzzle-orbitals
{:/comment}
________________________________________________________________

Jigsaw Puzzle Orbitals (<b>JPO</b>s) have a number of highly desirable properties of a basis set.

 + They are short ranged and atom centered, with pure <i>Y<sub>lm</sub></i> character on the augmentation boundary where they are centered.
   Thus, they serve as good projectors for special subspaces, e.g. correlated atoms.
 + They are smooth everywhere.  This greatly facilitate their practical implementation.
 + They have an exponentially decying asymptotic form far away from a nucleus, as low-lying eigenfunctions do.
 + They are tailored to the potential.
   Inside or near an augmentation site, almost the the Schr&ouml;dinger equation is carried by almost entirely by
   a single function. Thus they form a nearly optimum basis set for the Schr&ouml;dinger equation over a given energy window.

In the figure below, the JPO envlope functions are shown for _s_ and _p_ orbitals in a 1D model with two atom centers.

![s and p JPO's for a 1d 2-centers model](/assets/img/jpo2c.svg)

The solid lines depict the interstitial region, where the envelope functions carry the wave function.  Dashed lines depict augmenented
regions where the envelope is substituted by [partial waves](/docs/package_overview/#linear-methods-in-band-theory) --- numerical solutions
of the Schr&ouml;dinger equation.  It is nevertheless very useful that the envelope functions are smooth there, since sharply peaked
envelope functions, require many plane waves o represent the
[smooth charge density <i>n</i><sub>0</sub>](/docs/code/fpoverview/#augmentation-and-representation-of-the-charge-density)

At points where the envelope functions and augmented functions join, the function value is _unity_ on the head site
(<i>V<sub>1p</sub></i> or <i>V<sub>1s</sub></i> on the left, <i>V<sub>2p</sub></i> or <i>V<sub>2s</sub></i> on the right)
and _zero_ on the other site.  (More precisely <i>V<sub>1</sub>&times;Y<sub>lm</sub></i> is either 1 or zero.)
Moreover, the _kinetic energy_ is tailored to be _continuous_ at the head site and _vanish_ at the other site.

These two facts taken in combination are very important. Consider the Schr&ouml;dinger equation near an augmentation point.  Inside the
augmentaion region, the partial wave is constructed numerically, and is very accurate.  It is not quite exact: the partial wave is
[linearized](/docs/package_overview/#linear-methods-in-band-theory), and the potential which constructs the partial wave is taken to be the
spherical average of the actual potential.  But it is well established that errors are small: the the LAPW method, for example, considered
to be the gold standard basis set for accuracy, makes the same approximations.  Since the kinetic energy is continuous across the 
boundary, the partial wave is an equally good representation of the Schr&ouml;dinger on the other side of the boundary, at least 
very near the boundary.

This alone is not sufficient to make the basis set accurate.  Tails from heads centered elsewhere will contribute to the construction
of an eigenfunction.  They can "contaminate" the accurate solution the head gives.  However, consider the form of the Schr&ouml;dinger equation:

$$ [\Delta + V(r)] \psi = \varepsilon \psi \quad\quad\quad\quad (1) $$

By construction both value and kinetic energy of <i>V<sub>Rl</sub></i> all vanish except for
the single partial wave that forms the head.  Thus _any_ linear combination of them will yield
a nearly exact solution of the Schr&ouml;dinger equation.

In many respects, JPOs are nearly ideal basis functions.  They do have two important drawbacks, however:

 + They are complex objects, complicating their augmentation and assembling of matrix elements.
 + No analytic form for products of two of them as there are for plane waves and guassian orbitals.



### *Mathematical construction of Jigsaw Puzzle Orbitals*

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
