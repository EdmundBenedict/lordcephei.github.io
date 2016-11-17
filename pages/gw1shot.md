---
layout: page-fullwidth
title: "1-shot GW tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/gw1shot/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />

### _Purpose_
{:.no_toc}
_____________________________________________________________


This tutorial carries out a 1-shot GW calculation for silicon. The basic set up is the same as in the QSGW tutorial, which should be read for further details. 

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Preliminaries_
_____________________________________________________________


Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path;
similarly for the GW script **lmgw1-shot**{: style="color: blue"}; and the binaries it requires should be in subdirectory **code2**.

### _Introduction to a 1-shot GW calculation_
________________________________________________________________________________________________

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a 1-shot GW calculation. Click on the 'GW' dropdown menu below for a brief description of the 1-shot GW scheme. A complete summary of the commands used throughout is provided in the 'Commands' dropdown menu. Theory for GW and QSGW, and its implementation in the Questaal suite, can be found in [Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106).


<div onclick="elm = document.getElementById('qsgwsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Click for description.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgwsummary">{:/}

One-shot GW (_G_<sup>0</sup>W<sup>0</sup>) calculations are perturbations to a DFT calculation (such as LDA). They are simpler than QSGW calculations, because only the diagonal part of &Sigma;<sup>0</sup> is normally calculated (this is an approximation) and only one self-energy is calculated (single iteration). On the other hand, one-shot calculations are sensitive to the starting point and you also no longer have the luxury of interpolating between k points to get full bandstructures. As a result, it is only possible to calculate 1-shot corrections for k points that lie on the k-mesh used in the self-energy calculation.

The self-energy enters the Hamiltonian as a perturbation and gives us access to quasi-particle (QP) energies. The QP energies are the main output of a 1-shot GW calculation.  

The DFT executable is **lmf**{: style="color: blue"}.  **lmfgwd**{: style="color: blue"} is similar
to **lmf**{: style="color: blue"}, but it is a driver whose purpose is to set up inputs for the _GW_ code.
&Sigma;<sup>0</sup> is made by a shell script **lmgw1-shot**{: style="color: blue"}.


{::nomarkdown}</div>{:/} 

