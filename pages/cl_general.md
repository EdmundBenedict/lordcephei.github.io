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

____________________________________________________________

#### _Table of Contents_
_____________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}
{::comment}
(/docs/commandline/general/#table-of-contents)
{:/comment}

#### _Introduction_
_____________________________________________________________
All of the programs have special branches that may be (and sometimes must be) set from command-line switches.

Here is an example:

    $ lmf cafeas -vns=4 -vnm=5 --rpos=pos

Following unix style, switches always begin with dash (**&minus;**). Many codes have command-line switches unique to their purpose,
but there are a number of other switches are shared in common.

Some switches have a single dash ; some have two. Those with two tend to control program flow (e.g. `--show`), while those with a single dash tend to have an “assignment” function, such as a variables declaration (e.g. `-vx=3`). Sometimes there is not a clear distinction between the two, e.g. the printout verbosity `--pr` accepts either one or two dashes (see below).

In the example above, `-vns=4 -vnm=5` assigns variables **ns** and **nm** to 4 and 5, respectively, while `--rpos=pos` tells **lmf**{: style="color: blue"} to read site positions from file
_pos.cafeas_{: style="color: green"}.


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
    _fnam.ext_{: style="color: green"} is in standard [Questaal format][Questaal protocol](/docs/input/data_format/#standard-data-formats-for-2d-arrays) for 2D arrays.

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

See [Table of Contents](/docs/misc/fplot/#table-of-contents)

#### _Switches for the **blm** tool_
{::comment}
(/docs/commandline/general/#switches-for-the-blm-tool)
{:/comment}

+ **\-\-express[=_n_]**
  + Express style input file level _n_.  If _n_>0, an [express category](/tutorial/lmf/lmf_pbte_tutorial/#the-EXPRESS-category) is created.\\
    If **\-\-express** is missing, a default value of _n_=3 is used.\\
    If _n_ is missing, a default value of _n_=6 is used.\\
    For _n_>0, an EXPRESS category is created and a site file is created.  Lattice and site information are not included in the ctrl file
    but are read through the site file. As _n_ increases, the ctrl file becomes simpler but contains less information.\\
    Level:&emsp; mode
    + 0:&emsp;  _Standalone_ All input through standard categories, and site file is not automatically made.  No supporting comments are given.
    + 1:&emsp;  _Expert_ Similar to mode 9, but EXPRESS category is added.\\
      &emsp;&ensp; Input is terse with no supporting comments\\
      &emsp;&ensp; Tags duplicated by EXPRESS are retained to facilitate editing by the user (EXPRESS takes precedence).
    + 2:&emsp;  _Verbose_   Similar to mode 1, with comments added
    + 3:&emsp;  _Large_     Similar to mode 2, but duplicate tags are removed
    + 4:&emsp;  _Standard_  Most tags covered by defaults are removed.
    + 5:&emsp;  _Simple_    No preprocessor instructions, variables or expressions are used
    + 6:&emsp;  _Light_     Some nonessential tags are removed
    + 7:&emsp;  _Skeleton_  Minimal input file

+ **\-\-asa**
  + tailor input file to an ASA calculation

+ **\-\-gw**
  + tailor input file to a GW calculation
    + modifies **AUTOBAS**
    + Adds a [**GW** category](/docs/input/inputfile/#gw) and some _GW_ specific tokens

+ **\-\-gf**
  + add tokens for lmgf input file: adds BZ_EMESH and a [GF category]((/docs/input/inputfile/#gf))

+ **\-\-pgf**
  + add tokens for lmpg input file: adds BZ_EMESH and a [PGF category]((/docs/input/inputfile/#pgf))

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
  + Same as \-\-nk but for _GW_ _k_-mesh

+ **\-\-gmax=#**
  + specify mesh density cutoff **GMAX**

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

