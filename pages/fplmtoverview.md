---
layout: page-fullwidth
title: "Full Potential Overview"
permalink: "/docs/code/fpoverview/"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________
The **lmf**{: style="color: blue"} program is an all-electron implementation of the local-density approximation, with a basis consisting of generalized (smoothed) Hankel functions, or **LAPWs**, or some combination of the two.

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Overview of the full-potential method_
_____________________________________________

The full-potential program **lmf**{: style="color: blue"} was originally adapted from a program **nfp**{: style="color: blue"} written by M. Methfessel and M. van Schilfgaarde. The method is described in some detail in the following reference :

M. Methfessel, Mark van Schilfgaarde, and R. A. Casali, “A full-potential **LMTO** method based on smooth Hankel functions,” in Electronic Structure and Physical Properties of Solids: The Uses of the **LMTO** Method, *Lecture Notes in Physics 535. H. Dreysse, ed. (Springer-Verlag, Berlin)* 2000.

There is also a manual written for the original 1997 code. The present code is a descendant of it with many new features and with a different input system. But the underlying mathematical formalism, the novel augmentation method in particular, is basically the same.

The following features are unique to this method:

### *Smoothed Hankel functions*
________________________________________________________________________________________________
{::comment}
/docs/code/fpoverview/#smoothed-hankel-functions
{:/comment}

