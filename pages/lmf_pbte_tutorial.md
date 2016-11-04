---
layout: page-fullwidth
title: "Self-Consistent LDA calculation for PbTe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/lmf_pbte_tutorial/"
header: no
---

### _Purpose_
_____________________________________________________________

This tutorial carries out a self-consistent density-functional calculation for PbTe using the **lmf**{: style="color: blue"} code.
It has a purpose [similar to the basic tutorial](/tutorial/lmf/lmf_tutorial/) but shows some additional features
([Another tutorial](/tutorial/gw/qsgw_fe/) presents an LDA calculation for Fe, a ferromagnetic metal).\\
This tutorial:

1. explains the input file's structure and illustrates some of its programming language capabilities
2. generates self consistent atomic densities, to provide information for the crystal calculation
3. generates a self consistent potential within the LDA
5. makes neighbour tables using the **lmchk**{: style="color: blue"} tool
5. synchronizes with an [ASA tutorial](/tutorial/asa/lm_pbte_tutorial/) on the same system, enabling a comparison of the ASA and full potential methods
6. forms a starting point for other tutorials, e.g. on [optics](/tutorial/application/optics).

### _Table of Contents_
_____________________________________________________________

{:.no_toc}
*  Auto generated table of contents
{:toc}  


### _Preliminaries_
_____________________________________________________________

Some of the basics are covered in the basic [lmf tutorial for Si](/tutorial/lmf/lmf_tutorial/), which you may wish to go through first.

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path. 

_____________________________________________________________

### _Command summary_

To see a synopsis of the commands in this tutorial, click on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