<hr style="height:5pt; visibility:hidden;" />
### _Command summary_
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('command'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="command">{:/}

    $ cp lm/doc/demos/qsgw-si/init.si .                    #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20 --gw  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent
    $ echo -1 | lmfgwd si                                  #make GWinput file
    $ lmgw1-shot --autoht --insul=4 -job= si-test si       #1-shot GW calculation

{::nomarkdown}</div>{:/}

<hr style="height:5pt; visibility:hidden;" />
### _LDA calculation_
________________________________________________________________________________________________
To carry out a self-consistent LDA calculation, we use the lmf code. Try running the commands below. The steps follow those from the lmf tutorial. Please review this page for more details on the set up and running of commands.

<hr style="height:5pt; visibility:hidden;" />
### _LDA commands_
________________________________________________________________________________________________
<div onclick="elm = document.getElementById('commandsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="commandsummary">{:/}

    $ cp lm/doc/demos/qsgw-si/init.si/init.si .            #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20 --gw  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent

{::nomarkdown}</div>{:/}

After running these commands, we now have a self-consistent LDA density. Check the 'out.lmfsc' file and you should find a converged gap of around 0.58 eV. Now that we have the input eigenfunctions and eigenvalues, the next step is to carry out a _GW_ calculation. For this, we need an input file for the _GW_ code.

<hr style="height:5pt; visibility:hidden;" />
### _Making GWinput_
________________________________________________________________________________________________
Create a template GWinput file by running the following command:

    $ echo -1 | lmfgwd si                              #make GWinput file

Take a look at GWinput, the k mesh is specified by n1n2n3 in the following line:

    $ n1n2n3  4  4  4 ! for GW BZ mesh

In the QSGW tutorial we changed the mesh to 3x3x3 to speed things up. This time we will use the 4x4x4 mesh as teh 3x3x3 mesh does not include the X point L points that we are interested in. Look for the following section:

~~~
*** q-points (must belong to mesh of points in BZ).
  3
  1     0.0000000000000000     0.0000000000000000     0.0000000000000000
  2    -0.2500000000000000     0.2500000000000000     0.2500000000000000
  3    -0.5000000000000000     0.5000000000000000     0.5000000000000000
  4     0.0000000000000000     0.0000000000000000     0.5000000000000000
  5    -0.2500000000000000     0.2500000000000000     0.7500000000000000
  6    -0.5000000000000000     0.5000000000000000     1.0000000000000000
  7     0.0000000000000000     0.0000000000000000     1.0000000000000000
  8     0.0000000000000000     0.5000000000000000     1.0000000000000000
~~~

These are the 8 irreducible k points of the 4x4x4 mesh, including X (0,0,1) and L (-1/2,1/2,1/2). You can calculate QP corrections for all of these points. But we will only calculate QP corrections at Γ, X, and L in this tutorial. The 3 just below the q-points line tells the GW codes how many points to calculate QP corrections for. We stick with 3, but rearrange the order so that these three points are the first three. Make the change with your text editor:
~~~
*** q-points (must belong to mesh of points in BZ).
  3
  1     0.0000000000000000     0.0000000000000000     0.0000000000000000
  3    -0.5000000000000000     0.5000000000000000     0.5000000000000000
  7     0.0000000000000000     0.0000000000000000     1.0000000000000000
  2    -0.2500000000000000     0.2500000000000000     0.2500000000000000
  4     0.0000000000000000     0.0000000000000000     0.5000000000000000
  5    -0.2500000000000000     0.2500000000000000     0.7500000000000000
  6    -0.5000000000000000     0.5000000000000000     1.0000000000000000
  8     0.0000000000000000     0.5000000000000000     1.0000000000000000
~~~

We are now ready to run a one-shot GW calculation, which is carried out by the lmgw1-shot script:

    $ lmgw1-shot --insul=4 -job= si-test si   #1-shot GW calculation

The resulting quasi-particle (QP) energies are reported in the QPU file. The '\-\-insul=4' tells the codes where to find the valence band maximum and QP energies are given relative to it (here it is the 4th state).

~~~
           q               state  SEx   SExcore SEc    vxc    dSE  dSEnoZ  eLDA    eQP  eQPnoZ   eHF  Z    FWHM=2Z*Simg  ReS(elda)
  0.00000  0.00000  0.00000  1  -17.40  -1.81   6.70 -12.47  -0.02  -0.04 -11.98 -12.02 -12.04 -19.01 0.65   1.25745    -12.50888
  0.00000  0.00000  0.00000  2  -12.92  -1.96   1.30 -13.62   0.02   0.03  -0.00  -0.00   0.00  -1.56 0.78   0.00000    -13.59113
  0.00000  0.00000  0.00000  3  -12.92  -1.96   1.30 -13.62   0.02   0.03  -0.00   0.00   0.00  -1.56 0.78   0.00000    -13.59115
  0.00000  0.00000  0.00000  4  -12.92  -1.96   1.30 -13.62   0.02   0.03   0.00   0.00   0.00  -1.56 0.78   0.00000    -13.59115
  0.00000  0.00000  0.00000  5   -5.56  -1.42  -4.01 -11.82   0.63   0.82   2.51   3.12   3.30   7.05 0.77  -0.00096    -10.99907
  0.00000  0.00000  0.00000  6   -5.56  -1.42  -4.01 -11.82   0.63   0.82   2.51   3.12   3.30   7.05 0.77  -0.00096    -10.99908
  0.00000  0.00000  0.00000  7   -5.56  -1.42  -4.01 -11.82   0.63   0.82   2.51   3.12   3.30   7.05 0.77  -0.00096    -10.99908
  0.00000  0.00000  0.00000  8   -5.85  -3.72  -4.57 -15.20   0.80   1.06   3.23   4.02   4.27   8.58 0.76  -0.00274    -14.13472

 -0.50000  0.50000  0.50000  1  -16.79  -2.08   5.68 -13.15  -0.04  -0.05  -9.64  -9.70  -9.72 -15.66 0.72   0.98211    -13.20036
 -0.50000  0.50000  0.50000  2  -14.81  -1.66   4.27 -12.12  -0.06  -0.08  -7.02  -7.09  -7.12 -11.66 0.71   0.39708    -12.19791
 -0.50000  0.50000  0.50000  3  -13.14  -1.92   1.70 -13.30  -0.05  -0.06  -1.21  -1.27  -1.29  -3.25 0.76   0.00000    -13.36710
 -0.50000  0.50000  0.50000  4  -13.14  -1.92   1.70 -13.30  -0.05  -0.06  -1.21  -1.27  -1.29  -3.25 0.76   0.00000    -13.36711
 -0.50000  0.50000  0.50000  5   -5.81  -2.15  -3.86 -12.66   0.65   0.83   1.42   2.05   2.23   5.83 0.78  -0.00000    -11.82740
 -0.50000  0.50000  0.50000  6   -4.90  -0.99  -4.26 -10.98   0.63   0.83   3.28   3.90   4.09   8.08 0.77  -0.00729    -10.15130
 -0.50000  0.50000  0.50000  7   -4.90  -0.99  -4.26 -10.98   0.63   0.83   3.28   3.90   4.09   8.08 0.77  -0.00729    -10.15131
 -0.50000  0.50000  0.50000  8   -2.38  -0.59  -5.33  -8.87   0.44   0.57   7.58   8.00   8.12  13.19 0.77  -0.32644     -8.29489

  0.00000  0.00000  1.00000  1  -15.93  -2.11   4.80 -13.20  -0.03  -0.04  -7.84  -7.89  -7.90 -12.97 0.69   0.54541    -13.24249
  0.00000  0.00000  1.00000  2  -15.93  -2.11   4.80 -13.20  -0.03  -0.04  -7.84  -7.89  -7.90 -12.97 0.69   0.54540    -13.24245
  0.00000  0.00000  1.00000  3  -13.35  -1.69   2.30 -12.59  -0.12  -0.16  -2.87  -3.01  -3.05  -5.61 0.74   0.00361    -12.74140
  0.00000  0.00000  1.00000  4  -13.35  -1.69   2.30 -12.59  -0.12  -0.16  -2.87  -3.01  -3.05  -5.61 0.74   0.00361    -12.74140
  0.00000  0.00000  1.00000  5   -5.04  -0.92  -3.63 -10.25   0.52   0.66   0.58   1.08   1.22   4.58 0.79   0.00000     -9.58925
  0.00000  0.00000  1.00000  6   -5.04  -0.92  -3.63 -10.25   0.52   0.66   0.58   1.08   1.22   4.58 0.79   0.00000     -9.58932
  0.00000  0.00000  1.00000  7   -3.67  -2.35  -6.62 -13.50   0.63   0.86  10.02  10.62  10.85  17.20 0.73  -0.64702    -12.64286
  0.00000  0.00000  1.00000  8   -3.67  -2.35  -6.62 -13.50   0.63   0.86  10.02  10.62  10.85  17.20 0.73  -0.64702    -12.64286
~~~

The exchange and correlation terms are in the SEx, SExcore and SEc columns. 



<hr style="height:5pt; visibility:hidden;" />
### _Running QSGW_
________________________________________________________________________________________________
We are now ready for a QSGW calculation, this is run using the shell script lmgwsc:

    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=0 si         #zeroth iteration of QSGW calculation

The switch '--wt' includes additional timing information in the printed output, insul refers to the number of occupied bands
