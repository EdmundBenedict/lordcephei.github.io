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

This tutorial explains the main features of the **lmf**{: style="color: blue"} basis set.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Preliminaries_

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

    autobas[pnu=1 loc=1 lmto=3 mto=3 gw=0]

This is an alias for the same tag in the **HAM** category.

    AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=3 GW=0]

(Note that you must modify _actrl.bi2te3_{: style="color: green"} a little; the default gives [.. LMTO=5 MTO=4], which makes a [double kappa basis](#multikappa).

**lmfa**{: style="color: blue"} calculates wave functions and atomic densities for free atoms. It also has a mode that automatically generates information for basis sets, using tokens in AUTOBAS to guide it. This information is written to a file _basp0.ext_{: style="color: green"}. AUTOBAS specifies set of conditions that enable **lmfa**{: style="color: blue"} to automatically build the basis set for you, including specification of envelope function parameters [RSMH and EH](fp.html#spec). Alternatively you can define parameters such as EH and RSMH basis by hand, as described [in this tutorial](FPtutorial.html#basis).

Tokens in AUTOBAS tell **lmfa**{: style="color: blue"} to do the following:

PNU=1    Calculate the [logarithmic derivative parameter _P<sub>l</sub>_](/docs/code/asaoverview/#logderpar) for the free atom.
:  Calculated parameters are saved in file _basp0.ext_{: style="color: green"} as **P=&hellip;**. Nothing about **P** is written if **PNU=0**.

LOC=1    Look for shallow cores to be explicitly treated as valence electrons, using [local orbitals](fp.html#localorbitals).
:  Shallow cores that meet specific criteria are identified and written to  _basp0.ext_{: style="color: green"} as **PZ=&hellip;**
   No search is made if **LOC=0**

LMTO=3   Pick a default choice about the size of basis.  LMTO=3 is a standard minimal basis.
:  Run `lmfa --input` and look for **HAM\_AUTOBAS\_LMTO** to see what other choices there are.

   **lmfa**{: style="color: blue"} will pick some defaults for the _l_-cutoff, e.g. _spd_ or _spdf_ depending on the value of **LMTO**.

MTO=1    Choose 1-kappa basis set (single orbital per _l_ channel).
:  Small basis for fast calculations. For better quality calculations, it is recommended you use **MTO=2**.

GW=0     Create a setup for an LDA calculation.
:  If **GW=1**, tailor basis for a GW calculation, selecting stricter criteria for including shallow cores as valence, and the size of basis.

These tokens thus define some reasonable default basis for you. **lmfa**{: style="color: blue"} _writes_ _basp0.ext_{: style="color: green"}. This file is never read, but **lmf**{: style="color: blue"} will _read_ _basp.ext_{: style="color: green"} and use this information when assembling the basis set. The two files have the same structure and you can copy _basp0.ext_{: style="color: green"} to _basp.ext_{: style="color: green"}. What **lmfa**{: style="color: blue"} generates is not cast in concrete. You are free to adjust the parameters to your liking, e.g. add a local orbital or remove one from the basis.

The **AUTOBAS** tokens tell **lmf**{: style="color: blue"} what to read from _basp.ext_{: style="color: green"}. It uses tokens in a manner similar, but not identical, to the way **lmfa**{: style="color: blue"} uses them:

PNU=1  Read parameters P for all species present in _basp.ext_{: style="color: green"}.
:  If PNU=0, these parameters will not be read.

LOC=1  tells **lmf**{: style="color: blue"} to read local orbital parameters **PZ**.
:  Since these parameters may also be specified by the input file,
             LOC=1 tells lmf to give precedence to parameters specified by ctrl file
             LOC=2 tells lmf to give precedence to parameters specified by basp.

**LMTO=**   is not used by **lmf**{: style="color: blue"}.

MTO=1   controls what part of **RSMH** and **EH** is read from _basp.bi2te3_{: style="color: green"}.
:       LMTO=1 or 3 tells lmf to read 1-kappa parameters specified by basp\\
        LMTO=2 or 4 tells lmf to read 2-kappa parameters specified by basp\\
        LMTO=1 or 2 tells lmf that parameters in the ctrl file take precedence\\
        LMTO=2 or 4 tells lmf that parameters in the basp file take precedence

GW=0   Tune basis for an LDA calculation
:   If **GW=1**, tune basis for a **GW** calculation.   For example log derivative parameters P
    are floated a little differently in the self-consistency cycle.
    They are weighted to better represent unoccupied states, at a slight cost
    to their representation of occupied states.

#### 2. _Checking sphere overlaps_

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


#### 3. _Making the atomic density_

Make the free atom density. If you did not do so already copy _actrl.bi2te3_{: style="color: green"} to the input file (changing [.. LMTO=4 MTO=4] to [.. LMTO=3 MTO=3]) and invoke **lmfa**{: style="color: blue"}:

    $ lmfa bi2te3

The primary purpose of **lmfa**{: style="color: blue"} is to generate a free atom density. A secondary purpose is to supply additional information about the basis set in an automatic way. All of this information can be supplied manually in the input file, but the autogenerated input file supplies a minimum amount of information. **lmfa**{: style="color: blue"} generates _basp0.bi2te3_{: style="color: green"} which contains

    BASIS:
    Te RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
    Bi RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 5.089 PZ= 0 0 15.936

Every species gets one line. This file specifies a basis set consisting of _spdf_ orbitals on Te sites, and _spdf_ orbitals on Bi sites, and a local _5d_ orbital on Bi. The contents of this file are explained [above](#autobas); see also [RSMH and EH](fp.html#spec), [P](lmto.html#pbasp), and [PZ](fp.html#localorbitals).

*Note:*{: style="color: red"} Remember that **lmf**{: style="color: blue"} reads from _basp.ext_{: style="color: green"}, not _basp0.ext_{: style="color: green"}.

##### 3.1 _Automatically finding deep states to include as valence electrons_ 

The partitioning between valence and core states is something that requires a judgement call. **lmfa**{: style="color: blue"} has made a default choice for you: the [output](FPsamples/out.bi2te3.lmfa1#bihead) shows that for Bi, **lmfa**{: style="color: blue"} selected the 6_s_, 6_p_, 6_d_, 5_f_ states, populating them with charges   2, 3, 0, 0. Note that the total sphere charge is Q=0. You can override the default, e.g. choose the 5_d_ over the 6_d_ with SPEC_ATOM_P; override the _l_ channel charges with SPEC_ATOM_Q.

As was explained [earlier](#autobas), when HAM_AUTOBAS_QLOC is set **lmfa**{: style="color: blue"} will look for shallow core levels below 6_s_, 6_p_, 6_d_, 5_f_ states, and as [this table](FPsamples/out.bi2te3.lmfa1#localorbital) shows **lmfa**{: style="color: blue"} selected the 5_d_ orbital which is normally a core state, to be included as a [local orbital](fp.html#localorbitals) so that the usual 6_d_ state and the 5_d_ state are simultaneously included in the basis. Even though the 5_d_ state is fairly deep (the [output](FPsamples/out.bi2te3.lmfa1#bicore) shows it lies at −2 Ry), the criterion of having a charge density outside the smoothing radius greater than 3×10−3 was met. (Use HAM_AUTOBAS_ELOC and HAM_AUTOBAS_QLOC to change these criteria.) **lmfa**{: style="color: blue"} supplies information about this to _basp0.bi2te3_{: style="color: green"}, in the form  PZ=0 0 15.936 (no local orbitals for _s_ or _p_ states). The 0.936 is significant: it tells **lmf**{: style="color: blue"} what boundary condition to use for the 5_d_ radial function.

##### 3.2 _Automatically finding linearization energies_

Because HAM_AUTOBAS_P is set, **lmfa**{: style="color: blue"} save estimates for logarithmic derivative parameters P into basp0._ext_. As is well known from elementary quantum mechanics, and as described [here](lmto.html#pbasp), there is a relation between the energy of a wave function and its logaritmic derivative at some radius. This information is supplied through the parameters P.

**lmfa**{: style="color: blue"} calculates P for the free-atom potential. Since this potential is not so far removed from the crystal potential, these parameters can find the "band center" reasonably well for each partial wave _l_. In any case, these are only estimates; they normally get "floated" in the self-consistency cycle.

##### 3.3 _Automatically finding envelope function parameters_

Finally, the input file contains AUTOBAS[MTO=1]. This causes **lmfa**{: style="color: blue"} to envelope function parameters [RSMH and EH](fp.html#spec) (RSMH is the [most important](FPtutorial.html#optimizebasis) of the two) that fit the free atom wave functions well, and save the result in _basp0.bi2te3_{: style="color: green"}. Unfortunately, what is optimum for the free atom is not optimum for the crystal, but the parameters are a reasonable starting point. These parameters are important, as they determine the quality of the basis. Later we discuss ways to optimize them, or improve the basis quality by adding APWs. **blm** cannot automatically determine every required input from the structural data. But for the following reasons: **lmf**{: style="color: blue"} will not run properly as the situation now stands



1.   The [basis set](fp.html) has to be specified. **lmfa**{: style="color: blue"} autogenerated parameters for a basis set, and saved the result to _basp0.bi2te3_{: style="color: green"}. A decision must be made whether to use **lmfa**{: style="color: blue"}'s choices for RSMH, EH, P, and PZ, to supply your own, or to modify **lmfa**{: style="color: blue"}'s choice. In any case, you can do it in one of two ways:

    *   With your text editor pick up the lines in _basp0.bi2te3_{: style="color: green"} for Te and Bi, and paste them into _ctrl.bi2te3_{: style="color: green"}, e.g.

            ATOM=Te Z= 52  R= 2.870279
            RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
            ATOM=Bi Z= 83  R= 2.856141
            RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 PZ= 0 0 15.936

    *   Copy _basp0.bi2te3_{: style="color: green"} to _basp.bi2te3_{: style="color: green"}, and modify it as you like. File basp._ext_ is read after the main input file is read. If basp._ext_ exists, and one or more of the following tokens is present, their corresponding parameters _may_ be read from basp._ext_:
    *   AUTOBAS[MTO]: read RSMH,EH (also possibly RSMH2,EH2)
    *   AUTOBAS[P]: read P
    *   AUTOBAS[PZ]: read PZ

    If some this information is given in both the ctrl file and the basp file, the AUTOBAS settings tell **lmf**{: style="color: blue"} which to use, as described [here](#basprules).

2.  The atm file was created by **lmfa**{: style="color: blue"} without prior knowledge that the 5_d_ local orbital is to be included as a valence state (via a local orbital). Thus it incorrectly partitioned the core and valence charge. You must do one of the following:

    *   Remove **PZ=0 0 15.936** from _basp.bi2te3_{: style="color: green"}. It will no longer be treated as a valence state. Removing it means the remaining envelope functions are much smoother, which allows you to get away with a coarser mesh density, as described [below](#gmax). Whether you need it or not depends on the context.

    *   Copy _basp0.bi2te3_{: style="color: green"} to _basp.bi2te3_{: style="color: green"} and run **lmfa**{: style="color: blue"} over again:

            $ cp basp0.bi2te3 basp.bi2te3
            $ lmfa bi2te3

    With the latter choice **lmfa**{: style="color: blue"} operates a little differently from before as can be seen by comparing [new output](FPsamples/out.bi2te3.lmfa2) with the old. Initially the Bi 5_d_ was part of the [core](FPsamples/out.bi2te3.lmfa1#bicore); now is included as part of the [valence](FPsamples/out.bi2te3.lmfa2#xxx2).

3.  **blm** does not by default assign any value to the plane wave cutoff for the interstitial density. **lmf**{: style="color: blue"} reads this information through [HAM_GMAX](FPtutorial.html#GMAX). It is a required input; but **blm** does not pick a value because its [proper choice](FPtutorial.html#meshdensity) depends on the smoothness of the basis. **lmfa**{: style="color: blue"} will determine a suggested value for HAM_GMAX for you. In the present instance, when the usual 6_s_, 6_p_, 6_d_, 5_f_ states are included **lmfa**{: style="color: blue"} recommends GMAX=4.4 as can be seen by inspecting the [first **lmfa**{: style="color: blue"} run](FPsamples/out.bi2te3.lmfa1#gmax). In the second run it recommends GMAX=4.1 from the valence states alone (as before), but because of the 5_d_ state **lmfa**{: style="color: blue"} recommends that [GMAX=8.1](FPsamples/out.bi2te3.lmfa2#gmax). The 5_d_ state is strongly peaked at around the atom, and requires more plane waves to represent reasonably, even a smoothed version of it, than the other states. The difference between 8.1 and 4.4 is substantial, and it reflects the additional computational cost of including deep core-like states in the valence. This is the all-electron analog of the "hardness" of the pseudopotential in pseudopotential schemes. If you want high-accuracy calculations (especially in the _GW_ context), you will need to include these states as valence. This particular choice of local orbital is rather overkill for LDA calculations however. If you eliminate the Bi 5_d_ local orbital you can set GMAX=4.4 and significantly speed up the execution time.

4.  **blm** assigns the initial _k_-point mesh to zero. Note the following lines in _actrl.bi2te3_{: style="color: green"}:

        % const met=5 nk=0
        BZ      NKABC={nk}  METAL={met}  # NKABC requires 1 to 3 positive numbers

    BZ_NKABC governs the mesh of _k_-points. An appropriate choice will depend strongly on the context of the calculation and the sytem of interest; the density-of-states at the Fermi level; whether Fermi surface properties are important; whether you want optical properties as well as total energies well described; the precision you need; the integration method, and so on. Any automatic formula can be dangerous, so **blm** will not choose a default for you. In this case, a 4×4×4 mesh works well. Use your text editor to change nk=0 to nk=4. Alternatively, supply --nk=.. to **blm** on the command line, as was done in [this tutorial](Demo_QSGW_Si.html#nk).

    Note that as generated, _ctrl.bi2te3_{: style="color: green"} will reflect METAL=5. Using METAL=5 with the tetrahedron integration is the recommended way to handle Fermi surface integration in metals. See [this tutorial](FPtutorial.html#metal) for some discussion.

#### _Input files for GW_

_GW_ calculations demand more of the basis set because unuoccupied states are important. To set up a job in preparation for a _GW_ calculation, invoke **blm** as :

    $ blm --gw bi2te3

Compare _actrl.bi2te3_{: style="color: green"} generated with the --gw switch to one without. One important difference will be that the default basis parameters are modified because AUTOBAS becomes:

    AUTOBAS[PNU=1 LOC=1 LMTO=5 MTO=4 GW=1]

The basis is similar to LMTO=4 but EH has been set a little deeper. This helps the QS_GW_ implementation interpolate between _k_-points. The larger basis makes a minor difference to the valence bands; but the conduction bands change, especially the higher in energy you go.

Look also at this [QS_GW_ demo for Silicon](Demo_QSGW_Si.html).

_*Note_  The GW implementation allows you to use plane waves, but the QS_GW_ part of it does not, as yet.
