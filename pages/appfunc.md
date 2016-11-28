---
layout: page-fullwidth
title: "Questaal Functionalities by Physical Property"
permalink: "/functionality/application/"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________
This page capabilities of the Questaal suite organized by physical property.


### _Table of Contents_
{:.no_toc}
____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Preliminaries_
{:.no_toc}
_____________________________________________________________


This page points to a number of capabilities in the Questaal package.
A detailed explanation of the capabilities of each package within the suite can be found on the [package page](/docs/package_overview/).

Where tutorials exists that explain a feature in some detail, this page will point to them.
However, tutorials do not yet exist for many features.

As a stopgap, this page refers to a script in the source directory that tests the feature.
For definiteness, we assume that the source directory is called _~/lm_{: style="color: green"}.

### _Drawing Energy Bands_
_____________________________________________________________
Energy bands can be drawn with the **lmf**{: style="color: blue"}, **lm**{: style="color: blue"}, **tbe**{: style="color: blue"}, **lmgf**{: style="color: blue"} and **lumpy**{: style="color: blue"} codes.

**lmf**{: style="color: blue"} can generate energy bands as shown in this test:

    $ ~/lm/fp/test/test.fp co

### _Drawing Fermi Surfaces_
_____________________________________________________________
Fermi surfaces can be drawn with the **lmf***{: style="color: blue"} and **lm**{: style="color: blue"} codes.
An illustration can be found here:


    $ ~/lm/fp/test/test.fp fe 1

Alternatively, perform the steps by hand:

~~~
$ cp ~/lm/fp/test/ctrl.fe ~/lm/fp/test/fs.fe .
$ lmfa fe
$ lmf fe
$ lmf fe --iactiv --band~con~fn=fs
$ mc -r:open bnds.fe -shft=0 -w b2 -r:open bnds.fe -shft=0 -w b3 -r:open bnds.fe -shft=0 -w b4 -r:open bnds.fe -shft=0 -w b5
$ fplot -f ~/lm/fp/test/plot.fs0
~~~

