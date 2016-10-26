---
layout: page-fullwidth
title: "Implementation of the Dynamical Mean Field Theory"
permalink: "/docs/code/dmftoverview/"
sidebar: "left"
header: no
---

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Purpose_
{:.no_toc}
_____________________________________________________________
This manual is meant to give the guidelines and a reference for one of the several packages of the Questaal Suite, the one responsible for the execution of a QSGW+DMFT calculation from first principles.

### _Preliminaries_
_____________________________________________________________
In what follows a basic user's background on electronic structure methods, in particular Density Functional Theory, GW methods and DMFT, as well as the LMTO basis set, is assumed. For an overview of the theory, and in particular a specific account of the equations used in the implementation, we will refer to Paolo Pisanti's PhD thesis [2], whose browsing is advised when reading this document.   

The user is also advised to have a basic understanding of the lmf code and familiarity with its usage. For this purpose we refer to [lmf tutorial](/tutorial/lmf/lmf_tutorial/). In particular, this manual has to be considered complementary to a specific tutorial written by Lorenzo Sponza which can be found [here](/tutorial/qsgw_dmft/dmft0/) and whose reading is incouraged.

### _Introduction_
_____________________________________________________________
A schematic flowchart clarifying the structure of the software and the main routines involved in the QSGW+DMFT loop is presented in the figure below. For a formal introduction on DMFT, its assumptions, main equations and key quantities into play we refer to chapter 3, section 3.1 of [2]. The details of our specific implementation of the QSGW+DMFT scheme are instead presented in chapter 4 of [2]. In particular in the next two chapters we will refer to the equations of section 4.2 and 4.3 to illustrate the several steps of the implementation and the different subroutines.   

In chapter 1 we will introduce the structure, main input and output files of the **lmfdmft**{: style="color: blue"} routine (blue box in the image below). The object of this routine is the calculation, from first principles and using as inputs the results of a converged QSGW (or DFT) loop, of the so-called hybridization function $\Delta(\omega)$, defined in DMFT to capture the coupling of the impurity with the surrounding bath in which is embedded. The key steps for such a purpose will be to define and calculate a projection operator to the correlated local subset, employ this operator to define local quantities such as local Green's function and impurity levels, correct the eigenvalues with the embedded impurity self-energy injection, and tune the chemical potential accordingly.

In chapter 2 we will present the Continuous Time Quantum-Monte Carlo (CTQMC) impurity solver (red box in the image below), whose main operation is the calculation of the impurity self-energy $$\Sigma^\text{imp}(\omega)$$. The software has been implemented by Kristjan Haule at Rutgers University and it was originally part of his Wien2k-DMFT code [1]. It has been isolated in such a way to work in connection with the LMTO suite in a QSGW+DMFT implementation. The CTQMC solver takes the hybridization function $\Delta(\omega)$ and the impurity level $E^\text{imp}(\omega)$ originating from the **lmfdmft**{: style="color: blue"} loop as main inputs, together with the effective interactions parameters $U,J$. These parameters are tuned with respect to the material under study and they are typically specific to the DMFT implementation and the solver adopted.

![I/O in the DMFT Loop](/assets/img/inout_dmftloop.svg)

The flowchart of the main routines of the present QSGW+DMFT implementation. The new interface (lmfdmft routine) has been singled out in a red box. This interface connects the main LMTO suite package to the CTQMC solver of DMFT. Image created by Lorenzo Sponza. The gold and green boxes appearing in the image represent the other programs necessary to complete the interface between the two packages. They will also be object of 2nd chapter.

### _Building the DMFT Hybridization Function - Routine lmfdmft_
_____________________________________________________________
This chapter is focused on the first block of the DMFT cycle, the calculation (and update) of the *hybridization function* from the inputs of a converged QSGW (or DFT) calculation. This operation is performed by the routine, part of the Full-Potential package.   

A tutorial written by L. Sponza to run a full QSGW+DMFT calculation and in particular the executable can be found at this [link](/tutorial/qsgw_dmft/dmft1).

#### _Input Files_
In this section an overview of the input files required and their syntax will be presented. The starting point of the DMFT loop are the results of a converged QSGW (or either a DFT) calculation, executed with the package.   

In order to keep consistence with the tutorial, we will refer to _lmfinput/_{: style="color: green"} as the routine containing the original input files and _it\#\_lmfrun/_{: style="color: green"} as the routine containing the \#-th iteration of **lmfdmft**{: style="color: blue"}.

    $ ls -l lmfinput
    ctrl.case
    site.case
    rst.case
    sigm.case
	
    indmfl.case
    sig.inp

An experience user will notice that the first 4 files are regular files belonging to the full-potential package, those are the results of the converged QSGW loop. For a specific discussion of these files, we refer to this [tutorial](/tutorial/lmf/lmf_tutorial/) for **lmf**{: style="color: blue"}. The last 2 files (_indmf1.case_{: style="color: green"} and _sig.inp_{: style="color: green"}) are instead specific of the **lmfdmft**{: style="color: blue"} program and they are used just in DMFT cycles.

