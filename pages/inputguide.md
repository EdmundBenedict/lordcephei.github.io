---
layout: page-fullwidth
title: "The Input File"
permalink: "/docs/input/inputfile/"
header: no
---

### _Purpose_
_____________________________________________________________
{:.no_toc}
This guide aims to detail the structure and use of the input file and related topics. Additionally, the guide details the different categories that the input file uses and the tokens that can be set within each category.  A more careful description of the input file's syntax can be found in [this manual](/docs/input/inputfilesyntax/).

### _Table of Contents_
_____________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}
{::comment}
/docs/input/inputfile/#table-of-contents
{:/comment}

_____________________________________________________________

### 1. _Input File Structure_
{::comment}
/docs/input/inputfile/#input-file-structure
{:/comment}

##### _Introduction_

Here is a sample input file for the compound Bi<sub>_2</sub>Te<sub>_3</sub> written for the **lmf**{: style="color: blue"} code.

<div onclick="elm = document.getElementById('sampleinput'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click to show.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="sampleinput">{:/}

        categories                  tokens


        VERS    		LM:7 FP:7
        HAM     		AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=1 GW=0]
                                GMAX=8.1
        ITER    		MIX=B2,b=.3  NIT=10  CONVC=1e-5
        BZ      		NKABC=3  METAL=5  N=2 W=.01
        STRUC
                                NSPEC=2  NBAS=5  NL=4
                                ALAT=4.7825489
                                PLAT= 1     0          4.0154392
                                -0.5   0.8660254  4.0154392
                                -0.5  -0.8660254  4.0154392
        SPEC
                                ATOM=Te         Z= 52  R= 2.870279
                                ATOM=Bi         Z= 83  R= 2.856141
        SITE
                                ATOM=Te         POS=  0.0000000   0.0000000   0.0000000
                                ATOM=Te         POS= -0.5000000  -0.8660254   1.4616199
                                ATOM=Te         POS=  0.5000000   0.8660254  -1.4616199
                                ATOM=Bi         POS=  0.5000000   0.8660254   0.8030878
                                ATOM=Bi         POS= -0.5000000  -0.8660254  -0.8030878

{::nomarkdown}</div>{:/}

Each element of data follows a _token_{: style="color: blue"}. The token tells the reader what the data signifies.

Each token belongs to a _category_{: style="color: red"}. **VERS**{: style="color: red"}, **ITER**{: style="color: red"}, **BZ**{: style="color: red"}, **STRUC**{: style="color: red"}, **SPEC**{: style="color: red"}, **SITE**{: style="color: red"} are categories that organize the input by topic.
Any text that begins in the first column is a category.

The full identifier (_tag_{: style="color: brown"}) consists of a sequence of branches, usually trunk and branch e.g. **BZ**{: style="color: red"}\_**METAL**{: style="color: blue"}.
The leading component (trunk) is the *category*{: style="color: red"}; the last is the *token*{: style="color: blue"},
which points to actual data.  Sometimes a tag has three branches, e.g. **HAM**{: style="color: red"}\_**AUTOBAS**{: style="color: green"}\_**LOC**{: style="color: blue"}.


##### _Tags, Categories and Tokens_
{::comment}
/docs/input/inputfile/#tags-categories-and-tokens
{:/comment}


The input file offers a very flexible free format: tags identify data to be read by a program, e.g.

        W=.01

reads a number (.01) from token **W=**. In this case **W=** belongs to the **BZ**{: style="color: red"} category, so the full tag name is **BZ**{: style="color: red"}\_**W**{: style="color: blue"}.

A category holds information for a family of data, for example **BZ**{: style="color: red"} contains parameters associated with Brillouin zone integration. The entire input system has at present a grand total of 17 categories, though any one program uses only a subset of them.

{::comment}
<button type="button" class="button tiny radius">Click here for a more detailed description of the input file's syntax.</button>
{:/comment}
<div onclick="elm = document.getElementById('tagexample'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<b>Click here</b> for a more detailed description of how a tag's tree structured syntax is represented.
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="tagexample">{:/}

Consider the Brillouin zone integration category. You plan to carry out the BZ integration using the Methfessel-Paxton sampling method.
M-P integration has two parameters: polynomial order _n_ and gaussian width _w_.
Two tags are used to identify them: **BZ\_N** and **BZ_W**; they are usually expressed in the input file as follows:

    BZ	N=2	W=.01

This format style is the most commonly used because it is clean and easy to read; but it conceals the tree structure a little. The same data can equally be written:

    BZ[	N=2 	W=.01]

Now the tree structure is apparent: [..] delimits the scope of tag **BZ**.

Any tag that starts in the first column is a category, so any non-white character appearing in the first column automatically starts a new category, and also terminates any prior category. **N=** and **W=** mark tokens **BZ_N** and **BZ_W**.

Apart from the special use of the first column to identify categories, data is largely free-format, though there are a a few mild exceptions. Thus:

    BZ  N=2
        W=.01
    BZ	W=.01	N=2
    BZ[	W=.01	N=2]

all represent the same information.

_Note:_{: style="color: red"} if two categories appear in an input file, only the first is used. Subsequent categories are ignored. Generally, only the first tag is used when more than one appears within a given scope.

{::nomarkdown}</div>{:/}

Usually the tag tree has only two levels (category and token) but not always. For example, data associated with atomic sites must be supplied for each site. In this case the tree has three levels, e.g. **SITE_ATOM_POS**. Site data is typically represented in a format along the following lines:

    SITE    ATOM=Ga  POS=  0   0   0    RELAX=T
            ATOM=As  POS= .25 .25 .25
            ATOM=...
            ...
    END

The scope of  **SITE**  starts at "SITE"  and terminates just before "END". There will be multiple instances of the  **SITE_ATOM**  tag, one for each site. The scope of the first instance begins with the first occurrence of  ATOM  and terminates just before the second:

    ATOM=Ga  POS=  0   0   0    RELAX=T

And the scope of the second **SITE_ATOM** is

    ATOM=As  POS= .25 .25 .25

Note that **ATOM** simultaneously acts like a token pointing to data (e.g. Ga) and as a tag holding tokens within it, in this case **SITE_ATOM_POS** and (for the first site) **SITE_ATOM_RELAX**.

Some tags are required; others are optional; still others (in fact most) may not be used at all by a particular program. If a code needs site data, **SITE_ATOM_POS** is required, but **SITE_ATOM_RELAX** is probably optional, or not read at all.

_Note:_{: style="color: red"} [this manual](/docs/input/inputfilesyntax/) contains a more careful description of the input file's syntax.

##### _Preprocessor_
{::comment}
/docs/input/inputfile/#preprocessor
{:/comment}