### _Density Of States_
_____________________________________________________________
All of the band codes have the ability to generate the total Density of States (DOS).
Total DOS are automatically generated when you set [**BZ\_SAVDOS**](/docs/input/inputfile/#bz). 
DOS are written to file _dos.ext_{: style="color: green"} (one DOS
in the nonmagnetic case and two in the spin-polarized case).\\
The [**pldos**{: style="color: blue"}](/docs/misc/pldos/) tool will render _dos.ext_{: style="color: green"} into more user friendly
formats, and perform other functions.
_Note:_{: style="color: red"} this switch will not be active if [**BZ\_METAL**](/docs/input/inputfile/#bz) is zero.

Codes can also resolve DOS in different ways.

**lmf**{: style="color: blue"} and **lm**{: style="color: blue"} can generate partial densities-of-states with the
  [-\-pdos](/docs/input/commandline/#pdos) switch.

#### lmf

For partial DOS, see [this tutorial](/tutorial/lmf/pdos/).

**lmf**{: style="color: blue"} can also generate joint density-of-states, project DOS onto particular orbitals,
and resolve DOS by wave number <b>k</b>, as part of the [optics package](/application/opt-part/).
[This tutorial](/tutorial/gw/fe_optics/) illustrates how the _d_ partial DOS in Fe can be resolved into
<i>t</i><sub>2g</sub> and <i>e</i><sub>g</sub> components, and how those components
can resolved at a special _k_ point.

#### lm

A detailed tutorial for **lm**{: style="color: blue"} partial DOS can be found [here](/tutorial/asa/lm_pdos).

Features of the optics package also work with **lm**{: style="color: blue"}.

#### lmgf and lmpg

**lmgf**{: style="color: blue"} can make partial DOS.  It can either do it by Pade extrapolation to the
real axis of Im&thinsp;<i>G</i> calculated on the contour in the complex plane, or you can choose a contour
close to the real axis and generate DOS directly.  The latter is more accurate, but more time consuming.
For a demonstration, try

    $ ~/lm/gf/test/test.gf nife

### _Spectral Functions_
_____________________________________________________________

DOS are equivalent to spectral functions, though generally spectral functions refer to DOS when there is some scattering to spread out the
pole <i>&delta;</i>(<i>E&minus;E</i><sub>0</sub>) in Im&thinsp;<i>G</i> from a noninteracting eigenstate at energy <i>E</i><sub>0</sub>.

Codes calculate spectral functions for interacting electrons in several contexts:

+ Calculated from _GW_. See [this tutorial](/tutorial/gw/gw_self_energy/).
+ Calculated in Dynamical Mean Field Theory. See the [DMFT tutorial](/tutorial/qsgw_dmft/dmft0/).
+ The ASA Green's function code **lmgf**{: style="color: blue"} will calculate spectral functions in the context of the Coherent Potential
  Approximation, see [this document](/docs/code/spectral-functions/).  Electrons aren't interacting in the many-body sense here; disorder
  causes scattering which has the same effect.

### _Mulliken Analysis and Core Level Spectroscopy_
_____________________________________________________________


Mulliken Analysis and Core Level Spectroscopy are are closely related to densities of states.

The **lmf**{: style="color: blue"} package can also perform Mulliken analysis or Core-Level Spectroscopy (CLS) using switches
**-\-mull** or **-\-cls**.  **-\-mull**  is very similar to **-\-pdos**:  both resolve the total DOS into projections.

+ **-\-pdos** projects onto [partial waves](/docs/package_overview/#linear-methods-in-band-theory "linear methods") in augmentation spheres
+ **-\-mull** projects onto basis functions.

Both switches have several options; for **-\-mull**  see [here](/docs/input/commandline/#pdos); for **-\-cls**  see [here](/docs/input/commandline/#cls).

A usage guide for Mulliken analysis, including how the switch is actually used, can be found [here](/tutorial/lmf/mulliken/).  For
core-level spectroscopy, see [this tutorial](/tutorial/lmf/cls/).

For _k_-resolved DOS, and as well as joint projection of _k_ resolved and Mulliken resolved DOS onto orbitals, see [this tutorial](/tutorial/gw/fe_optics/).

### _Obtaining quasiparticle Energy Bands From 1-shot GW_
_____________________________________________________________

The test case

    $ gwd/test/test.gwd fe 1

demonstrates the method to obtain results for a metallic system.

See [Table of Contents](/functionality/application/#table-of-contents)

### _Obtaining a Self-Energy in Dynamical Mean Field Theory_
_____________________________________________________________


See [this document](/docs/code/dmftoverview/) and [this tutorial](/tutorial/qsgw_dmft/dmft0/).

### _Dielectric Response and Optics_
_____________________________________________________________

See [this document](/docs/properties/optics/) and [this tutorial](/tutorial/application/optics/).

### _Spin Susceptibility and Magnetic Exchange Interactions_
_____________________________________________________________

For spin susceptibility in the ASA-Green's function scheme, see [this tutorial](/tutorial/lmgf/lmgf/#b-magnetic-exchange-interactions).

For a demonstration of the transverse magnetic susceptibility in the _GW_ frameowork, try

    $ gwd/test/test.gwd zbmnas 6

### _Properties of Disordered Materials and the Coherent Potential Approximation_
_____________________________________________________________


The ASA Green's function code **lmgf**{: style="color: blue"} can treat chemical and spin disorder, and both at the same time, with the
Coherent Potential approximation.  See [this tutorial](/docs/code/cpadoc/).

### _Molecular Statics_
_____________________________________________________________


For a demonstration, see this test

    $ ~/lm/fp/test/test.fp te

### _Molecular Dynamics_
_____________________________________________________________


**lmf**{: style="color: blue"} can do molecular dynamics, but other DFT codes that 
use iterative diagonalization generally are more efficient.

The [empirical tight-binding](/tutorial/tbe/tbectrl/) code has an efficient 
implementation.

### _Noncollinear Magnetism_
_____________________________________________________________


This is available only in the ASA at present.
There are no tutorials as yet.  However, the source code has a number
of tests that illustrate noncollinear magnetism.  Try

    $ ~/lm/nc/test/test.nc --list

### _Spin Statistics: Relaxation of Spin Quantization Axis_
_____________________________________________________________

**lm**{: style="color: blue"} and **lmgf**{: style="color: blue"}
can perform "spin statics" --- the analog of molecular statics where
the spin quantization axis is relaxed to where the off-diagonal parts
of the spin density matrix vanish.

There are no tutorials as yet.  But try:

    $ ~/lm/gf/test/test.gf nife

### _Spin Orbit Coupling_
_____________________________________________________________

There are no tutorials as yet.  This test demonstrates 
the addition of <i>&lambda;L&middot;S></i> into the band code **lm**{: style="color: blue"}:

    $ ~/lm/nc/test/test.so

Thistest combines CPA and spin orbit coupling in **lmgf**{: style="color: blue"}:

    $ ~/lm/gf/test/test.gf fe2b

A basic test using **lmf**{: style="color: blue"}), comparing 
<i>&lambda;L<sub>z</sub>S<sub>z</sub>></i> to <i>&lambda;L&middot;S></i>:

    $ ~/lm/fp/test/test.fp felz 4

The following provides an extensive test of SO coupling, resolving contribution by site,
and scaling <i>&lambda;L&middot;S></i> to extract the dependence on 
<i>&lambda;</i>

    $ ~/lm/fp/test/test.fp coptso

### _Fully Relativistic Dirac Equation_
_____________________________________________________________

The Dirac equation is implemented in the ASA, in codes **lm**{: style="color: blue"}
and **lmgf**{: style="color: blue"}.

There is no tutorial as yet.  See this demonstration:

    $ ~/lm/gf/test/test.frgf ni

**lmfa**{: style="color: blue"} will generate core levels from the Dirac equation.
See [this tutorial](/tutorial/lmf/lmf_pbte_tutorial/#relativistic-core-levels).

### _Application of External Scalar Potential_
_____________________________________________________________

For the **lmf**{: style="color: blue"} code, try the following demonstration:

    $ ~/lm/fp/test/test.fp mgo

### _Fixed spin-moment_
_____________________________________________________________


One technique stabilize self-consistency in difficut magnetic calculations,
or to extract quantities such as the magnetic susceptibility, you can
imposed a fixed magnetic moment by imposing distinct Fermi levels for
each spin.  This is equivalent to imposing a static, <i>q></i>=0 Zeeman field.

The following tests demonstrate the fixed-spin moment technique

    $ fp/test/test.fp felz
    $ fp/test/test.fp ni

### _Application of External Zeeman B Field_
_____________________________________________________________

In the ASA, try the following demonstrations

    $ ~/lm/nc/test/test.nc 5 6

In the FP code, try the following demonstration

    $ ~/lm/fp/test/test.fp gdn

### _Using Functionals Other Than LDA_
_____________________________________________________________

**lmf**{: style="color: blue"} demonstrates the PBE functional with this test:

The ASA code demonstrates the PBE functional with this test:

    $ ~/lm/fp/test/test.fp te

The ASA code **lm**{: style="color: blue"}
demonstrates the PBE functional with this test:

    $ ~/lm/testing/test.lm kfese

See [this annoated output]((/docs/outputs/lmf_output/#lda-functionals)

### _LDA+U_
_____________________________________________________________

The following tests illustrate LDA+U in the **lmf**{: style="color: blue"} code:

    $ ~/lm/fp/test/test.fp cdte
    $ ~/lm/fp/test/test.fp gdn
    $ ~/lm/fp/test/test.fp eras
    $ ~/lm/fp/test/test.fp er

In the ASA, try

    $ ~/lm/testing/test.lm er

See [Table of Contents](/functionality/application/#table-of-contents)

### _Adding a Homogenous Background Density_
_____________________________________________________________

Try the following demonstration:

    $ ~/lm/fp/test/test.fp c


### _Band Edge and Effective Mass Finder_
_____________________________________________________________

Finding band edges in complex semiconductors and insulators can be a tedious exercise.
[This tutorial](/tutorial/lmf/lmf_bandedge/) explains a tool that automates the process
and also gives effective mass tensors around band extrema.

### _Building a Supercell_
_____________________________________________________________

For now, look at these tests:

    $ ~/lm/testing/test.lmscell --list

### _Point Defects in Large Supercells_
_____________________________________________________________

Tutorials are in progress.  If you are interested contact us.

### _Special Quasirandom Structures_
_____________________________________________________________

For now, do this test for an SQS structure of NiO

    $ ~/lm/testing/test.lmscell 4

### _Spin Dynamics_
_____________________________________________________________

No tutorials yet, sorry.

### _Phonons_
_____________________________________________________________

No tutorials yet, sorry.

See [Table of Contents](/functionality/application/#table-of-contents)

### _Other Notes_
_____________________________________________________________

#### _Techniques for Brillouin Zone Integration_

Techniques for 
Brillouin zone integration are described some detail [here](/docs/numerics/bzintegration/).

#### _How to Make Integer Lists in Various Contexts_

The syntax for integer lists is described [here](/docs/input/integerlists/).
In some contexts lists can consist of real numbers.  The same rules apply.

#### _How to Define Rotations in Various Contexts_

Rotations are used for crystal axes, spin quantization axes, and in
a few other contexts.  They are constructed by a succession of angles
around specified axes.  [This page](/docs/input/rotations/) explains
how to specify rotations.

#### _How Site Positions are Read by the Input File_

Lattice data (lattice vectors and site positions) can be read in different
ways.  See [this page](/docs/input/sitefile/).

#### _Angular Momentum in the Questaal suite_

Questaal codes use real harmonics <i>Y<sub>lm</sub></i> by default,
which are real linear combination of spherical harmonics Y<i><sub>lm</sub></i>.
The ASA codes will, however, use true spherical harmonics
if you set [**OPTIONS_SHARM**](/docs/input/inputfile/#options) to true.

The <i>Y<sub>lm</sub></i> are functions of solid angle, while
<i>Y<sub>lm</sub>r<sup>l</sup></i> are polynomials in _x_, _y_, and
_z_.  [This page](/docs/numerics/spherical_harmonics/)
documents Questaal's conventions for real and spherical harmonics.
and shows the polynomial forms of hte <i>Y<sub>lm</sub></i>
for _l_=0&hellip;3.

See [Table of Contents](/functionality/application/#table-of-contents)
