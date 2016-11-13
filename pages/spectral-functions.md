---
layout: page-fullwidth
title: "Spectral function calculations with lmgf "
subheadline: ""
show_meta: false
teaser: ""
permalink: "/docs/code/spectral-functions/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Preliminaries_
_____________________________________________________________

Spectral function was implemented in **lmgf**{: style="color: blue"} **v7.10** by _Bhalchandra Pujari_ and _Kirill Belashchenko_ (_belashchenko@unl.edu_). The details of the theory in the CPA case can be found in

_I. Turek, V. Drchal, J. Kudrnovský, M. Šob, P. Weinberger._ **Electronic structure of disordered alloys, surfaces and interfaces**. _Kluwer academic publishers (1997), see Eqs. (4.25)-(4.29)_

### _How to calculate spectral functions?_
_____________________________________________________________

The spectral function can be calculated both with and without CPA. The calculation is performed in 3 steps:

+ Charge self consistency. (The spectral function can be calculated for any potential, but it is usual to work with the self-consistent one).
+ CPA self-consistency in the coherent interactor $$\Omega$$ (CPA only). Since $$\Omega$$ is energy dependent, it has to be calculated for the energy points where the spectral function is needed. For drawing spectral functions this is usually a uniform mesh of points close to the real axis.
+ Calculation of the spectral function on some contour, usually a uniform mesh close to the real axis.

**Charge self consistency**{: style="color: orange"} is performed in the usual manner, for example with the following options:

    BZ       EMESH=31 10 -.9 0 .5 .0
    GF       MODE=1 DLM=12 GFOPTS=p3;omgmix=1.0;padtol=1d-3;omgtol=1d-5;lotf;nitmax=50
    
Note the **EMESH mode** (contour type) is elliptical (type 10). If CPA is used, the coherent interactors $$\Omega$$ for all CPA sites are also iterated to self-consistency during this calculation, but this is done for the complex energy points on the elliptical contour. The following additional step is needed in this case to obtain self-consistent $$\Omega$$ at those points where the spectral function will be calculated.

**Omega self-consistency**{: style="color: orange"} is turned on by setting **DLM=32**. In this mode only Ω for each CPA site is converged, while the atomic charges are left unchanged. It is important to converge Ω to high precision. Typically **omgtol=1d-6** is a good criterion. The contour type should be set to 2. Example input for this step is

    BZ       EMESH=150 2 -.25 .25  .0005  0
    GF       MODE=1 DLM=32  GFOPTS=p3;omgmix=1.0;padtol=1d-3;omgtol=1d-6;lotf;nitmax=50
   
The highlighted parameters are of particular importance. lotf is required to iterate $$\Omega$$ for convergence (and it is recommended to keep it enabled in all CPA calculations, including charge self-consistency). It is also necessary to monitor the output file (set **\-\-pr41**) and make sure that the required precision has been achieved for all energy points. If convergence appears to be problematic, try to start with a larger imaginary part for the complex energy or reduce the mixing parameter omgmix.

Calculation of the spectral function should be done with **EMESH** set to the same mesh as used for $$\Omega$$ self-consistency, e.g.

    BZ       EMESH=150 2 -.25 .25  .0005  0
    GF       MODE=1 DLM=12 GFOPTS=p3;omgmix=1.0;padtol=1d-3;specfun

**Important: If there are sites treated in CPA, the contour specified by EMESH should be kept exactly as in the previous step when CPA self-consistency was performed.**

In order to start the calculation, invoke **lmgf**{: style="color: blue"} with the **\-\-band** flag referring to the symmetry-line file (same format as used for band structure calculation with **lm**{: style="color: blue"}):

    lmgf «sys» --band:fn=syml 

where _«sys»_ is the extension of the **ctrl**{: style="color: green"} file. Once completed, the program will generate a **spf.«sys»**{: style="color: green"} file containing the complete spectral function along the lines given in the **syml.«sys»**{: style="color: green"} file. Other options included with **\-\-band** are currently not used. 

### _Plotting of the spectral function_
_____________________________________________________________

Upon successful completion of calculation **spf.«sys»**{: style="color: green"} file will be generated. The file has the [following format](/docs/input/data_format/#the-spf-file):

    ZP        KP         SF_UP         SF_DN
    .
    .
    -0.250   0.137      5.708839      4.742153
    -0.250   0.160     10.658114      4.844647
    .
    .

where _ZP_ are the points on the energy contour, _KP_ are the points of the K-mesh and SF_UP, SF_DN are the spectral functions for Up and Down channel respectively. The very first line of the file indicate the location of the high symmetry points of the Brillouin zone. User can utilize this information to visualize the spectral function using any desired graphics package. A small bash utility, **SpectralFunction.sh**{: style="color: green"}, is given for the sake of convenience. This bash script uses Gnuplot to view and save the spectral function. Users with standard Linux/unix distro should be able to use it without special prerequisites. Typical output of the script is shown in the figure. Please see SpectralFunction.sh -h for usage. (The file **spf.«sys»**{: style="color: green"} should be renamed **specfun.«sys»**{: style="color: green"} to be read by this script. See below why.) 

### _Site-resolved spectral functions_
_____________________________________________________________

Site-resolved spectral functions can be obtained by including the option **specfr** in **GFOPTS**. (It supersedes the option specfun.) A series of output files will then be generated, which contain the spectral function on each basis site . The file names are **spfN.«sys»**{: style="color: green"}, where N is the index of the site. The format of this file is the same as for **spf.«sys»**{: style="color: green"}, and it can be also plotted using the SpectralFunction.sh script (first rename to **specfun.«sys»**{: style="color: green"}). 


### _Notes_
_____________________________________________________________

+ Spectral function calculations can be run with MPI parallelization.
