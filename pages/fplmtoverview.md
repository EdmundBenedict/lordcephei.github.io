---
layout: page-fullwidth
title: "Full Potential Overview"
permalink: "/docs/code/fpoverview/"
header: no
---

The **lmf**{: style="color: blue"} program is an all-electron implementation of the local-density approximation, with a basis consisting of generalized linear muffin tin orbitals, or **LAPWs**, or some combination of the two.

<hr style="height:5pt; visibility:hidden;" />
#### *Overview of the full-potential method*
_____________________________________________

The full-potential program **lmf**{: style="color: blue"} was originally adapted from a program **nfp**{: style="color: blue"} written by M. Methfessel and M. van Schilfgaarde. The method is described in some detail in the following reference :

M. Methfessel, Mark van Schilfgaarde, and R. A. Casali, “A full-potential **LMTO** method based on smooth Hankel functions,” in Electronic Structure and Physical Properties of Solids: The Uses of the **LMTO** Method, *Lecture Notes in Physics 535. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000*.

There is also a manual written for the original 1997 code. The present code is a descendant of it with many new features and with a different input system. But the underlying mathematical formalism, the novel augmentation method in particular, is basically the same.

The following features are unique to this method:

#### *Smoothed Hankel functions*
_____________________________________________

The envelope functions are smoothed generalizations of Hankel functions that are found in **LMTO** programs. Unlike the normal Hankel functions, the smoothed versions — convolutions of ordinary Hankel functions and Gaussian functions — are regular at the origin. They are a significantly better choice of basis than the customary **LMTO** basis set. However, the smoothing introduces complications because the augmentation of a smoothed Hankel function is less straightforward than of a normal Hankel. The envelope functions are not screened into a tight-binding representation, as in the second-generation and later generation **LMTO** methods; thus wave functions are evaluated by Ewald summation. A real-space version using screened envelope functions is in progress.

