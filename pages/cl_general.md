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
sphere radii), and to generate neighbor tables in various contexts.

Command-line switches:

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

{:/comment}


**\-\-shell[~opts]** &nbsp;\|&nbsp; **\-\-shell~tab[~opts]**
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
    **_file_** can be generated with **\-\-wpos**: it uses the [standard Questaal style for 2D arrays](/docs/input/data_format/#standard-data-formats-for-2d-arrays).\\
    This mode synchronizes with **lmscell**{: style="color: blue"} switch `--disp~tab2`.

    Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):

      + **r=#** Specifies range of neighbor-list. Default value is 5.
      + **e**   prints inner product between Euler angles (relevant to noncollinear magnetism in the ASA)
      + **fn=_filename_** writes neighbor table to file _filename.ext_{: style="color: green"}
      + **sites~_site-list_** restricts sites considered to _site-list_.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_
      + **pair~_site-list_** restricts neighbors to _site-list_.
      + **nn**  restrict table to nearest-neighbor shell (tab mode only)

    Example: **\-\-shell:tab=2:disp=pos:sites:1:r=3:fn=tab2:nn**

**\-\-angles[opts]**
: Prints angles between triples of sites.  

  Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):

  + **r=#** Specifies range of neighbor-list. Default value is 2.5.
  + **sites~_site-list_** loops over center atoms in **_site-list_**.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_.
  + **bonds~_site-list_** prints out table only for triples whose neighbors are in _site-list_.

  Example: **--angles~sites~1,2~bonds~style=2~z==34**\\
  finds triples of atoms connected to sites 1 and 2.  Both sites connected to the central site must have atomic number 34 (Selenium)

**\-\-euler[opts]**
: Prints angles between spins (applicable to noncollinear magnetism, ASA)

  Euler angles must be supplied either in the input file, or in the Euler angles file
  _eula.ext_{: style="color: green"}.  (It takes the [standard Questaal style for 2D arrays](/docs/input/data_format/#standard-data-formats-for-2d-arrays).)

  Options are delimited by &thinsp;**~**&thinsp; (or the first character following **\-\-shell**):
: ^
  + **r=_rmax_[,_rmin_]**  Include in table only pairs closer than **_rmax_**.\\
    If **_rmin_** is also given, exclude pairs closer than **_rman_**.
  + **sites~_site-list_** include only sites in **_site-list_**.  See [here](/docs/commandline/general/#site-list-syntax) for the syntax of _site-list_.
  + **sign**  If present, rotate angle by 180&deg; for each member of the pair whose magnetic moment is negative

  Example: **--euler~r=10,6~sign~sites~style=2~z==26**\\
  finds angles between Fe atoms (_Z_=26) between 6 and 10 atomic units apart.

**\-\-findes**
*\-\-nescut=#**
: tells **lmchk**{: style="color: blue"} to locate empty spheres to fill space.
  It works by adding adding empty spheres (largest possible first)
  until space is filled with **sum-of-sphere volumes** = **unit cell volume**.\\
  Tokens in the ctrl file affecting this switch are:
: ^
  + OPTIONS RMINES RMAXES minimum and maximum allowed radius of empty spheres to be added
  + SPEC  SCLWSR OMAX1  OMAX2  WSRMAX
  \-\-findes uses these parameters to constrain size of spheres as new ones are added.

  **\-\-nescut=#** (used in conjunction with **\-\-findes**) stop adding sites once the number crosses threshold &thinsp;**#**.

**\-\-getwsr**
:   tells **lmchk**{: style="color: blue"} to use an [algorithm](/docs/code/asaoverview/#algorithm-to-automatically-determine-sphere-radii) to determine
    augmentation sphere radii.  Results are printed to stdout.

**\-\-mino~z \| \-\-mino~_site-list_**
:  tells **lmchk**{: style="color: blue"} to shuffle atom positions in site-list to minimize some
     simple function of the overlap. (For now, the function has been set
     arbitrarily to the sixth power of the overlap).
: ^
    + **\-\-mino~z** : &ensp; construct list from all sites with atomic number _Z_=0
    + **\-\-mino~_site-list_** : &ensp; the syntax for **_site-list_** is given [here](/docs/commandline/general/#site-list-syntax).

**\-\-terse**
: print minimum information about overlaps

**\-\-wpos=_file_**
: writes the site positions to _file.ext_{: style="color: green"}


### _Site-list syntax_
_____________________________________________________________
{::comment}
(/docs/commandline/general/#site-list-syntax)
{:/comment}

Site-lists are used in command-line arguments in several contexts, e.g. in **lmchk**{: style="color: blue"}'s **\-\-shell** and
**\-\-angles** switches.\\
For definiteness assume &thinsp;**~**&thinsp; is the delimiter and the segment being parsed is **sites~_site-list_**.\\
**sites~_site-list_** can take one of the following forms:

**sites~_list_**
: **_list_** is an integer list of site indices, e.g. **1,3,5:9**.
  The syntax for integer lists is described [here](/docs/misc/integerlists).

**sites~style=1~_list_**
: **_list_** is an [integer list](/docs/misc/integerlists) of species or class indices (depending on the switch).

  All sites which belong a species in the species (or class) list get included in the site list.
  
**~style=2~_expr_** 
: **_expr_** is an integer expression. 
  The expression can involve the species index **is** (or class index **ic**) and atomic number **z**.\\
  The species list (or class list) is composed of members for which **_expr_** is nonzero.\\
  All sites which belong a species in the species (or class) list form the site list.
    
**~style=3~_spec1_,_spec2_,&hellip;**
: _spec1_,_spec2_,&hellip; are a string of one or more species names.
  The species list (or class list) is composed of species with a name in the list.

  All sites which belong a species in the species (or class) list form the site list.


