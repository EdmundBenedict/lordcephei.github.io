---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/fpnew/"
header: no

---

# Tutorial For The Full-Potential LDA Program **lmf** (v0.00)  



### _Purpose_
________________________________________

This tutorial demonstrates the all-electron, full-potential LDA program **lmf**. It:

1. describes how to build the input file, by categories. You can build input files automatically from structural data, but this section is worth going through nevertheless.

2. Some checks are made and a band pass is explained.

3. The basis set is tuned.

4. explains the output of a self-consistent calculation, and how to create energy bands and density-of-states

5. shows how to compute shear constants *c*<sub>11</sub>−*c*<sub>12</sub> and *c*<sub>44</sub> in Al.

In this tutorial two of the three elastic constants in Al are calculated. Build the input file yourself, or copy [ctrl.al](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/FPsamples/ctrl.al) and skip immediately to the electronic structure calculations.  



### _Prerequisites_
________________________________________

You will need the executables **lmchk**, **lm**, **lmstr** etc in your path (all of these are installed when scons is run with the target flag *all*).

It is assumed you have read the ASA documentation and the FP documentation, how the input file is structured and have gone through the ASA tutorial, and you understand how the file preprocessor works.  



### _Tutorial_
________________________________________

This tutorial gives a brief outline as to the commands and procedures required to use the **lmf** program for users who may have experience with the program already. More detailed instructions can be found in each section should you require them.

_Note:_ All instances of _al_ in the command lines can be replaced with _*ctrl.al*{: style="color: green"}_, depending on what your input file has been named.  



#### _1\. Building The Input File_
________________________________________

It is assumed for the tutorial that the specific categories in the input file are known. The sample input file for Al is provided [here](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/FPsamples/ctrl.al). 

The input file and all of its categories are properly explained [here](/fpinputfile/).  



#### _2\. Getting Started: Analyzing The Results Of A Band Pass_
________________________________________

Use **lmchk** to verify:

*    The preprocessor works as advertised:
         
         lmchk al --showp

     For example, the line containing *RSMH=*{: style="color: blue"} should have been turned into 

         RSMH=1.8,1.8,1.8	EH=-.1,-.1,-.1

*    Invoke:

         lmchk al

     And verify from the output that the sphere overlaps about 0.6% (a safe number) and that sum-of-sphere volumes equals about 75% of the total.

Use **lmfa** to generate densitites for the free atom. Atomic densities will be overlapped to make a first trial density for the solid (Mattheis construction).

        lmfa al

Invoke **lmf** in a non self-consistent mode:
        
        lmf al -vhf=1

A full description and the output from this command can be found in the extended tutorial [here](/fpbandpass/).  



#### _3\. Optimizing The Basis Set_
________________________________________

*    One can optimize RSMH efficiently with:

        lmf al --optbas 

     You can take the result of the optimized calculation (saved in *basp2.ext*{: style="color: green"}) and copy them to your input file. Or, you can have lmf automatically read these parameters from file basp; tokens in *HAM_AUTOBAS*{: style="color: blue"} control what **lmf** reads from this file, and what **lmfa** writes to it.

*    We might consider the effect of enlarging the basis, which as we noted we can do from the commmand line with *-vbigbas=1*{: style="color: blue"}. Do this:

        lmf al -vbigbas=1 -vhf=1 

Read more about basis sets [here](/fpbasisset/).  



#### _4\. Self-consistent LDA calculation_
________________________________________

We can do a self-consistent calculation with:

        lmf al > out 

Up to the calculation of the Fermi level the output will be essentially the same.

