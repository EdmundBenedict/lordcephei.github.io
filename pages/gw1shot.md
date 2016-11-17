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
The ...

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

The 



<hr style="height:5pt; visibility:hidden;" />
### _Running QSGW_
________________________________________________________________________________________________
We are now ready for a QSGW calculation, this is run using the shell script lmgwsc:

    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=0 si         #zeroth iteration of QSGW calculation

The switch '--wt' includes additional timing information in the printed output, insul refers to the number of occupied bands