![Ordinary and Smooth Hankel functions](https://lordcephei.github.io/assets/img/smhankels.svg)

#### *Local Orbitals*
_____________________________________________

This package extends the [linear method](/docs/package_overview/#linear-methods-in-band-theory/) through the use of local orbitals. Augmented methods substitute radial solutio
ns of the Schrödinger equation with combinations of partial waves of angular quantum number *l* inside the augmentation region. Linear methods used a fixed radial function (more precisely, pair of functions), which has validity over only a certain energy window. With local orbitals, a third radial function is added to the basis, which greatly extends the energy window over which energy eigenvalues can be calculated. It is necessary, for example, to obtain the reliable **LDA** band gap in GaAs, as the Ga *3d* and *4d* partial waves are both important. To see how to include local orbitals in the basis, see  
[this tutorial](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals/).

#### *Augmented Plane Waves*
_____________________________________________

In July 2008 Takao Kotani added **APW**s as additional envelope functions, which can increase the flexibility of the basis. One can view this package as an extension of a conventional **LAPW** method, enabling through the use of a few **MTO**s a much faster convergence in energy cutoff of **APW**s. Alternatively, it can be viewed as an extension of the original **MTO** method, A principal advantage of the **APW**s basis is that it easier to make complete. Thus **APW**s offer a systematic way of converging the combined **MTO** + **APW** basis systematic and reliable manner, to almost arbitrarily high accuracy. This is particularly important when reliable eigenvalues far above the Fermi level are needed, and to check the accuracy of a given **MTO** basis. To include **APW**s in the basis, see here for documentation.

#### *Augmentation and Representation of the charge density*
_____________________________________________

The charge density representation is unique to this method. It consists of three parts: a smooth density <i>n</i><sub>0</sub> carried on a
uniform mesh, defined everywhere in space (<i>n</i><sub>0</sub> is not augmented, as occurs with conventional augmentation), the true
density <i>n</i><sub>1</sub> expressed in terms of spherical harmonics <i>Y<sub>lm</sub></i> inside each augmentation sphere, and a one-center expansion
of the smooth density <i>n</i><sub>2</sub>, also expanded in terms of <i>Y<sub>lm</sub></i> inside each augmentation sphere. The total density is
expressed as in the “threefold representation” <i>n</i> = <i>n</i><sub>0</sub> + <i>n</i><sub>1</sub> – <i>n</i><sub>2</sub>.

This turns out to be an extremely useful way to carry out the augmentation procedure. Quantities converge much more rapidly in the *l*-truncation in the augmentation sphere than occurs in conventional augmented wave constructions. (The analysis is a little subtle; see the reference at the start of this document.)

The full-potential program builds on the [ASA package](/docs/code/asaoverview/) which contains an implementation of a tight-binding **LMTO**
program in the Atomic Spheres Approximation (**ASA**), and shares most things in common with it, including a number of 
[auxiliary programs](/docs/package_overview/#executable-codes-in-the-questaal-suite) useful to both **ASA** and **FP**. 
For example, both methods are linear augmented-wave methods, and the wave functions inside the augmentation spheres are equivalent in the two cases. 
You may find that the [ASA overview](/docs/code/asaoverview/) is helpful even if you will not be using the ASA code.
A description of tokens available to this method are documented
[here](/inputguide/); which specifies which tokens can and cannot be used with this and other methods within the package. There is also a
description of tokens specific to this method located in Section 3. See the [input file tutorial](/inputguide/) or the [FP
tutorial](/fpnew/) for a tutorial that helps you build an input file, and explains the output, and the [**ASA** tutorial](/asadoc/) for a
corresponding tutorial for the **ASA** programs.

One important difference between the **ASA** and **FP** methods is that the **FP** method has no neat parametrization of total density in terms of the **ASA** energy moments <i>Q</i><sub>0</sub>, <i>Q</i><sub>1</sub>, <i>Q</i><sub>2</sub>, or the representation of the potential by a few potential parameters, as in the **ASA** (see **ASA** overview in [here](/asadoc/)). However, the basis within the augmentation spheres is defined from the spherical average of the potential, just as in the **ASA**, and the linearization proceeds in the same way. Both use the “[continuously variable principal quantum numbers](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers/)” *P* to establish a mapping between the linearization energy and logarithmic derivative at the **MT** boundary, and to float the linearization energy to band center-of-gravity.

A second important difference is that the basis set is more complicated, and in its current form, the user must choose parameters defining the basis. This complication is the most onerous part of the present method, and there are plans for redesign; but at present it is necessary to treat the interstitial region reliably. The inputs are described below; see also [this](/fpoptbas/) for a tutorial about choosing the basis optimally. Note also with the incorporation of the **APW** basis, other options are available.

#### *Primary executables in FP package*
_____________________________________________

+ **lmf**{: style="color: blue"} is the program used for self-consistent full-potential calculations. It requires a starting density, which it obtains either from a binary restart file *rst.ext*{: style="color: green"} (typically generated by a prior invocation of **lmf**{: style="color: blue"}) or an (almost) equivalent version *rsta.ext*{: style="color: green"} in **ASCII** format, from a superposition of free-atom densities (*file atm.ext*{: style="color: green"}), which is created as follows.

+ **lmfa**{: style="color: blue"} makes each species self-consistent for the free atom and writes the local density, plus a fit to the tail beyond the **MT** radius (fit as a linear combination of smooth Hankel functions) to file "atm". Also appended to file "atm" is a fit to the free-atom wave functions for *r* outside the augmentation radius. **lmfa**{: style="color: blue"} also serves as an automatic generator of parameters for the basis set, as explained in [this tutorial](/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set).

The FP suite is needed to connect to the <b><i>GW</i></b> and **DMFT** packages.  Scripts and other executables (e.g. **lmfgwd**{: style="color: blue"}
**lmfdmft**{: style="color: blue"}) make interfaces to these extensions.