Now the [output density](FPsamples/out.al.lmf#outrho) is generated. With the output density, the HKS energy functional can be evaluated. Also the log derivative parameters P are floated to the band centers-of-gravity. How the P's are floated is prescribed by tokens [IDMOD](tokens.html#SPECcat); there is a corresponding ASA counterpart discussed in the [ASA overview](lmto.html#section2).

A [new density](FPsamples/out.al.lmf#mixrho) is constructed as follows:

*    The _output density_ is screened using the model Lindhard function, provided the Lindhard parameter [ELIND](tokens.html#HAMcat) is nonzero:

        $$ n_{out}^* = n_{in} + eps^{-1} (n_{out}-n_{in}) $$ 

*    An estimate for the self-consistent density is made by mixing n<sub>in</sub> and n<sub>out</sub><sup>*</sup> using some [mixing scheme](tokens.html#mixing).

*    The resultant density is [saved](FPsamples/out.al.lmf#iors) in *rst.ext*{: style="color: green"}, unless you specify otherwise using *--rs=*{: style="color: blue"}.

*    At the end of the iteration, the total energies are printed and checks are made whether self-consistency is achieved to tolerances specified by [ITER_CONV](tokens.html#ITERcat) and [ITER_CONVC](tokens.html#ITERcat). The RMS DQ generated at the [mixing step](FPsamples/out.al.lmf#mixrho) is the measure compared against tolerance [CONVC](tokens.html#ITERcat); the change in energy from one iteration to the next is tested against tolerance [CONV](tokens.html#ITERcat). Both tolerances must be satisfied, unless you set CONV=0 or CONVC=0 (0 tolerance tells **lmf** not to test that parameter).

Look at this [page](/fpldacalc/) for LDA calculations.  



#### _5\. Shear constants_
________________________________________

This section shows how to calculate two of the three independent shear constants in Al. We first calculate *c*<sub>11</sub>−*c*<sub>12</sub>, which we will do by computing the total energy at different lattice distortions, and fitting the curvature of the total energy. The tetragonal distortion is conveniently generated using the line

        SHEAR=0 0 1 1+dist 

which distorts the lattice in a way that conserves volume to all orders (this is useful because it tends to be less error-prone). The direction of distortion is set by the first three parameters; the lattice will be sheared along (001).

The first difficulty is that our specification of the FT mesh using token GMAX may cause the program to switch meshes for as parameter _dist_ changes. This is a bad idea, since we want to resolve very small energy differences. So, the first step is to comment out the line with *GMAX=gmax*{: style="color: blue"} in the input and use instead:

        FTMESH=10 10 10 

The second difficulty is that the shear constants in Al are difficult to converge, because they require many _k_-points. The following steps are written in 'tcsh' and compute the self-consistent total energy parameterically as a function of 'dist':

           rm -f out save.al
           foreach x ( -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04)
               rm -f mixm.al wkp.al
               lmf al -vdist=$x -vnk=24 --pr20,20 >>out
           end
        
Note that the mixing file eigenvalue weights file (*mixm.al*{: style="color: green"} and *wkp.al*{: style="color: green"}) are deleted for each new shear calculation. File save.al contains total energies ehf for 9 values of dist using 24 divisions of k-points. (To properly converge the calculation use *nk=32*{: style="color: blue"} or even *nk=40*{: style="color: blue"}.)

Extracting ehf and ehk parametrically as a function of dist is very easy with the [vextract](Building_FP_input_file.html#vextract) tool:

        cat save.al | startup/vextract c dist ehf > dat 

The key 'c' tells vextract that you want lines beginning only with 'c': these lines correspond to band passes when [self-consistency](Building_FP_input_file.html#vextract) was reached. You can use any regular expression for the key. You can ask vextract to extract any quantity associated with a variable in the file.

A trigonal shear will yield c<sub>44</sub>. To compute it, replace the SHEAR token with:

        SHEAR=1 1 1 1+dist 
        
Both of these elastic constants depend on the fitting procedure with an uncertainty of about 5%. A careful calculation would use more points dist and increase nk. The final shear constant, the bulk modulus, you can calculate by varying the lattice constant. We do not do it here, but if you do this, you are advised to use token *STRUC_DALAT*{: style="color: blue"}, rather than change ALAT (see the following note).  



#### _6\. Other things to read and do_
________________________________________
        
You can generate and plot the energy bands using **lmf**. It proceeds in the same way as in the [ASA tutorial](/asadoc/). Generate the band file this way:

        cp startup/syml.fcc ./syml.al
        lmf al --band:fn=syml 

The generation of the core-level spectroscopy, Mulliken analysis or density-of-states is done first by invoking **lmf** with the appropriate [command-line switch](fp.html#section3), followed by **lmdos**. The **lmdos** step is illustrated (including a way to plot results) in the [ASA tutorial](/asadoc/).

To compute the density of states, see [this tutorial](generating-density-of-states.html). To compute core-level EELS spectra or Mulliken analysis in Fe, try running

        fp/test/test.fp fe 2 

To compute total or partial DOS in hcp Co, try running

        fp/test/test.fp co 2 

Read about bandpass [here](/fpbandpass/).  



### _Further Reading_
________________________________________

**lmf** has many other useful features not described in this tutorial. Look at [this page]() for information about other tools and kinds of calculations available.  



### _Issues Or Comments_
________________________________________