##### _Input Files: A Brief Overview_
The is the main input file of, for a full documentation read [here](/docs/input/inputfile/). In order to process this input file in a QSGW+DMFT calculation, one line has to be added to the input file resulting from the QSGW loop, this can be done by means of the following command

    echo 'DMFT    PROJ=2 NLOHI=11,53 BETA=50 NOMEGA=1999 KNORM=0' >> ctrl.case}.

The token _DMFT\_PROJ_ refers to the kind of projection operation, n.2 corresponds to equation (4.6) of [2]. No other option is advised at state of the art. The token _DMFT\_NHOLI_ defines the energy window in which the DMFT projection operator is included. In particular the first number refers to the first band to be included, lower bound of the window and the second number to the last band, upper bound. This energy window is supposed to include the contributions from the correlated subset of orbitals chosen (say, the $3d$-orbitals of Cu), as well as the contributions from orbitals which these bands are hybridized with (e.g. typically in copper oxides, the O $2p$-levels). We refer to section 4.1 of [2] for a guideline on the origin of this energy window and how to use it. The choice of the correct energy window should be inferred by looking at the QSGW bandstructure of the solid and in particular the $\Gamma$ point. The token _DMFT\_BETA_ refers to the inverse temperature, in units of eV$^{-1}$, _DMFT\_NOMEGA_ to the total number of points of the Matsubara frequency mesh on which the dynamical impurity quantities are defined. _DMFT\_KNORM_ is a token related to the kind of renormalization to apply to the projection operator, the value of 0 related to eq.(4.8) of [2] and the value of 1 to the eq. following eq.(4.9), but the second option is strongly discouraged and it will probably be eliminated.    

The file _site.case_{: style="color: green"} displays the atom type and coordinates of the single cell, no modification with respect to the file adopted in **lmf**{: style="color: blue"}. This file can also be incorporated in the _ctrl.case_{: style="color: green"} file by listing it under the token _SITE_. In the case of magnetic calculations, a _site2.case_{: style="color: green"} with the coordinates related to the super-cell is usually employed instead, with the switch _-vfile=2_to be added to the command line.   

The file _rst.case_{: style="color: green"} contains the charge density of the system.   

The content of _sigm.case_{: style="color: green"} file is the QSGW self-energy scaled by the exchange-correlation potential in such a way to eliminate this contribution when updating the Hamiltonian. For this reason when no _sigm.file_{: style="color: green"} file is found the exchange-correlation potential will be read automatically and a DFT+DMFT loop will be carried on.

##### _indfml File_
The _indfml.case_{: style="color: green"} is the key input file in **lmfdmft**{: style="color: blue"}, containing all the parameters required to run the DMFT loop starting from QSGW inputs. It was originally part of K. Haule’s Wien2k-DMFT code [1] and therefore it still contains features which are not meaningful in this implementation. It can be
generated by the script **init\_dmft.py**{: style="color: blue"} taking the _ctrl.case_{: style="color: green"} file as as input or it can be simply copied from other calculations and revised. An example:

    #---- Example of indmfl file---
    0.1 1.2 1 2                # hybridization Emin and Emax, measured from FS, renormalize for interstitials, projection type
    1 0.0025 0.0025 600 -3.000000 1.000000  # matsubara, broadening-corr, broadening-noncorr, nomega, omega_min, omega_max (in eV)
    1                                     # number of correlated atoms
    1     1   0                           # iatom, nL, locrot
      2   2   1                           # L, qsplit, cix
    #================ # Siginds and crystal-field transformations for correlated orbitals ================
    1     5  5       # Number of independent kcix blocks, max dimension, max num-independent-components
    1     5  5       # cix-num, dimension, num-independent-components
    #---------------- # Independent components are --------------
    'x^2-y^2' 'z^2' 'xz' 'yz' 'xy'
    #---------------- # Sigind follows --------------------------
    1 0 0 0 0
    0 2 0 0 0
    0 0 3 0 0
    0 0 0 4 0
    0 0 0 0 5
    #---------------- # Transformation matrix follows -----------
     0.70710679 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.70710679 0.00000000
     0.00000000 0.00000000   0.00000000 0.00000000   1.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000
     0.00000000 0.00000000   0.70710679 0.00000000   0.00000000 0.00000000  -0.70710679 0.00000000   0.00000000 0.00000000
     0.00000000 0.00000000   0.00000000 0.70710679   0.00000000 0.00000000   0.00000000 0.70710679   0.00000000 0.00000000
    -0.70710679 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.70710679 0.00000000

Let us review the content block by block.

    0.1 1.2 1 2                \# hybridization Emin and Emax, measured from FS, renormalize for interstitials, projection type}

The first 2 entries indicate the minimum and maximum values for the energy window entering the projector. These values are calculated from the eigenvalues at the $\Gamma$ point in correspondence of the bands indicated in the _DMFT\_NLOHI_ token of the _ctrl.case_{: style="color: green"} file. The 3rd value regards a normalization option for the interstitials which is not taken into account in this code and the 4th entry is equivalent to the token _DMFT\_PROJ_ of _ctrl.case_{: style="color: green"}.

    1 0.0025 0.0025 600 -3.000000 1.000000  \# matsubara, broadening-corr, broadening-noncorr, nomega, omega\_min, omega\_max (in eV)