Input lines are passed through a [preprocessor](/docs/input/preprocessor),
which provides a wide flexibility in how input files are structured.
The preprocessor has many features in common with a programming language, including the ability to
[declare and assign variables](/docs/input/preprocessor/#variables), evaluate algebraic expressions;
and it has constructs for
[branching](/docs/input/preprocessor/#branching-constructs) and
[looping](/docs/input/preprocessor/#looping-constructs), to make possible multiple or conditional reading of input lines.

For example, supposing through a prior preprocessor instruction you have declared a variable *range*, and it has been assigned the value 3. This line in the input file:

        RMAX={range+1/4}

is turned in to:

        RMAX=3.25

The preprocessor treats text inside brackets {...} as an expression (usually an algebraic expression), which is evaluated and rendered back as an ASCII string.
See this [annotated lmf output](/docs/outputs/lmf_output/#preprocessors-transformation-of-the-input-file)
for an example.

The preprocessor's programming language makes it possible for a single file to serve as input for many materials systems in the manner of a database; or as documentation. Also you can easily vary input conditions in a parameteric fashion.

Other files besides _ctrl.ext_{: style="color: green"} are first parsed by the preprocessor ---
files for site positions, Euler angles for noncollinear magnetism are read through the preprocessor, among others.

_____________________________________________________________

### 2. _Help with finding tokens_
{::comment}
/docs/input/inputfile/#help-with-finding-tokens
{:/comment}
<br>

Seeing the effect of the preprocessor
: The preprocessor can act in nontrivial ways.  To see the effect of the preprocessor, use the `--showp` command-line option.\\
See [this annotated output](/docs/outputs/lmf_output/#preprocessors-transformation-of-the-input-file)
for an example.

Finding what tags the parser seeks
: It is often the case that you want to input some information but don't
know the name of the tag you need.  Try searching this page for a keyword.
: You can list each tag a particular tool reads, together with a synopsis
of its function, by adding `--input` to the command-line.\\
Search for keywords in the text to find what you need.

<div onclick="elm = document.getElementById('input'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click here to see  --input  explained.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="input">{:/}

Take for an example:

~~~
  lmchk --input
~~~
This switch tells the parser not to try and read anything, but print
out information about what it would would try to read.  Several useful bits
of information are given, including a brief description of each tag
in the following format.  A snippet of the output is reproduced below:

~~~
 Tag                    Input   cast  (size,min)
 ------------------------------------------

 IO_VERBOS              opt    i4v      5,  1     default = 35
   Verbosity stack for printout.
   May also be set from the command-line: --pr#1[,#2]
 IO_IACTIV              opt    i4       1,  1     default = 0
   Turn on interactive mode.
   May also be controlled from the command-line:  --iactiv  or  --iactiv=no
...
 STRUC_FILE             opt    chr      1,  0
   (Not used if data read from EXPRESS_file)
   Name of site file containing basis and lattice information.
   Read NBAS, PLAT, and optionally ALAT from site file, if specified.
   Otherwise, they are read from the ctrl file.
...
 STRUC_PLAT             reqd   r8v      9,  9
   Primitive lattice vectors, in units of alat
...
 SPEC_ATOM_LMX          opt    i4       1,  1     (default depends on prior input)
   l-cutoff for basis
...
 SITE_ATOM_POS          reqd*  r8v      3,  1
   Atom coordinates, in units of alat
 - If preceding token is not parsed, attempt to read the following:
 SITE_ATOM_XPOS         reqd   r8v      3,  1
   Atom coordinates, as (fractional) multiples of the lattice vectors
~~~

The table tells you **IO_VERBOS** and **IO_IACTIV** are optional tags; default values are 35 and 0, respectively.  A single integer will be
read from the latter tag, and between one and five integers will be read from **IO_VERBOS**.

There is a brief synopsis explaining the functions of each.  For these particular cases, the output gives alternative means to perform
equivalent functions through command-line switches.

**STRUC_FILE=fname** is optional.  Here **fname** is a character string: it should be the site file name _fname.ext_{: style="color: green"}
from which lattice information is read. If you do use this tag, other tags in the **STRUC** category (**NBAS**, **PLAT**, **ALAT**) may be omitted.
Otherwise, **STRUC_PLAT** is required input; the parser requires 9 numbers.\\
The synopsis also tells you that you can specify the same information using **EXPRESS_file=fname** (see **EXPRESS** category below).

**SPEC_ATOM_LMX** is optional input whose default value depends on other input (in this case, atomic number).

**SITE_ATOM_POS** is required input in the sense that you must supply either it
or **SITE_ATOM_XPOS**.  The <b>\*</b> in <b>reqd\*</b> the information in **SITE_ATOM_POS**
can be supplied by an alternate tag -- **SITE_ATOM_XPOS** in this case.

_Note:_{: style="color: red"} if site data is given through a site file,
all the other tags in the **SITE** category will be ignored.

The cast (real, integer, character) of each tag is indicated, and also how many numbers are to be read.  Sometimes tags will look for more
than one number, but allow you to supply fewer.  For example, **BZ_NKABC** in the snippet below looks for three numbers to determine the
_k_-mesh, which are the number of divisions only each of the reciprocal lattice vectors.  If you supply only one number it is copied to
elements 2 and 3.

~~~
BZ_NKABC               reqd   i4v      3,  1
  (Not used if data read from EXPRESS_nkabc)
  No. qp along each of 3 lattice vectors.
  Supply one number for all vectors or a separate number for each vector.
~~~

{::nomarkdown}</div>{:/}

Command-line options
: `--help` performs a similar function for the command line arguments: it prints out a brief summary of arguments effective in the executable you are using.
  A more complete description of general-purpose command line options can be found on [this page](/docs/commandline/general/).\\
  See this [annotated lmfa output](/docs/outputs/lmfa_output/#help-explained) for an example.

Displaying tags read by the parser
: To see what is actually read by a particular tool, run your tool with `--show=2` or `--show`.\\
See the [annotated lmf output](/docs/outputs/lmf_output/#display-tags-parsed-in-the-input-file)
for an example.

These special modes are summarized [here](/tutorial/lmf/lmf_pbte_tutorial/#determining-what-input-an-executable-seeks).

### 3. _The EXPRESS category_
_____________________________________________________________

Section 4 provides some description of the input and purpose of tags in each category.

There is one special category, **EXPRESS**, whose purpose is to
simplify and streamline input files.  Tags in **EXPRESS** are
effectively aliases for tags in other categories, e.g. reading
**EXPRESS_gmax** reads the same input as **HAM_GMAX**.

If you put a tag into **EXPRESS**, it will be read there and
any tag appearing in its usual location will be ignored. Thus including **GMAX**
in **HAM** would have no effect if **gmax** is present in **EXPRESS**.

**EXPRESS** collects the most commonly used tags in one place.
There is usually a one-to-one correspondence between the tag in **EXPRESS**
and its usual location.  The sole exception to this is **EXPRESS_file**,
which performs the same function as the pair of tags, **STRUC_FILE** and **SITE_FILE**.
Thus in using **EXPRESS_file** all structural data is supplied through the site file.

_____________________________________________________________

### 4. _Input File Categories_

This section details the various categories and tokens used in the input file.


##### _Preliminaries_
_Note:_{: style="color: red"} The tables below list the input systems’ tokens and their function. Tables are organized by category.

*   The Arguments column refers to the cast belonging to the token ("l", "i", "r", and "c" refer to logical, integer, floating-point and character data, respectively)
*   The Program column indicates which programs the token is specific to, if any
*   The Optional column indicates whether the token is optional (Y) or required (N)
*   The Default column indicates the default value, if any
*   The Explanation column describes the token’s function.

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _BZ_
{::comment}
(/docs/input/inputfile/#bz)
{:/comment}

Category BZ holds information concerning the numerical integration of quantities such as energy bands over the Brillouin Zone (BZ). The LMTO programs permit both sampling and tetrahedron integration methods. Both are described in bzintegration.html, and the relative merits of the two different methods are discussed. As implemented both methods use a uniform, regularly spaced mesh of k-points, which divides the BZ into microcells as described here. Normally you specify this mesh by the number of divisions of each of the three primitive reciprocal lattice vectors (which are the inverse, transpose of the lattice vectors PLAT); NKABC below.

These tokens are read by programs that make hamiltonians in periodic crystals (lmf,lm,lmgf,lmpg,tbe). Some tokens apply only to codes that make energy bands, (lmf,lm,tbe).

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
GETQP | l | | Y | F | Read list of k-points from a disk file. This is a special mode, and you normally would let the program choose its own mesh by specifying the number of divisions (see NKABC). <br> If token is not parsed, the program will attempt to parse NKABC.
NKABC | l to 3 i | | N | | The number of divisions in the three directions of the reciprocal lattice vectors. k-points are generated along a uniform mesh on each of these axes. (This is the optimal general purpose quadrature for periodic functions as it integrates the largest number of sine and cosine functions exactly for a specified number of points.) <br><br> The parser will attempt to read three integers. If only one number is read, the missing second and third entries assume the value of the first. <br><br> Information from NKABC, together with BZJOB below, contains specifications equivalent to the widely used “Monkhorst Pack” scheme. But it is more transparent and easier to understand. The number of k-points in the full BZ is the product of these numbers; the number of irreducible k-points may be reduced by symmetry operations.
PUTQP | l | | Y | F | If T, Write out the list of irreducible k-points to file qpts, and the weights for tetrahedron integration if available.
BZJOB | l to 3 i | | Y | 0 | Controls the centering of the k-points in the BZ: <br>0: the mesh is centered so that one point lies at the origin <br>1: points symmetrically straddle the origin <br><br>Three numbers are supplied, corresponding to each of the three primitive reciprocal lattice vectors. As with NKABC if only one number is read the missing second and third entries assume the value of the first.
METAL | i | lmf, lm, tbe | Y | 1 | Specifies how the weights are generated for BZ integration. <br><br>Numerical quadrature is used to to accumulate the output density or any BZ-integrated property. In insulators, each point in the full BZ gets equal weight; in metals, the weights depend on the Fermi level <i>E<sub>F</sub></i>, which must be determined from the eigenvalues. <br>There are these possibilities:<br> &#8226; the weights for each k are known in advance, as is the case for insulators.<br> &#8226; <i>E<sub>F</sub></i> must be determined before BZ integrations are performed.<br>&emsp;In this more difficult case, there are two possibilities:<br> &emsp; the weight at k does not depend on values of neighboring k (sampling integration).<br> &emsp; the weight at k does depend on values of neighboring k (tetrahedron integration).<br> The first case is easy to handle. For the latter several strategies have been developed.<br> The METAL token accepts the following:<br> 0. System assumed to be an insulator; weights determined <i>a priori</i>.<br> 1. Eigenvectors are written to disk, in which case the integration for the charge density can be deferred until all the bands are obtained.  This option is available only for the ASA: When accumulating just the spherical part of the charge, eigenvector data can be contracted over <i>m</i>, reducing memory demands.<br> 2. Integration weights are read from file _wkp.ext_{: style="color: green"}, which will have been generated in a prior band pass.  If _wkp.ext_{: style="color: green"} is missing or unsuitable, the program will temporarily switch to METAL=3.<br> 3. Two band passes are made; the first generates only eigenvalues to determine <i>E<sub>F</sub></i>. It is slower than METAL=2, but it is more stable which can be important in difficult cases.<br> 4. Three distinct Fermi levels are assumed and weights generated for each.  After <i>E<sub>F</sub></i> is determined, the actual weights are calculated by quadratic interpolation through the three points.  The three Fermi levels are gradually narrowed to a small window around the true <i>E<sub>F</sub></i> in the course of the self-consistency cycle. This scheme works for sampling integration where the <i>k</i>-point weights depend on <i>E<sub>F</sub></i> only and not eigenvalues at neighboring <i>k</i>. You can also use this scheme in a mixed tetrahedron/sampling method: Weights for the band sum are determined by tetrahedron, but the charge density is integrated by sampling. It works better than straight sampling because the total energy is variational in the density.<br> 5. like METAL=3 in that two passes are made but eigenvectors are kept in memory so there is no additional overhead in the first pass. This is the recommended mode for <b>lmf</b> unless you are working with a large system and need to conserve memory.<br><br>The ASA implements METAL=0,1,2; the FP codes METAL=0,2,3,4,5.
TETRA | 1 | lmf,lm,tbe | Y | T | Selects BZ integration method<br>0: Methfessel-Paxton sampling integration. Tokens NPTS, N, W, EF0, DELEF (see below) are relevant to this integration scheme.<br>1: tetrahedron integration, with Bloechl weights
N | i | lmf,lm,tbe | Y | 0 | Polynomial order for sampling integration; see [Methfessel and Paxton, Phys. Rev. B, 40, 3616 (1989)](http://link.aps.org/doi/10.1103/PhysRevB.40.3616). (Not used with tetrahedron integration or for insulators.)<br>&ensp;0: integration uses standard gaussian method<br>&gt;0:   integration uses generalized gaussian functions, i.e. polynomial of order N &times; gaussian to generate integration weights<br>−1:      use the Fermi function rather than gaussians to broaden the &delta;-function. This generates the actual electron (fermi) distribution for a finite temperature.<br>Add 100: by default, if a gap is found separating occupied and occupied states, the program will treat the system as and insulator, even when MET>0. To suppress this, add 100 to N (use −101 for Fermi distribution).
W | r | lmf,lm,tbe | Y | 5e-3 | Case BZ_N&gt;0 (sampling weights from &delta;-function broadened into a Gaussian):<br>&emsp;W=Broadening (Gaussian width) for Gaussian sampling integration (Ry).<br>Case BZ_N&lt;0 (sampling weights computed from the Fermi function):<br>&emsp;W=temperature, in Ry. <br>W is not used for insulators or with tetrahedron integration.
EF0 | r | lmf,lm,tbe | Y | 0 | Initial guess at Fermi energy. Used with BZ_METAL=4.
DELEF | r | lmf,lm,tbe | Y | 0.05 | Initial uncertainty in Fermi level for sampling integration.<br>Used with BZ_METAL=4.
ZBAK | r | lmf,lm | Y | 0 | Homogeneous background charge
SAVDOS | i | lmf,lm,tbe | Y | 0 |  0: does not save dos on disk<br>1: writes the total density of states on NPTS mesh points to disk file *dos.ext*{: style="color: green"}<br>2: Write weights to disk for partial DOS (In the ASA this occurs automatically).<br>4: Same as (2), but write weights m-resolved (ASA)<br>*Notes*{: style="color: red"}<br>SAVDOS>0 requires BZ_NPTS and BZ_DOS also.<br>You may also cause lm or lmf to generate m-resolved dos using the –pdos command-line argument.  You must turn OFF all symmetry operations to produce correct results (--nosym).
DOS | 2 r | | Y | -1,0 | Energy window over which DOS accumulated. Needed either for sampling integration or if SAVDOS>0.
NPTS | i | | Y | 1001 | Number of points in the density-of-states mesh used in conjunction with sampling integration. Needed either for sampling integration or if SAVDOS>0.
EFMAX | r | lmf,lm,tbe | Y | 2 | Only eigenvectors whose eigenvalues are less than EFMAX are computed; this improves execution efficiency.
NEVMX | i | lmf,lm,tbe | Y | 0 | \>0 : Find at most NEVMX eigenvectors<br>=0 : program uses internal default<br>\<0 : no eigenvectors are generated (and correspondingly, nothing associated with eigenvectors such as density.)<br><br>Caution: if you want to look at partial DOS well above the Fermi level (which comes out around 0), you must set EFMAX and NEVMX high enough to encompass the range of interest.
ZVAL | r | | Y | 0 | Number of electrons to accumulate in BZ integration. Normally zval is computed by the program.
NOINV | l | lmf,lm,tbe | Y | F | Suppress the automatic addition of the inversion to the list of point group operations. Usually the inversion symmetry can be included in the determination of the irreducible part of the BZ because of time reversal symmetry. There may be cases where this symmetry is broken:<br>e.g. when spin-orbit coupling is included or when the (beyond LDA) self-energy breaks time-reversal symmetry. In most cases, the program will automatically disable this addition in cases that it knows the symmetry is broken.
FSMOM | 2 r | lmf,lm | Y | 0 0 | Set the global magnetic moment (collinear magnetic case). In the fixed-spin moment method, a spin-dependent potential shift Beff is added to constrain the total magnetic moment to value assigned by FSMOM=. No constraint is imposed if this value is zero (the default).<br>Optional second arg supplies an initial Beff. It is applied whether or not the first argument is 0. If arg#1 ≠ 0, Beff is made consistent with it.
DMAT | l | lmf,lmgf | Y | F | Calculate the density matrix.
INVIT | l | lmf,lm | Y | F | Enables inverse iteration generate eigenvectors (this is the default). It is more efficient than the QL method, but occasionally fails to find all the vectors. When this happens, the program stops with the message:<br> DIAGNO: tinvit cannot find all evecs<br>If you encounter this message set INVIT=F.
EMESH | r | lmgf,lmpg | Y | 10,0,-1,... | Parameters defining contour integration for Green’s function methods.<br>Element: <br>1. number of energy points n<br>2. contour type:<br>&emsp;0: Uniform mesh of nz points: Real part of z between emin and emax<br>&emsp;1: Same as 0, but reverse sign of Im z<br>&emsp;10: elliptical contour<br>&emsp;11: same as 10, but reverse sign of Im z<br>&emsp;100s digit used for special modifications<br>&emsp;Add 100 for nonequil part using Im(z)=delne<br>&emsp;Add 200 for nonequil part using Im(z)=del00<br>&emsp;Add 300 for mixed elliptical contour + real axis to find fermi level<br>&emsp;Add 1000 to set nonequil part only.</li></ul><br>3. lower bound for energy contour emin (on the real axis)<br>4. upper bound for energy contour emax, e.g. Fermi level (on the real axis)<br>5. (elliptical contour) eccentricity: ranges between 0 (circle) and 1 (line)<br>&emsp;(uniform contour) Im z<br>6. (elliptical contour) bunching parameter eps : ranges between 0 (distributed symmetrically) and 1 (bunched toward emax)<br>&emsp;(uniform contour) not used<br>7. (nonequilibrium GF, lmpg) nzne = number of points on nonequilibrium contour<br>8. (nonequilibrium GF, lmpg) vne = difference in fermi energies of right and left leads<br>9. (nonequilibrium GF, lmpg) delne = Im part of E for nonequilibrium contour<br>10 (nonequilibrium GF, lmpg) substitutes for delne when making the surface self-energy.<br>
MULL | i | tbe | Y | 0 | Mulliken population analysis. Mulliken population analysis is also implemented in lmf, but you specify the analysis with a command-line argument.

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _CONST_

Category CONST enables the user to declare variables for use in algebraic expressions. The syntax is a string of declarations inside the category, e.g:

        CONST   a=10.69 nspec=4+2

Variables declared this way are similar to, but distinct from variables declared for the preprocessor, such as

        % const nbas=5

In the latter case the preprocessor makes a pass, and may use expressions involving variables declared by e.g. "% const nbas=5" to alter the structure of the input file.

Variables declared for use by the preprocessor lose their definition after
the preprocessor completes.

The following code segment illustrates both types:

~~~
% const nbas=5
CONST   a=10.69 nspec=4
SPEC    ALAT=a  NSPEC=nspec NBAS={nbas}
~~~

After the preprocessor compiles, the input file appears as:

~~~
CONST   a=10.69 nspec=4
SPEC    ALAT=a  NSPEC=nspec NBAS=5
~~~

When the CONST category is read (it is read before other categories),
variables a and nspec are defined and used in the SPEC category.

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _DYN_
{::comment}
/docs/input/inputfile/#dyn
{:/comment}

Contains parameters for molecular statics and dynamics.

{::comment}
<div onclick="elm = document.getElementById('dyntable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="dyntable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NIT | i | lmf, lmmc, tbe | Y | | maximum number of relaxation steps (molecular statics)
SSTAT[...] | | lm, lmgf | Y | | (noncollinear magnetism) parameters specifying how spin statics (rotation of quantization axes to minimze energy) is carried out
SSTAT\_MODE | i | lm, lmgf | N | 0 | 0: no spin statics or dynamics<br>-1: Landau-Gilbert spin dynamics<br>1: spin statics: quantization axis determined by making output density matrix diagonal<br>2: spin statics: size and direction of relaxation determined from spin torque<br>Add 10 to mix angles independently of P,Q (Euler angles are mixed with prior iterations to accelerate convergence)<br>Add 1000 to mix Euler angles independently of P,Q
SSTAT\_SCALE | i | lm, lmgf | N | 0 | (used with mode=2) scale factor amplifying magnetic forces
SSTAT\_MAXT | i | lm, lmgf | N | 0 | maximum allowed change in angle
SSTAT\_TAU | i | lm, lmgf | N | 0 | (used with mode=-1) time step
SSTAT\_ETOL | i | lm, lmgf | N | 0 | (used with mode=-1) Set tau=0 this iter if etot-ehf>ETOL
MSTAT[...] | | lmf, lmmc, tbe | Y | | (molecular statics) parameters specifiying how site positions are relaxed given the internuclear forces
MSTAT\_MODE | i | lmf, lmmc, tbe | N | 0 | 0: no relaxation<br>4: relax with conjugate gradients algorithm (not generally recommended)<br>5: relax with Fletcher-Powell alogirithm. Find minimum along a line; a new line is chosen. The Hessian matrix is updated only at the start of a new line minimization. Fletcher-Powell is more stable but usually less efficient then Broyden.<br>6: relax with Broyden algorithm. This is essentially a Newton-Raphson algorithm, where Hessian matrix and direction of descent are updated each iteration.
MSTAT\_HESS | l | lmf, lmmc, tbe | N | T | T: Read hessian matrix from file, if it exists<br>F: assume initial hessian is the unit matrix
MSTAT\_XTOL | r | lmf, lmmc, tbe | Y | 1e-3 | Convergence criterion for change in atomic displacements<br>>0: criterion satisfied when xtol > net shift (shifts summed over all sites)<br><0: criterion satisfied when xtol > max shift of any site<br>0: Do not use this criterion to check convergence<br><br>Note: When molecular statics are performed, either GTOL or XTOL must be specified. Both may be specified
MSTAT\_GTOL | r | lmf,lmmc,tbe | Y | 0 | Convergence criterion for tolerance in forces.<br>>0: criterion satisfied when gtol > "net" force (forces summed over all sites)<br><0: criterion satisfied when xtol > max absolute force at any site<br>0: Do not use this criterion to check convergence<br><br>Note: When molecular statics are performed, either GTOL or XTOL must be specified. Both may be specified
MSTAT\_STEP | r | lmf, lmmc, tbe | Y | 0.015 | Initial (and maximum) step length
MSTAT\_NKILL | i | lmf, lmmc, tbe | Y | 0 | Remove hessian after NKILL iterations.<br>Never remove Hessian if NKILL=0
MSTAT\_PDEF= | r | lmf, lmmc, tbe | Y | 0 0 0 ... | Lattice deformation modes (not documented)
MD[...] | | lmmc, tbe | Y | | Parameters for molecular dynamics
MD\_MODE | i | lmmc | N | 0 | 0: no MD<br>1: NVE<br>2: NVT<br>3: NPT
MD\_TSTEP | r | lmmc | Y | 20.671 | Time step (a.u.)<br>NB: 1 fs = 20.67098 a.u.
MD\_TEMP | r | lmmc | Y | 0.00189999 | Temperature (a.u.)<br>NB: 1 deg K = 6.3333e-6 a.u.
MD\_TAUP | r | lmmc | Y | 206.71 | Thermostat relaxation time (a.u.)
MD\_TIME | r | lmmc | N | 20671000 | Total MD time (a.u.)
MD\_TAUB | r | lmmc | Y | 2067.1 | Barostat relaxation time (a.u.)

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _EWALD_
Category EWALD holds information controlling the Ewald sums for structure consstants entering into, e.g. the Madelung summations and Bloch summed structure constants (**lmf**{: style="color: blue"}). Most programs use quantities in this category to carry out Ewald sums (exceptions are **lmstr**{: style="color: blue"} and the molecules code **lmmc**{: style="color: blue"}).

{::comment}
<div onclick="elm = document.getElementById('ewaldtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ewaldtable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
AS | r | | Y | 2 | Controls the relative number of lattice vectors in the real and reciprocal space
TOL | r | | Y | 1e-8 | Tolerance in the Ewald sums
NKDMX | i | | Y | 800 | The maximum number of real-space lattice vectors entering into the Ewald sum, used for memory allocation.<br>Normally you should not need this token. Increase NKDMX if you encounter an error message like this one: xlgen: too many vectors, n=...
RPAD | r | | Y | 0 | Scale rcutoff by RPAD when lattice vectors padded in oblong geometries

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _HAM_
{::comment}
(/docs/input/inputfile/#ham)
{:/comment}

This category contains parameters defining the one-particle hamiltonian.

Portions of HAM are read by these codes:

**lm**{: style="color: blue"},&nbsp; **lmfa**{: style="color: blue"},&nbsp; **lmfgwd**{: style="color: blue"},&nbsp; **lmfgws**{: style="color: blue"},&nbsp; **lmf**{: style="color: blue"},&nbsp;
**lmgf**{: style="color: blue"},&nbsp; **lmpg**{: style="color: blue"},&nbsp; **lmdos**{: style="color: blue"},&nbsp; **lmchk**{: style="color: blue"},&nbsp; **lmscell**{: style="color: blue"},&nbsp;
**lmstr**{: style="color: blue"},&nbsp; **lmctl**{: style="color: blue"},&nbsp; **lmmc**{: style="color: blue"},&nbsp; **tbe**{: style="color: blue"},&nbsp; **lmmag**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('hamtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="hamtable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NSPIN | i | ALL | Y | 1 | 1 for non-spin-polarized calculations<br>2 for spin-polarized calculations<br>NB: For the magnetic parameters below to be active, use NSPIN=2.
REL	| i | ALL | Y | 1 | 0: for nonrelativistic Schr&ouml;dinger equation<br>1: for scalar relativistic approximation to the Dirac equation<br>2: for Dirac equation (ASA only)<br>11: [compute cores](/tutorial/lmf/lmf_pbte_tutorial/#relativistic-core-levels) with the Dirac equation (lmfa only)
SO | i | ALL | Y | 0 | 0: no SO coupling<br>1: Add L·S to hamiltonian<br>2: Add Lz·Sz only to hamiltonian<br>3: Like 2, but also add L·S−LzSz in an approximate manner that preserves independence in the spin channels.<br>See [here](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/spin-orbit-coupling.html) for analysis and description of the different approximations
NONCOL | l | ASA | Y | F | F: collinear magnetism<br>T: non-collinear magnetism
SS | 4 r | ASA | Y | 0 | Magnetic spin spiral, direction vector and angle.<br><br>Example: nc/test/test.nc 1
BFIELD | i | lm, lmf | Y | 0 | 0: no external magnetic field applied.<br>1: add site-dependent constant external Zeeman field (requires NONCOL=T).<br>Fields are read from file _bfield.ext_{: style="color: green"}.<br>2: add Bz·Sz only to hamiltonian.<br><br>Examples:<br>fp/test/test.fp gdn<br>nc/test/test.nc 5
BXCSCAL | i | lm, lmgf | Y | 0 | This tag provides an alternative means to add an effective external magnetic field in the LDA.<br>0: no special scaling of the exchange-correlation field.<br>1: scale the magnetic part of the LDA XC field by a site-dependent factor 1 + sbxci as described below.<br>2: scale the magnetic part of the LDA XC field by a site-dependent factor $$(1 + sbxc_i^2)^{1/2}$$ as described below.<br>This is a special mode used to impose constraining fields on rotations, used, e.g. by the CPA code.<br>Site-dependent scalings sbxci are read from file bxc.ext.
XCFUN | i | ALL LDA | Y | 2 | Specifies local exchange correlation functional<br>0,#2,#3: Use [libxc](http://www.tddft.org/programs/octopus/wiki/index.php/Libxc) exchange functional #2 and correlation functional #3<br>1: Ceperly-Alder<br>2: Barth-Hedin (ASW fit)<br>3: PW91 (same as PBE)<br>4: PBE (Same as PW91)
GGA | i | ALL LDA | Y | 0 | Specifies a GGA functional (not used when XCFUN=0,#2,#3)<br>1. No GGA (LDA only)<br>2. Langreth-Mehl<br>3. PW91<br>4. PBE<br>5. PBE with Becke exchange<br><br>Example: fp/test/test.fp te
PWMODE | i | lmf, lmfgwd | Y | | Controls how APWs are added to the LMTO basis.  <br>1s digit:<br>1. LMTO basis only<br>2. Mixed LMTO+PW<br>&emsp;Examples: <br>&emsp;fp/test/test.fp srtio3 and fp/test/test.fp felz 4<br>3. PW basis only<br>10s digit:<br>0. PW basis fixed (less accurate, but simpler)<br>1. PW basis k-dependent.<br>&emsp; Symmetry-consistent but basis, dimension depend on k.<br>&emsp;Example: fp/test/test.fp te
PWEMIN | r | lmf, lmfgwd | Y | 0 | Include APWs with energy E > PWEMIN (Ry)
PWEMAX | r | lmf, lmfgwd | Y | -1 | Include APWs with energy E < PWEMAX (Ry)
NPWPAD | i | lmf, lmfgwd | Y | -1 | Overrides default padding of variable basis dimension
RDSIG | i | lmf, lmfgwd, lm, lmgf | Y | 0 | Controls how the QSGW self-energy &Sigma;<sup>0</sup> substitutes for the LDA exchange correlation functional.<br>Note: the GW codes store $$\Sigma^0{-}V_{xc}^\mathrm{LDA}$$ in file *sigm.ext*{: style="color: green"}.<br>1s digit:<br>&nbsp;0 do not read &Sigma;<sup>0</sup><br>&nbsp;1 read file *sigm.ext*{: style="color: green"}, if it exists, and add it to the LDA potential<br>&emsp;&nbsp;Add 2 to symmetrize **sigm**<br>&emsp;&nbsp;Add 4 to include Re(**sigm**(T)) only<br>10s digit:<br>0&nbsp; simple interpolation (not recommended)<br>1&nbsp; approximate high energy parts of **sigm** by diagonal<br>3&nbsp; interpolate **sigm** by LDA eigenvectors (no longer supported)<br>&emsp;In this mode use 100s digit for # interpolation points.<br>Add:<br>10000 to indicate the sigma file was stored in the full BZ (no symmetry operations are assumed)<br>20000 to use the minimum neighbor table (only one translation vector at the surfaces or edges; cannot be used with symmetrization)<br>40000 to allow file mismatch between expected k-points and file values.<br><br>Note: Some options can be supplied via the command-line, using **--rsig**.
RSSTOL | r | ALL | Y | 5e-6 | Max tolerance in Bloch sum error for real-space &Sigma;<sup>0</sup>.<br><br>&Sigma;<sup>0</sup> is read in k-space and is immediately converted to real space by inverse Bloch transform.<br>The r.s.form is forward Bloch summed and checked against the original k-space &Sigma;<sup>0</sup>.<br>If the difference exceeds RSSTOL the program will abort.<br>The conversion should be exact to machine precision unless the range of &Sigma;<sup>0</sup> is truncated.<br>You can control the range of real-space &Sigma;<sup>0</sup> with RSRNGE below.
RSRNGE | r | ALL | Y | 5 | Maximum range of connecting vectors for real-space &Sigma;<sup>0</sup> (units of ALAT)
NMTO | i | ASA | Y | 0 | Order of polynomial approximation for NMTO hamiltonian
KMTO | r | ASA | Y | | Corresponding NMTO kinetic energies.<br>Read NMTO values, or skip if NMTO=0
EWALD | l | lm | Y | F | Make strux by Ewald summation (NMTO only)
VMTZ | r | ASA | Y | 0 | Muffin-tin zero defining wave functions
QASA | i | ASA | Y | 3 | A parameter specifying the definition of ASA moments [<i>Q</i><sub>0</sub>,<i>Q</i><sub>1</sub>,<i>Q</i><sub>2</sub>](/docs/code/asaoverview/#generation-of-the-sphere-potential-and-energy-moments-q); see lmto documentation<br>0. Methfessel conventions for 2nd gen ASA moments <i>Q</i><sub>0</sub>,<i>Q</i><sub>1</sub>,<i>Q</i><sub>2</sub><br>1. <i>Q</i><sub>2</sub> = coefficient to $${\dot{\phi}}^2{−}p\phi^2$$ in sphere.<br>2. <i>Q</i><sub>1</sub>,<i>Q</i><sub>2</sub> accumulated as coefficients to $$\langle \phi \dot{\phi} \rangle$$ and $$\langle{\dot{\phi}}^2\rangle$$, respectively.<br>3. 1+2 (Stuttgart conventions)
PMIN | r | ALL | Y | 0 0 0 ... | Global minimum in fractional part of [logarithmic derivative parameters](/docs/code/asaoverview/#logderpar) Pl.<br>Enter values for l=0,..lmx<br>0: no minimum constraint<br>\# : with \#<1, floor of fractional P is \#<br>1: use free-electron value as minimum<br><br>Note: lmf always uses a minimum constraint, the free-electron value (or slightly higher if AUTOBAS_GW is set).<br>You can set the floor still higher with PMIN=#.
PMAX | r | ALL | Y | 0 0 0 ... | Global maximum in fractional part of potential functions Pl. Enter values for l=0,..lmx<br>0 : no maximum constraint<br>\#: with \#<1, uppper bound of of fractional P is \#
OVEPS | r | ALL | Y | 0 | The overlap is diagonalized and the hilbert space is contracted, discarding the part with eigenvalues of overlap < OVEPS<br>Especially useful with the PMT basis, where the combination of smooth Hankel functions and APWs has a tendency to make the basis overcomplete.
OVNCUT | i | ALL | Y | 0 | This tag has a similar objective to OVEPS.<br>The overlap is diagonalized and the hilbert space is contracted, discarding the part belonging to lowest OVNCUT evals of overlap.<br>Supersedes OVEPS, if present.
GMAX | r | lmf, lmfgwd | N | | G-vector cutoff used to create the mesh for the interstitial density. A uniform mesh is with spacing between points in the three directions as homogeneous as possible, with G vectors &#124;G&#124; < GMAX.<br>This input is required; but you may omit it if you supply information with the FTMESH token.
FTMESH | i1 [i2 i3] | FP | N | | The number of divisions specifying the uniform mesh density along the three reciprocal lattice vectors. The second and third arguments default to the value of the first one, if they are not specified. <br>This input is used only in the parser failed to read the GMAX token.
TOL | r | FP | Y | 1e-6 | Specifies the precision to which the generalized LMTO envelope functions are expanded in a Fourier expansion of G vectors.
FRZWF | l | FP | Y | F | Set to T to freeze the shape of the augmented part of the wave functions. Normally their shape is updated as the potential changes, but with FRZWF=t the potential used to make augmentation wave functions is frozen at what is read from the restart file (or free-atom potential if starting from superposing free atoms).<br>This is not normally necessary, and freezing wave functions makes the basis slightly less accurate. However, there are slight inconsistencies when these orbitals are allowed to change shape. Notably the calculated forces to not take this shape change into account, and they will be slightly inconsistent with the total energy.
FORCES | i | FP | Y | 0 | Controls how forces are to be calculated, and how the second-order corrections are to be evaluated. Through the variational principle, the total energy is correct to second order in deviations from self-consistency, but forces are correct only to first order. To obtain forces to second order, it is necessary to know how the density would change with a (virtual) displacement of the core+nucleus, which requires a linear response treatment.<br>lmf estimates this change using one of ansatz:1.  &nbsp;the free-atom density is subtracted from the total density for nuclei centered at the original position and added back again at the (virtually) displaced position.<br>12. the core+nucleus is shifted and screened assuming a Lindhard dielectric response. You also must specify ELIND, below.
ELIND | r | lmf | Y | -1 | a parameter in the Lindhard response function, (the Fermi level for a free-electron gas relative to the bottom of the band). You can specify this energy directly, by using a positive number for the parameter. If you use instead a negative number, the program will choose a default value from the total number of valence electrons and assuming a free-electron gas, scale that default by the absolute value of the number you specify. If you have a simple sp bonded system, the default value is a good choice. If you have d or f electrons, it tends to overestimate the response.<br>Use something smaller, e.g. ELIND=-0.7.<br><br>ELIND is used in three contexts:<br>(1) in the force correction term; see FORCES= above<br>(2) to estimate a self-consistent density from the input and output densities after a band pass<br>(3) to estimate a reasonable smooth density from a starting density after atoms are moved in a relaxation step.
SIGP[...] | r | lmf, lmfgwd | Y | | Parameters used to interpolate the self-energy &Sigma;<sup>0</sup>. Used in conjunction with the GW package. See gw.html for description. Default: not used
SIGP\_MODE | r | lmf, lmfgwd | Y | 4 | Specifies the linear function used for matrix elements of &Sigma;<sup>0</sup> at highly-lying energies. With recent implementations of the GW package 4 is recommended; it requires no input from you.
SIGP\_EMAX SIGP\_NMAX SIGP\_EMIN SIGP\_NMIN SIGP\_A SIGP\_B | r | lmf, lmfgwd | Y | | See gw.html
AUTOBAS[...] | r | lmfa, lmf, lmfgwd | Y | | Parameters associated with the automatic determination of the basis set.<br>These switches greatly simplify the creation of an input file for lmf.<br>Note: Programs lmfa and lmf both use tokens in the AUTOBAS tag but they mean different things, as described below. This is because lmfa generates the parameters while lmf uses them.<br><br>Default: not used
AUTOBAS\_GW | i | lmfa | Y | 0 | Set to 1 to tailor the autogenerated basis set file _basp0.ext_{: style="color: green"} to a somewhat larger basis, better suited for GW.
AUTOBAS\_GW | i | lmf | Y | 0 | Set to 1 to float log derivatives P a bit more conservatively — better suited to GW calculations.
AUTOBAS\_LMTO | i | lmfa | Y | 0 | lmfa autogenerates a trial basis set, saving the result into _basp0.ext_{: style="color: green"}.<br>LMTO is used in an algorithm to determine how large a basis it should construct: the number of orbitals increases as you increase LMTO. This algorithm also depends on which states in the free atom which carry charge.<br>Let lq be the highest l which carries charge in the free atom.<br><br>There are the following choices for LMTO:<br>0. standard minimal basis; same as LMTO=3.<br>1. The hyperminimal basis, which consists of envelope functions corresponding those l which carry charge in the free atom, e.g. Ga sp and Mo sd (this basis is only sensible when used in conjunction with APWs).<br>2. All l up to lq+1 if lq<2; otherwise all l up to lq<br>3. All l up to min(lq+1, 3).<br>For elements lighter than Kr, restrict l≤2.<br>For elements heavier than Kr, include l to 3.<br>4. (Standard basis) Same as LMTO=3, but restrict l≤2 for elements lighter than Ar.<br>5. (Large basis) All l up to max(lq+1,3) except for H, He, Li, B (use l=spd).<br>Use the MTO token (see below) in combination with this one. MTO controls whether the LMTO basis is 1-κ or 2-κ, meaning whether 1 or 2 envelope functions are allowed per l channel.
AUTOBAS\_MTO | i | lmfa | Y | 0 | Autogenerate parameters that control which LMTO basis functions are to be included, and their shape.<br><br>Tokens RSMH,EH (and possibly RSMH2,EH2) determine the shape of the MTO basis. lmfa will determine a reasonable set of RSMH,EH automatically (and RSMH2,EH2 for a 2-κ basis), fitting to radial wave functions of the free atom.<br><br>Note: lmfa can generate parameters and write them to file _basp0.ext_{: style="color: green"}.<br>lmf can read parameters from _basp.ext_{: style="color: green"}.<br>You must manually create _basp.ext_{: style="color: green"}, e.g. by copying _basp0.ext_{: style="color: green"} into _basp.ext_{: style="color: green"}. You can tailor _basp.ext_{: style="color: green"} with a text editor. There are the following choices for MTO:<br> 0: do not autogenerate basis parameters<br>1: or 3 1-κ parameters with Z-dependent LMX<br>2: or 4 2-κ parameters with Z-dependent LMX
AUTOBAS\_MTO | i | lmf, lmfgwd | Y | 0 | Read parameters RSMH,EH,RSMH2,EH2 that control which LMTO basis functions enter the basis.<br><br>Once initial values have been generated you can tune these parameters automatically for the solid, using lmf with the --optbas switch; see Building_FP_input_file.html and FPoptbas.html.<br><br>The --optbas step is not essential, especially for large basis sets, but it is a way to improve on the basis without increasing the size.<br><br>There are the following choices for MTO:<br><br>0 Parameters not read from _basp.ext_{: style="color: green"}; they are specified in the input file _ctrl.ext_{: style="color: green"}.<br>1 or 3: 1-κ parameters may be read from the basis file _basp.ext_{: style="color: green"}, if they exist<br>2 or 4: 2-κ parameters may be read from the basis file _basp.ext_{: style="color: green"}, if they exist<br>1 or 2: Parameters read from _ctrl.ext_{: style="color: green"} take precedence over _basp.ext_{: style="color: green"}<br>3 or 4: Parameters read from _basp.ext_{: style="color: green"} take precedence over those read from _ctrl.ext_{: style="color: green"}.
AUTOBAS\_PNU | i | lmfa | Y | 0 | Autoset boundary condition for augmentation part of basis, through specification of [logarithmic derivative parameters](/docs/code/asaoverview/#logderpar) P.<br><br>0 do not make P <br>1 Find P for l < lmxb from free atom wave function; save in _basp0.ext_{: style="color: green"}
AUTOBAS\_PNU | i | lmf, lmfgwd | Y | 0 | Autoset boundary condition for augmentation part of basis, through specification of plogarithmic derivative parameters](/docs/code/asaoverview/#logderpar) P.<br><br>0 do not attempt to read P from _basp.ext_{: style="color: green"}.<br>1 Read P from _basp.ext_{: style="color: green"}, for species which P is supplied.
AUTOBAS\_LOC | i | lmfa, lmf, lmfgwd | Y | 0 | Autoset local orbital parameters PZ, which determine which deep or high-lying states are to be included as local orbitals.<br><br>Used by lmfa to control whether parameters PZ are to be sought:<br>0: do not autogenerate PZ<br>1 or 2: autogenerate PZ<br><br>Used by lmf and lmfgwd to control how PZ is read:<br><br>1 or 2: read parameters PZ<br>1: Nonzero values from ctrl file take precedence over basis file input
AUTOBAS\_ELOC | r | lmfa | Y | -2 Ry | The first of two criteria to decide which orbitals should be included in the valence as local orbitals. If the energy of the free atom wave function exceeds (is more shallow than) ELOC, the orbital is included as a local orbital.
AUTOBAS\_QLOC | r | lmfa | Y | 0.005 | The second of two criteria to decide which  orbitals should be included in the valence as local orbitals.<br>If the fraction of the free atom wave function’s charge outside the augmentation radius exceeds QLOC, the orbital is included as a local orbital.
AUTOBAS\_PFLOAT | i1 i2 | lmf, lmfgwd | y | 1 1 | Governs how the Pnu are set and floated in the course of a self-consistency cycle.<br>The 1st argument controls default starting values of P and lower bounds to P when it is floated<br>0: Use version 6 defaults and float lower bound<br>1: Use defaults and float lower bound designed for LDA<br>2: Use defaults and float lower bound designed for GW<br>The 2nd argument controls how the band center of gravity (CG) is determined — used when floating P.<br>0: band CG is found by a traditional method<br>1: band CG is found from the true energy moment of the density

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _GF_
{::comment}
(/docs/input/inputfile/#gf)
{:/comment}

Category GF is intended for parameters specific to the Green’s function code **lmgf**{: style="color: blue"}.
It is read by **lmgf**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('gftable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="gftable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | ASA | Y | 0 | 0: do nothing<br>1:self-consistent cycle<br>10: Transverse magnetic exchange interactions J(q)<br>11: Read J(q) from disk and analyze results<br>14: Longitudinal exchange interactions<br>20: Transverse <i>&chi;</i><sup>+&minus;</sup> from ASA Green's function<br>21: Read <i>&chi;</i> from disk and analyze results<br>20: Transverse <i>&chi;</i><sup>++</sup>, <i>&chi;</i><sup>&minus;&minus;</sup> from ASA Green's function<br>Caution: Modes 14 and higher have not been maintained.
GFOPTS | c | ASA | Y | | ASCII string with switches governing execution of lmgf. Use &nbsp;**';'**&nbsp; to separate the switches.<br>Available switches:<br>**p1** First order of potential function<br>**p3** Third order of potential function<br>**pz** Exact potential function (some problems; not recommended)<br>Use only one of the above; if none are used, the code generates second order potential functions.<br>**idos** integrated DOS (by principal layer in the lmpg case)<br>**noidos** suppress calculation of integrated DOS<br>**pdos** accumulate partial DOS<br>**emom** accumulate output moments; use **noemom** to suppress<br>**noemom** suppresss accumulation of output moments<br>**sdmat** make site density-matrix<br>**dmat** make density-matrix<br>**frzvc** do not update potential shift needed to obtain charge neutrality<br>**padtol** Tolerance in Pade correction to charge. If tolerance exceeded, lmgf will repeat the band pass with an updated Fermi level<br>**omgtol** (CPA) tolerance criterion for convergence in coherent potential<br>**omgmix** (CPA) linear mixing parameter for iterating convergence in coherent potential<br>**nitmax** (CPA) maximum number of iterations to iterate for coherent potential<br>**lotf** (CPA)<br>**dz** (CPA)
DLM | i | ALL | Y | 0 | disordered local moments for CPA.<br>Governs self-consistency for both chemical CPA and magnetic CPA.<br>12 : normal CPA/DLM calculation: charge and coherent potential &Omega; both iterated to self-consistency.<br>32 : &Omega; alone is iterated to self-consistency.
BXY | 1 | ALL | Y | F | (DLM) Setting this switch to T generates a site-dependent constraining field to properly align magnetic moments.<br><br>In this context constraining field is applied by scaling the LDA exchange-correlation field.<br>The scaling factor is **[1+bxc(ib)^2]<sup>1/2</sup>**. <br><br>A table of bxc is kept for each site in the first column of file shfac.ext.<br>See also [**HAM_BXCSCAL**](/docs/input/inputfile/#ham)
TEMP | r | ALL | Y | 0 | (DLM) spin temperature.

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _GW_
{::comment}
(/docs/input/inputfile/#gw)
{:/comment}

Category GW holds parameters specific to GW calculations, particularly for the GW driver **lmfgwd**{: style="color: blue"}. Most of these tokens supply values for tags in the _GWinput_{: style="color: green"} template when **lmfgwd**{: style="color: blue"} generates it (**\-\-jobgw -1**).

{::comment}
<div onclick="elm = document.getElementById('gwtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="gwtable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
CODE | i | lmfgwd | Y | 2 | This token tells what GW code you are creating input files for.<br>lmfgwd serves as a driver to several GW codes. <br>0. First GW version v033a5 (code still works but it is no longer maintained) <br>2. Current version of GW codes <br>1. Driver for the Julich spex code (not fully debugged or maintained)
NKABC | 1 to 3 i | | Y | | Defines the k-mesh for GW. This token serves the same function for GW as BZ_NKABC does for the LDA codes, and the input format is the same.<br><br>When generating a GWinput template, lmfgwd passes the contents of NKABC to the n1n2n3 tag.<br><br>Note: Shell scripts lmgw and lmgwsc used for the GW codes may also use this token.<br>When invoked with switches --getsigp or --getnk, they will modify the n1n2n3 in GWinput.<br>The data they use is taken from GW\_NKABC.
MKSIG | i | lmfgwd | Y | 3 | (self-consistent calculations only).<br>Controls the form of &Sigma;<sup>0</sup> (the QSGW approximation to the dynamical self-energy &Sigma;).<br>In the table below $$ &Sigma;_{nn'}(E)$$ refers to a matrix element of &Sigma; between eigenstates <i>n</i> and <i>n</i>&#8242;, at energy _E_ relative to <i>E<sub>F</sub></i>. <br>When generating a GWinput template, lmfgwd passes MKSIG to the iSigMode tag.<br>Values of this tag have the following meanings. <br>0. do not make &Sigma;<sup>0</sup> <br>1. &Sigma;<sup>0</sup> = &Sigma;<sub><i>nn</i>'</sub>&thinsp;(<i>E</i><sub><i>F</i></sub>) if <i>n</i>&ne;<i>n</i>', and &Sigma;<sub><i>nn</i></sub>(<i>E</i><sub><i>n</i></sub>) if <i>n</i>=<i>n</i>': mode B, Eq.(11) in Phys. Rev. B<b>76</b>, 165106 (2007) <br>3. &Sigma;<sup>0</sup> = 1/2[&Sigma;<sub><i>nn</i>'</sub>&thinsp;(<i>E</i><sub><i>n</i></sub>) + &Sigma;<sub><i>nn</i>'</sub>&thinsp;(<i>E</i><sub><i>n</i>'</sub>)]: mode A, Eq.(10) in Phys. Rev. B<b>76</b>, 165106 (2007) <br>5. “eigenvalue only” self-consistency &Sigma;<sup>0</sup> = &delta;<sub><i>nn</i>'</sub>&Sigma;<sub><i>nn</i>'&thinsp;</sub>(<i>E</i><sub><i>n</i></sub>)
GCUTB | r | lmfgwd | Y | 2.7 | G-vector cutoff for basis envelope functions as used in the GW package.<br>When generating a GWinput template, lmfgwd passes GCUTB to the QpGcut_psi tag.
GCUTX | r | lmfgwd | Y | 2.2 | G-vector cutoff for interstitial part of two-particle objects such as the screened coulomb interaction.<br>When generating a GWinput template, lmfgwd passes GCUTX to the QpGcut_cou tag.
ECUTS | r | lmfgwd | Y | 2.5 | (for self-consistent calculations only). Maximum energy for which to calculate the $$ V^{xc} $$ described in MKSIG above.<br>This energy should be larger than HAM_SIGP_EMAX which is used to interpolate $$V^{xc}$$.<br>When generating a GWinput template, lmfgwd passes ECUTS+1/2 to the emax_sigm tag.
NIME | i | lmfgwd | Y | 6 | Number of frequencies on the imaginary integration axis when making the correlation part of &Sigma;.<br>When generating a GWinput template, lmfgwd passes NIME to the new tag.
DELRE | r | lmfgwd | Y | .01, .04 | frequency mesh parameters GW and OMG defining the real axis mesh in the calculation of Im $$\chi_0$$.<br>The <i>i</i><sup>th</sup> mesh point is given by:<br><i>&omega;<sub>i</sub></i>=DW&times;(i−1) + [DW&times;(i−1)]<sup>2</sup>/OMG/2<br>Points are approximately uniformly spaced, separated by DW, up to frequency OMG, around which point the spacing begins to increase linearly with frequency.<br>When generating a GWinput template, lmfgwd passes DELRE(1) to the dw tag and DELRE(2) to the omg\_c tag.<br>Note: the similarity to OPTICS\_DW used by the optics part of lmf and lm.
DELTA | r | lmfgwd | Y | -1e-4 | &delta;-function broadening for calculating &chi;<sub>0</sub>, in atomic units.<br>Tetrahedron integration is used if DELTA<0.<br>When generating a GWinput template, lmfgwd passes DELTA to the delta tag.
GSMEAR | r | lmfgwd | Y | .003 | Broadening width for smearing pole in the Green’s function when calculating &Sigma;.<br>This parameter is sometimes important in metals, e.g. Fe.<br>See Section 3 in this manual.<br>When generating a GWinput template, lmfgwd passes GSMEAR to the esmr tag.
PBTOL | r | lmfgwd | Y | .001 | Overlap criterion for product basis functions inside augmentation spheres.<br>The overlap matrix of the basis of product functions generated and diagonalized for each l. Functions with overlaps less than PBTOL are removed from the product basis.<br>When generating a GWinput template, lmfgwd passes PBTOL to the second line after the the start of the PRODUCT_BASIS section.

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _HEADER_
This category is optional, and merely prints to the standard output whatever text is in the category. For example:

~~~
HEADER  This line and the following one are printed to
        standard output whenever a program is run.
NEXT
~~~

Alternately:

~~~
HEADER [ In this form only two lines reside within the
        category delimiters,]
        and only two lines are printed.
~~~

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _IO_
(/docs/input/inputfile/#io)
This optional category controls what kind of information, and how much, is written to the standard output file.

{::comment}
<div onclick="elm = document.getElementById('iotable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="iotable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
SHOW | 1 | all | Y | F | Echo lines as they is read from input file and parsed by the proprocessor.<br>Command-line argument \-\-show provides the same functionality.
HELP | 1 | all | Y | F | Show what input would be sought, without attempting to read data.<br>Command-line argument \-\-input provides the same functionality.
VERBOS | 1 to 3 | all | Y | 30 | Sets the verbosity. 20 is terse, 30 slightly terse, 40 slightly verbose, 50 verbose, and so on. If more than one number is given, later numbers control verbosity in subsections of the code, notably the parts dealing with augmentation spheres.<br>May also be set from the command-line: \-\-pr#1[,#2]
IACTIV | 1 | all | Y | F | Turn on interactive mode. At some point programs will prompt you with queries.<br>May also be controlled from the command-line: \-\-iactiv or \-\-iactiv=no.
TIM | 1 or 2 | all | Y | 0, 0 | Prints out CPU usage of blocks of code in a tree format.<br>First value sets tree depth. Second value, if present, prints timings on the fly.<br>May also be controlled from the command-line: \-\-time=#1[,#2]

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _ITER_
{::comment}
(/docs/input/inputfile/#iter)
{:/comment}

The ITER category contains parameters that control the requirements to reach self-consistency.

It applies to all programs that iterate to self-consistency:
**lm**{: style="color: blue"},&nbsp; **lmf**{: style="color: blue"},&nbsp; **lmmc**{: style="color: blue"},&nbsp; **lmgf**{: style="color: blue"},&nbsp; **lmpg**{: style="color: blue"},&nbsp; **tbe**{: style="color: blue"},&nbsp; **lmfa**{: style="color: blue"}.

A detailed discussion can be found at the [end of this document](/docs/input/inputfile/#itermix).

{::comment}
<div onclick="elm = document.getElementById('itertable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="itertable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NIT | i | all | Y | 1 | Maximum number of iterations in the self-consistency cycle.
NRMIX | i1 i2 | ASA, lmfa | Y | 80, 2 | Uses when self-consistency is needed inside an augmentation sphere. This occurs when the density is determined from the momentsQ0,Q1,Q2 in the ASA; or in the free atom code, just Q0.<br>i1: max number of iterations<br>i2: number of prior iterations for Anderson mixing of the sphere density<br>Note: You will probably never need to use this token.
MIX | c | all | Y | | Mixing rules for mixing input, output density in the self-consistency cycle. Syntax:<br>A[nmix][,b=beta][,bv=betv][,n=nit][,w=w1,w2][,nam=fn][,k=nkill][;...] or<br>B[nmix][,b=beta][,bv=betv][,wc=wc][,n=#][,w=w1,w2][,nam=fn][,k=nkill]<br>See [here](/docs/input/inputfile/#the-itermix-tag-and-how-to-use-it) for detailed description.
AMIX | c | ASA | Y | | Mixing rules when Euler angles are mixed independently. Syntax as in MIX
CONV | r | all | Y | 1e-4 | Maximum energy change from the prior iteration for self-consistency to be reached.
CONVC | r | all | Y | 1e-4 | Maximum in the RMS difference in $$ <n^{out} − n^{in}> $$.<br>In the ASA, this is measured by the change in moments Q0..Q2 and log derivative parameter P.<br>In the full-potential case it is measured by an integral over the various parts of n (local, interstitial parts).
UMIX | r | all | Y | 1 | Mixing parameter for density matrix; used with LDA+U
TOLU | r | all | Y | 0 | Tolerance for density matrix; used with LDA+U
NITU | i | all | Y | 0 | Maximum number of LDA+U iterations of density matrix

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _OPTICS_
{::comment}
(/docs/input/inputfile/#optics)
{:/comment}

Optics functions available with the ASA extension packages OPTICS.

It is read by **lm**{: style="color: blue"} and **lmf**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('opticstable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="opticstable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | OPTICS | Y | 0 | 0: make no optics calculations<br>1: generate linear $$ ε_2 $$<br>20: generate second harmonic ε<br>&emsp;Example: optics/test/test.optics sic<br>The following cases (MODE&lt;0) generate joint or single density-of-states.<br>_Note:_{: style="color: red"} MODE&lt;0 works only with LTET=3 described below.<br> −1: generate joint density-of-states <br>&emsp;Examples: <br>&emsp;(ASA) optics/test/test.optics \-\-all 4 <br>&emsp;(FP) fp/test/test.fp zbgan <br>−2: generate joint density-of-states, spin 2 <br>&emsp;Example:optics/test/test.optics fe 6 <br>−3: generate up-down joint density-of-states <br>−4: generate down-up joint density-of-states <br>−5: generate spin-up single density-of-states<br>&emsp;Example: optics/test/test.optics \-\-all 7 <br>−6: generate spin-dn single density-of-states
LTET | i | OPTICS | Y | 0 | 0: Integration by Methfessel-Paxton sampling<br>1: standard tetrahedron integration<br>2: same as 1<br>3: enhanced tetrahedron integration <br>_Note:_{: style="color: red"} In the metallic case, states near the Fermi level must be treated with partial occupancy. LTET=3 is the only scheme that handles this properly.<br>It was adapted from the GW package and has extensions, e.g. the ability to handle non-vertical transitions $$ k^{occ} \ne k^{unocc} $$.
WINDOW | r1 r2 | OPTICS | N | 0 1 | Energy (frequency) window over which to calculate Im[ε(ω)].<br>Im ε is calculated on a mesh of points $$ ω_i $$.<br>The mesh spacing is specified by NPTS or DW, below.
NPTS | i | OPTICS | N | 501 | Number of mesh points in the energy (frequency) window. Together with WINDOW, NPTS specifies the frequency mesh as:<br>$$ ω_i $$ = WINDOW(1) + DW×(i−1)<br>where DW = (WINDOW(2)−WINDOW(1))/(NPTS−1)<br>Note: you may alternatively specify DW below.
DW | r1 [r2] | OPTICS | Y | | Frequency mesh spacing DW[,OMG]. You can supply either one argument, or two.<br>If one argument (DW) is supplied, the mesh will consist of evenly spaced points separated by DW.<br>If a second argument (OMG) is supplied, points are spaced quadratically as:<br>$$ ω_i $$ = WINDOW(1) + DW×(i−1) + [DW×(i−1)]2/OMG/2<br>Spacing is approximately uniform up to frequency OMG; beyond which it increases linearly.<br>Note: The quadratic spacing can be used only with LTET=3.
FILBND | i1 [i2] | OPTICS | Y | 0 0 | i1[,i2] occupied energy bands from which to calculate ε using first order perturbation theory, without local fields.<br>i1 = lowest occupied band<br>i2 = highest occupied band (defaults to no. electrons)
EMPBND | i1 [i2] | OPTICS | Y | 0 0 | i1[,i2] occupied energy bands from which to calculate ε using first order perturbation theory, without local fields.<br>i1 = lowest unoccupied band<br>i2 = highest unoccupied band (defaults to no. bands)
PART | l | OPTICS | Y | F | Resolve ε or joint DOS into band-to-band contributions, or by k.<br>Result is output into file popt.ext. <br>0. No decomposition <br>1. Resolve ε or DOS into individual (occ,unocc) contributions <br>&emsp;Example: optics/test/test.optics ogan 5 <br>2. Resolve ε or DOS by k <br>&emsp;Example: optics/test/test.optics \-\-all 6 <br>3. Both 1 and 2 <br>Add 10 to write popt as a binary file.
CHI2[..] | | OPTICS | Y | | Tag containing parameters for second harmonic generation.<br>Not calculated unless tag is parsed.<br>&emsp;Example: optics/test/test.optics sic
CHI2\_NCHI2 | i | OPTICS | N | 0 | Number of direction vectors for which to calculate <i>&chi;</i><sub>2</sub>.
CHI2\_AXES | i1, i2, i3 | OPTICS | N | | Direction vectors for each of the NCHI2 sets
ESCISS | r | OPTICS | Y | 0 | Scissors operator (constant energy added to unoccupied levels)
ECUT | r | OPTICS | Y | 0.2 | Energy safety margin for determining (occ,unocc) window.<br>lmf will attempt to reduce the number of (occ,unocc) pairs by restricting, for each k, transitions that contribute to the response, i.e. to those inside the optics WINDOW.<br>The window is padded by ECUT to include states outside, but near the edge of the window.<br>States outside window may nevertheless make contribution, e.g. because they can be part of a tetrahedron that does contribute.<br>If you do not want lmf to restrict the range, use ECUT<0.

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _OPTIONS_
{::comment}
(/docs/input/inputfile/#options)
{:/comment}

Portions of OPTIONS are read by these codes:

**lm**{: style="color: blue"},&nbsp; **lmfa**{: style="color: blue"},&nbsp; **lmfgwd**{: style="color: blue"},&nbsp; **lmfgws**{: style="color: blue"},&nbsp; **lmf**{: style="color: blue"},&nbsp;
**lmmc**{: style="color: blue"},&nbsp; **lmgf**{: style="color: blue"},&nbsp; **lmdos**{: style="color: blue"},&nbsp; **lmstr**{: style="color: blue"},&nbsp; **lmctl**{: style="color: blue"},&nbsp;
**lmpg**{: style="color: blue"},&nbsp; **tbe**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('optionstable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="optionstable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
HF | 1 | lm, lmf | Y | F | If T, use the Harris-Foulkes functional only; do not evaluate output density.
SHARM | 1 | ASA, lmf, lmfgwd | Y | F | If T, use true spherical harmonics, rather than real harmonics.
FRZ | l | all | Y | F | (ASA) If T, freezes core wave functions.<br>(FP) If T, freezes the potential used to make augmented partial waves, so that the basis set does not change with potential.
SAVVEC | 1 | lm | Y | F | Save eigenvectors on disk. (This may be enabled automatically in some circumstances)
Q | c | all | Y | | Q=HAM, Q=BAND,&thinsp;Q=MAD,&thinsp;Q=ATOM,&thinsp;Q=SHOW<br>make the program stop at selected points without completing a full iteration.
SCR | i | ASA | Y | 0 | Is connected with the generation or use of the q->0 ASA dielectric response function. It is useful in cases when there is difficulty in making the density self-consistent.<br>See linear-response-asa.html for documentation.<br>0. do not screen qout−qin. <br>1. Make the ASA response function P0. <br>2. Use P0 to screen qout−qin and the change in ves. <br>3. 1+2 (lmgf only) <br>4. screen qout−qin from a model P0 <br>5. illegal input <br>6. Use P0 to screen the change in ves only<br> P0 and U should be updated every iteration, but this is expensive and not worth the cost. However, you can: <br>Add 10*k* to recompute intra-site contribution U every kth iteration, 0<k≤9.<br>Add 100*k* to recompute P0 every kth iteration (lmgf only).<br>&emsp;Examples: testing/test.scr and gf/test/test.gf mnpt 6
ASA[...] | r | ASA | N | | Parameters associated with ASA-specific input.
ASA\_ADNF | 1 | ASA | Y | F | Enables automatic downfolding of orbitals
ASA\_NSPH | 1 | ASA | Y | 0 | Set to 1 to generate l>0 contributions (from neighboring sites) to l=0 electrostatic potential
ASA\_TWOC | i | ASA | Y | 0 | Set to 1 to use the two-center approximation ASA hamiltonian
ASA\_GAMMA | i | ASA | Y | 0 | Set to 1 to rotate to the (orthogonal) gamma representation. This should have no effect on the eigenvalues for the usual three-center hamiltonian, but converts the two-center hamiltonian from first order to second order.<br>Set to 2 to rotate to the spin-averaged gamma representation. <br>The lm code does not allow downfolding with GAMMA≠0.
ASA\_CCOR | 1 | lm | Y | T | If F, suppresses the combined correction. By default it is enabled. Note: NB: if any orbitals are downfolded, CCOR is automatically enabled.
ASA\_NEWREP | 1 | NC | Y | F | Set to 1 to rotate structure constants to a user-specified representation.<br>It requires special compilation to be effective
ASA\_NOHYB | 1 | NC | Y | F | Set to 1 to turn off hybridization
ASA\_MTCOR | 1 | NC | Y | F | Set to T to turn on Ewald MT correction
ASA\_QMT | r | NC | Y | 0 | Override standard background charge for Ewald MT correction<br>Input only meaningful if MTCOR=T
RMINES | r | lmchk | N | 1 | Minimum augmentation radius when finding new empty sites [(\-\-getwsr)](/docs/commandline/general/#switches-for-lmchk)
RMAXES | r | lmchk | N | 2 | Maximum augmentation radius when finding new empty sites [(\-\-getwsr)](/docs/commandline/general/#switches-for-lmchk)
NESABC | i,i,i | lmchk | N | 100 | Number of mesh divisions when searching for empty spheres [(\-\-getwsr)](/docs/commandline/general/#switches-for-lmchk)

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _PGF_
Category PGF concerns calculations with the layer Green’s function program **lmpg**{: style="color: blue"}.

It is read by **lmpg**{: style="color: blue"} and **lmstr**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('pgftable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="pgftable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | ASA | Y | | 0: do nothing<br>1: diagonal layer GF<br>&emsp;Examples: pgf/test/test.pgf -all 5 and pgf/test/test.pgf -all 6<br>2: left- and right-bulk bulk GF<br>3: find k(E) for left bulk<br>&emsp;Example: pgf/test/test.pgf 2<br>4: find k(E) for right bulk<br>5: Calculate ballistic current<br>&emsp;Example: pgf/test/test.pgf femgo
SPARSE | i | ASA | Y | 0 | 0: Calculate G layer by layer using Dyson’s equation<br>&emsp;Example: pgf/test/test.pgf -all 5<br>1: Calculate G using LU decomposition<br>&emsp;Example: pgf/test/test.pgf -all 6
PLATL | r | ASA | N | | The third lattice vector of left bulk region
PLATR | r | ASA | N | | The third lattice vector of right bulk region
GFOPTS | c | ASA | Y | | ASCII string with switches governing execution of lmgf or lmpg. Use &nbsp;'**;**' to separate the switches.<br>Available switches:<br>**p1** First order of potential function<br>**p3** Third order of potential function<br>**pz** Exact potential function (some problems; not recommended)<br>Use only one of the above; if none are used, the code makes second order potential functions<br>**idos** integrated DOS (by principal layer in the lmpg case)<br>**noidos** suppress calculation of integrated DOS<br>**pdos** accumulate partial DOS<br>**emom** accumulate output moments; use **noemom** to suppress<br>**noemom** suppresss accumulation of output moments<br>**sdmat** make site density-matrix<br>**dmat** make density-matrix<br>**frzvc** do not update potential shift needed to obtain charge neutrality<br>'padtol** Tolerance in Pade correction to charge. If tolerance exceeded, lmgf will repeat the band pass with an updated Fermi level<br>**omgtol** (CPA) tolerance criterion for convergence in coherent potential<br>**omgmix** (CPA) linear mixing parameter for iterating convergence in coherent potential<br>**nitmax** (CPA) maximum number of iterations to iterate for coherent potential<br>**lotf** (CPA)<br>**dz** (CPA)

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _SITE_
Category SITE holds site information. As in the SPEC category, tokens must read for each site entry; a similar restriction applies to the order of tokens. Token ATOM= must be the first token for each site, and all tokens defining parameters for that site must occur before a subsequent ATOM=.

{::comment}
<div onclick="elm = document.getElementById('sitetable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="sitetable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
FILE | c | all | Y | | Provides a mechanism to read site data from a separate file. File subs/iosite.f documents the syntax of the site file structure.<br>The reccommended (standard) format has the following syntax:<br><br>The first line should contain a ‘%’ in the first column, and a `version’ token vn=#.<br>Structural data (see category STRUC documentation) may also be included in this line. Each subsequent line supplies input for one site. In the simplest format, a line would have the following:<br>spid x y z<br>where spid is the species identifier (same information would otherwise be specified by token ATOM= below) and x y z are the site positions.<br><br>Examples: fp/test/test.fp er and fp/test/test.fp tio2<br><br>Bug: when you read site data from an alternate file, the reader doesn’t compute the reference energy.<br><br>Kotani format (documented here but no longer maintained). In this alternative format the first four lines always specify data read in the STRUC category; see FILE= in STRUC.<br>Then follow lines, one line for each site<br>ib iclass spid x y z<br>The first number is merely a basis index and should increment 1,2,3,4,… in successive lines. The second class index is ignored by these programs. The remaining columns are the species identifier for the site positions.<br><br>If SITE_FILE is missing, the following are read from the ctrl file:
ATOM | c | all | N | | Identifies the species (by label) to which this atom belongs. It is a fatal error for the species not to have been defined.
ATOM\_POS | r1 r2 r3 | all | N | | The basis vector (3 elements), in dimensionless Cartesian coordinates. As with the primitive lattice translation vectors, the true vectors (in atomic units) are scaled from these by ALAT in category STRUC.<br>NB: XPOS and POS are alternative forms of input. One or the other is required.
ATMOM\_XPOS | r1 r2 r3 | all | N | | Atom coordinates, as (fractional) multiples of the lattice vectors.<br>NB: XPOS and POS are alternative forms of input. One or the other is required.
ATOM\_DPOS | r1 r2 r3 | all | Y | 0 0 0 | Shift in atom coordinates to POS
ATOM\_RELAX | i1 i2 i3 | all | Y | 1 1 1 | Relax site positions (lattice dynamics or molecular statics) or Euler angles (spin dynamics)
ATOM\_RMAXS | r | FP | Y | | Site-dependent radial cutoff for structure constants, in a.u.
ATOM\_ROT | c | ASA | Y | | Rotation of spin quantization axis at this site
ATOM\_PL | i | lmpg | Y | 0 | (lmpg) Assign principal layer number to this site

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _SPEC_
{::comment}
/docs/input/inputfile/#spec
{:/comment}

Category SPEC contains species-specific information. Because data must be read for each species, tokens are repeated (once for each species). For this reason, there is some restriction as to the order of tokens. Data for a specific species (Z=, R=, R/W=, LMX=, IDXDN= and the like described below) begins with a token ATOM=;&thinsp; input of tokens specific to that species must precede the next occurence of ATOM=.

The following tokens apply to the automatic sphere resizer:

{::comment}
<div onclick="elm = document.getElementById('spec1table'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="spec1table">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
SCLWSR | r | ALL | Y | 0 | SCLWSR>0 turns on the automatic sphere resizer. It defaults to 0, which turns off the resizer.<br>The 10’s digit tells the resizer how to deal with resizing empty spheres; see lmto.html.
OMAX1 | r1 r2 r3 | ALL | Y | 0.16, 0.18, 0.2 | Constrains maximum allowed values of sphere overlaps.<br>You may input up to three numbers, which correspond to atom-atom, and atom-empty-sphere, and empty-sphere-empty-sphere overlaps respectively.
OMAX2 | r1 r2 r3 | ALL | Y | 0.4, 0.45, 0.5 | Constrains maximum allowed values of sphere overlaps defined differently from OMAX1; see lmto.html.<br>Both constraints are applied.
WSRMAX | r | ALL | Y | 0 | Imposes an upper limit to any one sphere radius

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

{::nomarkdown} <a name="spec-cat"></a> {:/}

The following tokens are input for each species. Data sandwiched between successive occurences of ATOM apply to one species.

{::comment}
<div onclick="elm = document.getElementById('spec2table'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="spec2table">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
ATOM | c | all | N | | A character string (8 characters or fewer) that labels this species. This label is used, e.g. by the SITE category to associate a species with an atom at a given site.<br>Species are split into classes; how and when this is done depends whether you are using an ASA or full-potential implementation.<br><br>ASA-specific:<br>The species ID also names a disk file with information about that atom (potential parameters, moments, potential and some sundry other information). More precisely, species are split into classes, the program differentiates class names by appending integers to the species label. The first class associated with the species has the species label; subsequent ones have integers appended.<br>&emsp;Example: testing/test.ovlp 3
Z | r | all | N | | Nuclear charge. Normally an integer, but Z can be a fractional number. A fractional number implies a virtual crystal approximation to an alloy with some Z intermediate between the two integers sandwiching it.
R | r | all | N | | The augmentation sphere radius, in atomic units. This is a required input for most programs:<br>choose one of R=, R/W= or R/A=. Read descriptions of the R/W AND R/A below for further remarks; also see [this page](/docs/code/asaoverview/#selection-of-sphere-radii) for a more complete discussion on the choice of sphere radii.<br><br>lmchk can find sphere radii automatically. Invoke lmchk with \-\–getwsr.<br>You can also rescale as-given radii to meet constraints with the SCLWSR token.
R/W | r | all | N | | R/W= ratio of the augmentation sphere radius to the average Wigner Seitz radius W.<br>W is the radius of a sphere such that (4πW3/3) = V/N, where V/N is the volume per atom.<br>Thus if all radii are equal with R/W=1, the sum of sphere volumes would fill space, as is usual in the ASA.<br><br>ASA-specific:<br>You must choose the radii so that the sum of sphere volumes (4π/3&Sigma;iRi3) equals the unit cell volume V; otherwise results may become unreliable. The space-filling requirement means sphere may overlap quite a lot, particularly in open systems. If sphere overlaps get too large, (>20% or so) accuracy becomes an issue. In such a case you should add “empty spheres” to fill space. Use lmchk to print out sphere overlaps. lmchk also has an automatic empty spheres finder, which you invoke with the –findes switch; see [here](/docs/code/asaoverview/#algorithm-to-automatically-determine-sphere-radii) for a discussion.<br><br>Example: testing/test.ovlp 3<br><br>FP-specific:<br>FP results are much less sensitive to the choice of sphere radii. Strictly, the spheres should not overlap, but because of lmf‘s unique augmentation scheme, overlaps of up to 10% cause negligibly small errors as a rule.<br>(This does not apply to GW calculations!)<br>Even so, it is not advisable to let the overlaps get too large. As a general rule the L-cutoff should increase as the sphere radius increases. Also it has been found in practice that self-consistency is harder to accomplish when spheres overlap significantly.
R/A | r | all | N | | R/A = ratio of the aumentation sphere radius to the lattice constant
A | r | all | Y | | Radial mesh point spacing parameter. All programs dealing with augmentation spheres represent the density on a shifted logarithmic radial mesh. The ith point on the mesh is $$ r_i $$ = b[exp(a(i−1)−1]. b is determined from the number of radial mesh points specified by NR.
NR | i | all | Y | Depends on other input | Number of radial mesh points
LMX | i | all | Y | | Basis l-cutoff inside the sphere. If not specified, it defaults to NL−1
RSMH | r | lmf, lmfgwd | Y | 0 | Smoothing radii defining basis, one radius for each l.<br>RSMH and EH together define the shape of basis function in lmf.<br>To optimize, try running lmf with \-\-optbas
EH | r | lmf, lmfgwd | Y | | Hankel energies for basis, one energy for each l. RSMH and EH together define the shape of basis function in lmf.
RSMH2 | r | lmf, lmfgwd | Y | 0 | Basis smoothing radii, second group
EH2 | r | lmf, lmfgwd | Y | | Basis Hankel function energies, second group
LMXA | i | FP | Y | NL - 1 | Angular momentum l-cutoff for projection of wave functions tails centered at other sites in this sphere.<br>Must be at least the basis l-cutoff (specified by LMX=).
IDXDN | i | ASA | Y | 1 | A set of integers, one for each l-channel marking which orbitals should be downfolded.<br>0 use automatic downfolding in this channel.<br>1 leaves the orbitals in the basis.<br>2 folds down about the inverse potential function at $$ E_ν $$ <br>3 folds down about the screening constant alpha.<br>In the FP case, 1 includes the orbital in the basis; >1 removes it
KMXA | i | lmf, lmfgwd | Y | 3 | Polynomial cutoff for projection of wave functions in sphere.<br>Smoothed Hankels are expanded in polynomials around other sites instead of Bessel functions as in the case of normal Hankels.
RSMA | r | lmf, lmfgwd | Y | R * 0.4 | Smoothing radius for projection of smoothed Hankel tails onto augmentation spheres. These functions are expanded in polynomials by integrating with Gaussians of radius RSMA at that site. RSMA very small reduces the polynomial expansion to a Taylor series expansion about the origin. For large KMXA the choice is irrelevant, but RSMA is best chosen that maximizes the convergence of smooth Hankel functions with KMXA.
LMXL | i | lmf, lmfgwd | Y | NL - 1 | Angular momentum l-cutoff for explicit representation of local charge on a radial mesh.
RSMG | r | lmf, lmfgwd | Y | R/4 | Smoothing radius for Gaussians added to sphere densities to correct multipole moments needed for electrostatics. Value should be as large as possible but small enough that the Gaussian doesn’t spill out significantly beyond rmt.
LFOCA | i | FP | Y | 1 | Prescribes how the core density is treated.<br>0 confines core to within RMT. Usually the least accurate.<br>1 treats the core as frozen but lets it spill into the interstitial<br>2 same as 1, but interstitial contribution to vxc treated perturbatively.
RFOCA | r | FP | Y | R &times; 0.4 | Smoothing radius fitting tails of core density. A large radius produces smoother interstitial charge, but less accurate fit.
RSMFA | r | FP | Y | R/2 | Smoothing radius for tails of free-atom charge density. <br>Irrelevant except first iteration only (non-self-consistent calculations using Harris functional).<br>A large radius produces smoother interstitial charge, but somewhat less accurate fit.
RS3 | r | FP | Y | 1 | Minimum allowed smoothing radius for local orbital
HCR | r | lm | Y | | Hard sphere radii for structure constants.<br>If token is not parsed, attempt to read HCR/R below
HCR/R | r | lm | Y | 0.7 | Hard sphere radii for structure constants, in units of R
ALPHA | r | ASA | Y | | Screening parameters for structure constants
DV | r | ASA | Y | 0 | Artificial constant potential shift added to spheres belonging to this species
MIX | 1 | ASA | Y | F | Set to suppress self-consistency of classes in this species
IDMOD | i | all | Y | 0 | 0 : floats log derivative parameter _P<sub>l</sub>_ aka [continuous principal quantum number](/docs/code/asaoverview/#logderpar) to band center of gravity<br>1 : freezes Pl<br>2 : freezes linearization energy $$ E_ν $$.
CSTRMX | 1 | all | Y | F | Set to T to exclude this species when automatically resizing sphere radii
GRP2 | i | ASA | Y | 0 | Species with a common nonzero value of GRP2 are symmetrized, independent of symmetry operations.<br>The sign of GRP2 is used as a switch, so species with negative GRP2 are symmetrized but with spins flipped (NSPIN=2)
FRZWF | 1 | FP | Y | F | Set to freeze augmentation wave functions for this species
IDU | i | all | Y | 0 0 0 0 | LDA+U mode:<br>0 No LDA+U<br>1 LDA+U with Around Mean Field limit double counting<br>2 LDA+U with Fully Localized Limit double counting<br>3 LDA+U with mixed double counting
UH | r | all | Y | 0 0 0 0 | Hubbard U for LDA+U
JH | r | all | Y | 0 0 0 0 | Exchange parameter J for LDA+U
EREF= | r | all | Y | 0 | Reference energy subtracted from total energy
AMASS= | r | FP | Y | | Nuclear mass in a.u. (for dynamics)
C-HOLE | c | lmf, lm | Y | | Channel for core hole. You can force partial core occupation.<br>Syntax consists of two characters, the principal quantum number and the second one of 's’,&thinsp;'p’,&thinsp;'d’,&thinsp;'f’ for the _l_ quantum number, e.g. '2s’<br>See Partially occupied core holes for description and examples.<br><br>Default: nothing
C-HQ | r[,r] | all | Y | -1 0 | First number specifies the number of electrons to remove from the _l_ channel specified by C-HOLE=.<br>Second (optional) number specifies the hole magnetic moment.<br>See Partially occupied core holes for description and examples.
P | r,r,... | all | Y | | Starting values for log derivative parameter _P<sub>l</sub>_, aka ["continuous principal quantum number"](/docs/code/asaoverview/#logderpar), one for each _l_=0..LMXA<br><br>Default: taken from an internal table.
PZ | r,r,... | FP | Y | 0 | starting values for local orbital’s potential functions, one for each of l=0..LMX. Setting PZ=0 for any l means that no local orbital is specified for this l. Each integer part of PZ must be either one less than P (semicore state) or one greater (high-lying state).
Q | r,r,... | all | Y | | Charges for each _l_-channel making up free-atom density<br><br>Default: taken from an internal table.
MMOM | r,r,... | all | Y | 0 | Magnetic moments for each _l_-channel making up free-atom density<br>Relevant only for the spin-polarized case.

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _STR_
Category STR contains information connected with real-space structure constants, used by the ASA programs. It is read by **lmstr**{: style="color: blue"}, **lmxbs**{: style="color: blue"}, **lmchk**{: style="color: blue"}, and **tbe**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('strtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="strtable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
RMAXS | r | all | Y | | Radial cutoff for strux, in a.u.<br>If token is not parsed, attempt to read RMAX, below
RMAX | r | all | Y | 0 | The maximum sphere radius (in units of the average WSR) over which neighbors will be included in the generation of structure constants. <br>This takes a default value and is not required input. It is an interesting exercise to see how much the structure constants and eigenvalues change when this radius is increased.
NEIGHB | i | FP | Y | 30 | Minimum number of neighbors in cluster
ENV\_MODE | i | all | Y | 0 | Type of envelope functions:<br>0 2nd generation<br>1 SSSW (3rd generation)<br>2 NMTO<br>3 SSSW and val-lap basis
ENV\_NEL | i | lm, lmstr | Y | | (NMTO only) Number of NMTO energies
ENV\_EL | r | lm, lmstr | N | 0 | SSSW of NMTO energies, in a.u.
DELRX | r | ASA | Y | 3 | Range of screened function beyond last site in cluster
TOLG | r | FP | Y | 1e-6 | Tolerance in _l_=0 gaussians, which determines their range
RVL/R | r | all | Y | 0.7 | Radial cutoff for val-lap basis (this is experimental)
VLFUN | i | all | Y | 0 | Functions for val-lap basis (this is experimental)<br>0 G0 + G1<br>1 G0 + Hsm<br>2 G0 + Hsm-dot
MXNBR | i | ASA | Y | 0 | Make lmstr allocate enough memory in dimensioning arrays for MXNBR neighbors in the neighbor table. This is rarely needed.
SHOW | 1 | lmstr | Y | F | Show strux after generating them
EQUIV | 1 | lmstr | Y | F | If true, try to find equivalent neighbor tables, to reduce the computational effort in generating strux.<br>Not generally recommended
LMAXW | i | lmstr | Y | -1 | <i>l</i>-cutoff for (optional) Watson sphere, used to help localize strux
DELRW | r | lmstr | Y | 0.1 | Range extending beyond cluster radius for Watson sphere
IINV\_NIT= | i | lmstr | Y | 0 | Number of iterations
IINV\_NCUT | i | lmstr | Y | 0 | Number of sites for inner block
IINV\_TOL | r | lmstr | Y | 0 | Tolerance in errors

*IINV parameters govern iterative solutions to screened strux

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _START_
Category START is specific to the ASA. It controls whether the code starts with moments P,Q or potential parameters; also the moments P,Q may be input in this category. It is read by **lm**{: style="color: blue"}, **lmgf**{: style="color: blue"}, **lmpg**{: style="color: blue"}, and **tbe**{: style="color: blue"}.

{::comment}
<div onclick="elm = document.getElementById('starttable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="starttable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
BEGMOM | i | ASA | Y | 1 | When true, causes program lm to begin with moments from which potential parameters are generated. If false, the potential parameters are used and the program proceeds directly to the band calculation.
FREE | 1 | ASA | Y | F | Is intended to facilitate a self-consistent free-atom calculation. When FREE is true, the program uses rmax=30 for the sphere radius rather than whatever rmax is passed to it; the boundary conditions at rmax are taken to be value=slope=0 (rmax=30 should be large enough that these boundary conditions are sufficiently close to that of a free atom.); subroutine atscpp does not calculate potential parameters or save anything to disk; and lm terminates after all the atoms have been calculated.
CNTROL | 1 | ASA | Y | F | 	When CONTRL=T, the parser attempts to read the “continuously variable principal quantum numbers” P and moments Q0,Q1,Q2 for each l channel; see P,Q below.
ATOM | c | ASA | Y | | Class label. P,Q (and possibly other data) is given by class.<br>Tokens following a class label and preceding the next class label belong to that class.
ATOM\_P= and ATOM\_Q | c | ASA | Y | | Read “continuously variable principal quantum numbers” for this class (P=...), or energy moments Q0,Q1,Q2 (Q=...). P consists of one number per l channel, Q of three numbers (Q0,Q1,Q2) for each l.<br><br>Note In spin<br> polarized calculations, a second set of parameters must follow the first, and the moments should all be half of what they are in non-spin polarized calculations.<br><br>In this sample input file for Si, P,Q is given as:<br>ATOM=SI  P=3.5 3.5 3.5    Q=1 0 0    2 0 0   0 0 0<br>ATOM=ES  P=1.5 2.5 3.5    Q=.5 0 0  .5 0 0   0 0 0<br><br>One electron is put in the Si s orbital, 2 in the p and none in the d, while 0.5 electrons are put in the s and p channels for the empty sphere. All first and second moments are zero. This rough guess produces a correspondingly rough potential.<br><br>You do not have to supply information here for every class; but for classes you do, you must supply all of (P,Q0,Q1,Q2). Data read in START supersedes whatever may have been read from disk.<br><br>Remarks below provide further information about how P,Q is read and printed.
RDVES | 1 | ASA | Y | F | Read Ves(RMT) from the START category along with P,Q
ATOM\_ENU | r | ASA | Y | | Linearization energies

How the parser reads P,Q:
Remember that knowledge of P,Q is sufficient to completely determine the ASA density.
Thus the ASA codes use several ways to read these important quantities.

The parser returns P,Q according the following priorities:

* P,Q are read from the disk, if supplied, (along possibly with other quantities such as potential parameters El, C, Δ, γ.) One file is created for each class that contains this data and other class-specific information. Some or all of the data may be missing from the disk files. Alternatively, you may read these data from a restart file rsta.ext, which if it exists contains data for all classes in one file. The program will not read this data by default; use \-\-rs=1 to have it read from the rsta file. To write class data to rsta, use \-\-rs=*,1 (* must be be 0 or 1)

* If START_CONTRL=T, P,Q (and possibly other quantities) are read from START for classes you supply (usually all classes). Data read from this category supersedes any that might have been read from disk. If class data read from either of these sources, the input system returns it. For classes where none is available the parser will pick a default:

  * If data from a different class but in the same species is available, use it.

  * Otherwise use some preset default values for P,Q.

After a calculation finishes you can run **lmctl**{: style="color: blue"} to read P,Q from disk and format it in a form ready to insert into the START category. Thus all the information needed to generate a self-consistent ASA calculation can be contained in the ctrl file.

When the sample Si test is run to self-consistency, invoking **lmctl**{: style="color: blue"} will generate something like:

~~~
ATOM=SI       P=  3.8303101  3.7074067  3.2545634
              Q=  1.1694276  0.0000000  0.0297168
                  1.8803181  0.0000000  0.0489234
                  0.1742629  0.0000000  0.0063520
ATOM=ES       P=  1.4162942  2.2521617  3.1546386
              Q=  0.2873686  0.0000000  0.0129888
                  0.3485430  0.0000000  0.0165416
                  0.1400664  0.0000000  0.0055459
~~~

Because the P‘s float to the band center-of gravity (i.e. center of gravity of the occupied states for a particular site and l channel) the corresponding first moments Q1 vanish. P‘s are floated by default since it minimizes the linearization error.

**Caution:**{: style="color: red"} Sometimes it is necessary to override this default: If the band CG (of the occupied states) is far removed from the natural CG of a particular channel, you must restrict how far P can be shifted to the band CG. In some cases, allowing P to float completely will result in “ghost bands”.

The high-lying Ga 4_d_ state is a classic example. To restrict P to a fixed value, see **SPEC_IDMOD**.

In such cases, you want to pick the fractional part of P to be small, but not so low as to cause problems (about 0.15).

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _STRUC_
{::comment}
(/docs/input/inputfile/#struc)
{:/comment}

{::comment}
<div onclick="elm = document.getElementById('structable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="structable">{:/}
{:/comment}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
FILE | c | all | Y | | Read structural data (ALAT, NBAS, PLAT) from an independent site file. The file structure is documented [here](/docs/input/sitefile); see also [this tutorial](/tutorial/lmf/lmf_tutorial)
NBAS | i | all | N&dagger; | | Size of the basis
NSPEC | i | all | Y | | Number of atom species
ALAT | r | all | N&dagger; | | A scaling, in atomic units, of the primitive lattice and basis vectors
DALAT | r | all | Y | 0 | is added to ALAT. It can be useful in contexts certain quantities that depend on ALAT are to be kept fixed (e.g. **SPEC\_ATOM\_R/A**) while ALAT varies.
PLAT | r,r,&hellip; | all | N&dagger; | | (dimensionless) primitive translation vectors
SLAT | r,r,&hellip; | lmscell | N | | Superlattice vectors
NL   | i | all | Y | 3 | Sets a global default value for _l_-cutoffs _l_<sub>cut</sub> = NL&minus;1. NL is used for both basis set and augmentation cutoffs.
SHEAR | r,r,r,r | all | Y | | Enables shearing of the lattice in a volume-conserving manner.<br>If SHEAR=#1,#2,#3,#4, &ensp;#1,#2,#3=direction vector; &ensp;#4=distortion amplitude.<br>Example:  SHEAR=0,0,1,0.01<br> distorts a lattice in initially cubic symmetry to tetragonal symmetry, with 0.01 shear.
ROT | c | all | Y | | Rotates the lattice and basis vectors, and the symmetry group operations by a unitary matrix.<br>Example:  ROT=z:pi/4,y:pi/3,z:pi/2 generates a rotation matrix corresponding to the Euler angles &alpha;=&pi;/4, &beta;=&pi;/3, &gamma;=&pi;/2. See [this document](/docs/misc/rotations/) for the general syntax.<br>Lattice and basis vectors, and point group operations (SYMGRP) are all rotated.
DEFGRD | r,r,&hellip; | all | Y | | A 3×3 matrix defining a general linear transformation of the lattice vectors.
STRAIN | r,r,&hellip; | all | Y | | A sequence of six numbers defining a general distortion of the lattice vectors
ALPHA  | r            | all | N | | Amount of Voigt strain

&dagger;Information may be obtained from a [site file](/docs/input/sitefile)

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _SYMGRP_

{::comment}
<div onclick="elm = document.getElementById('symtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show SYMGRP.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="symtable">{:/}
{:/comment}

Category SYMGRP provides symmetry information; it helps in two ways. First, it provides the relevant information to find which sites are equivalent, this makes for a simpler and more accurate band calculations. Secondly, it reduces the number of k-points needed in Brillouin zone integrations.

Normally you don't need SYMGRP; the program is capable of finding its own symmetry operations. However, there are cases where it is useful or even necessary to manually specify them. For example when including spin-orbit coupling or noncollinear magnetism where the symmetry group isn't only specified by the atomic positions. In this case you need to supply extra information.

You can use SYMGRP to explicitly declare a set of generators from which the entire group can be created. For example, the three operations R4X, MX and R3D are sufficient to generate all 48 elements of cubic symmetry.

Unless conditions are set for noncollinear magnetism and/or SO coupling, the inversion is assumed by default as a consequence of time-reversal symmetry.

A tag describing a generator for a point group operation has the form O(nx,ny,nz) where O is one of M, I or Rj, or E, for mirror, inversion j-fold rotation and identity operation, respectively. nx,ny,nz are a triplet of indices specifying the axis of rotation. You may use X, Y, Z or D as shorthand for (1,0,0), (0,1,0), (0,0,1), and (1,1,1) respectively. You may also enter products of rotations, such as I*R4X.

Thus

    SYMGRP  R4X MX R3D

specifies three generators (4-fold rotation around x, mirror in x, 3-fold rotation around (1,1,1)). Generating all possible combinations of these rotations will result in the 48 symmetry operations of the cube.

To suppress all symmetry operations, use

    SYMGRP E

Full-potential programs (e.g. **lmf**{: style="color: blue"}) do not make spherical approximations to the potential and require you to specify the full space group. The translation part is appended to the point group (rotation) in one of the following forms: ':(x1,x2,x3)' or alternatively '::(p1,p2,p3)' with the double '::'. The first defines the translation in Cartesian coordinates; the second as multiples of plat. These two lines (taken from testing/ctrl.cr3si6) are equivalent specifications:

    SYMGRP   r6z:(0,0,0.4778973) r2(1/2,sqrt(3)/2,0)
	SYMGRP   r6z::(0,0,1/3)      r2(1/2,sqrt(3)/2,0)

###### _Keywords in the SYMGRP category_
SYMGRP accepts, in addition to symmetry operations the following keywords:

* `find‘ tells the program to determine its own symmetry operations. Thus:

      SYMGRP find

  amounts to the same as not incuding a SYMGRP category in the input at all

  You can also specify a mix of generators you supply, and tell the program to find any others that might exist. For example:

      SYMGRP r4x find

  specifies that 4-fold rotation be included, and `find‘ tells the program to look for any additional symops that might exist.

* 'AFM':
  For certain antiferromagnets, certain translation operations exist provided the rotation/shift is accompanied by a spin flip. Say a translation of (-1/2,1/2,1/2)a restores the crystal structure, but all atoms after translation have opposite spin. Specify this symmetry with:

      SYMGRP   ...       AFM::-1/2,1/2,1/2

  This operation is used only by **lmf**{: style="color: blue"}.

* 'SOC' or 'SOC=2':
  Tells the symmetry group generator to exclude operations that do not preserve the z axis.
  This is used particularly for spin-orbit coupling where the crystal symmetry is reduced (z is the quantization axis).
  SOC=2 is like SOC but allows operations that preserve z or flip z to −z.
  This works in some cases.

  **Note:**{: style="color: red"} This keyword is only active when the two spin channels are linked, e.g. SO coupling or noncollinear magnetism.

* 'GRP2' turns on a switch that can force the density among inequivalent classes that share a common species to be averaged. In the ASA codes the density is spherical and the averaging is complete; in the FP case only the spherical part of the densities can be averaged. This helps sometimes with stabilizing difficult cases in the path to self-consistency.
  You specify which species are to be averaged with the SPEC_ATOM_GRP2 token.

  'GRP2‘ averages the input density;
  'GRP2=2‘ averages the output density;
  'GRP2=3‘ averages both the input and the output density.

* 'RHOPOS' turns on a switch that forces the density positive at all points

{::comment}
{::nomarkdown}</div>{:/}
{:/comment}

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _VERS_
This category is used for version control. As of version 7, the input file must have the following tokens for any program in the suite:

    VERS LM:7

It tells the input system that you have a v7 style input file.

For a particular program you need an additional token to tell the parser that this file is set up for that program.
Thus your VERS category should read:

~~~

VERS LM:7 ASA:7              for lm, lmgf or lmpg
VERS LM:7 FP:7               for lmf or lmfgwd
VERS LM:7 MOL:3              for a molecules codes such as lmmc
VERS LM:7 TB:9               for the empirical tight-binding tbe
                             and so on.

~~~

Add version control tokens for whatever programs your input file supports.

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

##### _ITER\_MIX_
{::comment}
(/docs/input/inputfile/#itermix)
{:/comment}

**_ITER\_MIX_** a token in the [**ITER**](/docs/input/inputfile/#iter) category.
Its contents are a string consisting of mixing options, described here.
This string controls the mixing scheme, mixing input density <i>n</i><sup>in</sup> with output density <i>n</i><sup>out</sup> to make a
trial density <i>n</i><sup>\*</sup> for a new iteration.


###### Charge mixing, general considerations
{::comment}
(/docs/input/inputfile/#charge-mixing-general-considerations)
{:/comment}

In a perfect mixing scheme, <i>n</i><sup>\*</sup> would be the self-consistent
density.  If the static dielectric response is known, <i>n</i><sup>\*</sup> can be estimated to linear order in
<i>n</i><sup>out</sup>&minus;<i>n</i><sup>in</sup>.  It is not difficult to show that
<div style="text-align:center;">
<i>n</i><sup>*</sup> = <i>&epsilon;</i><sup>&minus;1</sup> (<i>n</i><sup>out</sup>&minus;<i>n</i><sup>in</sup>). &emsp;&emsp;&emsp;  (1)
</div>

<i>&epsilon;</i> is a function of source and field point coordinates <b>r</b> and <b>r</b>&prime;:
<i>&epsilon;</i> = <i>&epsilon;</i>(<b>r</b>,<b>r</b>&prime;) and in any case
it is not given by the standard self-consistency procedure.
The Thomas Fermi approximation provides a reasonable, if rough estimate for <i>&epsilon;</i>, which
which reads in reciprocal space

$$ \epsilon^{-1}(q) = \frac{q^2}{q^2 + k_{TF}^2} \quad\quad (2) $$

Eq.(2) has one free parameter, the Thomas Fermi wave number <i>k</i><sub><i>TF</i></sub>.
It can be estimated given the total number of electrons **qval** from the free electron gas formula.
<div style="text-align:center;">
<i>k</i><sub><i>F</i></sub> = (3<i>&pi;</i><sup>3</sup>/vol&times;<b>qval</b>)<sup>1/3</sup>
</div>

If the density were expanded in plane waves <i>n</i> = &Sigma;<sub><b>G</b></sub>&thinsp;<i>C</i><sub><b>G</b></sub>&thinsp;<i>n</i><sub><b>G</b></sub>,
a simple mixing scheme would be to mix each <i>C</i><sub><b>G</b></sub> separately according to Eq.(2).
This is called the "Kerker mixing" algorithm.  The Questaal codes do not have a plane wave representation so they do something else.

The ASA uses a simplified mixing scheme since the [logarithmic derivative parameters](/docs/code/asaoverview/#logderpar) <i>P</i>
and [energy moments of charge](/docs/code/asaoverview/#generation-of-the-sphere-potential-and-energy-moments-q) <i>Q</i> for each class
is sufficient to completely specify the charge density.  The density is not explicitly mixed.

**lmf**{: style="color: blue"}, by contrast, uses a density consisting of [three
parts](/docs/code/fpoverview/#augmentation-and-representation-of-the-charge-density): a smooth density <i>n</i><sub>0</sub> carried on a
uniform mesh, defined everywhere in space and two local densities: the true density <i>n</i><sub>1</sub> and a one-center expansion
<i>n</i><sub>2</sub> of the smooth density The mixing algorithm must mix all of them and it is somewhat involved.
See **fp/mixrho.f**{: style="color: green"} for details.

The mixing process reduces to estimating a vector <b>X</b><sup>*</sup>
related to the density (e.g. &thinsp;**P,Q**&thinsp; in the ASA)
where &delta;<b>X</b> = <b>X</b><sup>out</sup> &minus; <b>X</b><sup>in</sup>
vanishes at <b>X</b><sup>in</sup> = <b>X</b><sup>*</sup>.

Mixing algorithms mix linear combinations of
(<b>X</b><sup>in</sup>,<b>X</b><sup>out</sup>) pairs taken from the current iteration together with pairs from prior iterations.
If there are no prior iterations, then
<div style="text-align:center;">
  <b>X</b><sup>*</sup> = <b>X</b><sup>in</sup> + <b>beta</b> &times; (<b>X</b><sup>out</sup> &minus; <b>X</b><sup>in</sup>) &emsp;&emsp;&emsp;  (3)
</div>

It is evident from Eq.(1) that **beta** should be connected with the dielectric function.  However, **beta** is just a number.  If
**beta**=1, <b>X</b><sup>*</sup> = <b>X</b><sup>out</sup>; if **beta**&rarr;0, <b>X</b><sup>*</sup> scarcely changes from
<b>X</b><sup>in</sup>.  Thus in that case you move like an "amoeba" downhill towards the self-consistent solution.
For small systems it is usually sufficient to take **beta** on the order of, but smaller than unity.  For large
systems charge sloshing becomes a problem so you have to do something different.  This is because the potential change goes as
<i>&delta;V</i> ~ <i>G</i><sup>&minus;2</sup>&times;<i>&delta;n</i> so small _G_ components of <i>&delta;n</i> determine the rate of mixing.
The simplest (but inefficient) choice is to make **beta** small.

The beauty of the Kerker mixing scheme is that charges in small _G_ components of the density
get damped out, while the short-ranged, large _G_ components do not.
An alternative is to use an estimate <span style="text-decoration: overline">&epsilon;</span> for the dielectric function.
Construct <span style="text-decoration: overline"><i>&delta;n</i></span> =
<span style="text-decoration: overline">&epsilon;</span><sup>&minus;1</sup>&thinsp;(<i>n</i><sup>out</sup>&minus;<i>n</i><sup>in</sup>)
and build <span style="text-decoration: overline"><i>&delta;</i>X</span> from
<span style="text-decoration: overline"><i>&delta;n</i></span>.
Then estimate
<div style="text-align:center;">
  <b>X</b><sup>*</sup> = <b>X</b><sup>in</sup> + <b>beta</b> &times; <span style="text-decoration: overline"><i>&delta;</i>X</span>
</div>
Now **beta** can be much larger again, of order unity.

**lmf**{: style="color: blue"} uses a Lindhard function for the mesh density (similar to Thomas Fermi screening; only the Lindhard function
is the actual dielectric function for the free electron gas) and attempts to compensate for the contribution from local densities in an
approximate way.  The ASA codes offer two options:

1. A rough <span style="text-decoration: overline">&epsilon;</span> is obtained from eigenvalues of the Madelung matrix ([OPTIONS\_SCR](/docs/input/inputfile/#options)=4).
2. The q=0 discretized polarization at _q_=0 is explicitly calculated (see [OPTIONS\_SCR](/docs/input/inputfile/#options)).

There is some overhead associated with the second option, but it is not too large and having it greatly facilitates convergence in large systems.
This is particularly important in magnetic metals, where there are low-energy degrees of freedom associated with the magnetic parts that
require large **beta**.

###### The _ITER\_MIX_ tag and how to use it
{::comment}
(/docs/input/inputfile/#the-itermix-tag-and-how-to-use-it)
{:/comment}

Mixing proceeds through (<b>X</b><sup>in</sup>,<b>X</b><sup>out</sup>) pairs taken from the current iteration together with pairs from prior iterations.
As noted in the previous section it is generally better to mix <span style="text-decoration: overline"><i>&delta;</i>X</span>
than <i>&delta;</i>X; but the mixing scheme works for either.

You can choose between Broyden and Anderson methods.  The string belonging to **_ITER\_MIX_** should begin with one of
<pre>
  MIX=A<i>n</i>
  MIX=B<i>n</i>
</pre>
which tells the mixer which scheme to use.  **slatsm/amix.f**{: style="color: green"} describes the mathematics behind the Anderson scheme.

**_n_** is the maximum number of prior iterations to include in the mix.  As programs proceed to self-consistency, they dump prior
iterations to disk, to read them the next time through.  Data is I/O to _mixm.ext_{: style="color: green"}.

The Anderson scheme is particularly simple to monitor.  How much of <span style="text-decoration: overline"><i>&delta;</i>X</span>
from prior iterations is included in the final mixed vector is printed to **stdout** as parameter **tj**, e.g.
<pre>
   tj: 0.47741                           &larr; iteration 2
   tj:-0.39609  -0.44764                 &larr; iteration 3
   tj:-0.05454   0.01980                 &larr; iteration 4
   tj: 0.24975
   tj: 0.48650
   tj:-1.34689
</pre>
In the second iteration, one prior iteration was mixed; in the third and fourth, two; and after that, only one.
(When the normal matrix picks up a small eigenvalue the Anderson mixing algorithm reduces the number of prior iterations).

Consider the case when a single prior iteration was mixed.

+ If **tj**=0, the new **X** is entirely composed of the current
iteration.  This means self-consistency is proceeding in an optimal manner.
+ If **tj**=1, it means that the new **X** is composed 100% of the prior iteration.
  This means that the algorithm doesn't like how the mixing is proceeding, and is discarding the current iteration.
  If you see successive iterations where **tj** is close to (or
  worse, larger than) unity, you should change something, e.g. reduce **beta**.
+ If **tj**<0, the algorithm thinks you can mix more of <b>X</b><sup>out</sup> and less of <b>X</b><sup>in</sup>.
  If you see successive iterations where **tj** is significantly negative (less than &minus;1), increase **beta**.

Broyden mixing uses a more sophisticated procedure, in which it
tries to build up the Hessian matrix.  It usually works better
but has more pitfalls than Anderson. Broyden has an additional parameter, **wc**, that
controls how much weight is given to prior iterations in the mix
(see below).

The general syntax is for **_ITER\_MIX_** is
<pre>
A<i>n</i>[,b=<i>beta</i>][,b2=b2][,bv=betv][,n=<i>nit</i>][,w=w1,w2][,nam=<i>fn</i>][,k=<i>nkill</i>][,elind=#][;...]  or
B<i>n</i>[,b=<i>beta</i>][,b2=b2][,bv=betv][,wc=<i>wc</i>][,n=<i>nit</i>][,w=w1,w2][,nam=<i>fn</i>][,elind=#][,k=<i>nkill</i>]
</pre>
The options are described below.  They are parsed in routine **subs/parmxp.f**{: style="color: green"}.  Parameters (**b**, **wc**, etc.) may occur in any order.:

+ **A<i>n</i>** or **B<i>n</i>**:&ensp; maximum number of prior iterations to include in the mix (the mixing file may contain more than _n_ prior iterations).\\
  **_n_**=0 implies linear mixing.

+ **b=_beta_**:&ensp; the mixing parameter **beta** in Eq. 3 above.

+ **n=_nit_**:&ensp; the number of iterations to use mix with this set of parameters before passing on to the next set. After the last set is exhausted,
  it starts over with the first set.

+ **name=_fn_**:&ensp; mixing file name (_mixm_{: style="color: green"} is the default). Must be eight characters or fewer.

+ **k=_nkill_**:&ensp; kill mixing file after **_nkill_** iterations.  This is helpful when the mixing runs out of steam, or when the mixing parameters change.

+ **wc=_wc_**:&ensp; (Broyden only) that controls how much weight is given to prior iterations in estimating the Jacobian.  **wc=1** is fairly conservative.
  Choosing **wc<0** assigns a floating value to the actual **wc**, proportional to **&minus;_wc_/rms-error**.  This increases **wc** as the error becomes small.

+ **w1,w2**:&ensp; (spin-polarized calculations only) The up- and down- spin channels are not mixed independently.
  Instead the sum (up+down) and difference (up-down) are mixed.  The two combinations are
  weighted by **w1** and **w2** in the mixing, more heavily emphasizing the more heavily weighted.
   As special cases, **w1=0** _freezes_ the charge and mixes the magnetic moments only while **w2=0** _freezes_ the moments and mixes the charge only.

+ **elind=_elind_**:&ensp; The Fermi energy entering into the Lindhard dielectric function: **elind**=k</i><sub><i>F</i></sub><sup>2</sup>.\\
  **elind<0**: Use the free-electron gas value, scaled by **&minus;_elind_**.

+ **wa**:&ensp; (ASA only) weight for extra quantities included with **P,Q** in the mixing procedure.  For noncollinear magnetism, includes the Euler angles.

+ **locm**:&ensp; (FP only) not documented yet.

+ **r=_expr_**:&ensp; continue this block of mixing sequence until **rms error < _expr_.

You can string together several rules.  One set of rules applies for a certain number of iterations; followed by another set.\\
Rules are separated by a "&thinsp;;&thinsp;".

  Example: &emsp;**MIX=B10,n=8,w=2,1,fn=mxm,wc=11,k=4;A2,b=1**\\
  does 8 iterations of Broyden mixing, followed by Anderson mixing.  The
  Broyden iterations weight the (up+down) double that of (up-down) for the magnetic case, and iterations are saved in a file which is
  deleted at the end of every fourth iteration.  **wc** is 11.  **beta** assumes the default value.  The Anderson rules mix two prior iterations
  with **beta**=1.

See [Table of Contents](/docs/input/inputfile/#table-of-contents)

[//]: test

