---
layout: page-fullwidth
title: "Dielectric function and other optical properties"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/application/optics/"
header: no
---

_____________________________________________________________

### _Purpose_

To calculate optical and related properties using the **lmf**{: style="color: blue"} or **lm**{: style="color: blue"} code.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

_____________________________________________________________

### _Preliminaries_

This tutorial calculates optical properties of PbTe using **lm**{: style="color: blue"} or **lm**{: style="color: blue"}.  
There is a [full potential tutorial](/tutorial/lmf/lmf_pbte_tutorial/)
for PbTe as well as an [ASA tutorial](/tutorial/asa/lm_pbte_tutorial/).
See either of those tutorials to build the self-consistent density.

You can begin this tutorial once you have the self-consistent density in hand.

_____________________________________________________________

### _Tutorial_

#### _Introduction_

The full-potential (FP) and the Atomic Spheres Approximation (ASA) implementations of the code executed through  **lmf**{: style="color: blue"} and  **lm**{: style="color: blue"} respectively, have the capacity to preform a number of equilibrium and non-equilibrium optical and electronic calculations. This tutorial will only focus on the equilibrium calculation for optical properties and the joint density of states (JDOS), non-equilibrium modes will be covered here(HYPERLINKTHIS).

#### _Input File_

Using the optics mode for calculating JDOS or the imaginary part of the complex dielectric function  can be done in two steps. The first step is to include a new category in the control file with associated tokens, an example of what needs to be included for a simple calculation is shown below:

      OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 LTET=3

the category above describes all necessary information needed to calculate the imaginary part of the complex dielectric function. The tokens above indicate an optics calculation mode 1 which is the imaginary part of the dielectric function, calculated for an energy range of (&minus;1,0) Ry (indicated by WINDOW token) with an energy mesh density of 1001 using the  enhanced tetrahedron integration method (determined through LTET). Further more the token **FREE=F** should be added to the start category in the control file.

#### _Preforming calculations_

To preform this calculation simply add the text above to the ctrl file (in this tutorial we will use **lm**{: style="color: blue"} and GaAs) and invoke:

    $ lm -vnit=1 ctrl.pbte

or equivalently for the FP implementation

    $ lmf -vnit=1 ctrl.pbte

(**NOTE**: the **START** category is not used in full-potential calculations and hence can be ignored)additional switches are added to restrict the number of iteration to one, it is also recommended to include the switch  **-\-rs=1,0** for FP calculations which will read the saved density from disk but will not update the electron density; this insures that all calculations after self-consistent calculation are preformed on the same density.

#### _Output file_

The output file of the optics mode can vary by mode, for the mode above the file will be named _opt.pbte_{: style="color: green"}, and will contain 4 columns and 1002 rows in the standard [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) for 2D arrays. The first row contains brief metadata; the columns from left to right are energy value (in Ry), followed by values for the imaginary part of the dielectric function for three orientations of the electric field polarization.

#### _Further Optics Modes_

##### _Imaginary part of the dielectric function_
The optics **mode=1** used above calculates the dielectric function for the nonmagnetic cases (**HAM\_NSPIN=1**) or analytic implementation of SOC(**HAM\_SO=1**), in the cases of polarized spin or perturbation based implementation of SOC **OPTICS_MODE=1** only calculates Im<i>&epsilon;</i> for spin up, to preform the same calculation for spin down electrons **OPTICS\_MODE=2** must be used.

##### _Single and Joint Density of States(DOS)_

It is possible to calculate  Single DOS and the Joint DOS (JDOS) through the optics category of the control file. These calculations are preformed by simply using **OPTICS_MODE-1** to **-4** for JDOS calculations, and **-5** and **-6** for density calculations and running the **lm**{: style="color: blue"} or **lm**{: style="color: blue"} as describe for Im<i>&epsilon;</i> calculations above.
The six modes described above correlate to

    mode=:
       		-1: generate JDOS, similarly to mode=1 this generates complete JDOS in case of unpolarized spins and  so=1, otherwise JDOS for spin 1
       		-2: generate JDOS for spin 2, similarly to mode=2 this generates JDOS for the second spin  in cases of polarized spin and so=3
       		-3: generate JDOS between spin 1 and spin 2
       		-4: generate JDOS between spin 2 and spin 1
       		-5: generate single DOS for spin 1
       		-6: generate single DOS for spin 2

The output files for all six optics modes described above  consists of 2 columns ( the number of rows is **OPTICS_NPTS** plus and additional meta data line), the first of which is energy (in Ry) followed by the corresponding JDOS or DOS values.

#### _Resolving output_
Both **lm**{: style="color: blue"} and **lmf**{: style="color: blue"} offer a range of option to resolve Im<i>&epsilon;</i>,DOS and JDOS through **OPTICS_PART**, **OPTICS_FILBND** and **OPTICS_EMPBND**, the options described here apply to all of the optics modes described above (Im<i>&epsilon;</i>,JDOS and DOS).

##### _Occupied and unoccupied bands_

It is possible to perform any of the optics mode calculations described above for a restricted number of bands, this can greatly speed up the calculation and allow for isolation and identification of individual band contributions. To restrict the bands involved in the calculation simply provide a range of values for occupied and unoccupied bands through **OPTICS_PART**, **OPTICS_FILBND** and **OPTICS_EMPBND** respectively. Below is an example of an optics category which calculates the contribution to  Im<i>&epsilon;</i> from the highest two valence bands and the lowest two conduction bands for silicon:

      OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 LTET=3
              FILBND=4,5 EMPBND=6,7
              
The optics output file generated with restricted bands will have the same name and format as unrestricted band calculations, which has been described previously in this tutorial.

##### _Resolve by k, &epsilon; and band to band contribution_
The optical and electronic properties described above can also be separated by band to band contribution through **OPTICS_PART=1**, this method has the advantage that the band to band contributions for a number of bands can be preformed quickly. The output of optical calculations while using **OPTICS_PART=1** is poptt.pbte_{: style="color: green"} the format of this file differs from _opt.pbte_{: style="color: green"}. Details of output format for **OPTICS_PART=1** can be found [here](https://lordcephei.github.io//application/opt-part/).

The contributions to the optical and electronic properties can also be resolved by contributions from single k-points, this can be achieved by preforming the optical calculations above with the added switch **OPTICS_PART=2**. A full tutorial for this option is provided [here](https://lordcephei.github.io//application/opt-part/).

Finally options **OPTICS_PART=1** and **OPTICS_PART=2** can be preformed simultaneously, the output of this option is described [here](https://lordcephei.github.io//application/opt-part/).
