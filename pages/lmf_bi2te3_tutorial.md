---
layout: page-fullwidth
title: "Properties of the lmf basis set"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/lmf_bi2te3_tutorial/"
header: no
---

### _Purpose_
{:.no_toc}
This tutorial is similar to the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/) but it focuses on features of the **lmf**{: style="color:
blue"} basis set.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Preliminaries_
{:.no_toc}
The input file structure is briefly described in [this lmf tutorial for Pbte](https://lordcephei.github.io/lmf_tutorial/), which you may wish to go through first.

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path. 

_____________________________________________________________

### _Command summary_

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

[Make an input file:](/tutorial/lmf/lmf_bi2te3_tutorial/#building-the-input-file)

~~~
nano init.bi2te3
blm init.bi2te3                                 #makes template actrl.bi2te3 and site.bi2te3
cp actrl.bi2te3 ctrl.bi2te3
~~~

[Free atomic density and basis parameters](/tutorial/lmf/lmf_bi2te3_tutorial/#initial-setup-free-atomic-density-and-parameters-for-basis)

~~~
lmfa ctrl.bi2te3                                #use lmfa to make basp file, atm file and to get gmax
cp basp0.bi2te3 basp.bi2te3                       #copy basp0 to recognised basp prefix
lmfa ctrl.bi2te3                                 #remake atomic density with updated valence-core partitioning
~~~

    ... to be finished

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Tutorial_

#### 1. _Building the input file_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#building-the-input-file)

This step is essentially identical to the [first step](/tutorial/lmf/lmf_pbte_tutorial/#building-the-input-file) in the PbTe tutorial.
An abbreviated version is presented here.

Cut and paste the following into _init.bi2te3_{: style="color: green"}.

~~~
# from http://cst-www.nrl.navy.mil/lattice/struk/c33.html
# Bi2Te3 from Wyckoff
% const a=4.3835 c=30.487 uTe=0.788 uBi=0.40
LATTICE
   SPCGRP=R-3M
   UNITS=A
   A={a} C={c}
SITE
    ATOM=Te X=0     0    0
    ATOM=Te X=0     0   {uTe}
    ATOM=Bi X=0     0   {uBi}
~~~

[This tutorial](/docs/input/inputfile/) explains how the input files _init.ext_{: style="color: green"} and _ctrl.ext_{: style="color: green"} are structured.

To create the skeleton input file invoke **blm**{: style="color: blue"}:

~~~
$ blm bi2te3
$ cp actrl.bi2te3 ctrl.bi2te3
~~~

There are five atoms in the unit cell: 2 Bi atoms and 3 Te atoms.  Two of the Te atoms are symmetry equivalent.

This template will not work as is; three essential pieces of information which **blm**{: style="color: blue"} does not supply are missing, to rectify this :

*   You must specify plane-wave cutoff **GMAX**; see the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#remaining-inputs).
*   You must specify a valid **k** mesh for Brillouin zone integration; see the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#remaining-inputs).
*   You must define a basis set which can be done manually or automatically, as described next.

**blm**{: style="color: blue"} creates a family of tags belonging to AUTOBAS to enbable other programs to automatically find a basis set for you. We will use this tag, which sets up a standard minimal basis:

    autobas[pnu=1 loc=1 lmto=3 mto=1 gw=0]

This is an alias for the tag in the **HAM** category

    AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=1 GW=0]

(Note that you must modify _actrl.bi2te3_{: style="color: green"} a little; the default gives [&hellip; LMTO=5 MTO=4], which makes a [double kappa basis](/tutorial/lmf/lmf_bi2te3_tutorial/#singlekappa).

**lmfa**{: style="color: blue"} calculates wave functions and atomic densities for free atoms. It also has a mode that automatically
generates information for basis sets, using tokens in **AUTOBAS** to guide it. This information is written to a file _basp0.ext_{: style="color:
green"}. **AUTOBAS** specifies set of conditions that enable **lmfa**{: style="color: blue"} to automatically build the basis set for you,
as described below.  Parameters are generated, but you can modify them as you like.

{::nomarkdown} <a name="autobaslmfa"></a> {:/}

<div onclick="elm = document.getElementById('autobastags'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description of the AUTOBAS tags.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id='autobastags'>{:/}


Tokens in **AUTOBAS** tell **lmfa**{: style="color: blue"} to do the following:

PNU=1&nbsp;    Calculate the [logarithmic derivative parameter _P<sub>l</sub>_](/docs/code/asaoverview/#logderpar) for the free atom.
:  Calculated parameters are saved in file _basp0.ext_{: style="color: green"} as **P=&hellip;**. Nothing about **P** is written if **PNU=0**.

LOC=1&nbsp;    Look for shallow cores to be explicitly treated as valence electrons, as [local orbitals](fp.html#localorbitals).
:  Shallow cores that meet specific criteria are identified and written to  _basp0.ext_{: style="color: green"} as **PZ=&hellip;**.
   No search is made if **LOC=0**

LMTO=3&nbsp;   Pick a default choice about the size of basis.  LMTO=3 is a standard minimal basis.
:  Run `lmfa --input` and look for **HAM\_AUTOBAS\_LMTO** to see what other choices there are.

   **lmfa**{: style="color: blue"} will pick some defaults for the _l_-cutoff, e.g. _spd_ or _spdf_ depending on the value of **LMTO**.

MTO=1&nbsp;    Choose 1-kappa basis set (single orbital per _l_ channel).
:  Small basis for fast calculations. For better quality calculations, it is recommended you use **MTO=2** or **MTO=4**.

GW=0&nbsp;     Create a setup for an LDA calculation.
:  If **GW=1**, tailor basis for a GW calculation, selecting stricter criteria for including shallow cores as valence, and the size of basis.

These tokens thus define some reasonable default basis for you. **lmfa**{: style="color: blue"} _writes_ _basp0.ext_{: style="color: green"}. This file is never read, but **lmf**{: style="color: blue"} will _read_ _basp.ext_{: style="color: green"} and use this information when assembling the basis set. The two files have the same structure and you can copy _basp0.ext_{: style="color: green"} to _basp.ext_{: style="color: green"}. What **lmfa**{: style="color: blue"} generates is not cast in concrete. You are free to adjust the parameters to your liking, e.g. add a local orbital or remove one from the basis.

{::nomarkdown} <a name="autobaslmf"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_bi2te3_tutorial/#autobaslmf)
{:/comment}

The **AUTOBAS** tokens tell **lmf**{: style="color: blue"} what to read from _basp.ext_{: style="color: green"}. It uses tokens in a manner similar, but not identical, to the way **lmfa**{: style="color: blue"} uses them:

PNU=1&nbsp;  Read parameters P for all species present in _basp.ext_{: style="color: green"}.
:  If PNU=0, these parameters will not be read.

LOC=1&nbsp;  tells **lmf**{: style="color: blue"} to read local orbital parameters **PZ**.
:  Since these parameters may also be specified by the input file,\\
   LOC=1 tells **lmf**{: style="color: blue"} to give precedence to parameters specified by ctrl file\\
   LOC=2 tells **lmf**{: style="color: blue"} to give precedence to parameters specified by basp.

**LMTO=**&nbsp;  is not used by **lmf**{: style="color: blue"}.

**MTO=1**&nbsp;   controls what part of **RSMH** and **EH** is read from _basp.bi2te3_{: style="color: green"}.
:       LMTO=1 or 3 tells lmf to read 1-kappa parameters specified by basp\\
        LMTO=2 or 4 tells lmf to read 2-kappa parameters specified by basp\\
        LMTO=1 or 2 tells lmf that parameters in the ctrl file take precedence\\
        LMTO=2 or 4 tells lmf that parameters in the basp file take precedence

GW=0&nbsp; tunes the basis for an LDA calculation
:   If **GW=1**, tune basis for a **GW** calculation.   For example log derivative parameters P
    are floated a little differently in the self-consistency cycle.
    They are weighted to better represent unoccupied states, at a slight cost
    to their representation of occupied states.

{::nomarkdown}</div>{:/}

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)

#### 2. _Checking sphere overlaps_
[//]: (tutorial/lmf/lmf_bi2te3_tutorial/#checking-sphere-overlaps)

Sphere overlaps can be checked using **lmchk**{: style="color: blue"}. To do this copy the template _actrl.bi2te3_{: style="color: green"} to the input file and run **lmchk**{: style="color: blue"}:

    $ lmchk bi2te3

You should see the site positions for all the atoms:

~~~
   Site    Class            Rmax        Hcr                 Position
    1      1  Te          2.870279    2.009195    0.00000    0.00000    0.00000
    2      3  Te2         2.870279    2.009195   -0.50000   -0.86603    1.46162
    3      3  Te2         2.870279    2.009195    0.50000    0.86603   -1.46162
    4      2  Bi          2.856141    1.999299    0.50000    0.86603    0.80309
    5      2  Bi          2.856141    1.999299   -0.50000   -0.86603   -0.80309
~~~

and a table of overlaps

~~~
 ib jb  cl1     cl2        Pos(jb)-Pos(ib)      Dist  sumrs   Ovlp    %    summt   Ovlp   %
  1  4  Te      Bi        2.391 -4.142  3.841  6.134  5.726  -0.41  -6.6   4.008  -2.13 -34.7
  1  5  Te      Bi       -2.391 -4.142 -3.841  6.134  5.726  -0.41  -6.6   4.008  -2.13 -34.7
  2  4  Te2     Bi       -2.391 -4.142 -3.149  5.726  5.726   0.00   0.0*  4.008  -1.72 -30.0
  3  5  Te2     Bi        2.391 -4.142  3.149  5.726  5.726   0.00   0.0*  4.008  -1.72 -30.0
~~~

By default, **blm**{: style="color: blue"} makes the spheres as large as possible without overlapping. In this case the Bi and Te radii are nearly the same.

The packing fraction is printed

~~~
 Cell volume= 1141.20380   Sum of sphere volumes= 492.34441 (0.43143)
~~~

Generally larger packing fractions are better because the augmentation [partial waves](/docs/package_overview/#linear-methods-in-band-theory) are quite accurate.
**0.43** is a fairly good packing fraction.

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)

#### 3. _The atomic density and basis set parameters_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#the-atomic-density-and-basis-set-parameters)

If you did not do so already copy _actrl.bi2te3_{: style="color: green"} to _ctrl.bi2te3_{: style="color: green"} and change
**[&hellip; LMTO=4&thinsp; MTO=4]** &rarr; **[&hellip; LMTO=3&thinsp; MTO=1]**).

Invoke **lmfa**{: style="color: blue"}:

    $ lmfa bi2te3

The primary purpose of **lmfa**{: style="color: blue"} is to generate a free atom density. A secondary purpose is to supply additional information about the basis set in an automatic way. All of this information can be supplied manually in the input file, but the **blm**{: style="color: blue"} provides a minimum amount of information. **lmfa**{: style="color: blue"} generates [_basp0.bi2te3_{: style="color: green"}](/docs/input/data_format/#the-basp-file) which contains

    BASIS:
    Te RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
    Bi RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 5.089 PZ= 0 0 15.936

Every species gets one line. This file specifies a basis set consisting of _spdf_ orbitals on Te sites, and _spdf_ orbitals on Bi sites, and a local _5d_ orbital on Bi.
See the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set) for further description of these parameters.

*Note:*{: style="color: red"} Remember that **lmf**{: style="color: blue"} reads from _basp.ext_{: style="color: green"}, not _basp0.ext_{: style="color: green"}.

The partitioning between valence and core states is something that requires a judgement call. **lmfa**{: style="color: blue"} has made a
default choice: from _basp0.bi2te3_{: style="color: green"} you can see that **lmfa**{: style="color: blue"} selected the
6_s_, 6_p_, 6_d_, 5_f_ states, populating them with charges &thinsp; 2, 3, 0, 0, making the total sphere charge Q=0. You can override the
default, e.g. choose the 5_d_ over the 6_d_ with SPEC_ATOM_P; override the _l_ channel charges with SPEC_ATOM_Q.

**lmfa**{: style="color: blue"} does the following to find basis set parameters:

+ Automatically finds deep states to include as valence electrons.
+ Selects sphere boundary condition for partial waves
+ Finds envelope function parameters

{::nomarkdown} <a name="singlekappa"></a> {:/}
{::comment}
(/tutorial/lmf/lmf_bi2te3_tutorial/#singlekappa)
{:/comment}

The process is essentially the same as described in the [PbTe
tutorial](/tutorial/lmf/lmf_pbte_tutorial/#automatic-determination-of-basis-set); it is described in some detail there and in the [annotated
**lmfa**{: style="color: blue"} output](/docs/outputs/lmfa_output/#generating-basis-information).  The main difference is that in this case a
smaller, single-kappa basis was specified (**LMTO=3**); **lmfa**{: style="color: blue"} makes (**RMSH,EH**)
instead of the double kappa (**RMSH,EH**; **RMSH2,EH2**).  Later we will improve on the basis by adding APW's.

With your text editor insert lines from _basp0.bi2te3_{: style="color: green"} in the **SPEC** category of the ctrl file, viz

~~~
  ATOM=Te         Z= 52  R= 2.870279  LMX=3  LMXA=3
    RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
  ATOM=Bi         Z= 83  R= 2.856141  LMX=3  LMXA=4
    RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 5.089 PZ= 0 0 15.936
~~~

Alternatively make **lmf**{: style="color: blue"} read these parameters from _basp.bi2te3_{: style="color: green"}.  Copy _basp0.bi2te3_{:
style="color: green"} to _basp.bi2te3_{: style="color: green"}, and modify it as you like. _basp.ext_{: style="color: green"}
is read after the main input file is read, if it exists.  According to which of following tokens is present, their corresponding parameters
will be be read from the basp file, superseding prior values for these contents:

AUTOBAS   | **lmfa**{: style="color: blue"} [writes](/tutorial/lmf/lmf_bi2te3_tutorial/#autobaslmfa), **lmf**{: style="color: blue"} [reads](/tutorial/lmf/lmf_bi2te3_tutorial/#autobaslmf)
MTO       | RSMH,EH (and RSMH2,EH2 if double kappa basis)
P         | P
LOC       | PZ


If this information is supplied in both the ctrl file and the basp file, [values of **MTO** and **LOC**](/tutorial/lmf/lmf_bi2te3_tutorial/#autobaslmf)
tell **lmf**{: style="color: blue"} which to use.  In this tutorial we will work just with the basp file.

    $ cp basp0.bi2te3 basp.bi2te3

The atm file was created by **lmfa**{: style="color: blue"} without prior knowledge that the 5_d_ local orbital is to be included as a
valence state (via a local orbital). Thus it incorrectly partitioned the core and valence charge. You must do one of the following:

1. Remove **PZ=0 0 15.936** from _basp.bi2te3_{: style="color: green"}. It will no longer be treated as a valence state. Removing it means
   the remaining envelope functions are much smoother, which allows you to get away with a coarser mesh density.
   Whether you need it or not depends on the context: with _GW_, for example, this state is a bit too shallow to be treated with Fock exchange
   only (which is how cores are handled in _GW_).

2. Copy _basp0.bi2te3_{: style="color: green"} to _basp.bi2te3_{: style="color: green"} and run **lmfa**{: style="color: blue"} over again:

~~~
$ cp basp0.bi2te3 basp.bi2te3
$ lmfa bi2te3
~~~

With the latter choice **lmfa**{: style="color: blue"} operates a little differently from the first pass. Initially the Bi 5_d_ was part of
the core (similar to the Pb 5_d_ in the [Pbte
tutorial](/tutorial/lmf/lmf_pbte_tutorial/#valence-core-partitioning-of-the-free-atomic-density); now it is included in the valence.

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)

#### 4. _GMAX and NKABC_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#gmax-and-nkabc)


##### 4.1 _Setting GMAX_

**blm**{: style="color: blue"} makes no attempt to automatically assign a value to the plane wave cutoff for the interstitial density.  This
value determines the mesh spacing for the charge density.  **lmf**{: style="color: blue"} reads this information through
[**HAM\_GMAX**](/docs/input/inputfile/#spec) or **EXPRESS\_gmax**, or **HAM\_FTMESH**.  It is a required input; but **blm**{: style="color: blue"} does not
automatically pick a value because its [proper choice](/docs/outputs/lmf_output/#envelope-function-parameters-and-their-g-cutoffs) depends
on the smoothness of the basis. In general the mesh density must be fine as the most strongly peaked orbital in the basis.

**lmfa**{: style="color: blue"} makes **RSMH** and **EH** and can determine an appropriate value for **HAM\_GMAX** based on them. In the
present instance, when the usual 6_s_, 6_p_, 6_d_, 5_f_ states are included **lmfa**{: style="color: blue"} recommends **GMAX=4.4** as can
be seen by inspecting the first **lmfa**{: style="color: blue"} run.  If you keep the 5_d_ in the valence and run **lmfa**{: style="color:
blue"} second time you will see this output

~~~
 FREEAT:  estimate HAM_GMAX from RSMH:  GMAX=4.4 (valence)  8.1 (local orbitals)
~~~

The valence states still require only **GMAX=4.4** but the 5_d_ state is strongly peaked but **GMAX=8.1** for the local orbitals. The 5_d_
state is strongly peaked at around the atom, and requires more plane waves to represent reasonably, even a smoothed version of it, than the
other states. The difference between 8.1 and 4.4 is substantial, and it reflects the additional computational cost of including deep
core-like states in the valence. This is the all-electron analog of the "hardness" of the pseudopotential in pseudopotential schemes. If you
want high-accuracy calculations (especially in the _GW_ context), you will need to include these states as valence. Including the Bi 5_d_ is
a bit of overkill for LDA calculations however. If you eliminate the Bi 5_d_ local orbital you can set GMAX=4.4 and significantly speed up the
execution time.  It is what this tutorial does.

##### 4.2 _Setting NKABC_

**blm**{: style="color: blue"} assigns the initial _k_-point mesh to zero. Note the following lines in _ctrl.bi2te3_{: style="color: green"}:

~~~
% const nkabc=0 gmax=0
...
# Brillouin zone
  nkabc=  {nkabc}                  # 1 to 3 values
~~~

*Note:*{: style="color: red"} **nkabc** is simultaneously a _variable_ and a _tag_ here.  This can be somewhat confusing.  The expression
&thinsp;**{nkabc}**&thinsp; gets parsed by the preprocessor and is turned into the value of _variable_ **nkabc** (see how **nit** gets turned into
**10** in the [PbTe tutorial](/tutorial/lmf/lmf_pbte_tutorial/#self-consistency)), so after preprocessing, the argument following _tag_ is 
a number.

**EXPRESS\_nkabc** (alias [**BZ\_NKABC**](/docs/input/inputfile/#bz)) governs the mesh of _k_-points. An appropriate choice will depend
strongly on the context of the calculation and the sytem of interest; the density-of-states at the Fermi level; whether Fermi surface
properties are important; whether you want optical properties as well as total energies well described; the precision you need; the
integration method, and so on. Any automatic formula can be dangerous, so **blm**{: style="color: blue"} will not choose an operational
default.

The most reliable way determine the appropriate mesh is to vary **nkabc** and monitor the convergence.  We don't need a self-consistent
calculation for that: the k-convergence will not depend strongly whether the potential is converged or assembled
from [free atoms](/docs/outputs/lmf_output/#mattheis-construction).

Do the following (assuming no 5_d_ local orbital)

~~~
lmf ctrl.bi2te3 -vgmax=4.4 --quit=band -vnkabc=2
lmf ctrl.bi2te3 -vgmax=4.4 --quit=band -vnkabc=3
lmf ctrl.bi2te3 -vgmax=4.4 --quit=band -vnkabc=4
lmf ctrl.bi2te3 -vgmax=4.4 --quit=band -vnkabc=5
lmf ctrl.bi2te3 -vgmax=4.4 --quit=band -vnkabc=6
~~~

The meaning of `--quit=band` is described [here](/docs/input/inputfile/#pr)

Total energies are written to the [save file](/docs/input/data_format/#the-save-file) _save.bi2te3_{: style="color: green"}
It should read:

~~~
h gmax=4.4 nkabc=2 ehf=-126808.2361717 ehk=-126808.1583957
h gmax=4.4 nkabc=3 ehf=-126808.3137885 ehk=-126808.2492178
h gmax=4.4 nkabc=4 ehf=-126808.3168406 ehk=-126808.2505156
h gmax=4.4 nkabc=5 ehf=-126808.3165536 ehk=-126808.2497121
h gmax=4.4 nkabc=6 ehf=-126808.3164058 ehk=-126808.2494041
~~~

You can use the [**vextract**{: style="color: blue"}](/docs/input/commandline/#switches-for-vextract) tool to conveniently extract a table
of the [Harris-Foulkes](/tutorial/lmf/lmf_tutorial/#faq) total energy as a function of nkabc

~~~
cat save.bi2te3 | vextract h nkabc ehf | tee dat
~~~

You can plot the data, or just see by inspection that the energy is converged to less than a mRy with 4&times;4&times;4 _k_ mesh and about
0.1&thinsp;mRy with a 5&times;5&times;5 _k_ mesh.  A detailed analysis of _k_ point convergence is given
[here](/docs/numerics/bzintegration/).

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)

#### 5. _Self-consistent LDA calculation, minimal basis_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#self-consistent-lda-calculation-minimal-basis)

In the following we will use **nkabc=3**, though after convergence is reached we might consider increasing it a little.  Before doing the
calculation you can use your text editor to set **nkabc=3** and **gmax=4.4**, or continue to set assign values from the command line.

The density can be made self-consistent with

~~~
rm -f mixm.bi2te3 save.bi2te3
lmf ctrl.bi2te3 -vgmax=4.4 -vnkabc=3
~~~

##### 5.1 _Convergence in density_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#convergence-in-density)

You should **lmf**{: style="color: blue"} reach self-consistency in 9 iterations.

The Harris-Foulkes and Kohn-Sham total energies are **ehf=-126808.3137885** and **ehk=-126808.2492178**
from the Mattheis construction.  At self-consistency they come together: **ehf=-126808.2950696** and **ehk=-126808.2950608**.

The self-consistent value is 18&thinsp;mRy _less binding_ than the Harris-Foulkes energy of the Mattheis construction,
and 46&thinsp;mRy <i>more binding</i> than the corresponding Kohn-Sham energy.
That the two initial functionals bracket the self-consistent result, and that the HF
is generally closer to the final result than the HK functional, is typical behavior.
(The HF functional is generally more stable.)

##### 5.2 _Convergence in G cutoff_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#convergence-in-g-cutoff)

How reliable the _G_ cutoff can be seen from this table:

~~~
 sugcut:  make orbital-dependent reciprocal vector cutoffs for tol=1.0e-6
 spec      l    rsm    eh     gmax    last term   cutoff
  Te       0    1.61  -0.89   4.603    3.31E-06    1635*
  Te       1    1.68  -0.29   4.662    5.08E-06    1635*
  Te       2*   1.91  -0.10   4.273    1.15E-06    1539 
  Te       3    1.91  -0.10   4.471    1.71E-06    1635*
  Bi       0    1.67  -0.84   4.441    1.29E-06    1635*
  Bi       1    1.87  -0.21   4.183    1.08E-06    1411 
  Bi       2*   1.90  -0.10   4.297    1.37E-06    1539 
  Bi       3    1.90  -0.10   4.497    2.06E-06    1635*
~~~

**gmax=4.4** isn't quite large enough to push the error in the plane-wave expansion of the envelopes below tolerance (**1.0e-6**), but it is pretty close.
You can check how well the total energy is converged by doing

~~~
lmf ctrl.bi2te3 -vgmax=4.4 -vnkabc=3 --quit=band
lmf ctrl.bi2te3 -vgmax=6 -vnkabc=3 --quit=band
~~~

and comparing **ehf** in the last two lines of _save.bi2te3_{: style="color: green"}.  You should find that the energy is converged to about 0.1&thinsp;mRy.

##### 5.3 _Convergence in lmxa_
[//]: (/tutorial/lmf/lmf_bi2te3_tutorial/#convergence-in-lmxa)

See [Table of Contents](/tutorial/lmf/lmf_bi2te3_tutorial/#table-of-contents)


#### _Modifying the input file for GW_

_GW_ calculations demand more of the basis set because unuoccupied states are important. To set up a job in preparation for a _GW_ calculation, invoke **blm** as :

    $ blm --gw bi2te3

Compare _actrl.bi2te3_{: style="color: green"} generated with the **-\-gw** switch to one without. One important difference will be that the default basis parameters are modified because **AUTOBAS** becomes:

    AUTOBAS[PNU=1 LOC=1 LMTO=5 MTO=4 GW=1]

The basis is similar to **LMTO=4** but **EH** has been set a little deeper. This helps the QS<i>GW</i> implementation interpolate between _k_-points. The larger basis makes a minor difference to the valence bands; but the conduction bands change, especially the higher in energy you go.

{::comment}

_*Note_  The GW implementation allows you to use plane waves, but the QS<i>GW</i> part of it does not, as yet.

{:/comment}
