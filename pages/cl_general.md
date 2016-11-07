---
layout: page-fullwidth
title: "Command Line switches"
permalink: "/docs/commandline/general/"
header: no
---

#### _Purpose_
_____________________________________________________________
{:.no_toc}
This page serves to document the command line switches generally applicable to most of the packages in the suite, and to give an idea of the usage cases of certain switches and switch types.

#### _Table of Contents_
_____________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}
{::comment}
(/docs/commandline/general/#table-of-contents)
{:/comment}

#### _Switches for_ lmf
{::comment}
(/docs/commandline/general/#switches-for-lmf)
{:/comment}

**lmf**{: style="color: blue"} is the [main density-functional code](/docs/code/fpoverview/) in the Questaal suite.

Command-line switches:

**\-\-rs=#1[,#2,#3,#4,#5**]
:  tells **lmf**{: style="color: blue"} how to read from or write to the restart file.

   +  **#1=0:** do not read the restart file on the initial iteration, but overlap free-atom densities.
      Requires [_atm.ext_{: style="color: green"}](/tutorial/lmf/lmf_pbte_tutorial/#initial-setup-free-atomic-density-and-parameters-for-basis).
   +  **#1=1:** read restart data from binary _rst.ext_{: style="color: green"}
   +  **#1=2:** read restart data from ascii _rsta.ext_{: style="color: green"}
   +  **#1=3:** same as **0**, but also tells **lmf**{: style="color: blue"} to overlap free-atom densities after a molecular statics or molecular dynamics step.
   +  Add 10 to additionally adjust the mesh density to approximately accommodate shifts in site positions relative to those used in the generation of the
      restart file.  See **\-\-rs** switch #3 below for which site positions the program uses.
   +  Add 100 to rotate local densities, if the lattice has been rotated.

   +  **#2=0:** serves same function as **#1**, but for writing output densities.
   +  **#2=1:** write binary restart file _rst.ext_{: style="color: green"}
   +  **#2=2:** write ascii restart file _rsta.ext_{: style="color: green"}
   +  **#2=3:** write binary file to _rsta_.#{: style="color: green"}, where # = iteration number

   +  **#3=0:** read site positions from restart file, overwriting positions from input file (default)
   +  **#3=1:** ignore positions in restart file

   +  **#4=0:** read guess for Fermi level and window from restart file, overwriting data from input file (default).
      This data is needed when the BZ integration is performed by sampling.
   +  **#4=1:** ignore data in restart file

   +  **#5=0:** read [logarithmic derivative parameters](/tutorial/lmf/lmf_pbte_tutorial/#bc-explained) **P** from restart file, overwriting data from input file (default).
   +  **#5=1:** ignore **P** in restart file

   Default switches:&ensp; **\-\-rs=1,1,0,0,0**.&ensp; Enter anywhere between one and five integers; defaults are used for those not given.
^
**\-\-band[~options]**
: tells **lmf**{: style="color: blue"} to generate energy bands instead of making a self-consistent calculation.  The energy bands (or energy levels)
   can be generated at specified k-points in one of three formats, or [modes](/docs/input/data_format/#file-formats-for-k-point-lists).

   + [Symmetry line mode](/docs/input/data_format/#symmetry-line-mode) (default) is designed for plotting energy bands along symmetry lines.  In
     this case <i>k</i>-points are specifed by a sequences of lines with start and end points.  The output is a bands file in a
     [special format](/docs/misc/plbnds/examples) that **plbnds**{: style="color: blue"} is [designed to read](/docs/misc/plbnds).
   + The [list mode](/docs/input/data_format/#list-mode) is a general purpose mode to be used when energy levels are sought at some arbitrary set
     of <i>k</i>-points, specified by the user.  Data is written in a [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays)
     with k-points followed by eigenvalues.
   + The [mesh mode](/docs/input/data_format/#mesh-mode) is a mode that generates states on a uniform mesh of <i>k</i>-points in a plane.  Its
     purpose is to generate contour plots of constant energy surfaces, e.g. the Fermi surface.
     Data file output is written in a [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) designed for
     [contour plots](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr),

   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-band**):

   + **~qp**:&ensp;     list mode. An arbitrary list of <i>k</i> points can be specified.
             See [here](/docs/input/data_format/#file-formats-for-k-point-lists) for the file format.
   + **~con**:&ensp;    mesh mode for contour plot. <i>k</i>-points are specified on a uniform 2D grid; data is written for a specified list of bands.
             See [here](/docs/input/data_format/#file-formats-for-k-point-lists) for file format in this mode
   + **~bin**:&ensp;         write bands as a binary file, file name _bbnds.ext_{: style="color: green"}.  Works only with **~qp** and **~con** modes.
   + **~fn=<b>fnam</b>**:&ensp;  read <i>k</i> points from file **fnam.ext**{: style="color: blue"}. Default name is _qp.ext_{: style="color: green"}.
   + **~ef=#**:&ensp;        Use **#** for Fermi level.
   + **~spin1**:&ensp;       generate bands for 1st spin only (spin polarized case)
   + **~spin2**:&ensp;       generate bands for 2nd spin only (spin polarized case)
   + **~mq**:&ensp;          q-points are given as multiples of reciprocal lattice vectors Applies to symmetry line and qp-list modes only
   + **~long**:&ensp;        write bands with extra digits precision (has no effect for default mode)
   + **~rot=<i>strn</i>**:&ensp;    rotates the given <i>k</i> by a [rotation](/docs/misc/rotations) given by <i>strn</i>.
   + **~lst=<i>list</i>**:&ensp;    write only a subset of energy levels by an [integer list](/docs/misc/integerlists/) (contour mode only).
   + **~nband=#**:&ensp;     Write out no more than # bands (not to be used in conjunction with **~lst** !)
   + **~evn=#** keep track of smallest and largest eval for #th band. Print result at close.  (Purely for informational purposes).
   + **~col=<b><i>orbital-list</i></b>**:&ensp;    assign weights to orbitals specified as an [integer list](/docs/misc/integerlists).
   + **~col2=<b><i>orbital-list</i></b>**   generate a second weight to orbitals specified in a list.
      With this option you can make band plots with three independent colors.

   The **col** option tells the band generator to save, in addition to
   the energy bands, a corresponding weight for each energy.
   Each band is resolved into individual orbital character by a Mulliken decomposition
   The sum of Mulliken weights from <b><i>orbital-list</i></b> is the weight assigned to a state.
   Thus if <b><i>orbital-list</i></b> contains all orbitals the weights will be unity.

   The individual orbitals make up the hamiltonian basis. States specified in <b><i>orbital-list</i></b>
   corresponding to the ordering of the orbitals in the hamiltonian.  You can get a
   table of this ordering by invoking `lm|lmf --pr55 --quit=ham ...`.
   Choose <b><i>orbital-list</i></b> from the orbitals you want to select out of the Table.

   This list can sometimes be rather long and complex.  To accomodate this,
   some simple enchancements are added to the standard [integer list syntax](/docs/misc/integerlists/).

   _Note:_{: style="color: red"} **tbe**{: style="color: blue"} does not color weights capability.
^
**\-\-rpos=_fnam_**
:  tells **lmf**{: style="color: blue"} to read site positions from _fnam.ext_{: style="color: green"} after the input file has been read.
   _fnam.ext_{: style="color: green"} is in standard [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays)
^
**\-\-wpos=_fnam_**
:  tells **lmf**{: style="color: blue"} to write site positions to _fnam.ext_{: style="color: green"} after self-consistency or a relaxation step.
^
**\-\-pdos[~options] &thinsp;\|&thinsp; \-\-mull[:options]**
:  tells **lmf**{: style="color: blue"} to generate weights for density-of-states or Mulliken analysis resolved into partial waves.
   Options are described [here](/docs/commandline/general/#switches-for-lmdos).
^
**\-\-cls[.ib,l,n[.ib,l,n][.lst=list,l,n[.lst=list,l,n]][.fn=file]]**
:  tells **lmf**{: style="color: blue"} to generate weights to compute matrix
                   elements and weights for core-level-spectroscopy.
   See **subs/suclst.f**{: style="color: green"} for a description of options.
^
**\-\-optbas[~sort][~etol=#][~spec=_spid_[,rs][,e][,l=###]...]**
:  Operates the program in a special mode to optimize the total energy wrt the basis set. **lmf**{: style="color: blue"} makes several band
   passes (not generating the output density or adding to the save file), varying selected parameters belonging to tokens RSMH= and EH= to
   minimize the total energy wrt these parameters.\\
   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-optbas**):

   + **etol=#**:&ensp;  only adjust parameter if energy gain exceeds **#**.
   + No species given:&ensp; **lmf**{: style="color: blue"} optimizes wrt RSMH in each species.
   + **spec=_spid_,rs**: Optimize wrt RSMH for a particular species.
   + **spec=_spid_,e**:  Optimize wrt EH for a particular species.
   + **spec=_spid_,rs,e**:  Optimize wrt both RSMH and EH for a particular species.
   + **spec=_spid_\hellip;,_l=###'**:  Specify which _l_ to optimize (default is all _l_ in the basis)
   + **sort**: sort RSMH from smallest to largest.  The total energy is more sensitive to small RSMH;, then the most important parameters are optimized first.
^
**\-\-rdbasp[:_fn_]**
:  tells the program to read basis parameters from file **_fn_**.
   If not present, **_fn_** defaults to _basp.ext_{: style="color: green"}.
   This supersedes settings in **HAM\_AUTOBAS**.
^
**\-\-wden[~options]**
:  tells **lmf**{: style="color: blue"} to write the charge density to disk, on a uniform of mesh of points.
   At present, there is no capability to interpolate the smoothed density to an arbitrary plane, so you are restricted to choosing a plane
   that has points on the mesh.\\
   Options syntax:\\
   **[~fn=filenam][core=#][spin][3d][ro=#1,#2,#3][o=#1,#2,#3][q=#1,#2,#3][lst=band-list][l1=#1,#2,#3,[#4]][l2=#1,#2,#3,[#4]]**

   Information for the plane is specified by three groups of numbers: the origin (**o=**), i.e. a point through which the plane must pass; a first
   direction vector **l1** with its number of points; and a second direction vector **l2** with its number of points.  Default values will be taken for
   any of the three sets you do not specify.  The density generated is the smooth density, augmented by the local densities in a polynomial
   approximation (see option **core**)

   To comply with this restriction, all three groups of numbers may be given sets of integers.  Supposing your lattice vectors are
   **p1**, **p2**, and **p3**, which the smooth mesh having (**n1**,**n2**,**n3**) divisions.  Then the vector (**l1**=**#1**,**#2**,**#3**) corresponds to\\
      &emsp; **v1 = #1/n1 p1 + #2/n2 p2 + #3/n3 p3** \\
   Specify the origin (a point through which the plane must pass) by\\
      &emsp; **~o=i1,i2,i3**\\
   Default value is **o=0,0,0**. Alternatively you can specify a the origin in Cartesian coordinates by:\\
      &emsp; **~ro=x1,x2,x3**\\
   (**x1**,**x2**,**x3**) a vector in Cartesian coordinates, units of alat, and it is converted into the nearest integers **i1**,**i2**,**i3**.
   Thus the actual origin may not exactly coincide with (**x1**,**x2**,**x3**).

   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-wden**):

    + **~l1=#1,#2,#3[,#4]**&ensp;  first direction vector as noted above, that is:\\
       **#1**,**#2**,**#3** select the increments in mesh points along each of the three lattice vectors that define the direction vector.\\
       The last number (**#4**) specifies how many points to take in this direction and therefore corresponds to a length.
       Default values : **l1=1,0,0,n1+1** where **n1** is the number of points on the third axis.
    + **~l2=#1,#2,#3[,#4]**&ensp; second direction vector as noted above, and number of points (**#4**)\\
       Default values : **l2=0,1,0,n2+1** where **n2** is the number of points on the second axis.
    + **core=#**   specifies how local densities are to be included in the mesh.\\
       Any local density added is expanded as polynomial * gaussian, and added to the smoothed mesh density.
       + **#=0**&ensp; includes core densities + nuclear contributions
       + **#=1**&ensp; includes core densities, no nuclear contributions
       + **#=2**&ensp; exclude core densities
       + **#=-1**&ensp; no local densities to be included (only interstitial)
       + **#=-2**&ensp; local density, with no smoothed part
       + **#=-3**&ensp; interstitial and local smoothed densities\\
       Default: **core=2**

    + **fn=_filnam_**&ensp;  specifies the file name for file I/O. The default name is _smrho.ext_{: style="color: green"}
    + **3d**&ensp;           causes a 3D mesh density to be saved in XCRYSDEN format
    + **q=q1,q2,q3** and **lst=_list-of-band-indices_**\\
      These switches should be taken together. They generate the density from a single k-point only (at q) and for a particular set of bands.
      Use [integer list syntax](/docs/misc/integerlists/) for _list-of-band-indices_.

    Example: suppose **n1=n2=48** and **n3=120**.  Then\\
    **\-\-wden~fn=myrho~o=0,0,60~l1=1,1,0,49~l2=0,0,1,121**\\
    writes to _myrho.ext_{: style="color: green"} a mesh (49,121) points.  The origin (first point) lies at (**p3/2**) since **60=120/2**.
    The first vector (**l1=1,1,0,49**) points along **(p1+p2)** and has that length (**48+1**); the second vector points along **p3** and has that length.

    Example: suppose the lattice is fcc with **n1=n2=n3=40.**  Then\\
    **\-\-wden~q=0,0,0.001~core=-1~ro=0,0,.25~lst=7~l1=-1,1,1,41~l2=1,-1,1,41**\\
    generates the smoothed part of the density from the 7th band at &Gamma;, in a plane normal to the z axis
    (**q=0,0,0.001** is slightly displaced off &Gamma; along _z_), passing through **(0,0,0.25)**.
^
**\-\-shorten=no**
:  suppress shortening of site positions
^
**\-\-oldvc**
:  chooses old-style energy zero, which sets the cell average of the potential to zero.  By default average electrostatic potential at the augmentation
   boundary is chosen to be the zero.  That puts the Fermi level at roughly zero.
^
**\-\-no-fixef0**
:  Do not adjust estimate of Fermi level after 1st band pass
^
**\-\-cv: &thinsp;\|&thinsp; \-\-cvK:**
: Calculate electronic specific heat
^
**\-\-symsig &thinsp;\|&thinsp; \-\-symsig=no**
:  Symmetrize sigma (if read) overriding default behavior, or suppress it
^
**\-\-efrnge**
:  Print out indices to bands that bracket the Fermi level

The following switches have to do with the optics branch of **lmf**{: style="color: blue"}

**\-\-jdosw**
:  Channels for optical properties; See doc/optics.html
^
**\-\-jdosw2**
:  Channels for optical properties; See doc/optics.html
^
**\-\-opt:read**
:  Read optical matrix elements; See doc/optics.html
^
**\-\-opt:write**
:  Write optical matrix elements; See doc/optics.html
^
**\-\-quit=**
:  quit after execution of certain blocks, e.g. --quit=ham
^
**\-\-SOefield**
:  Makes SO-weighted average of electric field at each site
^
**\-\-vext**
:  Add external potential

The following switches affect how **lmf**{: style="color: blue"} reads, writes, or modifies the self-energy &Sigma;<sup>0</sup> generated by the QS<i>GW</i> suite.\\
_Note:_{: style="color: red"} &Sigma;<sup>0</sup> is stored in practice as $$\Sigma^0{-}V_{xc}^\mathrm{LDA}$$, so that this potential can be added
to the LDA potential.

**\-\-mixsig=#1[,#2]**
:  **lmf**{: style="color: blue"} reads QS<i>GW</i> self-energy &Sigma;<sup>0</sup> from
   two files, _sigm.ext_{: style="color: green"} and _sigm1.ext_{: style="color: green"}.
   For &Sigma;<sup>0</sup> it uses **#1&times;**_sigm.ext_{: style="color: green"} + **#2&times;**_sigm1.ext_{: style="color: green"}.
   If **#2** is missing, it does not read _sigm1.ext_{: style="color: green"} but scales &Sigma;<sup>0</sup> by **#1**.
^
**\-\-rsig[~options]**
:  Tells **lmf**{: style="color: blue"} about the form of the input self-energy file.

   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-rsig**):
   If either **~ascii** or **~rs** is used, the file name may change:

   | :- | :-: | :-: |
   &nbsp; |   k-space | real-space
   binary |    sigm   |   sigmrs
   ascii  |    sigma  |   sigmars

   + **~ascii**:&ensp;  read sigm in ascii format.
   + **~rs**:&ensp;     read sigm in real space.
   + **~null**:&ensp;   generate a null sigma consistent with the hamiltonian dimensions. Useful in combination with the sigma editor.
   + **~fbz**:&ensp;    sigma is stored for all _k_ points in the full Brillouin zone
   + **~spinav**:&ensp; average spin channels in spin-polarized sigma
   + **~shftq**:&ensp;  add qp offset to qp where sigma is made.
^
**\-\-wsig[~options]**
:  Writes a possibly modified QS<i>GW</i> self-energy to file <I>sigm2.ext</I> and exits.

   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-wsig**):

   + **~newkp**:&ensp;  	 generate sigma on a new k-mesh
   + **~edit**:&ensp;   	 invoke the sigma editor.  This editor has many options, which you can see by running the editor.

   The following are special-purpose modes

   + **~spinav**:&ensp; 	 average spin channels in spin-polarized sigma
   + **~onesp**:&ensp;  	 average spin channels in spin-polarized sigma
   + **~rot**:&ensp;    	 [rotate](/docs/misc/rotations) sigma matrix.
   + **~trans=#**:&ensp;	 # specifies how sigma is to be modified, or if some other object is to be made instead of sig.
   + **~phase**:&ensp;  	 Add phase shift to sigma
   + **~fbz**:&ensp;      sigma is stored for all _k_ points in the full Brillouin zone
   + **~sumk**:&ensp;   	 sum sigma over _k_.  Implies fbz
   + **~shftq**:&ensp;  	 add qp offset to qp where sigma is made
   + **~wvxcf**:&ensp;  	 read vxc file and write as vxcsig (used by **lmfgwd**{: style="color: blue"}).

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Introduction_
_____________________________________________________________
All of the programs have special branches that may be (and sometimes must be) set from command-line switches.

Here is an example:

    $ lmf cafeas -vns=4 -vnm=5 --rpos=pos

Following unix style, switches always begin with dash (**&minus;**). Many codes have command-line switches unique to their purpose,
but there are a number of other switches are shared in common.

Some switches have a single dash ; some have two. Those with two tend to control program flow (e.g. `--show`), while those with a single dash tend to have an “assignment” function, such as a variables declaration (e.g. `-vx=3`). Sometimes there is not a clear distinction between the two, e.g. the printout verbosity `--pr` accepts either one or two dashes (see below).

In the example above, `-vns=4 -vnm=5` assigns variables **ns** and **nm** to 4 and 5, respectively, while `--rpos=pos` tells **lmf**{:
style="color: blue"} to read site positions from file _pos.cafeas_{: style="color: green"}.


#### _Switches Common to Most or All Programs_

+ **\-\-help** \| **\-\-h**
  + Lists command-line switches for that program and exits.

+ **\-\-input**
  + Lists tags (categories and tokens) a program will read.
    Same as turning on [**IO\_HELP=T**](/docs/input/inputfile/#io)

+ **\-\-showp**
  + Prints out input file after parsing by preprocessor, and exits.
   It shows the action of the preprocessor, without parsing any tags.

+ **\-\-show** \| **\-\-show=2**
  + Prints the input file parsed by preprocessor, and the value of the tags parsed or default values taken.\\
    **\-\-show=2** causes the program to exits after printing.

_Note:_{: style="color: red"} the preceding switches are intended to assist in managing and reading input files.
They are discussed in more detail [here](/tutorial/lmf/lmf_pbte_tutorial/#determining-what-input-an-executable-seeks).


+ **\-\-pr#1[,#2]** \| **-pr#1[,#2]**
  + Sets output verbosities, overriding any specification in the ctrl file.
  + Optional #2 sets verbosity for the potential generation part (applicable to some codes)

+ **\-\-time=#1[,#2]**
  + Prints out a summary of timings in various sections of the code.
    Timings are kept to a nesting level of #1.\\
    If #2 is nonzero, timings are printed on the fly.

+ **\-\-iactive**
  + Turns on 'interactive' mode, overriding any specification through IO_IACTIV in the ctrl file.

+ **\-\-iactive=no** \| **\-\-no-iactive**
  + Turns off 'interactive' mode.

+ **-c<i>name</i>=_string_"**
  + Declares a character variable _name_ and assigns it to value _string_.

+ **-v<i>name</i>=_expr_**
  + Declares a numeric variable _name_ and assigns its value to the result of expression _expr_.
    Only the first declaration of a variable is used. Later declarations have no effect.

    In addition to the assignment operator (**=**{: style="color: red"}) there are generalized assignment
    operators &thinsp;<b>*=</b>{: style="color: red"},&thinsp; <b>/=</b>{: style="color: red"}, <b>+=</b>{: style="color: red"},&thinsp;
    <b>-=</b>{: style="color: red"},&thinsp; and <b>^=</b>{: style="color: red"} that [modify already-declared variables](/docs/input/preprocessor/#vardec),
    following C syntax.

<i> </i>

#### _Switches Common To Programs Using Site Information_
Additionally, for any program utilizing site information, the following switches apply

+ **\-\-rpos=fnam**
  + Tells the program to read site positions from file _fnam.ext_{: style="color: green"} after the input file has been read.
    _fnam.ext_{: style="color: green"} is in standard [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) for 2D arrays.

+ **\-\-fixpos[:tol=#]** \| **\-\-fixpos[:#]**
  + Adjust positions slightly, rendering them as consistent as possible with the symmetry group.
    That is, if possible to slightly displace site positions to make the bsis conform to a group
    operation, make the displacement.  Optional tolerance specifies the maximum amount of adjustment allowed.\\
    Example: **lmchk \-\-fixpos:tol=.001**

+ **\-\-fixlat**
  + Adjust lattice vectors and point group operations, attempting to render them internally
                    consistent with each other.

+ **\-\-sfill=_class-list_**
  + Tells the program to adjust the sphere sizes to space filling.

    By default, "class-list" is a list of integers. These enumerate class indices for
    which spheres you wish to resize, eg 1,5,9 or 2:11.
    For "class-list" syntax see [Syntax of Integer Lists](/docs/misc/integerlists/)

    A second alternative specification of a class-list uses
    the following:  "-sfill~style=2~expression"
    The expression can involve the class index ic and atomic number z. Any class satisfying
    expression is included in the list.\\
    Example: "-sfill~style=2~ic<6&z==14"

    A third alternative specification of a class-list is specifically for unix systems.
    The syntax is "-sfill~style=3~fnam". Here "fnam" is a filename with the usual
    unix wildcards. For each class, the program makes a system call "ls fnam | grep class"
    and any class which grep finds is included in the list.\\
    Example: "-sfill~style=3~a[1-6]"

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for the_ blm _tool_
{::comment}
(/docs/commandline/general/#switches-for-the-blm-tool)
{:/comment}

{::comment}
<div onclick="elm = document.getElementById('blm'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to show command-line switches.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="blm">{:/}
{:/comment}

**blm**{: style="color: blue"} creates input (ctrl) files from structural information.\\
Command-line switches:

+ **\-\-express[=_n_]**
  + Express style input file level _n_.  If _n_>0, an [express category](/tutorial/lmf/lmf_pbte_tutorial/#the-express-category) is created.\\
    For _n_>0, an EXPRESS category is created and a site file is created.  Lattice and site information are not included in the ctrl file
    but are read through the site file. As _n_ increases, the ctrl file becomes simpler but contains less information.\\
    If **\-\-express** is missing, a default value of _n_=3 is used.\\
    If _n_ is missing, a default value of _n_=6 is used.\\
    Level&emsp; mode
    + 0:&emsp;  _Standalone_: All input through standard categories, and site file is not automatically made.  No supporting comments are given.
    + 1:&emsp;  _Expert_: Similar to mode 9, but EXPRESS category is added.\\
      &emsp;&emsp; Input is terse with no supporting comments\\
      &emsp;&emsp; Tags duplicated by EXPRESS are retained to facilitate editing by the user (EXPRESS takes precedence).
    + 2:&emsp;  _Verbose_:   Similar to mode 1, with comments added
    + 3:&emsp;  _Large_:     Similar to mode 2, but duplicate tags are removed
    + 4:&emsp;  _Standard_:  Most tags covered by defaults are removed.
    + 5:&emsp;  _Simple_:    No preprocessor instructions, variables or expressions are used
    + 6:&emsp;  _Light_:     Some nonessential tags are removed
    + 7:&emsp;  _Skeleton_:  Minimal input file

+ **\-\-asa**
  + tailor input file to an ASA calculation

+ **\-\-gw**
  + tailor input file to a GW calculation\\
    modifies **AUTOBAS**; adds a [**GW** category](/docs/input/inputfile/#gw) and some _GW_ specific tokens

+ **\-\-gf**
  + add tokens for lmgf input file: adds BZ_EMESH and a [GF category](/docs/input/inputfile/#gf)

+ **\-\-pgf**
  + add tokens for lmpg input file: adds BZ_EMESH and a [PGF category](/docs/input/inputfile/#pgf)

+ **\-\-fpandasa**
  + tags for both ASA and FP

+ **\-\-addes**
  + add tags to prepare for later addition of empty spheres

+ **\-\-findes**
  + search for empty sphere sites to improve lattice packing

+ **\-\-mag**
  + set nsp=2 for spin polarized calculation

+ **\-\-noshorten**
  + suppress shortening of site positions

+ **\-\-nk=#1[,#2,#3]**
  + k-mesh for BZ integration

+ **\-\-nkgw=#[,#,#]**
  + Same as \-\-nk but applies to _GW_ _k_-mesh

+ **\-\-gmax=#**
  + specify mesh density cutoff **GMAX**; see [this tutorial]((/tutorial/lmf/lmf_pbte_tutorial/#estimate-for-gmax)

+ **\-\-nit=#**
  + specify max number of iterations to self-consistency

+ **\-\-scala=#**
  + multiply ALAT by #, and PLAT and POS by 1/#

+ **\-\-scalp=#**
  + like scala, but # specifies PLAT volume

+ **\-\-rdsite[=_fn_]**
  + read structural data from site file _fn_.  Default _fn_ is _sitein_{: style="color: green"}

+ **\-\-xpos**
  + write site positions as multiples of PLAT

+ **\-\-wsrmax=#**
  + when finding sphere radii, do not permit any radius to exceed #

+ **\-\-wsite** \| **\-\-wsitex**
  + write site file for structural data
  + **\-\-wsitex** writes site positions as fractional multiples of PLAT

+ **\-\-wpos=_fnam_**
  + write site positions to file **_fnam_**.

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for_ lmchk
{::comment}
(/docs/commandline/general/#switches-for-lmchk)
{:/comment}

**lmchk**{: style="color: blue"} has two main functions: to check augmentation sphere overlaps (and optionally to determine augmentation
sphere radii), and to generate neighbor tables in various contexts.

{::comment}
<div onclick="elm = document.getElementById('lmchk'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to show command-line switches.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="lmchk">{:/}
{:/comment}

{::comment}
Lists in definition lists are tricky.
: ^

  * Foo
  * Bar

  Still part of the definition description.

end

Definition list inside definition list
: a

  still part of list

  second definition
  : try this

  and this

Note : with extra space ":  xx" the sub-bullets begin without inserting blank line (??)
:  print out a neighbor table, in one of the following styles.

   + _Standard style_: a neighbors is printed, grouped in

Note : without it a blank line is inserted before sub-bullets
: print out a neighbor table, in one of the following styles.

  + _Standard style_: a neighbors is printed, grouped in

{:/comment}


**\-\-shell[~options]** &nbsp;\|&nbsp; **\-\-shell~tab[~options]**
:  print out a neighbor table, in one of the following styles.

   + _Standard style_: a neighbors is printed, grouped in
    shells of neighbors centered the site in question.
    A table is made for one site in each inequivalent class.
    Neighbors are grouped by shell:
    <pre>
    Shell decomposition for class K1        class   1  z=19
    shell   d     nsh csiz  class ...
      1  0.000000   1    1  1:K1
      4  0.880105   8   15  4:Se1(8)
      5  1.000000   4   19  1:K1(4)
      6  1.026646   8   27  2:Fe1(4)      3:Fe2(4)
    </pre>
    + _Tab style_: (**\-\-shell~tab**) a table of neighbors is printed in a table format, for all sites.
    <pre>
    # neighbor list for site 1, class 21x
        1   1   0.0000000   0.0000000   0.0000000     0.0000000  21x      21x
        1  44  -0.2500000   0.2500000  -0.2500000     0.4330127  21x      21
        1  48   0.2500000  -0.2500000  -0.2500000     0.4330127  21x      21
    </pre>

    This mode prints out site indices to pairs, connecting vector and length, and class labels.

    + _Compact Tab style_: (**\-\-shell~tab=2**) prints out the connecting vector only.
    <pre>
    # neighbor list for site 1, class K1
        0.0000000   0.0000000   0.0000000
        0.0000000   0.0000000  -0.6814628
        0.0000000   0.0000000   0.6814628
    </pre>

    + _Tab displacement style_: (**\-\-shell~tab=2~disp=_file_**) special purpose mode that
      reads in a second set of site positions from _file.ext_{: style="color: green"}.\\
      It lists only connecting vectors that are changed relative the original vectors.\\
      Moreover the table prints out both the original vector and the displacement vector, e.g.
    <pre>
    # neighbor list for site 1, class K1
        0.0000000   0.0000000   0.0000000     0.0000000   0.0000000   0.0100000
        1.0000000   0.0000000   0.0000000     0.0000000   0.0000000  -0.0100000
       -1.0000000   0.0000000   0.0000000     0.0000000   0.0000000  -0.0100000
        0.0000000   1.0000000   0.0000000     0.0000000   0.0000000  -0.0100000
    </pre>
    **_file_** should take he [standard Questaal style for 2D arrays](/docs/input/data_format/#standard-data-formats-for-2d-arrays).  It can be generated with **\-\-wpos**.\\
    This mode synchronizes with **lmscell**{: style="color: blue"} switch `--disp~tab2`.

    Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):\\
    &ensp; **~r=#**:&ensp; Specifies range of neighbor-list. Default value is 5.\\
    &ensp; **~e**:&ensp;   prints inner product between Euler angles (relevant to noncollinear magnetism in the ASA)\\
    &ensp; **~fn=_filename_**:&ensp; writes neighbor table to file _filename.ext_{: style="color: green"}\\
    &ensp; **~sites~_site-list_**:&ensp; restricts sites considered to _site-list_.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_\\
    &ensp; **~pair~_site-list_**:&ensp; restricts neighbors to _site-list_.\\
    &ensp; **~nn**:&ensp;  restrict table to nearest-neighbor shell (tab mode only)

    Example: **\-\-shell:tab=2:disp=pos:sites:1:r=3:fn=tab2:nn**\\
    writes to _tab2.ext_{: style="color: green"} a table in this format.  The table is restricted to displacements around site **1**, distance less than 3 a.u.

**\-\-angles[options]**
: Prints angles between triples of sites.

  Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):\\
  &ensp; **~r=#**:&ensp; Specifies range of neighbor-list. Default value is 2.5.\\
  &ensp; **~sites~_site-list_**:&ensp; loops over center atoms in **_site-list_**.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_.\\
  &ensp; **~bonds~_site-list_**:&ensp; prints out table only for triples whose neighbors are in _site-list_.

  Example: **\-\-angles~sites~1,2~bonds~style=2~z==34**\\
  finds triples of atoms connected to sites 1 and 2.  Both sites connected to the central site must have atomic number 34 (Selenium)

**\-\-euler[options]**
: Prints angles between spins (applicable to ASA noncollinear magnetism)

  Euler angles must be supplied either in the input file, or in the Euler angles file
  _eula.ext_{: style="color: green"} (in the [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays)).\\
  Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):\\
  &ensp; **~r=_rmax_[,_rmin_]**:&ensp;  Include in table only pairs closer than **_rmax_**.
         If **_rmin_** is also given, exclude pairs closer than **_rmin_**.\\
  &ensp; **~sites~_site-list_**:&ensp; include only sites in **_site-list_**.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_.\\
  &ensp; **~sign**:&ensp; If present, rotate angle by 180&deg; for each member of the pair whose magnetic moment is negative.

  Example: **\-\-euler~r=10,6~sign~sites~style=2~z==26**\\
  finds angles between Fe atoms (_Z_=26) between 6 and 10 atomic units apart.

**\-\-findes &thinsp;\|&thinsp; \-\-findes &thinsp; \-\-nescut=#**
:  tells **lmchk**{: style="color: blue"} to locate empty spheres to fill space.
   It works by adding adding empty spheres (largest possible first)\\
   until space is filled with **sum-of-sphere volumes** = **unit cell volume**.\\
   Optional **\-\-nescut=#** causes the finder stop adding sites once the number exceeds threshold &thinsp;**#**.\\
   Tags in the ctrl file affecting this switch are:

   + [OPTIONS &thinsp; RMINES &thinsp; RMAXES](/docs/input/inputfile/#options)
   + [SPEC &thinsp; SCLWSR &thinsp; OMAX1 &thinsp; OMAX2 &thinsp; WSRMAX](/docs/input/inputfile/#spec)

**\-\-getwsr**
:   tells **lmchk**{: style="color: blue"} to use an [algorithm](/docs/code/asaoverview/#algorithm-to-automatically-determine-sphere-radii) to determine
    augmentation sphere radii.\\
    Results are printed to stdout; you must modify the input file by hand.

**\-\-mino~z &thinsp;\|&thinsp; \-\-mino~_site-list_**
:  tells **lmchk**{: style="color: blue"} to shuffle atom positions in site-list to minimize some
     simple function of the overlap.\\
     (For now, the function has been set arbitrarily to the sixth power of the overlap).\\
    &ensp; **\-\-mino~z** : &ensp; construct list from all sites with atomic number _Z_=0\\
    &ensp; **\-\-mino~_site-list_** : &ensp; list of sites; see [here](/docs/commandline/general/#site-list-syntax) for **_site-list_** syntax.

**\-\-terse**
:  print minimum information about overlaps.
   Writes the site positions to _file.ext_{: style="color: green"}

**\-\-wsite[options] &thinsp;\|&thinsp; \-\-wsitex &thinsp;\|&thinsp; \-\-wsitep &thinsp;\|&thinsp; \-\-wpos=_file_**
: Writes structural data to a [site file](/docs/input/sitefile) or a positions file.

  + **\-\-wsite** &ensp;&thinsp; writes a [site file](/docs/input/sitefile), with basis in Cartesian coordinates.
  + **\-\-wsitex** &nbsp; writes a [site file](/docs/input/sitefile) with basis as
    [fractional multiples of lattice vectors](/tutorial/lmf/lmf_tutorial/#lattice-and-basis-vectors).
  + **\-\-wsitep** &nbsp; writes a VASP style _POSCAR_{: style="color: green"} file.
  + **\-\-wpos** &ensp;&nbsp;  writes a file of site positions in standard [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays).

  Options to **\-\-wsite** are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):\\
    &ensp; **~short** : &ensp; write site file in [short form](/docs/input/sitefile/#site-file-syntax)\\
    &ensp; **~fn=_file_** : &ensp; writes site file to _file.ext_{: style="color: green"}.

  If used in conjunction with **\-\-findes**, **lmchk**{: style="color: blue"} writes to file _essite.ext_{: style="color: green"}
  with the basis enlarged by the new empty sites.\\
  In this special mode there are two options: **\-\-wsite** and **\-\-wsitex** .

**\-\-basis=_file_**
: checks whether the given basis matches the basis in site file, up to a fixed translation

**\-\-shorten**
: shorten basis vectors

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for_ lmdos
{::comment}
(/docs/commandline/general/#switches-for-lmdos)
{:/comment}

**lmdos**{: style="color: blue"} is a postprocessing step that generates partial densities-of-states.
It reads the weights file _moms.ext_{: style="color: green"} generated by another program
and makes partial contributions to the total DOS.  The partial does are computed  either with tetrahedron integration or with sampling method.
_moms.ext_{: style="color: green"} must be made in advance by a generating program; see for example
**lmf**{: style="color: blue"} command line switch **\-\-pdos**.

How the channels for partial DOS are specified depends on the context.
Typically you generate _moms.ext_{: style="color: green"} specifying channels with **\-\-pdos**.
**lmdos**{: style="color: blue"} assumes the DOS are ordered as specified by the switch.  Otherwise it assumes the weights
are generated and stored by class.  This works with **lm**{: style="color: blue"} and **tbe**{: style="color: blue"},
but otherwise, generate _moms.ext_{: style="color: green"} with **\-\-pdos** or something similar.

**lmdos**{: style="color: blue"} doesn't need to know what the origin of the channels is; it simply reads the number of channels from the
weights file.  However, to assist you in making an identification of the channels with atom-centered functions, it will print out what it
thinks the connection is.\\
**Caution:**{: style="color: red"} **lmdos**{: style="color: blue"} may print out if you use the generating program inconsistently with it.

**lmdos**{: style="color: blue"} has a variety of options; for example it can generate the ballistic
conductivity as matrix elements of the velocity operator.

The generating program creates _moms.ext_{: style="color: green"} with a switch such as
<pre>
--pdos[~mode=#][~sites=<i>site-list</i>][~group=lst1;lst2;...][~nl=#][~lcut=<i>l</i><sub>1</sub>,<i>l</i><sub>2</sub>,...]
--mull[~mode=#][~sites=<i>site-list</i>][~group=lst1;lst2;...][~nl=#][~lcut=<i>l</i><sub>1</sub>,<i>l</i><sub>2</sub>,...]
</pre>

Use the same switch when invoking **lmdos**{: style="color: blue"}.

Command-line options:

**\-\-pdos\|mull[~mode=#][~sites=site-list][~group=lst1;lst2;...][~nl=#][~lcut=<i>l</i><sub>1</sub>,<i>l</i><sub>2</sub>,...]**
:  Specifies the channels for which partial DOS are generated or analyzed.\\
   **\-\-pdos**  partial DOS\\
   **\-\-mull**  Mulliken DOS\\
   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-pdos**):

   +  **~mode=#**:&ensp;
      + **#=0** DOS resolved by site
      + **#=1** DOS resolved by _l_ and site
      + **#=2** DOS resolved by _lm_ and site.
   +  **~sites=_site-list_**:&ensp; make DOS for a [list of sites](/docs/commandline/general/#site-list-syntax).
   +  **~group=_lst1_;_lst2_;&hellip;**:&ensp;  DOS for a list of groups.  A group can consist of one or more sites, which are combined to make a single channel.
   +  **~nl=#**:&ensp; **#&minus;1** is a global _l_ cutoff.
   +  **~lcut=<i>l</i><sub>1</sub>,<i>l</i><sub>2</sub>,&hellip;**: _l_-cutoff for each group or site in the group or site list.

   Example **--pdos~mode=2~group=1:3;4:9~lcut=2,1**\\
   makes DOS for sites 1:3 combined for the first channel, sites 4:9 for the second.  DOS is resolved by _l_ and _m_ (**mode=2**), with _l_=0,1,2 for the first group and _l_=0,1 for the second.
^
**\-\-dos~options**
:  Various options that affect the action of **lmdos**{: style="color: blue"}.\\
   Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-dos**):

   + **wtfn=<i>filename</i>**: name the file containing bands and DOS weights. By default, **lmdos**{: style="color: blue"} uses _moms.ext_{: style="color: green"}.
   + **cls**: equivalent to **wtfn=cls**
   + **tbdos**: sets defaults for to generate dos generated by **tbe**{: style="color: blue"}, which uses slightly different conventions.
   + **idos**: generate energy-integrated DOS.
   + **npts=#**: number of energy points.  If unspecified with this command-line argument, user is prompted for this number
   + **window=_emin_,_emax_**: energy window over which data is to be computed.  Defines the mesh together with **npts**.\\
     If unspecified with this command-line argument, the user is prompted for this number
   + **mode=#**   compute quantities other than the DOS.\\
     +  **#=0**   &ensp;Standard DOS, i.e. &int; <i>d</i><sup>3</sup><b>k</b> <i>&delta;</i>(<i>E(<b>k</b>)-E</i>)
     +  **#=1**   &ensp;Ballistic conductance, Landauer formula, i.e.
                  &int; <i>d</i><sup>3</sup><b>k</b> <i>&delta;</i>(<i>E</i>(<b>k</b>)-<i>E</i>) &nabla;<i>E</i>(<b>k</b>)\\
                  In this mode, you must supply vector **vec** to indicate which direction the gradient is to be projected.
     +  **#=2**   &ensp;diffusive conductivity in the relaxation time approximation
                  &int; <i>d</i><sup>3</sup><b>k</b> <i>&delta;</i>(<i>E</i>(<b>k</b>)-<i>E</i>) &nabla;_1<i>E</i>(<b>k</b>) &middot; &nabla;_2<i>E</i>(<b>k</b>)
                  In this mode you must supply both **vec** and **vec2**.
   + **vec=#1,#2,#3**:   **k** direction vector 1 for **mode=1** or **mode=2**.
   + **vec2=#1,#2,#3**:  **k** direction vector 2 for **mode=2**.
   + **totdos**:          compute total DOS by combining weights from all partial DOS.\\
                          Note: if input moments file has no special channels, this is the default.
   + **rdm**:             write DOS in [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays).
   + **ldig**:            read/write DOS with extra digits.
   + **bands=<i>list</i>**:   compute contribution to DOS from a prescribed [list of bands](/docs/misc/integerlists/).
   + **classes=<i>list</i>**: generate DOS for a specified [list of classes](/docs/commandline/general/#class-list-syntax)\\
     **Caution:**{: style="color: red"} this option is only compatible with default moments files generated by the ASA, which stores dos
     weights by class.  It is incompatible with the **\-\-pdos** switch which stores weights by site.

   _Example_: compute the ballistic conductance in the z direction over an energy range (-0.8,0.5)Ry:\\
   **--dos:mode=1:npts=501:window=-.8,.5:vec=0,0,1**
^
**\-\-cls**
:  tells **lmdos**{: style="color: blue"} that the _moms.ext_{: style="color: green"} holds data for core-level (EELS) spectrosopy (**lmf**{: style="color: blue"} output).

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for_ lmscell
{::comment}
(/docs/commandline/general/#switches-for-lmscell)
{:/comment}

**lmscell**{: style="color: blue"} works by generating a list of lattice vectors from the primitive lattice vectors, and adding them
to the basis vectors.  Basis vectors which differ by a lattice vector in the supercell are discarded. An expanded list of basis
vectors is thus generated.  You must supply a set of new (supercell) lattice vectors.  You can do so with
tag [**STRUC\_SLAT**](/docs/input/inputfile/#struc); if you do not, you will be prompted to input 9 numbers from the terminal.
It also has a limited capability to make [Special QuasiRandom Structures](http://journals.aps.org/prl/abstract/10.1103/PhysRevLett.65.353).

**Caution:**{: style="color: red"} **lmscell**{: style="color: blue"} may fail if you choose a supercell significantly elongated from the
original, because the list of lattice vectors may not encompass all the translations needed to create the new basis.

**\-\-wsite[x][~map][~sort][~fn=_file_] &thinsp;\|&thinsp; \-\-wpos=_file_**
: Writes a [site file](/docs/input/sitefile) to disk, or a positions file to dist.\\
  **\-\-wsite[x]** writes a site file with positions expressed as [fractional multiples of lattice vectors](/tutorial/lmf/lmf_tutorial/#lattice-and-basis-vectors).
  **\-\-wpos** writes a file of site positions in standard [Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays).
: ^
  + **~fn=_file_** : &nbsp; writes site file to _file.ext_{: style="color: green"}.
  + **~short** : &ensp; write site file in [short form](/docs/input/sitefile/#site-file-syntax)
  + **~map**: &emsp; appends a table mapping sites in the original cell to the supercell

**\-\-ring:i1,i2** &thinsp;\|&thinsp; \-\-swap:i1,i2 &thinsp;\|&thinsp; \-\-sort: _expr1_ &thinsp;\|&thinsp; \-\-sort:'_expr1_ _expr2_' &thinsp;\|&thinsp; \-\-sort:'_expr1_ _expr2_ _expr3_'**
: Rearrange order of sites in the supercell.\\
  (ring) shifts sites **i1&hellip;i2-1** to one position higher, and site **i2** cycles to position **i1**.\\
  (swap) swaps pairs **i1** and **i2**\\
  (sort) Sorts the basis by ordering algebraic expressions associated with them.\\
  Expressions can use Cartesian components **x1**, **x2**, **x3**, e.g. **\-\-sort:'x3 x2'**.\\
  Optional **_expr2_** sorts subsets of sites with equivalent values of **_expr1_**, similarly for **_expr3_**.

**\-\-sites:_site-list_**
: Make supercell of subset of sites in original basis. See [here](/docs/commandline/general/#site-list-syntax) for **_site-list_** syntax.

**\-\-rsta &thinsp;\|&thinsp; --rsta,amom**
: (ASA only) Makes ASA restart file for the supercell from existing file _rsta.ext_{: style="color: green"}.\\
  Optional **amom** applies to noncollinear magnetism: it flips the majority and minority spins for sites where the magnetic moment is negative,
  while rotating the Euler angle by 180&deg;

**\-\-shorten**
: shorten basis vectors.

**\-\-pl:_expr_**
: (for lmpg code) Assign principal-layer index according to **<i>expr</i>**. Sites with equivalent values of <i>expr</i> are assigned the same PL index.

**\-\-wrsj[~fn=name][~scl=#]**
: Writing the pairwise exchange parameters of the supercell generated, e.g., from **lmgf**{: style="color: blue"}. Input file _rsj.ext_{: style="color: green"} must be present.

**\-\-disp~fnam~<i>site-list</i>**
: Displace a set of atoms in the neighborhood of a given one, e.g. **\-\-disp:tab2:style=3:Fex**\\
  Use in conjunction with [**lmchk**](/docs/commandline/general/#switches-for-lmchk) command line argument (**\-\-shell~tab=2~disp=_file_**).
  See [here](/docs/commandline/general/#site-list-syntax) for **_site-list_** syntax.

**\-\-sqs[~seed=#][~r2max=#][~r3max=#][~r3mode=#]**
: Make a  Special QuasiRandom Structure.  It works by minimizing a norm function.\\
  The norm is obtained by assigning a weight to each pair and three body correlator, and summing the individual weights.\\

  Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):\\
    &ensp; **~seed=#**:&emsp;  initial seed for random number generator.  For a fixed seed the algorithm proceeds the same way each time.\\
    &ensp; **~r2max=#**:&nbsp; Maximum distance between pairs for pair participate in the norm\\
    &ensp; **~r3max=#**:&nbsp; Maximum sum of legs between for triples to participate in the norm.

  **Caution:**{: style="color: red"} This mode is still experimental.

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for_ lmctl
{::comment}
(/docs/commandline/general/#switches-for-lmctl)
{:/comment}

**lmctl**{: style="color: blue"} is an adjunct to the ASA, that read
sphere moments from class files and writes the data in a form suitable
for the input file.  It is an easy way to collect the results into the ctrl file.

Command-line switches:
^
+ **-spin1**:&ensp;   add spin-polarized moments into a non-polarized set
+ **-spinf**:&ensp;   exchange up- and down- moments
+ **-mad**:&emsp;     also write out the ves at RMAX.

See [Table of Contents](/docs/commandline/general/#table-of-contents)

#### _Switches for_ lmxbs
{::comment}
(/docs/commandline/general/#switches-for-lmxbs)
{:/comment}

**lmxbs**{: style="color: blue"} generates input for the graphics program **xbs**{: style="color: blue"}, a program
written by M. Methfessel, which draws cartoons of crystals.  See
[this page](http://newton.ex.ac.uk/research/qsystems/people/goss/xbshelp.html).

Command-line switches:
^
+  **-bs=_expr_**:&ensp;   factor that scales the default ball (sphere) size. This factor scales **SPEC\_RMAX** by _expr_**. By default, the scaling is 0.5.
+  **-ss=_expr_**:&ensp; controls the criterion for what length defines a connected bond.  This switch scales the default
   factor scaling a 'bond length' which must be closer than RMAX<sub>i</sub>+RMAX<sub>j</sub>.
+  **-shift=x1,x2,x3**:&ensp; shifts all the coordinates by this amount, in units of ALAT.
+  **-scale=val**:&emsp;   sets the **xbs**{: style="color: blue"} variable **scale**.
+  **-spec**:&ensp; shifts   Organize sites by species (e.g. colors).  By default sites are organized by classes.

+  **-sp:rule1[:rule2][...]**:&emsp;   modifies the species rmax and colors.\\
   _rule_ has the syntax\\
   _expr_,_rmax_,_red_,_green_,_blue_\\
    _expr_ is a logical expression involving the class index ic and atomic number z.
   If _expr_ evalates to true, the rule applies to this class.
   _rmax_, _red_, _green_, _blue_ are the ball size, and [RGB colors](/docs/misc/fplot/#color-specification) for the ball.
   Default values are taken for those numbers omitted.  For the colors, the defaults are  random numbers between 0 and 1.

   Example: **lmxbs -sp:z==0,.5,.1,.1,.1:z==13&ic>3,,1,0,0:z==13,,0,1,0'**\\
   Empty spheres are nearly black, with rmax=.5 and Al atoms class index > 3 are red, with all remaining Al atoms green.
^
+  **-dup=_n1_,_n2_,_n3_[,_expr_]**:&emsp;   duplicates the unit cell **n1+1**,**n2+1**,**n3+1** times in the three lattice directions.
   Optional **_expr_** is a constraint.  If **_expr_** is present, sites whose for which **_expr_** is zero are excluded.\\
   Variables that may be used in **_expr_** are:\\
   + x1,x2,x3   site positions, in units of ALAT
   + p1,p2,p3   site positions, as [projections onto plat](/tutorial/lmf/lmf_tutorial/#lattice-and-basis-vectors)
   + ic,ib,z,r  class index, basis index, atomic number, and radius

   Example: **lmxbs &thinsp; "-dup=4,4,4,0<=x1&x1<1.01&0<=x2&x2<1.01&0<=x3&x3<1.01&z>0"**\\
   selects sites in a (dimensionless) cube of size 1 and exclude empty spheres.


See [Table of Contents](/docs/commandline/general/#table-of-contents)


#### _Site-list syntax_
_____________________________________________________________
{::comment}
(/docs/commandline/general/#site-list-syntax)
{:/comment}

Site-lists are used in command-line arguments in several contexts, e.g. in **lmscell**{: style="color: blue"}, **lmgf**{: style="color:
blue"}'s exchange maker, and **lmchk**{: style="color: blue"}'s **\-\-shell** and **\-\-angles** switches.\\
For definiteness assume &thinsp;**~**&thinsp; is the delimiter and the segment being parsed is **sites~_site-list_**.\\
**sites~_site-list_** can take one of the following forms:

**sites~_list_**
: **_list_** is an integer list of site indices, e.g. **1,5:9**.
  The syntax for integer lists is described [here](/docs/misc/integerlists).
^
**sites~style=1~_list_**
: **_list_** is an [integer list](/docs/misc/integerlists) of species or class indices (depending on the switch).

  All sites which belong a species in the species (or class) list get included in the site list.
^
**~style=2~_expr_**
: **_expr_** is an integer expression.
  The expression can involve the species index **is** (or class index **ic**) and atomic number **z**.\\
  The species list (or class list) is composed of members for which **_expr_** is nonzero.\\
  All sites which belong a species in the species (or class) list form the site list.
^
**~style=3~_spec1_,_spec2_,&hellip;**
: _spec1_,_spec2_,&hellip; are a string of one or more species names.
  The species list (or class list) is composed of species with a name in the list.

  All sites which belong a species in the species (or class) list form the site list.

{::nomarkdown} <a name="class-list-syntax"></a> {:/}
{::comment}
(/docs/commandline/general/#class-list-syntax)
{:/comment}


_Note:_{: style="color: red"} some ASA-specific switches refer to _class-list_.  The structure is identical to the construction above,
except that the class list is not expanded into a site list.


See [Table of Contents](/docs/commandline/general/#table-of-contents)
