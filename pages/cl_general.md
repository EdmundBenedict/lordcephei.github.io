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

#### _Switches for the_ **blm** _tool_
{::comment}
(/docs/commandline/general/#switches-for-the-blm-tool)
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

See [Table of Contents](/docs/misc/fplot/#table-of-contents)

#### _Switches for lmchk_
{::comment}
(/docs/commandline/general/#switches-for-lmchk)
{:/comment}

**lmchk**{: style="color: blue"} has two main functions: to check augmentation sphere overlaps (and optionally to determine augmentation
sphere radii), and to generate neighbor tables in various contexts.\\
Command-line switches:

+ **\-\-getwsr**\\
  + tells **lmchk**{: style="color: blue"} to use an [algorithm](/docs/code/asaoverview/#algorithm-to-automatically-determine-sphere-radii) to find reasonable
    initial sphere radii automatically.

+ **\-\-findes**\\
  + tells **lmchk**{: style="color: blue"} to locate empty spheres to fill space.
    It works by adding adding empty spheres (largest possible first)
    until space is filled with sum-of-sphere volumes = cell volume.\\
    Inputs affecting this switch are:
    + OPTIONS RMAXES  : maximum allowed radius of ES to use when when adding new spheres
    + OPTIONS RMINES  : minimum allowed radius of ES to use
    + SPEC  SCLWSR OMAX1  OMAX2  WSRMAX

    \-\-findes uses these parameters to constrain size of spheres as new ones are added.
+ **\-\-mino~_site-list_**\\
  + tells **lmchk**{: style="color: blue"} to shuffle atom positions in site-list to minimize some
     simple function of the overlap. (For now, the function has been set
     arbitrarily to the sixth power of the overlap).
    + By default, _site-list_ is a list of integers.  These enumerate
      site indices for which positions you wish to move, eg 1,5,9
      or 2:11.  See [here](/docs/misc/integerlists/) for the complete syntax of integer lists of this type.
    + Alternatively, you can enumerate a _class-list_.  **lmchk**{: style="color: blue"} will expand
      the class-list into a site-list.  For this alternative, use
      **\-\-mino~style=1~class-list**, e.g.  **\-\-mino~style=1~1,6**.
    + Another alternative, or "style" to specifying a class-list uses
      the following:  **\-\-mino~style=2~expression**
      It is just like **-sfill~style=2 ...** above, but now the class
      list is expanded into a site-list.
    + Similarly, you can specify a class-list is with style=3 like
      the -sfill~style=3, above.
    + As a special case, you can invoke \-\-mino:z, which specifies in
      the list all sites with atomic number Z=0 (empty spheres).

+ **\-\-wpos=_filename_**\\
  + writes the site positions to file _filename_.

+ **\-\-shell[:opts]**\\
  + print out a neighbor table, in one of two styles.
    + _Standard style_: a table of neighbors is printed, grouped in
    shells of neighbors centered the site in question.  By
    default a table is printed for one site of each inequivalent class.\\
    Options for this style:
      + :r=# Specifies range of neighbors for this table. Default value is 5.
      + :v   prints electrostatic potential for each pair
      + :e   prints inner product between Euler angles (relevant to noncollinear magnetism in the ASA)
      + :sites=site-list restricts neighbors in shell to list. NB: this option must be the last one.
    + _Tab style_: (**\-\-shell:tab[&hellip;]**) a table of neighbors is printed in a table format
    suitable for the\-\-disp switch in **lmscell**{: style="color: blue"}.\\
    Invokes in a table format, positions of neighbors relative to site specified in site-list above.\\
    Tab style has several formats, specifed by #, described below. For all modes the table entries have the following meaning: \\
          &emsp; **ib** is the site around which the table is made;\\
          &emsp; **jb** is the site index of a particular neighbor;\\
          &emsp; **dpos(1..3,jb)** is the connecting vector (relative position) between sites ib and jb\\
     Options for tab style:
        &nbsp;\#  &nbsp;format
        1.  **ib** **jb** **dpos(1..3,jb)**  &emsp; (default)
        2.  **dpos(1..3,jb)**  &emsp;(**ib** and **jb** are left out)
        3.  **dpos0(1..3,jb)** **dpos(1..3,jb)**  &emsp; (in conjunction with :disp=fnam; setup for **lmscell**{: style="color: blue"})\\
           dpos= displacements relative to dpos0, calculated from the
                 differences in positions read from 'fnam'\\
                 relative to dpos0 (see disp:fnam below).\\
           In this mode, only neighbors for which there
           is some nonzero displacement are written.\\
           This mode is useful in conjuction with <b>lmscell</b>.
        4. (sparse matrix format)\\
             **1 jb dpos(1,jb)**\\
             **2 jb dpos(2,jb)**\\
             **3 jb dpos(3,jb)**\\
    + :disp=fnam
      read a second (displaced) set of positions from a positions
      file `fnam'.  Its format is the same as files read with switch \-\-rpos.
      In this mode, a neighbor table for both original and displaced
      positions is written (See tab=2 above).
    + :fn=fnam write neighbor table to file fnam
    + :r=#     Specifies range of neighbors for this table. Default value is 5.
    + :nn      only print first (closest neighbor) entry for a given pair of indices (ib,jb)

+ **\-\-angles[opts]**\\
  + similar to \-\-shell, but prints angles between triples of
                   sites.  opts are as follows (you may substitute another
                   character for `:' below)
                   :r=# Specifies range for this table. Default value is 2.5.
                   :sites=site-list  loops over only sites in site-list
                   :bonds=site-list prints out table only for triples
                   :                   whose neighbors are in site-list
                   Example : \-\-angles/r=3/sites/style=3/Si/bonds/style=3/Cr


+ **\-\-terse**\\
  + print out minimum information about overlaps


