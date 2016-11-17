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

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a 1-shot GW calculation. Click on the 'GW' dropdown menu below for a brief description of the GW scheme. A complete summary of the commands used throughout is provided in the 'Commands' dropdown menu. Theory for GW and QSGW, and its implementation in the Questaal suite, can be found in [Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106).


<div onclick="elm = document.getElementById('qsgwsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Click for description.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgwsummary">{:/}

One-shot GW (_G_<sup>0</sup>W<sup>0</sup>) calculations are perturbations to a DFT calculation (such as LDA). They are simpler than QSGW calculations, because only the diagonal part of &Sigma;<sup>0</sup> is normally calculated (this is an approximation) and only one self-energy is calculated (single iteration). On the other hand, one-shot calculations are sensitive to the starting point and you also no longer have the luxury of interpolating between k points to get full bandstructures. As a result, it is only possible to calculate 1-shot corrections for k points that lie on the k-mesh used in the self-energy calculation. 

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

The only difference to the LDA tutorial is the extra \-\-gw switch which  tailors the ctrl file for a _GW_ calculation. This switch is discussed in more detail in the QSGW tutorial. Now check the output file out.lmfsc. The self-consistent gap is reported to be around 0.58 eV as can be seen by searching for the last occurence of the word 'gap'. Note that this result differs slightly to that from the LDA tutorial because the gw switch increases the size of the basis set.

Now that we have the input eigenfunctions and eigenvalues, the next step is to carry out a _GW_ calculation. For this, we need an input file for the _GW_ code.

<hr style="height:5pt; visibility:hidden;" />
### _Making GWinput_
________________________________________________________________________________________________
The _GW_ package (both one-shot and QSGW) uses one main user-supplied input file, GWinput. The script lmfgwd can create a template GWinput file for you by running the following command:

    $ echo -1 | lmfgwd si                              #make GWinput file

The lmfgwd script has multiple options and is designed to run interactively. Using 'echo -1' automatically passes it the '-1' option that specifies making a template input file. You can try running it interactively by just using the command 'lmfgwd si' and then entering '-1'. Take a look at GWinput, it is a rather complicated input file but we will only consider the _GW_ _k_ mesh for now (further information can be found on the GWinput page). The k mesh is specified by n1n2n3 in the GWinput file, look for the following line:

    $ n1n2n3  4  4  4 ! for GW BZ mesh

When creating the GWinput file, lmfgwd checks the GW section of the ctrl file for default values. The 'NKABC= 4' part of the DFT input file (ctrl.si) is read by lmfgwd and used for n1n2n3 in the GW input file. Remember if only one number is supplied in NKABC then that number is used as the division in each direction of the reciprocal lattice vectors, so 4 alone means a 4x4x4 k mesh. To make things run a bit quicker, change the k mesh to 3x3x3 by editing the GWinput file line:

    $ n1n2n3  3  3  3 ! for GW BZ mesh

The k mesh of 3&\times;3&\times;3 divisions is rough, but it makes the calculation fast and for Si the results are reasonable.

<hr style="height:5pt; visibility:hidden;" />
### _Running QSGW_
________________________________________________________________________________________________
We are now ready for a QSGW calculation, this is run using the shell script lmgwsc:

    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=0 si         #zeroth iteration of QSGW calculation

The switch '--wt' includes additional timing information in the printed output, insul refers to the number of occupied bands
