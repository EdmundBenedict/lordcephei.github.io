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
It has a purpose similar to the [basic tutorial on Si](/tutorial/lmf/lmf_tutorial/) but provides much more detail.  The standard outputs
of **lmfa**{: style="color: blue"} and **lmf**{: style="color: blue"} are explained.
See also the [Fe tutorial](/tutorial/gw/qsgw_fe/), An LDA calculation for Fe for a ferromagnetic metal is followed by a QS<i>GW</i> calculation.
This tutorial:

1. explains the input file's structure and illustrates some of its programming language capabilities
2. generates self consistent atomic densities, to provide information for the crystal calculation
3. generates a self consistent potential within the LDA

It synchronizes with an [ASA tutorial](/tutorial/asa/lm_pbte_tutorial/) on the same system, enabling a comparison of the ASA and full
potential methods, and forms a starting point for other tutorials, e.g. on [optics](/tutorial/application/optics).

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

_Note:_{: style="color: red"} If you are preparating for a later QS<i>GW</i> calculation,
use `blm --gw init.pbte`.  See [this page](/docs/misc/fplot/#switches-for-blm) for documentation of 
**blm**{: style="color: blue"}'s command-line switches.

#### 2. _How the input file is organized_
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#how-the-input-file-is-organized)
{:/comment}

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
(/tutorial/lmf/lmf_pbte_tutorial/#the-EXPRESS-category)

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
(/tutorial/lmf/lmf_pbte_tutorial/#determining-what-input-an-executable-seeks)
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

See [Table of Contents](/tutorial/lmf/lmf_pbte_tutorial#table-of-contents)

####  5. _Initial setup: free atomic density and parameters for basis_
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#initial-setup-free-atomic-density-and-parameters-for-basis)

**lmf**{: style="color: blue"} will carry out a self-consistent calculation in the crystal.\\
First, however, it is necessary to perform calculations for free atoms using **lmfa**{: style="color: blue"}.
These calculations prepare the following.

1. Make a [self-consistent atomic density](/docs/outputs/lmfa_output/#self-consistent-density) for each species.
2. Fit the [density outside the augmentation radius](/docs/outputs/lmfa_output/#fitting-the-charge-density-outside-the-augmentation-radius). 
   **lmf**{: style="color: blue"} needs this information to overlap atomic densities for an initial [trial density](/docs/outputs/lmf_output/#mattheis-construction).

   Information about the augmented and interstitial parts of the density are written to file _atm.pbte_{: style="color: green"}.

3. Provide a reasonable estimate for the
   [gaussian smoothing radius <i>r<sub>s</sub></i> and hankel energy <i>&epsilon;</i>](/docs/code/smhankels/#differential-equation-for-smooth-hankel-functions))
   that fix the shape of the [smooth Hankel envelope functions](/tutorial/lmf/lmf_pbte_tutorial/#envelopes-explained)
   for _l_=0,&thinsp;1,&hellip;.  The _l_ cutoff is determined internally, depending on the setting of &thinsp;[**HAM\_AUTOBAS\_LMTO**](/docs/input/inputfile/#ham).\\
   These parameters are written to file _basp0.pbte_{: style="color: green"} as &thinsp;**RSMH**&thinsp; and &thinsp;**EH**.

4. Provide a reasonable estimate for boundary conditions that fix [linearization energies](/docs/package_overview/#linear-methods-in-band-theory), parameterized by the
   [logarithmic derivative parameter _P<sub>l</sub>_](/docs/code/asaoverview/#logderpar),
   aka the "continuous principal quantum number."\\
   These parameters are written to _basp0.pbte_{: style="color: green"} as &thinsp;**P**.

5. Decide on which shallow cores should be included as [local orbitals](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals).\\
   Local orbitals are written _basp0.pbte_{: style="color: green"} as nonzero values of &thinsp;**PZ**.

6. Supply an [estimate](/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax) for the interstitial density plane wave cutoff **GMAX**.

**lmfa**{: style="color: blue"} will provide all of this information automatically.  It will write atomic density information
to _atm.pbte_{: style="color: green"} and basis set information to template _basp0.pbte_{: style="color: green"}.  The Questaal suite reads
from _basp.pbte_{: style="color: green"}, but **lmfa**{: style="color: blue"} writes to basp0 to avoid overwriting a file you may want to
preserve.  You can edit _basp.pbte_{: style="color: green"} and customize the basis set.

As a first step, do:

~~~
$ lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
$ cp basp0.pbte basp.pbte                       #copy basp0 to recognised basp prefix
~~~

The output is annotated in some detail [here](/docs/outputs/lmfa_output/#display-tags-parsed-in-the-input-file)
The calculation begins with a header:

~~~
 LMFA:     nbas = 2  nspec = 2  vn 7.11.i  verb 35
 special
 pot:      XC:BH
 autogen:  mto basis(4), pz(1), pnu(1)   Autoread: pz(1)
~~~

The **pot** line says that **lmfa**{: style="color: blue"} the potential will be made from the Barth-Hedin functional.
To use a GGA, see [here](/docs/outputs/lmf_output/#lda-functionals).

The **autogen** line says that **lmfa**{: style="color: blue"} will make the basis set 3-5 information outlined above.


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

{::comment}
<div onclick="elm = document.getElementById('localorbitals'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description of how local orbitals are specified.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="localorbitals">{:/}
{:/comment}

<div class="dropButtonMid" onclick="dropdown( this );">Click here for a brief description of the linear method and its extension using local orbitals.</div>
{::nomarkdown}<div class="dropContent">{:/}

Inspect _basp.pbte_{: style="color: green"}.  Note in particular this text connected with the Pb atom:

~~~
    PZ= 0 0 15.934
~~~

(The same information can be supplied in the input file,
through [**SPEC\_ATOM\_PZ**](/docs/input/inputfile/#spec-cat).)

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
Even though **lmfa**{: style="color: blue"} writes the atomic to _atm.pbte_{: style="color: green"}, this file will change when
partitioning between core and valence will change with the introduction of local orbitals, as described next.
This is because core and valence densities are kept separately.


###### _Relativistic core levels_
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#relativistic-core-levels
{:/comment}

Normally **lmfa**{: style="color: blue"} determines the core levels and core density from
the scalar Dirac equation.  However there is an option to compute the core levels from the full Dirac equation.

{::comment}
<div onclick="elm = document.getElementById('diraccore'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for discussion about calculating core levels from the Dirac equation.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="diraccore">{:/}
{:/comment}

<div class="dropButtonMid" onclick="dropdown( this );">Click here for discussion about calculating core levels from the Dirac equation.</div>
{::nomarkdown}<div class="dropContent">{:/}

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

**lmfa**{: style="color: blue"} loops over each species, generating a [self-consistent density](/docs/outputs/lmfa_output/#self-consistent-density).

Given a density and corresponding potential, **lmfa**{: style="color: blue"} will construct some estimates for the basis set, namely the
generation of envelope function parameters **RSMH**&thinsp; and &thinsp;**EH** (and possibly **RSMH2**&thinsp; and &thinsp;**EH2**, depending
on the setting of [**HAM\_AUTOBAS\_MTO**](/docs/input/inputfile/#ham)), analyzing which cores should be promoted to local orbitals, and
reasonable estimates for the boundary condition of the partial wave that dete

{::nomarkdown} <a name="envelopes-explained"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#envelopes-explained)
{:/comment}

Envelope functions
: The envelope functions ([smoothed Hankel functions](/docs/code/smhankels/)) are characterized by **RSMH** and **EH**.
**RSMH** is the Gaussian "smoothing radius" and approximately demarcates the transition between short-range behavior,
where the envelope varies as <i>r<sup>l</sup></i>, and asymptotic behavior where it decays exponentially with
decay length 1/<i>&kappa;<sub>l</sub></i>=1/&radic;<span style="text-decoration: overline">&minus;<i>&epsilon;<sub>l</sub></i></span>, where
<i>&epsilon;<sub>l</sub></i> is one of the **EH**. **lmfa**{: style="color: blue"} finds an estimate for **RSMH** and **EH** by fitting them
to the "interstitial" part of the atomic wave functions (the region outside the augmentation radius).
: Fitting the smooth Hankel function to the numerically tabulated exact function is usually quite accurate.  For Pb, the
error in the energy (estimated from the single particle sum) is  0.00116 Ry --- very small on the scale of other errors.\\
The fitting process is described in more detail in the [annotated lmfa output](/docs/outputs/lmfa_output/#envelopes-explained).
: **lmf**{: style="color: blue"} requires **RSMH** and **EH**.  Those generated by **lmfa**{: style="color: blue"} are
reasonable, but unfortunately not optimal choices for the crystal, as explained in the [annotated lmfa
output](/docs/outputs/lmfa_output/#generating-basis-information). You can change them by hand, or optimize them with **lmf**{: style="color: blue"}'s
optimizing function, `--opt`.   To make an accurate basis, a second envelope function is added through **RSMH2** and **EH2**.
(**lmfa**{: style="color: blue"} automatically does this, depending on the setting of [**HAM\_AUTOBAS\_MTO**](/docs/input/inputfile/#ham)).
Alternatively you can add APW's to the basis.
For a detailed discussion on how to select the basis set, see [this tutorial](/tutorial/lmf/lmf_bi2te3_tutorial).\\
_Note:_{: style="color: red"} The new [Jigsaw Puzzle Orbital](/docs/code/jpos) basis is expected significantly improve on the accuracy of the existing Questaal basis.
High quality envelope functions are automatically constructed that continuously extrapolate the accurate augmented partial waves
smoothly into the interstitial; the kinetic energy of the envelope functions are continuous across the augmentation boundary.

{::nomarkdown} <a name="lo-explained"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#lo-explained)
{:/comment}

Local orbitals
: **lmfa**{: style="color: blue"} searches for core states which are shallow enough to be treated as local orbitals,
using the core energy and charge spillout of the augmentation radius (**rmt**) as criteria; see [annotated lmfa output](/docs/outputs/lmfa_output/#lo-explained).
: When it was run for the first time, **lmfa**{: style="color: blue"} [singled out](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals) the Pb 5_d_ state, using
information from the table below taken from **lmfa**{: style="color: blue"}'s standard output.  Once local orbitals are specified **lmfa**{: style="color: blue"} is able to appropriately
partition the valence and core densities.  This is essential because the two densities are treated differently in the crystal code.
Refer to the [annotated lmfa output](/docs/outputs/lmfa_output/#lo-explained) for more details.

~~~
 Find local orbitals which satisfy E > -2 Ry  or  q(r>rmt) > 5e-3
 l=2  eval=-1.569  Q(r>rmt)=0.0078  PZ=5.934  Use: PZ=15.934
 l=3  eval=-9.796  Q(r>rmt)=3e-8  PZ=4.971  Use: PZ=0.000
~~~

{::nomarkdown} <a name="bc-explained"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_pbte_tutorial/#bc-explained)
{:/comment}

Boundary conditions
: The free atomic wave function satisfies the boundary condition that the wave function decay as <i>r</i>&rarr;&infin;.
Thus, the value and slope of this function at **rmt** are determined by the asymptotic boundary condition.
This boundary condition is needed for fixing the [linearization energy](/docs/package_overview/#linear-methods-in-band-theory)
of the partial waves in the crystal code.
**lmfa**{: style="color: blue"} generates an estimate for this energy and encapsulates it into the
["continuous principal quantum number"](/docs/code/asaoverview/#logderpar),
saved as **P** in _basp0.pbte_{: style="color: green"} (normally **P** will updated in the
self-consistency cycle).\\
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
(/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax)
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

See [Table of Contents](/tutorial/lmf/lmf_pbte_tutorial#table-of-contents)

####  5. _Remaining Inputs_

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
**lmfa**{: style="color: blue"} conveniently [supplies](/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax) that information for us,
based in the shape of envelope functions it found.  In this case the valence
_G_ cutoff is quite small (**4.3**), but the Pb 5_d_ local orbital is a much sharper function,
and requires a larger cutoff (**7.8**).  You must use the larger of the two.

_Note:_{: style="color: red"} if you change the shape of the envelope functions
you must take care that **gmax** is large enough. This is described in the
lmf output below.

Change variable **gmax=0** in the ctrl file, or alternatively add a variable to the command line, as we do in the next section.

See [Table of Contents](/tutorial/lmf/lmf_pbte_tutorial#table-of-contents)

####  6. _Self consistency_
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#self-consistency)

Carry out a self-consistent calculation as follows:

~~~
$ lmf ctrl.pbte -vnkabc=6 -vgmax=7.8
~~~

**lmf**{: style="color: blue"} will iterate up to 10 iterations.  The cycle is capped to 10 iterations because of the following lines in
_ctrl.pbte_{: style="color: green"}, which before and after preprocessing [read](/docs/outputs/lmf_output/#preprocessors-transformation-of-the-input-file):

~~~
   before preprocessing               after preprocessing
% const nit=10               	  |
...                          	  |
EXPRESS                           |  EXPRESS
...                               |
  nit=    {nit}              	  |   nit=    10
~~~

#####  Initialization steps
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#initialization-steps)

**lmf**{: style="color: blue"} begins with some initialization steps.
Each step is explained in more detail in the [annotated lmf output](/docs/outputs/lmf_output).

+ Read [basis set parameters](/docs/outputs/lmf_output/#reading-basis-information-from-the-basp-file) from _basp.pbte_{: style="color: green"}.
  This information can also be given via the ctrl file, depending on the settings of [**EXPRESS\_autobas**](/docs/input/inputfile/#ham).
+ Informational printout about [computing conditions](/docs/outputs/lmf_output/#header-information),
  [lattice structure](/docs/outputs/lmf_output/#lattice-information), and
  [atomic parameters](/docs/outputs/lmf_output/#augmentation-parameters) such as augmentation radii and _l_-cutoffs
+ Automatic determination of [crystal symmetry](/docs/outputs/lmf_output/#symmetry-and-k-mesh)
+ Setup for the [Brillouin zone integration](/docs/outputs/lmf_output/#symmetry-and-k-mesh)
+ Construction of the [mesh](/docs/outputs/lmf_output/#interstitial-mesh) for interstitial density and potential
+ Assemble and display information about the size and constituents of the [basis set](/docs/outputs/lmf_output/#counting-the-size-of-the-basis)
+ Read or assemble an [input density](/docs/outputs/lmf_output/#obtain-an-input-density)
+ A QS<i>GW</i> potential &Sigma;<sup>0</sup> may be read in.

#####  Self-consistent cycle
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#self-consistent-cycle)

Each iteration of the self-consistency cycle begins with

~~~
 --- BNDFP:  begin iteration 1 of 10 ---
...
 --- BNDFP:  begin iteration 2 of 10 ---
...
~~~

One iteration consists of the following steps.
The standard output is annotated in some detail [here](/docs/outputs/lmf_output).

+ Construct the potential and matrix elements.
  + [Interstitial and local parts](/docs/outputs/lmf_output/#potential-and-matrix-elements) of the potential are made.
  + [Partial waves](/docs/package_overview/#linear-methods-in-band-theory) $$\phi$$ and $$\dot{\phi}$$ are integrated from the 
    potential subject to the [boundary conditions](/tutorial/lmf/lmf_pbte_tutorial/#bc-explained).
  + Matrix elements of the partial waves (kinetic energy, potential energy, overlap) are assembled for the Kohn-Sham hamiltonian.  
  + Matrix elements of the interstitial potential &#10216;<i>&chi;</i><sub><i>i</i></sub>\|V\|<i>&chi;</i><sub><i>j</i></sub>&#10217;.
    for envelope functions <i>&chi;</i><sub><i>i</i></sub>.

  This is sufficient to make the Kohn-Sham hamiltonian. Other matrix elements may be made depending on circumstances, matrix elements
  for [optics](/tutorial/application/optics/) or for [spin-orbit coupling](/docs/input/inputfile/#ham) (**HAM\_SO=t**).
^
+ Makes an initial pass through the irreducible _k_ points in the Brillouin zone to
  [obtain the Fermi level](/docs/outputs/lmf_output/#brillouin-zone-integration).  and obtain integration weights for each band and _k_
  point into a binary file _wkp.pbte_{: style="color: green"}.  In general until the Fermi level is known, the weights assigned to each
  eigenfunction are not known, so the charge density cannot be assembled.  How labor is divided between the first and second pass depends on
  **BZ\_METAL**.  See [here](/docs/outputs/lmf_output/#integration-weights-and-the-metal-switch) for further discussion.
+ Makes a second pass to accumulate the charge density.  For local densities,
  essential information is retained as coefficients of the local density matrix (a compact form).
+ Assembles the local densities (true and smoothed) on their radial meshes from density matrices
+ Symmetrizes the density
+ Finds new logarithmic derivative parameters **pnu** by floating them to the band center-of-gravity
+ Computes the Harris-Foulkes and Kohn-Sham total energies
+ Computes the forces
+ mixes the input and output densities to form a new trial density
+ checks for convergence


**lmf**{: style="color: blue"} should converge to [self-consistency](/tutorial/lmf/lmf_pbte_tutorial/#faq) in 10 iterations.

Just before exiting after the last iteration, **lmf**{: style="color: blue"} prints out

<pre>
              &darr;         &darr;
 diffe(q)=  0.000000 (0.000005)    tol= 0.000010 (0.000030)   more=F
c nkabc=6 gmax=7.8 ehf=-55318.1620974 ehk=-55318.1620958
</pre>

The first line prints out the change in [Harris-Foulkes](/tutorial/lmf/lmf_tutorial/#faq) energy relative to the prior iteration and some norm of RMS change in the
charge density <i>n</i><sup>out</sup>&minus;<i>n</i><sup>in</sup> (see arrows), followed by the tolerances required for self-consistency.

The last line prints out a table of variables that were specified on the command line, and total
energies from the Harris-Foulkes and Kohn-Sham functionals.  Theses are different
functionals but they should approach the same value at self-consistency.
The **c** at the beginning of the line indicates that this iteration 
achieved self-consistency with the tolerances specified.

See [Table of Contents](/tutorial/lmf/lmf_pbte_tutorial#table-of-contents)

#### _Other Resources_

+ Click [here](/docs/outputs/lmfa_output/) to see annotated standard output from **lmfa**{: style="color: blue"}, and
  [here](/docs/outputs/lmf_output/) to see annotated standard output from **lmf**{: style="color: blue"}.

+ An input file's structure, and features of the programming language capability, is explained in some detail
  [here](/docs/input/inputfile/). The full syntax of categories and tokens can be found in the [input file manual](/docs/input/inputfilesyntax).

+ [This tutorial](https://lordcephei.github.io/buildingfpinput/) more fully describes some important tags the **lmf**{: style="color: blue"} reads,
  and [this one](/tutorial/gw/poscar_qsgw) presents alternative ways to build input files from various sources such as the VASP _POSCAR_{: style="color: green"} file.

+ [This tutorial](/tutorial/lmf/lmf_bi2te3_tutorial/) more fully explains the **lmf**{: style="color: blue"} basis set.
  There is a corresponding tutorial on the basics of a [self-consistent ASA calculation for PbTe](/tutorial/asa/lm_pbte_tutorial).
  [A tutorial on optics](/docs/properties/optics/) can be gone through after you have finished this one.

+ [This document](/docs/code/fpoverview/) gives an overview of some of **lmf**{: style="color: blue"}'s unique features and capabilities.

+ The theoretical formalism behind the **lmf**{: style="color: blue"} is described in detail in this book chapter:
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in _Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method_, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.

### _FAQ_
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#faq)


[//]: To start counter at 5, uncomment the next line
[//]: {:start="5"}

1. How does **lmf**{: style="color: blue"} iterate to self-consistency?

   It mixes the input density <i>n</i><sup>in</sup> with output density <i>n</i><sup>out</sup> generated by **lmf**{: style="color: blue"},
   to construct a new input density <i>n</i><sup>in</sup>.  This process is repeated until <i>n</i><sup>out</sup>=<i>n</i><sup>in</sup>
   (within a specified tolerance). The actual mixing algorithm can be quite involved; see [this page](/docs/input/inputfile/#itermix).

1. The gap is small and Pb is a heavy element.  Doesn't spin-orbit coupling affect the band structure?

   Yes, it does.  The bandgap will change significantly when spin-orbit coupling is added.

1. The LDA is supposed to underestimate bandgaps.  But the PbTe bandgap looks pretty good.  Why is that?

   This turns out to be largely an accident.  If spin orbit coupling is included, the bandgap appears to be pretty good, but in fact levels
   L<sub>6</sub><sup>+</sup> and L<sub>6</sub><sup>&minus;</sup> that form the valence and conduction band edges are inverted in the LDA. 
   See Table I of [this paper](http://prb.aps.org/abstract/PRB/v81/i24/e245120).
   As the paper notes, they are well described in QS<i>GW</i>.

1. How do you know where the band edges are?

   PbTe is has a quite simple band structure with high symmetry. It's a good bet that the
   band edges are on high-symmetry lines.  But in general the position of band edges can be
   quite complex.  A slightly more complicated case is Si.  See [this tutorial](/tutorial/lmf/lmf_bandedge).

1. Is there an easy way to calculate effective masses?

Yes, once you know where the band edge is. See [this tutorial](/tutorial/lmf/lmf_bandedge).

### _Additional exercises_
[//]: (/tutorial/lmf/lmf_pbte_tutorial/#additional-exercises)

1. Try self-consistent calculations with the Pb 5_d_ in the valence as a local orbital.  Repeat the calculation but remove the **PZ** part from _basp.pbte_{: style="color: green"}.

2. Specify symops manually.

3. Turn on spin orbit coupling and observe how the band structure changes.

4. Try rotations

5. k-convergence.  Try BZ_BZJOB
{::comment}

1. Alternatively you can add APW's to the basis.
Create a hyperlink when one becomes available.

2. --opt needs a tutorial.

{:/comment}

See [Table of Contents](/tutorial/lmf/lmf_pbte_tutorial#table-of-contents)
