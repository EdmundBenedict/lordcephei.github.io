---
layout: page-fullwidth
title: "QSGW Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/qsgw_si/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />

### _Purpose_
{:.no_toc}
_____________________________________________________________


This tutorial carries out a basic QSGW calculation for Si, starting from
structural information.


### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Preliminaries_
_____________________________________________________________


Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path;
similarly for the QSGW script **lmgwsc**{: style="color: blue"}; and the binaries it requires should be in subdirectory **code2**.

### _Introduction to a QSGW calculation_
________________________________________________________________________________________________

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a quasi-particle
self-consistent GW (QSGW) calculation. An example of the 1-shot GW code is provided in a separate tutorial. Click on the 'QSGW' dropdown
menu below for a brief description of the QSGW scheme. A complete summary of the commands used throughout is provided in the 'Commands'
dropdown menu. Theory for GW and QSGW, and its implementation in the Questaal suite, can be found in
[Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106).

<hr style="height:5pt; visibility:hidden;" />
### _QSGW summary_
{::comment}
/tutorial/gw/qsgw_si/#qsgw-summary
{:/comment}

________________________________________________________________________________________________

![QSGW flowchart](/assets/img/qsgwcycle.png)

<div onclick="elm = document.getElementById('qsgwsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Click for description.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgwsummary">{:/}

Each iteration of a QSGW calculation has two main parts: a section that uses effective one-body hamiltonians to makes the density _n_, and
the _GW_ code that makes the self-energy &Sigma;(<i>&omega;</i>) of an interacting hamiltonian.  For quaisparticle self-consistency, the
_GW_ code makes a "quasiparticlized" self-energy &Sigma;<sup>0</sup>, which is used to construct the effective one-body hamiltonian for the
next cycle.  The process is iterated until the change in &Sigma;<sup>0</sup> becomes small.

The one-body executable is **lmf**{: style="color: blue"}.  **lmfgwd**{: style="color: blue"} is similar
to **lmf**{: style="color: blue"}, but it is a driver whose purpose is to set up inputs for the _GW_ code.
&Sigma;<sup>0</sup> is made by a shell script **lmgw**{: style="color: blue"}.  The entire cycle is managed
by a shell script **lmgwsc**{: style="color: blue"}.

Before any self-energy &Sigma;<sup>0</sup> exists, it is assumed to be zero.  Thus the one-body hamiltonian is usually the LDA, though it can be something else, e.g. LDA+U.\\
_Note:_{: style="color: red"} in some circumstances, e.g. to break time reversal symmetry inherent the LDA, you need to start with LDA+U.

Thus, there are two self-energies and two corresponding Green's functions: the interacting _G_[&Sigma;(<i>&omega;</i>)] and noninteracting
_G_<sup>0</sup>[&Sigma;<sup>0</sup>].  At self-consistency the poles of _G_ and _G_<sup>0</sup> coincide: this is a unique and very
advantageous feature of QSGW.  It means that there is no "mass renormalization" of the bandwidth --- at least at the _GW_ level.

Usually the interacting &Sigma;(<i>&omega;</i>) isn't made explicitly, but you can do so, as explained in [this tutorial](/tutorial/gw/gw_self_energy/).

In short, a QSGW calculation consists of the following steps. The starting point is a self-consistent DFT calculation (usually LDA). The DFT
eigenfunctions and eigenvalues are used by the GW code to construct a self-energy &Sigma;<sup>0</sup>.  This is called the "0<sup>th</sup> iteration."
If the diagonal parts only of &Sigma;<sup>0</sup> is kept, this corresponds to what is sometimes called _GW_, but is better referred to as
_G_<sup>LDA</sup>W<sup>LDA</sup>.

In the next iteration, &Sigma;<sup>0</sup>&minus;_V_<sub>xc</sub><sup>LDA</sup> is added to the LDA hamiltonian and the density is made
self-consistent, and handed over to the _GW_ part.  (Note that for a fixed density _V_<sub>xc</sub><sup>LDA</sup> cancels the exchange
correlation potential from the LDA hamiltonian.)  This process is repeated until the RMS change in &Sigma;<sup>0</sup> falls below a certain
tolerance value.  The final self-energy (QSGW potential) is an effectively an exchange-correlation functional, tailored to the system, that can
be conveniently used analogously to the standard DFT setup to calculate properties such as the band structure.

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
    $ vim GWinput                                          #change GW k mesh to 3x3x3
    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=5 si        #self-consistent GW calculation
    $ vim ctrl.si                                          #change number of iterations to 1
    $ lmf si --rs=1,0                                      #lmf with QSGW potential to get QSGW band gap
    $ lmgwclear                                            #clean up directory