The envelope functions are smoothed generalizations of Hankel functions that are found in **LMTO** programs. Unlike the normal Hankel
functions, the smoothed versions — [convolutions of ordinary Hankel functions and Gaussian functions](/docs/code/smhankels/) — are regular at the origin.
Their smoothness is controlled by an extra degree of freedom, the gaussian width or "smoothing" radius <i>r<sub>s</sub></i>.
[This page](/docs/code/smhankels/) defines them and outlines some of their mathematical properties.
They are described in detail in this [J. Math. Phys.](http://dx.doi.org/10.1063/1.532437) paper.

Smooth Hankels are a significantly better choice of basis than the customary **LMTO** basis set constructed of normal Hankels.
However, smoothing introduces complications because the augmentation of a smoothed Hankel function is less straightforward than it is for an ordinary Hankel.
The envelope functions, while an improvement over the traditional **LMTO** basis are not yet optimal. They are not screened into a tight-binding representation, as in the second-generation and later generation **LMTO** methods; thus wave functions are evaluated by Ewald summation. 
A new basis, "[Jigsaw Puzzle Orbitals](/docs/code/jpos/)," makes use of screening and some other tricks to construct a short ranged, minimal
basis of envelope functions.  They are highly accurate because they tailored to the potential, and accomplish level of precision in the
interstitial approachng that of the augmented parts.  Thus the basis set should be close to complete in the energy window where linearization is valid.

### *Local Orbitals*
_____________________________________________

This package extends the [linear method](/docs/package_overview/#linear-methods-in-band-theory) through the use of local orbitals. [Augmented wave methods](/docs/package_overview/#augmented-wave-methods) substitute radial solutions of the Schrödinger equation with combinations of partial waves of angular quantum number *l* inside the augmentation region. Linear methods used a fixed radial function (more precisely, pair of functions), which has validity over only a certain energy window. With local orbitals, a third radial function is added to the basis, which greatly extends the energy window over which energy eigenvalues can be calculated. It is necessary, for example, to obtain the proper **LDA** band gap in GaAs, both the Ga *3d* and *4d* partial waves are important. To see how to include local orbitals in the basis, see [this tutorial.](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals)

### *Augmented Plane Waves*
_____________________________________________

In 2008 Takao Kotani added augmented plane waves (<b>APWs</b>) as additional envelope functions, which can increase the flexibility of the basis. 
The combination of smooth Hankel functions and APWs is described in this paper on the [PMT basis set](http://dx.doi.org/10.1103/PhysRevB.81.125117).
One can view PMT's as an extension of a conventional **LAPW** method, enabling through the use of a few **MTO**s with much faster convergence in
energy cutoff of **APW**s. Alternatively, it can be viewed as an extension of the original **MTO** method, A principal advantage of the
**APW** basis is that it easier to make complete. Thus **APW**s offer a systematic way of converging the combined **MTO** + **APW** basis
systematic and reliable manner, to almost arbitrarily high accuracy. This is particularly important when reliable eigenvalues far above the
Fermi level are needed, and to check the accuracy of a given **MTO** basis. To include **APW**s in the basis, see [here](need link) for a tutorial.

### *Augmentation and Representation of the charge density*
_____________________________________________

The charge density representation is unique to this method. It consists of three parts: a smooth density <i>n</i><sub>0</sub> carried on a
uniform mesh, defined everywhere in space (<i>n</i><sub>0</sub> is <i>not</i> augmented; inside the augmentation spheres it is present as a "pseudodensity"); the true
density <i>n</i><sub>1</sub> expressed in terms of spherical harmonics <i>Y<sub>lm</sub></i> inside each augmentation sphere; and finally a one-center expansion
<i>n</i><sub>2</sub> of the smooth density in <i>Y<sub>lm</sub></i>, inside each augmentation sphere. The total density is
expressed as a sum of three independent densities: <i>n</i> = <i>n</i><sub>0</sub> + <i>n</i><sub>1</sub> – <i>n</i><sub>2</sub>.

This turns out to be an extremely useful way to carry out the augmentation procedure. Quantities converge much more rapidly in the *l*-truncation in the augmentation sphere than occurs in conventional augmented wave constructions. (The analysis is a little subtle; see the reference at the start of this document.)

### *Connection to the ASA packages*
_____________________________________________

The full-potential program builds on the [ASA suite](/docs/code/asaoverview) which contains an implementation of a tight-binding **LMTO**
program in the Atomic Spheres Approximation (**ASA**), and shares most things in common with it, including a number of 
[auxiliary programs](/docs/package_overview/#executable-codes-in-the-questaal-suite) useful to both **ASA** and **FP**. 
For example, both methods are [linear augmented-wave methods](/docs/package_overview/#linear-methods-in-band-theory), and the wave functions inside the augmentation spheres are equivalent in the two cases. 
You may find that the ASA overview is helpful even if you will not be using the ASA package.
Most input is common to both methods, but there are some differences, e.g. the selection of [sphere radii](/docs/code/asaoverview/#selection-of-sphere-radii).
The FP code requires some additional information, but most of it can be generated automatically,
as explained in [the introductory tutorial](/tutorial/lmf/lmf_tutorial/)
or in more detail in [this tutorial](/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set) for PbTe.
It is interesting to compare that tutorial with [an ASA tutorial](/tutorial/asa/lm_pbte_tutorial/) on the same material.

A description of the input system and tags needed for each method are found in the [input file guide](/docs/input/inputfile/).

One important difference between the **ASA** and **FP** methods is that the **FP** method has no simple parametrization of total density in terms of the **ASA** energy moments <i>Q</i><sub>0</sub>, <i>Q</i><sub>1</sub>, <i>Q</i><sub>2</sub>, or the representation of the potential by a few potential parameters, as in the **ASA** 
(see [**ASA** overview](/docs/code/asaoverview)). However, the basis within the augmentation spheres is defined from the spherical average of the potential, just as in the **ASA**, and the linearization proceeds in the same way. Both use the “[continuously variable principal quantum numbers](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers) *P* to establish a mapping between the linearization energy and logarithmic derivative at the augmentation sphere boundary, and to float the linearization energy to the center-of-gravity of the occupied states.

A second important difference is that the basis set is more complicated, and in its current form, the user must choose parameters defining
the basis. This complication is the most onerous part of the present method (a new "Jigsaw Puzzle Orbital basis" will automatically tailor the basis set shape to the given potential)  but at present it is the basis set is determined by hand, or only semi-automatically. 

### *Primary executables in the FP suite*
_____________________________________________

+ **lmf**{: style="color: blue"} is the program used for self-consistent full-potential calculations. It requires a starting density, which it obtains either from a binary restart file *rst.ext*{: style="color: green"} (typically generated by a prior invocation of **lmf**{: style="color: blue"}) or an equivalent version *rsta.ext*{: style="color: green"} in **ASCII** format, from a superposition of free-atom densities (*file atm.ext*{: style="color: green"}), which is created as follows.

+ **lmfa**{: style="color: blue"} makes each species self-consistent for the free atom and writes the local density, plus a fit to the tail beyond the the augmentation sphere radius (fit as a linear combination of smooth Hankel functions) to the atm file. Also appended to *atm.ext*{: style="color: green"} is a fit to the free-atom wave functions for *r* outside the augmentation radius. This is used to overlap atomic densities to make a trial density for the crystal.  Not least important, **lmfa**{: style="color: blue"} serves as an automatic generator of parameters for the basis set, as explained in [this tutorial](/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set).

The FP suite is needed to connect to the [<b><i>GW</i></b>](/docs/code/gwoverview) and [**DMFT**](/tutorial/qsgw_dmft/dmft0) implementations.  Scripts and other executables (e.g. **lmfgwd**{: style="color: blue"} and **lmfdmft**{: style="color: blue"}) make interfaces to these extensions.