The first entry is a switch for Matsubara frequencies (1 for true, 0 for false), but the impurity solver does not handle real frequencies so only the option 1 is advised. The 2nd and 3rd values are broadening parameters not taken into account. The same can be said about the 4th, 5th and 6th entry, controlling \# of frequency points, minimum and maximum frequency.

    1                                     # number of correlated atoms
    1     1   0                           # iatom, nL, locrot
      2   2   1                           # L, qsplit, cix

This block defines the local subset of correlated orbitals chosen   
First line: the 1st entry indicates the total number of different correlated atoms (equivalent or non-equivalent ones).   
Second line: there will be a line like this for each of the correlated atoms specified at the line before (just 1 in this case). The index _iatom_ points to the specific atom chosen with respect to the legend in the _site.case_{: style="color: green"} file, _nL_ to the number of different orbital characters for this atom (e.g. for both $p$,$d$ Copper orbitals _nL_ would be 2) and is a flag controlling local rotations (1 or 0).   
Third line: specifications for atom of the previous line. gives the value of the angular momentum (orbital $d$ in this case), _qsplit_ refers to the Harmonic orbitals basis in which the projector and hybridization function are written, _cix_ indicates the correlated block which this correlated set of orbitals belongs to. If orbitals of different character are included in the same block they will all be listed in the same file for the hybridization function and impurity self-energy. In this case the user will have the possibility of handling matrix elements (referring to the indices $LL'$ of section 4.1 of [2]) of mixed character, say, Oxigen-2$p$ and Copper-3$d$ for what regards the local functions.

    #================ # Siginds and crystal-field transformations for correlated orbitals ================
    1     5  5       # Number of independent kcix blocks, max dimension, max num-independent-components
    1     5  5       # cix-num, dimension, num-independent-components

This block gives indications regarding the correlated blocks included. The first line is a comment line. The entries at the second and third line define the same quantities except the second line refers to the maximum values for all the correlated blocks included and the second line for the specific block considered (in this case they are equivalent having selected just one block of orbitals). The 3 entries indicate the block index, its dimension (which corresponds to the value of $2\ell+1$) and the number of independent components (in the case of degeneracy this number is smaller than the dimension of the matrix).

    #---------------- # Independent components are --------------
    'x^2-y^2' 'z^2' 'xz' 'yz' 'xy'

This block is just explanatory and not read in the code. The second line gives the $m$-character order of orbital components of the $L$ index, with $2\ell+1=5$ in the case of $d$-shells.

    #---------------- # Sigind follows --------------------------
    1 0 0 0 0
    0 2 0 0 0
    0 0 3 0 0
    0 0 0 4 0
    0 0 0 0 5

This block refers to the matrix elements of the impurity self-energy contained in the _sig.inp_{: style="color: green"} file. It indicates the matrix of components in the $LL'$ basis following the notation of the previous block. In this example just the diagonal matrix elements are included with no degeneracy.   
A typical case of degeneracy in 3$d$ systems reduces the total number of components to 3 with the matrix looking like

    #---------------- # Transformation matrix follows -----------
     0.70710679 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.70710679 0.00000000
     0.00000000 0.00000000   0.00000000 0.00000000   1.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000
     0.00000000 0.00000000   0.70710679 0.00000000   0.00000000 0.00000000  -0.70710679 0.00000000   0.00000000 0.00000000
     0.00000000 0.00000000   0.00000000 0.70710679   0.00000000 0.00000000   0.00000000 0.70710679   0.00000000 0.00000000
    -0.70710679 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.00000000 0.00000000   0.70710679 0.00000000

This last block gives the transformation matrix from the harmonic basis chosen to complex spherical harmonics. It is another feature of Wien2k-DMFT code, not used in. A unitary transformation of this matrix (according to Kristjan’s Haule notation) gives the matrix appearing in the file which on the contrary is employed and will be described later.   
The reader will find a more extensive example of a indmfl file [here](assets/download/examples/indmflex.lsco) in the case of super-cell and different blocks of correlated orbitals, the corresponding super-cell site file is [here](assets/download/examples/siteex.lsco).

##### _sig.inp file_
The _sig.inp_{: style="color: green"} file contains the impurity self-energy resulting from the impurity solver. Specifically it is obtained from the file _Sig.out_{: style="color: green"} resulting from the _CTQMC_ solver and applying an operation of broadening to it as explained [here](/tutorial/qsgw_dmft/dmft2/). It is read in **lmfdmft**{: style="color: blue"} to update the local Green’s function and the hybridization function after an operation of embedding of the local impurity self-energy. The structure of this file is the following: a first column listing the values of Matsubara frequencies included (as many values as the token _DMFT\_NOMEGA_ indicates), and the other columns listing the complex values of $\Sigma^\text{imp}$ in the order and total number indicated in the block of the file (see previous section). An example of the first lines (referred to the convention of the of the previous section):

    #---- Example of siginp file (after several iterations)---
    # broad_sig.f90 : input parameters = Sig.out  230  l  (55  20  230)  k  (1 2 3 2 3)
        0.06283185      78.23564148   -0.04490779      78.62860107   -0.03800205      80.56986618   -0.45687344      78.62860107   -0.03800205      80.56986618   -0.45687344
        0.18849556      78.22446442   -0.13346720      78.61967087   -0.11252947      80.72179031   -0.74727110      78.61967087   -0.11252947      80.72179031   -0.74727110
        0.31415927      78.20281219   -0.21841954      78.60257339   -0.18401078      80.78148651   -0.94496335      78.60257339   -0.18401078      80.78148651   -0.94496335
        0.43982297      78.17199707   -0.29778469      78.57825470   -0.25096695      80.76762009   -1.11261369      78.57825470   -0.25096695      80.76762009   -1.11261369
        0.56548668      78.13374329   -0.37015086      78.54793167   -0.31232700      80.72345734   -1.26635915      78.54793167   -0.31232700      80.72345734   -1.26635915

The total number of column is 11. The first one lists the frequencies, the other 10 are the complex values (real and imaginary part) of the self-energies related to the 5 components of the $d$-orbitals (as indicated by the _sigind_ matrix).   
At the first iteration the self-energy is null, therefore the only non-zero column will be the first one listing the frequencies. The user will not need to prepare a blank file for the first iteration. When **lmfdmft**{: style="color: blue"} is executed a suitable file will automatically be created. The **lmfdmft**{: style="color: blue"} command will then have to be called twice in the first iteration, one to create the zero _siginp_{: style="color: green"} file, and a second one for the actual execution of the first loop.

#### _The lmfdmt cycle and its main subroutine: sudmft.f_
This section will be dedicated to a focus on the of the **lmfdmft**{: style="color: blue"} executable, with a description of its key steps together with the corresponding subroutines. We will refer to sections 4.2 and 4.3 of [2] and in particular Figures 4.1 and 4.2 for reference.   
The main body of **lmfdmft**{: style="color: blue"} is the **sudmft.f**{: style="color: blue"} subroutine, this is a list of its main steps (with a reference to the subroutines executing the several operations):

-   Read the _indmfl_{: style="color: green"} file and store the parameters needed to build the projector. This operation is carried on by routine.

-   Read the charge density from the _restart_{: style="color: green"} file, the QSGW self-energy from the _sigm_{: style="color: green"} file (when no _sigm_{: style="color: green"} file is found a LDA calculation is assumed) and diagonalize the QSGW Hamiltonian to return a set of quasi-particles eigenvalues and eigenvectors (see top block of Fig.4.2) in the FP-LMTO basis (introduced in sec. 4.1.1.1).   
    This operation is carried on by routine. It is the first conceptual step of the DMFT loop, repeated for each iteration but with the same results. This is because the QSGW Hamiltonian and eigenvalues are frozen, whereas the other quantities are updated up to DMFT convergence.
	
-   Read the impurity self-energy file _siginp_{: style="color: green"} and store the content in an array. This operation is carried on by **readsiginp**{: style="color: blue"} routine. At the first iteration _siginp_{: style="color: green"} is null and the code will recognize not to take any double-counting into account.

-   Construct the un-normalized DMFT projection operator (eq. (4.6)), by routine . Build the overlap matrices Olapm and use those to renormalize the projectors (eq. (4.8)), this operation follows the call of **makeproj**{: style="color: blue"}  in **sudmft**{: style="color: blue"} . The projector is then dumped to disk.

-   Embed the impurity self-energy from the local into the full-space basis using the projector just generated (according to eq.(4.3b)) and remove the DC contribution (eq.(4.23)). This operation is carried on by **embed\_sigma**{: style="color: blue"} routine.

-   Tune and update the chemical potential. This operation in quite elaborate, we refer to sec.4.4.3 for details. It requires the diagonalization of the Hamiltonian over all Matsubara frequencies after updating it with the embedded impurity self-energy (routines **makehbar2**{: style="color: blue"}  and **agonham**{: style="color: blue"}). The following step is to update the valence charge from the corresponding dynamical eigenvalues (routine **cmpvalcharg\_matsub4**{: style="color: blue"}). Finally determine the correct correction $V$ to the chemical potential in such a way to return the correct electron number (routine **getVnew**{: style="color: blue"}).

-   Define the local functions by means of the projection operator and the correction from the embedded impurity self-energy. The local Green’s function (eq. (4.24)) is generated by routine **makegloc2**{: style="color: blue"} and the impurity levels (eq. (4.25)) by routine **makeeimp**{: style="color: blue"}. These functions are both written to disk.

-   Build the Hybridization function (according to eq. (4.19)) and store it into disk. This operation is carried on by **makedelta3**{: style="color: blue"} routine.

##### _New feature: Total QSGW+DMFT charge density_
The steps just summarized are the key features of routine, representing the first block of the DMFT cycle (the second block is the object of next chapter), they are therefore repeated for each iteration of the cycle.   
When DMFT convergence is reached the **lmfdmft**{: style="color: blue"} executable can be adopted with a specific flag to extract the total charge density, updated by means of the converged impurity self-energy. This procedure is carried on following the prescription of [1], and it is a recent implementation coded by L.Sponza. For a review of this operation, together with the routines of **lmfdmft**{: style="color: blue"} responsible for its execution, we refer to section 6.3 of this [manual](assets/download/docs/sponza-notes.pdf) written by L. Sponza.

#### _Output Files_
In this section we present an overview of the main output files of the **lmfdmft**{: style="color: blue"} cycle. They will be the content of the so-called _it\#\_lmf_{: style="color: green"} folder, where the \# stands for the given iteration. The iterations following the first one use as input the impurity self-energy resulting from the _CTQMC_ solver, object of next chapter. Here we present the simple case of the output files of the first iteration.

    #---- Output of lmfdmft run (in chronological order)---
    evec.case
    wkp.case
    moms.case
    proj.case
    delta.case
    eimp1.case
    gloc.case
    log.case
    log

The first three files are regular outputs of **lmf**{: style="color: blue"}, binary files containing respectively the eigenalues (_evec_), information regarding the $k$-point mesh (_wkp_) and momentum (_moms_). They are temporary inputs used to produced the other outputs and they are not taken as inputs in the following steps of the DMFT cycle.   
The _proj.case_{: style="color: green"} file is another binary output storing the DMFT projection operator. It is generated and stored to disk on the fly and then read to define the local functions.   
The _gloc.case_{: style="color: green"} is instead an ASCII file, containing the local correlated Green’s function $G^\text{loc}_{LL'}(\omega_n)$ as a function of Matsubara frequencies. The file structure is the same as for the _sig.inp_{: style="color: green"} file, with as many columns as the correlated orbitals selected in the _Sigind_ block of the _indmfl_{: style="color: green"} file. The _gloc.case_{: style="color: green"} is not taken as input by other routines but it is a useful reference for other operations (such as the analytic continuation).   
The files _delta.case_{: style="color: green"} and _eimp1.case_{: style="color: green"} are ASCII files representing the key output of **lmfdmft**{: style="color: blue"}. They are taken as input by the _CTQMC_ impurity solver.   
What said about the _gloc.case_{: style="color: green"} file’s structure is equivalent for _delta.case_{: style="color: green"}, storing the hybridization function in the correlated local basis. The _eimp1.case_{: style="color: green"} file contains instead the impurity levels and the double-counting constant used. The file has a composite structure tailored to be parsed by the scripts of the interface in the _CTQMC_ solver. An example:

    #---- Example of eimp1.case file---
    Edc=[  25.500000,  25.500000,  25.500000,  25.500000,  25.500000,  25.500000,  25.500000,  25.500000,  25.500000,  25.500000]  # Double counting
    Eimp=[   0.326716,   0.393662,   0.061104,   0.460181,   0.061165,   0.326705,   0.393612,   0.061085,   0.460140,   0.061127] # Eimp: P.(e+E.sbar)-sinp-mu+Edc
    Eimp=[   0.000000,   0.066946,  -0.265612,   0.133464,  -0.265551,  -0.000011,   0.066895,  -0.265631,   0.133423,  -0.265589] # Eimp: shifted by Eimp[0]
    Ed [ -25.173284, -25.106338, -25.438896, -25.039819, -25.438835, -25.173295, -25.106388, -25.438915, -25.039860, -25.438873] # Ed: Eimp-Edc for PARAMS
    mu   25.173284 # mu = -Eimp[0] for PARAMS

The _log_{: style="color: green"} file shows the several passages of the routine summarized in the previous section. Let us review a portion of its content (in the case of the first iteration for zero _sig.inp_{: style="color: green"}).

    #---- First block of log file---
    iors  : read restart file (binary, mesh density) 
    use from  restart file: ef window, positions, pnu 
    ignore in restart file: *

from which we know that the _restart_{: style="color: green"} file containing the charge density has been
correctly read.

    #---- Second block of log file---
     ... sudmft job=1: make projectors
     Reading indmfl file ... 1 total (1 inequivalent) correlated blocks, among 1 sites
     readindmfl: 5 nonzero (5 inequivalent) matrix elements

       channels for 2nd spin block
       m1   m2   cix chn(1) chn(2)
        1    1    1     1     6
        2    2    1     2     7
        3    3    1     3     8
        4    4    1     4     9
        5    5    1     5    10

      correlated channels:
      chan equiv m1   m2   isp icix  cix  ib
        1    1    1    1    1    1    1    1
        2    2    2    2    1    1    1    1
        3    3    3    3    1    1    1    1
        4    4    4    4    1    1    1    1
        5    5    5    5    1    1    1    1
        6    6    1    1    2    1    1    1
        7    7    2    2    2    1    1    1
        8    8    3    3    2    1    1    1
        9    9    4    4    2    1    1    1
       10   10    5    5    2    1    1    1
     
     indmfl file expects 1 DMFT block(s) (max dimension 5),  10 matrix elements

This section corresponds to the creation of projection operators after reading the _indfml_{: style="color: green"} file. It gives direct infos about the correlated blocks of orbitals chosen and their character. In this case we notice how 10 channels are produced from a block of 5 in the _indmfl_{: style="color: green"} file since the calculation is magnetic and the spin is 2.

    #---- Third block of log file---
     Reading DMFT sigma from file ...
             DMFT sigma is zero ... no double counting

     SUDMFT: projector #2 with k-integrated norm.  8 bands in window (4,11)
             2000 Matsubara frequencies, interval (0.0628318,251.265) eV
             User-specified double-counting in eV : --ldadc=25.5

First part: being this the first iteration the file _sig.inp_{: style="color: green"} is null, the code recognizes it and no DC is included. Second part: general infos about the projector before these are renormalized, the Matsubara mesh, the energy window chosen and the DC calculated according to (4.29) of [2] by reading the values specified as inputs for Hubbard parameters $U,J$ and the the nominal occupancy of the correlated orbitals $n_f$.

    #---- Fourth block of log file---
     BNDFP:  Write evals,evecs to file for 29 qp
     bndfp:  kpt 1 of 29, k=  0.00000  0.00000  0.00000
     -3.8973 -3.8973 -3.8973 -0.5804 -0.1352 -0.1352 -0.1352 -0.0280 -0.0280
     bndfp:  kpt 1 of 29, k=  0.00000  0.00000  0.00000
     -3.8973 -3.8973 -3.8973 -0.5804 -0.1352 -0.1352 -0.1352 -0.0280 -0.0280

Here a first portions of the eigenvalues generated by routine and stored in _evec.case_{: style="color: green"} is reported. Being a magnetic calculation we notice the same $k$-points contribution being listed twice (for majority and minority spin components). In this case the eigenvalues are identical since the magnetic moment is initially null.

    #---- Fifth block of log file---
     Renormalize projectors ...

     Find chemical potential mu...
     Seek mu for 14 electrons ... 13.842564 electrons at Ef0=-0.026874.  D(Ef0)=57.196
     getVnew: v1=0e0 N1=-1.574e-1  v2=-2.753e-3 N2=-5.867e-3  bracket=F  est=-0.00286977
     getVnew: v1=-2.753e-3 N1=-5.867e-3  v2=-2.87e-3 N2=1.382e-4  bracket=T  est=-0.00286707
     getVnew: v1=-2.87e-3 N1=1.382e-4  v2=-2.867e-3 N2=-4.814e-8  bracket=T  est=-0.00286707
     mu = -0.024006 = Ef0--0.002867.  Deviation from neutrality = -9.59e-14
     Electron charge:  14.000000   moment:  0.000000    spin resolved DOS:    25.553  25.553

After the projector are renormalized, the chemical potential finder is run. In this case 3 iterations are sufficient to converge to the correct value for the electron count, the correction $V$ to $mu$ is stored.

    #---- Sixth block of log file---
      Make gloc, delta, eimp ...
     Writing files delta and eimp1 ...

     Check SC condition skipped (missing information about previous iteration)
     gloc(N)   recorded in gloc.ext file.
     Exit 0 done making DMFT hybridization function 

Last block of the _log_{: style="color: green"} file. The local functions are generated and written to disk. Being this the first iteration no DMFT self-consistent condition can be met.

### _Extracting the Impurity Self-Energy - CTQMC Software_
_____________________________________________________________
This chapter will be dedicated to the second (and last) block of the DMFT cycle, the employment of the QSGW-based hybridization function to extract the impurity self-energy of DMFT by means of the impurity solver (see sec.31 of [2] for the details of the equations and main quantities into play).   
In practice this operation pivots on two main programs, the _CTQMC_ (Continuous Time quantum Monte-Carlo) impurity solver and the interface connecting this program with the other block (i.e. the **lmfdmft**{: style="color: blue"} routine) completing the DMFT cycle. The _CTQMC_, mainly written in C++ code, is a program developed by K. Haule as part of his Wien2k-DMFT code [1] and which has been adapted in this implementation. The next section will mainly focus on the interface between the **lmfdmft**{: style="color: blue"} routine and the solver, the main inputs and scripts required, and a brief overview of the output files.   
This chapter is complementary to this [tutorial](/tutorial/qsgw_dmft/dmft2) by L. Sponza which provides detailed instructions on how to run the _CTQMC_ software, with some more insight into the scripts and some tips on how to set the correct parameters.

#### _Input Files and Scripts_
In this section we will provide a summary of the overall input files required for both the interface and the _CTQMC_ software, together with the main scripts needed.   
The folder containing the main input files and scripts is generally called _qmcinput_{: style="color: green"}. In order to be consistent with the notation of the previous chapter we will refer to _it\#\_qmcrun_{: style="color: green"} for the folders containing the several iterations of _CTQMC_. It is useful to review the input files for both folders.

    $ ls -l qmcinput
    atom_d.py
    broad_sig.f90
    Trans.dat
    PARAMS

    $ ls -l it#_qmcrun
    #output of atom_d.py 
    info_atom_d.dat
    actqmc.cix
    new.cix
    #output of previous lmfdmft run
    Delta_in -> ../it#_lmfrun/delta.fe
    Delta.inp
    Eimp_in -> ../it#_lmfrun/eimp1.fe
    Eimp.inp

The files contained in _qmcinput_{: style="color: green"} are frozen for all the iterations whereas the ones in _it\#\_qmcrun_{: style="color: green"} are updated for each iteration.

##### _The PARAMS File_
The _PARAMS_{: style="color: green"} file is the key input file of _CTQMC_. The correct choice for the parameters listed in this file can affect quite significantly the quality of the calculation. For this reason, the user is highly
encouraged to read this [tutorial](/tutorial/qsgw_dmft/dmft3) on how to set the most important parameters.   
An example:

    #---- Example of PARAMS file---
    Ntau  1000
    OffDiagonal  real
    Sig  Sig.out
    Naver  100000000
    SampleGtau  1000
    Gf  Gf.out
    Delta  Delta.inp
    cix  actqmc.cix
    Nmax  700     # Maximum perturbation order allowed
    nom  150      # Number of Matsubara frequency points sampled
    exe  ctqmc        # Name of the executable
    tsample  50       # How often to record measurements
    nomD  150     # Number of Matsubara frequency points sampled
    Ed [ -25.173284, -25.106338, -25.438896, -25.039819, -25.438835, -25.173295, -25.106388, -25.438915, -25.039860, -25.438873]     # Impurity levels updated by bash script
    M 75000000.0        # Total number of Monte Carlo steps
    Ncout  200000     # How often to print out info
    PChangeOrder  0.9     # Ratio between trial steps: add-remove-a-kink / move-a-kink
    CoulombF  'Ising'     # Ising Coulomb interaction
    mu   25.173284  # QMC chemical potential by bash script 
    warmup  100000       # Warmup number of QMC steps
    GlobalFlip  200000        # How often to try a global flip
    OCA_G  False      # No OCA diagrams being computed - for speed
    sderiv  0.01      # Maximum derivative mismatch accepted for tail concatenation
    aom  3        # Number of frequency points used to determin the value of sigma at nom
    HB2  False        # Should we compute self-energy with the Bullas trick?
    U    5.0
    J    0.8
    nf0  6.0
    beta 50.0

At the bottom of the file we notice the physical parameters, the Hubbard parameters $U,J$, the inverse temperature $\beta$ and the occupancy of the correlated orbitals $n_{f0}$ (set in accordance with the values previously selected in ). In addition, we notice the two line copied from the _Eimp.inp_{: style="color: green"} file, one labelled by _Ed_ (4th line of the file), and one labelled by _M_ (last line of the file).   
All the other parameters control the stochastic character of the Monte-Carlo calculation. For more details about these, and some tips on how to tune them, in order not to be redundant we refer again to L.Sponza’s [tutorial](/tutorial/qsgw_dmft/dmft3).

##### _Treating d-systems: the script atom\_d.py and the file Trans.dat_
The _atom\_d.py_{: style="color: blue"} is a python script written by K. Haule. It is specifically set for $d$-systems (not adopted otherwise) and its purpose is to initialize the atomic problem for the specific atom considered and to transform the Coulomb interaction $U$ via a rotation to the correct harmonics basis.   
The input file needed by is called _Trans.dat_{: style="color: green"}, it contains information about the local basis and in particular the transformation matrix from standard spherical Harmonics to a given user’s specified basis which is more convenient for the calculation. There are basically just two main cases of the file, the user can find an example at the following links, [one](/assets/download/inputfiles/Trans.dat-spinpol) for non-magnetic and [one](/assets/download/inputfiles/Trans.dat-nonmag) for spin-polarized calculations.   
The execution line for _atom\_d.py_{: style="color: blue"} requires some specific flags indicating parameters such as angular momentum and the starting impurity levels (the correct instructions on how to run it can be found at this [page](/tutorial/qsgw_dmft/dmft2) ). The main output file of the script is file _actqmc.cix_{: style="color: green"}. This file file has information regarding the atomic basis and the matrix elements of $U$ and is used as an input by the _CTQMC_ solver and has to be copied in the _it\#\_qmcrun_{: style="color: green"} folder. Two log files are produced by the script, _info\_atom\_d.dat_{: style="color: green"} and _new.cix_{: style="color: green"}, both not required by _CTQMC_.

##### _The Delta.inp and Eimp.inp Input Files_
These files are soft linked and renamed from _it\#\_lmf_{: style="color: green"} folder (containing the results of the iteration preceding the _CTQMC_ run). The _Delta.inp_{: style="color: green"} is directly taken as an input by _CTQMC_, whereas the _Eimp.inp_{: style="color: green"} is parsed and taken as input by 2 scripts composing the interface. In the first place the 3rd line, namely (see previous chapter for comparison):

    Eimp=[ 0.000000, 0.066946, -0.265612, 0.133464, -0.265551,-0.000011, 0.066895, -0.265631, 0.133423, -0.265589]

is copied in the execution line to run the script, object of next section. The fourth and fifth lines,

    Ed [ -25.173284, -25.106338, -25.438896, -25.039819, -25.438835,
    -25.173295, -25.106388, -25.438915, -25.039860, -25.438873] # Ed
    : Eimp-Edc for PARAMS
    mu 25.173284 # mu = -Eimp[0] for PARAMS

are instead used in the file (introduced further on).

##### _The broad\_sig.f90 Script_
This is the only script treating the output files. It takes the _Sig.out_{: style="color: green"} file, output of _CTQMC_ containing the impurity self-energy, and it applies a Gaussian broadening to it in order to lessen the statistical noise. Every channel of the self-energy (i.e. its orbital component) is convoluted with a Gaussian distribution with a frequency-dependent width.   
This script allow the user to specify the Gaussian width, the total number of frequency points of the broadened self-energy, the starting and ending frequency, depending on the noise and shape of the starting input function.   
The fortran routine **broad\_sig.f90**{: style="color: blue"} has obviously to be compiled so to obtain the _broad\_sig.x_{: style="color: blue"} executable. For instructions on how to compile the program and run the executable inspect this [page](/tutorial/qsgw_dmft/dmft2) of the tutorial.   
The resulting broadened self-energy is recorded in file _Sig.out.brd_{: style="color: green"} wheres files _broad.log_{: style="color: green"} and _width.log_{: style="color: green"} respectively list the parameters used in the broadening and the values of the Gaussian width as a function of the frequency.

#### _Outputs of CTQMC_
    #Outputs of CTQMC run
    Probability.dat
    g_qmc.dat
    g_hb0.dat
    s_hb1.dat
    g_hb1.dat
    Gtau.dat
    histogram.dat
    Sig.out
    Gf.out
    ctqmc.log
    statusfiles/

We can differentiate these files into 2 categories. In the first category are files which are useful to judge the quality of the calculation, and among these enter all the _*.dat_{: style="color: green"} files and the log file _ctqmc.log_{: style="color: green"}. For a preliminary discussion on these files, which will have to be extended by someone more familiar with program, we refer again to this [tutorial](/tutorial/qsgw_dmft/dmft2).   
A special remark must be undertaken for the so called _statusfiles_{: style="color: green"}. For any _CTQMC_ run, which is parallelized on a given number $N$ of cores, $N$ status files named _status.\#_{: style="color: green"} will be produced with infos about the sampling. In order to improve the quality of the calculation, these files have to be copied to the folder containing the following step of _CTQMC_ in such a way to be read by the program at the start. In the case the a single run of _CTQMC_ is not enough to produce a sensible impurity self-energy, which might be too affected by statistical noise, the program can be re-run with the same instructions and inputs and the status files just produced will be also read to improve the accuracy of the sampling.   
To the second group belong the actual output files of the calculation. The file _Gf.out_{: style="color: green"} contains the impurity Green’s function and the file _Sig.out_{: style="color: green"} the impurity self-energy, both files affected by the statistical noise of the Monte-Carlo sampling. In particular the Monte-Carlo sampling accurately accounts for the low frequency region of the self-energy, whereas it is known to be extremely noisy for the high-frequency regime. In order for the self-energy to approach its Hartree-Fock value in the high-energy limit, the high-frequency tails are analytically corrected and concatenated with the Monte-Carlo sampling according to boundary conditions on value and slope. The _CTQMC_ program make use of the Hubbard I approximation for the tails.   
To get rid of statistical noise the _Sig.out_{: style="color: green"} undergoes the _broad\_sig.x_{: style="color: blue"} broadening to return the _Sig.out.brd_{: style="color: green"} file, which gets soft linked to the _sig.inp_{: style="color: green"} file entering the following iteration of in such a way to restart the cycle.

#### _Bonus Track: A Fully Inclusive Interface_
At this point the user should have all the means to run a full QSGW+DMFT loop from scratch using the QUESTAAL program, assisted by this manual and following L. Sponza’s tutorials step by step.   
If this is the case, an inclusive set of scripts will allow him/her to run a full calculation in one go by just setting in advance all the parameters required. These scripts automatize the several operations needed to connect the **lmfdmft**{: style="color: blue"} block to the _CTQMC_ one in such a way to build a more user-friendly interface. They have been written mainly by L.Sponza and they are organized as follows.   
A central script **Contlte.sh**{: style="color: blue"} reads a file called _LoopParams.sh_{: style="color: green"} with all the overall parameters needed to set the DMFT calculation (provided that all of the input files discussed in this manual have already been set up in the respective input folders _qmcinput_{: style="color: green"}, _lmfinput_{: style="color: green"} ) and prepares the folders hosting the calculation of the two main programs. After that, it subsequently submits the corresponding scripts, which have to be also prepared in advance in the respective input folders, containing the execution lines for the two programs.   
A self-explanatory example of the main script **Contlte.sh**{: style="color: green"} can be found at this [link](/assets/download/scripts/ContIte.sh), together with an [example](/assets/download/inputfiles/LoopParams.sh) of the _LoopParam.sh_{: style="color: green"} file. An example of the two scripts, [one](/assets/download/scripts/lmfscript.sh) for the **lmfdmft**{: style="color: blue"} run (which in this version runs on a single processor) and [one](/assets/download/scripts/qmcscript.sh) for the _CTQMC_ run (which runs in parallel on a given number of cores) is also provided.

### _References_
_____________________________________________________________

[1] K. Haule, C.H. Yee, and K. Kim. Dynamical mean field theory within the full-potential methods: Electronic structure of ceirin5, cecoin5, and cerhin5. Phys. Rev. B, 81:195107, 2010.    
[2] Paolo Pisanti. A novel QSGW+DMFT method for the study of strongly correlated materials. PhD thesis, King's College London, 2016.