[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate QSGW band structure )
[//]: # (    $ lmf si --band:fn=syml; cp bnds.si bnds-lda.si        #calculate LDA band structure )


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

[//]: # (     $ lmf si --band:fn=syml                                #calculate LDA band structure )

{::nomarkdown}</div>{:/}

Note that we have included an extra --gw switch, which tailors the ctrl file for a GW calculation. To see how it affects the ctrl file, try running blm without --gw. The switch modifies the basis set section (see the autobas line) to increase the size of the basis, which is necessary for GW calculations.

Two new blocks of text, the HAM and GW categories, are also added towards the end of the ctrl file. The extra parameters in the HAM category handle the inclusion of a self-energy, actually a GW potential (see theory notes above), in a DFT calculation. The GW category provides some default values for parameters that are required in the GW calculation. The GW code has its own input file and the DFT ctrl file influences what defaults are set in it, we will come back to this later. One thing to note is the NKABC= token, which defines the GW k mesh. It is specified in the same way as the lower case nkabc= for the LDA calculation.

Now check the output file out.lmfsc. The self-consistent gap is reported to be around 0.58 eV as can be seen by searching for the last occurence of the word 'gap'. Note that this result differs slightly to that from the LDA tutorial because the gw switch increases the size of the basis set.

Now that we have the input eigenfunctions and eigenvalues, the next step is to carry out a GW calculation. For this, we need an input file for the GW code.

<hr style="height:5pt; visibility:hidden;" />
### _Making GWinput_
________________________________________________________________________________________________
The GW package (both one-shot and QSGW) uses one main user-supplied input file, GWinput. The script lmfgwd can create a template GWinput file for you by running the following command:

    $ echo -1 | lmfgwd si                              #make GWinput file

The lmfgwd script has multiple options and is designed to run interactively. Using 'echo -1' automatically passes it the '-1' option that specifies making a template input file. You can try running it interactively by just using the command 'lmfgwd si' and then entering '-1'. Take a look at GWinput, it is a rather complicated input file but we will only consider the GW k mesh for now (further information can be found on the GWinput page). The k mesh is specified by n1n2n3 in the GWinput file, look for the following line:

    $ n1n2n3  4  4  4 ! for GW BZ mesh

When creating the GWinput file, lmfgwd checks the GW section of the ctrl file for default values. The 'NKABC= 4' part of the DFT input file (ctrl.si) is read by lmfgwd and used for n1n2n3 in the GW input file. Remember if only one number is supplied in NKABC then that number is used as the division in each direction of the reciprocal lattice vectors, so 4 alone means a 4x4x4 k mesh. To make things run a bit quicker, change the k mesh to 3x3x3 by editing the GWinput file line:

    $ n1n2n3  3  3  3 ! for GW BZ mesh

The k mesh of 3&\times;3&\times;3 divisions is rough, but it makes the calculation fast and for Si the results are reasonable.

<hr style="height:5pt; visibility:hidden;" />
### _Running QSGW_
________________________________________________________________________________________________
We are now ready for a QSGW calculation, this is run using the shell script lmgwsc:

    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=0 si         #zeroth iteration of QSGW calculation

The switch '--wt' includes additional timing information in the printed output, insul refers to the number of occupied bands (normally spin degenerate so half the number of electrons), tol is the tolerance for the RMS change in the self-energy between iterations and maxit is the maximum number of QSGW iterations. Note that maxit is zero, this specifies that a single iteration is to be carried out starting from DFT with no self-energy (zeroth iteration).

Run the command and inspect the output. Take a look at the line containing the file name llmf.

~~~
    lmgw  15:26:47 : invoking         mpix -np=8 /h/ms4/bin/lmf-MPIK --no-iactive  cspi >llmf
~~~

Each QSGW iteration begins with a self-consistent DFT calculation by calling the program lmf and writing the output to the file llmf. We are starting from a self-consitent LDA density (we already ran lmf above) so this step is not actually necessary here. The next few lines are preparatory steps. The main GW calculation begins on the line containing the file name 'lbasC':

~~~
    lmgw  16:27:55 : invoking /h/ms4/bin/code2/hbasfp0 --job=3 >lbasC
    lmgw  16:27:55 : invoking /h/ms4/bin/code2/hvccfp0 --job=0 >lvccC ... 0.0m (0.0h)
    lmgw  16:27:58 : invoking /h/ms4/bin/code2/hsfp0_sc --job=3 >lsxC ... 0.0m (0.0h)
    lmgw  16:27:59 : invoking /h/ms4/bin/code2/hbasfp0 --job=0 >lbas
    lmgw  16:27:59 : invoking /h/ms4/bin/code2/hvccfp0 --job=0 >lvcc ... 0.0m (0.0h)
    lmgw  16:28:02 : invoking /h/ms4/bin/code2/hsfp0_sc --job=1 >lsx ... 0.0m (0.0h)
    lmgw  16:28:02 : invoking /h/ms4/bin/code2/hx0fp0_sc --job=11 >lx0 ... 0.1m (0.0h)
    lmgw  16:28:07 : invoking /h/ms4/bin/code2/hsfp0_sc --job=2  >lsc ... 0.1m (0.0h)
    lmgw  16:28:13 : invoking /h/ms4/bin/code2/hqpe_sc 4 >lqpe
~~~

The three lines with lbasC, lvccC and lsxC are the steps that calculate the core contributions to the self-energy and the following lines up to the one with lsc are for the valence contribution to the self-energy. The lsc step, calculating the correlation part of the self-energy, is usually the most expensive step. The self-energy is converted into an effective exchange-correlation potential in the lqpe step and the final few lines are to do with its handling. A full account of the GW steps can be found here (link) in the annotated output file.

Run the command again but this time set the number of iterations (maxit) to something like 5:

    $ lmgwsc --wt --insul=4 --tol=2e-5 --maxit=5 si        #self-consistent GW calculation

This time the iteration count starts from 1 since we are now starting with a self-energy from the zeroth iteration. Again, the iteration starts with a self-consistent DFT calculation but this time the zeroth iteration GW potential is used. The following line in the llmf file specifies that the GW potential is being used:
~~~
RDSIGM: read file sigm and create COMPLEX sigma(R) by FT ...
~~~
The GW potential is contained in the file sigm, lmgwsc also makes a soft link sigm.si so lmf can read it. The GW potential is automatically used if present, this is specified by the RDSIG variable in the ctrl file. Take a look at the GW output again and you can see that the rest of the steps are the same as before. After 3 iterations the RMS change in the self-energy is below the tolerance and the calculation is converged.

~~~
lmgwsc : iter 3 of 5  RMS change in sigma = 1.19E-05  Tolerance = 2e-5
~~~

Now that we have a converged self-energy (sigm) we can go back to using lmf to calculate additional properties. We only want to run a single iteration so change the number of iterations (nit) to 1 in the ctrl file. Run the following command:

    $ lmf si --rs=1,0                              #lmf with QSGW potential to get QSGW band gap

Inspect the lmf output and you can find that the gap is now around 1.41 eV.
[//]: # (QSGW overestimation...)

[//]: # (To make the QSGW energy bands, do: $ lmf si --band:fn=syml                                #calculate QSGW band structure)
[//]: # ($ cp bnds.si bnds-qsgw.si)

Check your directory and you will see that a large number of files were created. The following command removes many redundant files:

    $ lmgwclear                 #clean up directory

Further details can be found in the Additional exercises below.

- Correct gap:
This is actually the &Gamma;-X gap; the true gap is 0.44 eV as can be seen by running lmf with a fine k mesh.
- Changing k mesh:
Test the convergence with respect to the GW k mesh by increasing to a 4x4x4 k mesh.
- Adding floating orbitals:
Note  that the basis set for this calculation isn't quite converged. For Si this is not much of an issue but it can matter a bit for other materials (making errors of order 0.1 eV). The atom-centered LMTO basis set is sufficient for LDA calculations, but it is not quite adequate for GW (work is in progress for a next-generation basis which should address this limitation). To make the basis complete you should add floating orbitals (you cannot add (you cannot add APWs in the QSGW context because the self-energy interpolator does not work with delocalized orbitals). Floating orbitals are like the empty spheres often required by the ASA, but they have no augmentation radius. You can automatically locate them using lmchk (the same way the empty sphere locator works for the ASA).