[Make an input file:](/tutorial/lmf/lmf_pbte_tutorial/#building-the-input-file)

~~~
nano init.pbte
blm init.pbte                                 #makes template actrl.pbte and site.pbte
cp actrl.pbte ctrl.pbte
~~~

[Free atomic density and basis parameters](/tutorial/lmf/lmf_pbte_tutorial/#initial-setup-free-atomic-density-and-parameters-for-basis)

~~~
lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
cp basp0.pbte basp.pbte                       #copy basp0 to recognised basp prefix
lmfa ctrl.pbte                                #remake atomic density with updated valence-core partitioning
~~~

[Self-consistency:](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency)

~~~
lmf ctrl.pbte -vnkabc=6 -vgmax=7.8
~~~

{::nomarkdown}</div>{:/}

____________________________________________________________

### _Tutorial_

#### 1. _Building the input file_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#building-the-input-file
{:/comment}

PbTe crystallizes in the rocksalt structure with lattice constant _a_ = 6.428&thinsp;&#x212B;. You need the structural information in the box below to construct the main input file,
_ctrl.pbte_{: style="color: green"}. Start in a fresh working directory and cut and paste the box's contents to _init.pbte_{: style="color: green"}.

    LATTICE
	    ALAT=6.427916  UNITS=A
            PLAT=    0.0000000    0.5000000    0.5000000
                     0.5000000    0.0000000    0.5000000
                     0.5000000    0.5000000    0.0000000
    SITE
		ATOM=Pb   X=     0.0000000    0.0000000    0.0000000
		ATOM=Te   X=     0.5000000    0.5000000    0.5000000

The primitive lattice vectors are in row format (the first row contains the _x_, _y_ and _z_ components of the first lattice vector and so forth). In the **SITE** section, the atom type and coordinates are shown. **X=** specifies the site coordinates.  They are specified in "direct" representation, i.e., as fractional multiples of lattice vectors **PLAT**.  You can also use Cartesian coordinates; instead of **X=** you would use **POS=** (see additional exercises below).  Positions in Cartesian coordinates are in units of **ALAT**, like the lattice vectors.

Use the **blm**{: style="color: blue"} tool as in the box below to create the input file (_ctrl.pbte_{: style="color: green"}) and the site file (_site.pbte_{: style="color: green"}):

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte

#### 2. _How the input file is organized_

In this tutorial, **blm**{: style="color: blue"} is used in "standard" mode. (The [basic tutorial](/tutorial/lmf/lmf_tutorial/)
creates a simpler file with `blm --express init.si`). 
Standard mode makes limited use of the [preprocessing capabilities](/docs/input/inputfile/#preprocessor) of the Questaal input system : 
it uses [algebraic variables](/docs/input/preprocessor/#variables) which can be modified on the command line.
Thus `lmf -vnit=10 ...` sets variable **nit** to 10 before doing anything else.  Generally:

* Lines which begin with '**#**' are comment lines and are ignored. (More generally, text following a `**#**' in any line is ignored).
* Lines beginning with '**%**' are directives to the [preprocessor](/docs/input/preprocessor/).

<div onclick="elm = document.getElementById('variablesexplained'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here to see how variables are set and used in the ctrl file.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="variablesexplained">{:/}

The beginning of the ctrl file generated by **blm**{: style="color: blue"} should look like the following:

~~~
# Variables entering into expressions parsed by input
% const nit=10
% const met=5
% const so=0 nsp=so?2:1
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const pwmode=0 pwemax=3          # Use pwmode=1 or 11 to add APWs
% const nkabc=0 gmax=0
~~~ 

**% const** tells the proprocessor that it is declaring one or more variables.  **nit**, **met**, etc,  used in expressions later on.
The parser interprets the contents of brackets **{...}** as [algebraic expressions](/docs/input/preprocessor/#expression-substitution):
The contents of **{...}** is evaluated and the numerical result is substituted for it.
Expression substitution works for input lines proper, and also in the directives.  

For example this line

    metal=  {met}                    # Management of k-point integration weights in metals

becomes

    metal=  5

because **met** is a numerical expression (admittedly a trivial one).  It evaluates to 5 because **met** is declared as an algebraic variable and assigned value 5 near the top of the ctrl file.  The advantage is that you can do algebra in the input file, and you can also re-assign values to variables from the command line, as we will see shortly.

{::nomarkdown}</div>{:/}

Lines corresponding to actual input are divided into
[**categories**{: style="color: red"} and **tokens**{: style="color: blue"}](/docs/input/inputfile/#tags-categories-and-tokens) within the
categories.

A category begins when a character (other than **%** or **#**) occurs in the
3first column.  Each token belongs to a category; for example in box below **IO**{: style="color: red"} contains three tokens, 
**SHOWMEM**{: style="color: blue"}, **IACTIV**{: style="color: blue"} and **VERBOS**{: style="color: blue"} :

    IO    SHOWMEM=f
          IACTIV=f VERBOS=35,35

(Internally, a complete identifier (aka _tag_) would be **IO_IACTIV=**, though it does not appears in that form in the ctrl file.)

[This link](/docs/input/inputfile/#input-file-structure) explains the structure of the input file in more detail.

####  3. _The **EXPRESS** category_

**blm**{: style="color: blue"} normally includes an **EXPRESS** category in _ctrl.pbte_{: style="color: green"}.

<div onclick="elm = document.getElementById('express'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here to see the beginning of the EXPRESS category.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="express">{:/}

{::comment}
<div onclick="elm = document.getElementById('express'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click here
to see the beginning of the EXPRESS category.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="express">{:/} 
{:/comment}

~~~
EXPRESS
# Lattice vectors and site positions
  file=   site

# Basis set
  gmax=   {gmax}                   # PW cutoff for charge density
  autobas[pnu=1 loc=1 lmto=5 mto=4 gw=0]
~~~ 

{::nomarkdown}</div>{:/}

Tags in the **EXPRESS** category are effectively
aliases for tags in other categories, e.g. **EXPRESS_gmax** corresponds to
the same input as **HAM_GMAX**.  If you put a tag into **EXPRESS**, it will
be read there and ignored in its usual location; thus in this instance adding **GMAX**
to the **HAM** category would have no effect.

The purpose of **EXPRESS** is to simplify the input file,
collecting the most commonly used tags in one place.

####  4. _Determining what input an executable seeks_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#determining-what-input-an-executable-seeks
{:/comment}

Executables accept input from two primary streams : tags in the ctrl file and additional information through command-line switches.
Each executable reads its own particular set, though most executables share many tags in common.

Usuually an input file contains only a small subset of the tags an executable will try to read; defaults are used for the vast majority of tags.

There are four special modes designed to facilitate managing input files.  For definiteness consider the executable **lmfa**{: style="color: blue"}.

~~~
$ lmfa --input
$ lmfa --help
$ lmfa --showp
$ lmfa --show | lmfa --show=2
~~~

`--input` puts **lmfa**{: style="color: blue"} in a special mode.  It doesn't attempt to read anything; instead, it prints out a (large) table of all the tags it would try to read, including a brief description of the tag, and then exits.\\
See [here](/docs/input/inputfile/#help-with-finding-tokens) for further description.

`--help` performs a similar function for the command line arguments: it prints out a brief summary of arguments effective in the executable you are using.\\
See [annotated lmfa output](/docs/outputs/lmfa_output/#help-explained) for further description.

`--showp` reads the input through the preprocessor, prints out the preprocessed file, and exits.\\
See the [annotated lmf output](/docs/outputs/lmf_output/#preprocessors-transformation-of-the-input-file)
for a comparison of the pre- and post-processed forms of the input file in this tutorial.

`--show` tells **lmfa**{: style="color: blue"} to print out tags as it reads them (or the defaults it uses).\\
It is explained in the [annotated lmf output](/docs/outputs/lmf_output/#display-tags-parsed-in-the-input-file).

####  5. _Initial setup: free atomic density and parameters for basis_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#initial-setup-free-atomic-density-and-parameters-for-basis
{:/comment}

To carry out a self-consistent calculation, we need to prepare the following.

+ Make [self-consistent atomic densities](/docs/outputs/lmfa_output/#self-consistent-density), which **lmf**{: style="color: blue"} will overlap to make a 
  [starting trial density](/docs/outputs/lmf_output/#mattheis-construction).
+ Fit the [density outside the augmentation radius](/tutorial/lmf/lmf_pbte_tutorial/#fitting-the-interstital-density) to analytic smooth Hankel functions\\
  Information about the augmented and interstitial parts of the density are written to file _atm.pbte_{: style="color: green"}.
+ Provide a reasonable estimate for parameters 
  [gaussian smoothing radius <i>r<sub>s</sub></i> and hankel energy <i>&epsilon;</i>](/docs/code/smhankels/#differential-equation-for-smooth-hankel-functions))
  that fix the [shape of the envelope functions](/tutorial/lmf/lmf_pbte_tutorial/#envelopes-explained)
  for _l_=0,&thinsp;1,&hellip;\\
  These parameters are written to file _basp0.pbte_{: style="color: green"} as &thinsp;**RSMH**&thinsp; and &thinsp;**EH**.
+ Provide a reasonable estimate for boundary conditions that fix [linearization energies](/docs/package_overview/#linear-methods-in-band-theory), parameterized by the
  [logarithmic derivative parameter _P<sub>l</sub>_](/docs/code/asaoverview/#logderpar),
  aka the "continuous principal quantum number"\\
  These parameters are written to _basp0.pbte_{: style="color: green"} as &thinsp;**P**.
+ Decide on which high-lying cores should be included as [local orbitals](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals).\\
  Local orbitals are written _basp0.pbte_{: style="color: green"} as nonzero values of &thinsp;**PZ**.
+ Find any high-lying core states that should be included in the valence as [local orbitals](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals).
+ Supply an estimate for the [mesh density plane wave cutoff **GMAX**](/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax).

**lmfa**{: style="color: blue"} is a tool that will provide all of this information automatically.  It will write basis set information to
template _basp0.pbte_{: style="color: green"}.  The Questaal package reads from _basp.pbte_{: style="color: green"}, but it is written to
basp0 to avoid overwriting a file you may want to preserve.  You can customize the basis set by editing the file.

As a first step, do:

~~~
$ lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
$ cp basp0.pbte basp.pbte                       #copy basp0 to recognised basp prefix   
~~~

Note that, in addition to basis set information written _basp0.pbte_{: style="color: green"}.  **lmfa**{: style="color: blue"} saves
information about the density in file _atm.pbte_{: style="color: green"}.  However, this file will need modification because the
partitioning between core and valence will change with the introduction of local orbitals, as described next.

#####  5.1 Local orbitals
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals)
{:/comment}

Part of **lmfa**{: style="color: blue"}'s function is to identify _local orbitals_ that
[extend the linear method](/docs/package_overview/#linear-methods-in-band-theory).  Linear methods are reliable only over a limited energy
window; certain elements may require an extension to the linear approximation for accurate calculations.  This is accomplished with
[local orbitals](/docs/package_overview/#linear-methods-in-band-theory).  **lmfa**{: style="color: blue"} will automatically look for atomic
levels which, if certain criteria are satisfied it designates as a local orbital, and includes this information in the basp0 file.
The [annotated lmfa output](/docs/outputs/lmfa_output/#lo-explained) explains how **lmfa**{: style="color: blue"} analyzes core states for
local orbitals.

<div onclick="elm = document.getElementById('localorbitals'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description of how local orbitals are specified.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="localorbitals">{:/} 

Inspect _basp.pbte_{: style="color: green"}.  Note in particular this text connected with the Pb atom:

~~~
    PZ= 0 0 15.934
~~~

**lmfa**{: style="color: blue"} is suggesting that the Pb 5_d_ state is shallow enough that it be included in the valence.  Since this state
is far removed from the fermi level, we would badly cover the hilbert space spanned by Pb 6_d_ state were we to use Pb 5_d_ as the valence partial
wave. (In a linear method you are allowed to choose a single energy to construct the partial wave; it is 
usually the "valence" state, which is near the Fermi level.)

This problem is resolved with local orbitals : these are partials wave at an energy far removed from the Fermi level.
The three numbers following **PZ**
correspond to specifications for local orbitals in the _s_, _p_, and _d_ channels.  Zero indicates "no local orbital;"
there is only a _d_ orbital here.

**15.934** is actually a compound of **10** and the "[continuous principal quantum number](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers)"
**5.934**. The 10's digit tells **lmf**{: style="color: blue"}
to use an "enhanced" local orbital as opposed to the usual variety found in most
density-functional codes.  Enhanced orbitals append a tail so that the
density from the orbital spills into the interstitial. 
You can specify a "traditional" local orbital by omitting the 10, but this kind is more accurate, and there is no advantage to doing so.

The continuous principal quantum number (**5.934**) specifies the [number of nodes and boundary
condition](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers).  The large fractional part
of _P_ is [large for core states](/docs/code/asaoverview/#continuous-principal-quantum-number-for-core-levels-and-free-electrons), typically
around 0.93 for shallow cores.  **lmfa**{: style="color: blue"} determines the proper value for the atomic potential.  In the
self-consistency cycle the potential will change and **lmf**{: style="color: blue"} will update this value.

**lmfa**{: style="color: blue"} automatically selects the valence-core partitioning; the information is given in _basp.pbte_{: style="color: green"}.
You can set the partitioning manually by editing this file.  

_Note:_{: style="color: red"} high-lying states can also be included as local orbitals; they improve on the hilbert
space far above the Fermi level. In the LDA they are rarely needed and **lmfa**{: style="color: blue"} will not add them
to the _basp.pbte_{: style="color: green"}.  But they can sometimes be important in _GW_ calculations, since in contrast to
the LDA, unoccupied states also contribute to the potential.

{::nomarkdown}</div>{:/}

##### 5.2 Valence-core partitioning of the free atomic density
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#valence-core-partitioning-of-the-free-atomic-density
{:/comment}

After _basp.pbte_{: style="color: green"} has been modified, you must run **lmfa**{: style="color: blue"} a second time:

~~~
$ lmfa ctrl.pbte
~~~

This is necessary whenever the [valence-core partitioning changes]( /docs/outputs/lmfa_output/#self-consistent-density) through the addition or removal of a local orbital.

###### _Relativistic core levels_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#relativistic-core-levels
{:/comment}

Normally **lmfa**{: style="color: blue"} determines the core levels and core density from
the scalar Dirac equation.  However there is an option to use the full Dirac equation.

<div onclick="elm = document.getElementById('diraccore'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for discussion about calculating core levels from the Dirac equation.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="diraccore">{:/} 

Tag **HAM_REL** controls how the Questaal package manages different levels of relativistic treatment.
Run `lmfa --input` and look for **HAM_REL**.  You should see:

~~~
 HAM_REL                opt    i4       1,  1     default = 1
   0 for nonrelativistic Schr&ouml;dinger equation
   1 for scalar relativistic Schr&ouml;dinger equation
   2 for Dirac equation (ASA only for now)
   10s digit 1: compute core density with full Dirac equation
   10s digit 2: Like 1, but neglect coupling (1,2) pairs in 4-vector
~~~

Set **HAM_REL=11** to make **lmfa**{: style="color: blue"} calculate the core levels and core density with the full Dirac
equation.

You might want to see the core level eigenvalues; they can shift significantly relative to the scalar Dirac solution.
Also, _l_ is no longer a good quantum number so there can be multiple eigenvalues connected with
the scalar Dirac _l_.   To see these levels, invoke **lmfa**{: style="color: blue"} 
with a sufficiently high verbosity.  In the present instance insert
**HAM REL=11** into _ctrl.pbte_{: style="color: green"} and do

~~~
$ lmfa --pr41 ctrl.pbte
~~~

You should see the following table:

~~~
 Dirac core levels:
 nl  chg    <ecore(S)>     <ecore(D)>     <Tcore(S)>     <Tcore(D)>   nre
 1s   2   -6461.412521   -6461.420614    9160.575645    9160.568216   439
 ec(mu)   -6461.420614   -6461.420614
 2s   2   -1154.772794   -1154.777392    2201.484620    2201.485036   473
 ec(mu)   -1154.777392   -1154.777392
 3s   2    -277.137428    -277.136313     700.148783     700.160432   501
 ec(mu)    -277.136313    -277.136313
 4s   2     -62.683976     -62.678557     231.671152     231.686270   531
 ec(mu)     -62.678557     -62.678557
 5s   2     -10.589828     -10.580503      60.826909      60.833608   567
 ec(mu)     -10.580503     -10.580503
 2p   6    -990.094400   -1001.984462    1702.510726    1772.365432   475
 ec(mu)    -948.389636   -1109.174115    -948.389636   -1109.174115    -948.389636    -948.389636
 3p   6    -229.993746    -232.623198     568.649082     585.156080   505
 ec(mu)    -220.667558    -256.534478    -220.667558    -256.534478    -220.667558    -220.667558
 4p   6     -47.246014     -47.902771     184.751871     189.523363   537
 ec(mu)     -44.969950     -53.768412     -44.969950     -53.768412     -44.969950     -44.969950
 5p   6      -6.300710      -6.422904      43.507054      44.670581   577
 ec(mu)      -5.869706      -7.529300      -5.869706      -7.529300      -5.869706      -5.869706
 3d  10    -182.032939    -182.146340     501.452676     502.171493   509
 ec(mu)    -179.091564    -186.728504    -179.091564    -186.728504    -179.091564    -186.728504    -179.091564    -186.728504    -179.091564    -179.091564
 4d  10     -29.432703     -29.453418     150.979227     151.198976   545
 ec(mu)     -28.796634     -30.438595     -28.796634     -30.438595     -28.796634     -30.438595     -28.796634     -30.438595     -28.796634     -28.796634
 5d  10      -1.566638      -1.562069      23.907636      23.945913   605
 ec(mu)      -1.485638      -1.676716      -1.485638      -1.676716      -1.485638      -1.676716      -1.485638      -1.676716      -1.485638      -1.485638
 4f  14      -9.755569      -9.751307     117.412788     117.457023   569
 ec(mu)      -9.592725      -9.962749      -9.592725      -9.962749      -9.592725      -9.962749      -9.592725      -9.962749      -9.592725      -9.962749      -9.592725      -9.962749      -9.592725      -9.592725

 qcore(SR) 78.000000  qcore(FR)  78.000000  rho(rmax)  0.00000
 sum ec :    -25841.9031 (SR)    -25934.9233 (FR) diff       -93.0203
 sum tc :     48113.1010 (SR)     48677.3220 (FR) diff       564.2210
~~~

The scalar Dirac Pb 5_d_ eigenvalue (**-1.566638 Ry**) gets split into 6 levels with energy **-1.485638 Ry** and four with
**-1.676716 Ry**.  The mean (**-1.56207 Ry**) is close to the scalar Dirac value.  In the absence of a magnetic field a
particular _l_ will split into two distinct levels with degeneracies 2_l_ and 2_l_+2, respectively.

The bottom part of the table shows how much the free atom's total energy changes as a consequence of the fully
relativistic Dirac treatment.

{::nomarkdown}</div>{:/}

##### 5.3 Automatic determination of basis set
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set
{:/comment}

**lmfa**{: style="color: blue"} automatically generates parameters for the basis set, including

+ basis (shape parameters [gaussian smoothing radius <i>r<sub>s</sub></i> and hankel energy <i>&epsilon</i>](/docs/code/smhankels/#sm-hankel-diffe)) 
  for _l_=0,&thinsp;1,&hellip;
  These parameters are written to file _basp0.pbte_{: style="color: green"} as &thinsp;**RSMH**&thinsp; and &thinsp;**EH**.
+ suitable boundary conditions for linearization energies, parameterized by the
  [logarithmic derivative parameter _P<sub>l</sub>_](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers),
  aka the "continuous principal quantum number"\\
  These parameters are written to _basp0.pbte_{: style="color: green"} as &thinsp;**P**.
+ deciding on which high-lying cores should be included as [local orbitals](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals).\\
  Local orbitals are written _basp0.pbte_{: style="color: green"} as nonzero values of &thinsp;**PZ**.
+ estimate [plane wave cutoff **GMAX**](/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax) that is needed for the charge density basis, from **EH** and **RSMH**.\\
  This value is written to standard output.

**lmfa**{: style="color: blue"} loops over each species, generating a self-consistent density from the charges given to it.
See [annotation of **lmfa**{: style="color: blue"} output](/docs/outputs/lmfa_output/#self-consistent-density)
for a more detailed description of how it proceeds in making the atomic density self-consistent.

Given a density and corresponding potential, **lmfa**{: style="color: blue"} will construct some
basis set information, and writes the information to template _basp0.pbte_{: style="color: green"}.  It supplies:\\
1. 
2. boundary conditions of the partial waves at the augmentation radius, encapsulated in the ["continuous principal quantum numbers"](/docs/code/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers) _P<sub>l</sub>_\\
3. information about local orbitals, and sets which partial waves should be included\\
4. estimate plane wave cutoff **Gmax** that will be needed for the density mesh, from **EH** and **RSMH**.
  
{::nomarkdown} <a name="envelopes-explained"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#envelopes-explained)
{:/comment}

Envelope functions
: The envelope functions ([smoothed Hankel functions](/docs/code/smhankels/)) are characterized by **RSMH** and **EH**.
**RSMH** is the Gaussian "smoothing radius" and approximately demarcates the transition between short-range behavior,
where the envelope varies as <i>r<sup>l</sup></i>, and asymptotic behavior where it decays exponentially with
decay length 1/&kappa;1/&radic;<span style="text-decoration: overline">&minus;**EH**</span>. **lmfa**{: style="color: blue"} finds an estimate for
**RSMH** and **EH** by fitting them to the "interstial" part of the atomic wave functions (the region outside the augmentation radius).
: Fitting numerically tabulated functions beyond the augmentation radius to a smooth Hankel function is generally quite accurate.  For Pb, the
error in the energy (estimated from the single particle sum) is is 0.00116 Ry --- very small on the scale of other errors.\\
The fitting process is described in more detail in the [annotated lmfa output](/docs/outputs/lmfa_output/#envelopes-explained).
: For _crystal_ envelope functions these shapes are reasonable, but not optimal.  These parameters 
will become the ones **lmf**{: style="color: blue"} uses unless you change them by hand, or optimize them with **lmf**{: style="color: blue"}'s optimizing function, `--opt`.\\
_Note:_{: style="color: red"} The new [Jigsaw Puzzle Orbital](/docs/code/jpos) basis is expected to resolve these drawbacks.  High quality
envelope functions are automatically constructed that continuously extrapolate the high quality augmented partial waves smoothly into the
interstitial; the kinetic energy of the envelope functions are continuous across the augmentation boundary.

Local orbitals
: **lmfa**{: style="color: blue"} searches for core states which are shallow enough to be treated as local orbitals,
using the core energy and charge spillout of the augmentation radius (**rmt**) as criteria; see [annotated lmfa output](/docs/outputs/lmfa_output/#lo-explained).
: In the first time it was run, **lmfa**{: style="color: blue"} [singled out](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals) the Pb 5_d_ state, using
information from the table below taken from **lmfa**{: style="color: blue"}'s standard output.  Once local orbitals are specified **lmfa**{: style="color: blue"} is able to appropriately
partition the valence and core densities.  This is essential because the two densities are treated differently in the crystal code.
Refer to the [annotated lmfa output](/docs/outputs/lmfa_output/#lo-explained) for more details.

~~~
 Find local orbitals which satisfy E > -2 Ry  or  q(r>rmt) > 5e-3
 l=2  eval=-1.569  Q(r>rmt)=0.0078  PZ=5.934  Use: PZ=15.934
 l=3  eval=-9.796  Q(r>rmt)=3e-8  PZ=4.971  Use: PZ=0.000
~~~

Boundary conditions
: The free atomic wave function satisfies the boundary condition that the wave function decay as <i>r</i>&rarr;&infin;.
Thus, the value and slope of this function at **rmt** are determined by the asymptotic boundary condition.
This boundary condition is needed for fixing the partial waves in the crystal code.
**lmfa**{: style="color: blue"} generates this information and encapsulates it into the 
["continuous principal quantum number"](/docs/code/asaoverview/#boundary-conditions-and-continuous-principal-quantum-numbers)\\
Refer to the [annotated lmfa output](/docs/outputs/lmfa_output/#envelopes-explained) for more details.

<i> </i>

##### 5.4 Fitting the interstital density
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#fitting-the-interstital-density
{:/comment}

**lmfa**{: style="color: blue"} fits valence and core densities to a linear combination of smooth Hankel functions.
This information will be used to overlap free-atomic densities to obtain a trial starting density.
This is explained in the [annotated lmfa output](/docs/outputs/lmfa_output/#fitting-the-charge-density-outside-the-augmentation-radius).

##### 5.5 Estimate for GMAX
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax
{:/comment}

After looping over all species **lmfa**{: style="color: blue"} writes basis information to 
_basp0.pbte_{: style="color: green"}, atomic charge density data to file
_atm.pbte_{: style="color: green"}, and exits with the following printout:

~~~
 FREEAT:  estimate HAM_GMAX from RSMH:  GMAX=4.3 (valence)  7.8 (local orbitals)
~~~

This is the _G_ cutoff **EXPRESS\_gmax** or [**HAM\_GMAX**](/docs/input/inputfile/#spec) that the ctrl file needs in the next section.  It determines the mesh spacing for the charge density.
Two values are printed, one determined from the shape of valence envelope functions (**4.3**) and, if local orbitals are present
the largest value found from their shape, as explained in the [annotated lmfa output](/docs/outputs/lmfa_output/#estimating-the-plane-wave-cutoff-gmax).

####  6. _Self consistency_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#self-consistency
{:/comment}


We are almost ready to carry out a self-consistent calculation.
It proceeds in a manner [similar to the basic tutorial](/tutorial/lmf/lmf_tutorial/#tutorial).
Try the following:

~~~
$ lmf ctrl.pbte
~~~

**lmf**{: style="color: blue"} stops with this message:

~~~
 Exit -1 bzmesh: illegal or missing k-mesh
~~~

We haven't yet specified a _k_ mesh.
You must supply it yourself since there are too many contexts to supply a sensible default value.
In this case a _k_-mesh of 6&times;6&times;6
divisions is adequate.   With your text editor change **nkabc=0** in the ctrl file
to **nkabc=6**, or alternatively assign variable **nkabc** on the command line (which is what this tutorial will do).

We also haven't specified the _G_ cutoff for the density mesh.  **blm**{: style="color: blue"} does not determine this parameter automatically
because it is sensitive to the selection of basis parameters, hich local orbitals are included.
**lmfa**{: style="color: blue"} conveniently supplied that information for us,
based in the shape of envelope functions it found.  In this case the valence
_G_ cutoff is quite small (**4.3**), but the Pb 5_d_ local orbital is a much sharper function,
and requires a larger cutoff (**7.8**).  You must use use the larger of the two.

_Note:_{: style="color: red"} if you change the shape of the envelope functions
you must take care that **gmax** is large enough. This is described in the 
lmf output below.

Change variable **gmax=0** in the ctrl file, or alternatively add a variable to the command line.
Now run

~~~
$ lmf ctrl.pbte -vnkabc=6 -vgmax=7.8
~~~

**lmf**{: style="color: blue"} should converge to self-consistency in 10 iterations.
At the end of the file it prints out

~~~
                ↓        ↓
 diffe(q)=  0.000000 (0.000005)    tol= 0.000010 (0.000030)   more=F
c nkabc=6 gmax=7.8 ehf=-55318.1620974 ehk=-55318.1620958
~~~

The first line prints out the change in Harris-Foulkes energy relative to the prior iteration and some norm of RMS change in the
(output-input) charge density (see arrows), followed by the tolerances required for self-consistency.

The last line prints out a table of variables that were specified on the command line, and total
energies from the Harris-Foulkes and Kohn-Sham functionals.  Theses are different
functionals but they should approach the same value at self-consistency.
The **c** at the beginning of the line indicates that this iteration is self-consistent.

####  7. _Annotation of lmfa's output_

Click [here](/docs/outputs/lmfa_output/) to see **lmfa**{: style="color: blue"}'s standard output annotated.

####  8. _Annotation of lmf's output_

Click [here](/docs/outputs/lmf_output/) to see **lmf**{: style="color: blue"}'s standard output annotated.

### _Other Resources_

1. An input file's structure, and features of the programming language capability, is explained in some detail 
[here](/docs/input/inputfile/). The full syntax of categories and tokens can be found in [this reference](input.pdf).

2. [This tutorial](https://lordcephei.github.io/buildingfpinput/) more fully describes some important tags the **lmf**{: style="color: blue"} reads.  It also
presents alternative ways to build input files from various sources such as the VASP _POSCAR_{: style="color: green"} file.

3. [This tutorial](/tutorial/lmf/lmf_bi2te3_tutorial/) more fully explains the **lmf**{: style="color: blue"} basis set.\\
   There is a corresponding tutorial on the basics of a [self-consistent ASA calculation for PbTe](https://github.com/lordcephei/lordcephei.github.io/blob/master/pages/fptut-pbte.md).  [A tutorial on optics](/docs/properties/optics/) can be gone through after you have understood this one.

4. [This document](https://lordcephei.github.io/docs/lmf/overview/) gives an overview of some of **lmf**'s unique features and capabilities.

5. The theoretical formalism behind the **lmf**{: style="color: blue"} is described in detail in this book chapter:
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in _Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method_, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.

### _Additional exercises_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#additional-exercises
{:/comment}

1. Try self-consistent calculations with the Pb 5_d_ in the valence as a local orbital.  Repeat the calculation but remove the **PZ** part from _basp.pbte_{: style="color: green"}.

2. Specify symops manually.
