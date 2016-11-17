---
layout: page-fullwidth
title: "Questaal Data Formats"
permalink: "/docs/input/data_format/"
header: no
---

#### _Purpose_
{:.no_toc}

To explain the structure of data files in the Questaal suite.

#### _Table of Contents_
_____________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}  
{::comment}
(/docs/input/preprocessor/#table-of-contents)
{:/comment}

#### Introduction

Questaal codes require a wide variety of data formats to meet the diverse range of purposes they serve.  When files are not too large they
are usually written in ASCII format.  In many cases, such files are passed through the [file preprocessor](/docs/input/preprocessor) before
being scanned for data.  The preprocessor's facilities (e.g. to evaluate expressions and to make looping constructs) can be useful in many
contexts.

The preprocessor can [modify the input](/docs/input/preprocessor/#main-features) before it is parsed for data.  Note also:

* Lines which begin with '**#**' are comment lines and are ignored. (More generally, text following a `**#**' in any line is ignored).
* Lines beginning with '**%**' are directives to the [preprocessor](/docs/input/preprocessor/).

#### Standard data formats for 2D arrays
{::comment}
(/docs/input/data_format/#standard-data-formats-for-2d-arrays)
{:/comment}

Many Questaal programs, for example the [**fplot**{: style="color: blue"}](/docs/misc/fplot/) utility and electronic structure programs such
as **lm**{: style="color: blue"}, read files containing 2D arrays.  Most of the time they follow a standard format described in this section.

Where possible, the 2D array reader uses **rdm.f**{: style="color: green"}, so that the files are read in a uniform style.  Unless told
otherwise, the reader treats data as algebraic expressions.  Thus you can use expressions in these files, in addition to expressions
in [curly brackets](/docs/input/preprocessor/#curly-brackets-contain-expressions) **{&hellip;}** managed by the preprocessor.

The array reader must be given information about the number of rows and columns in the file.  (They are called **nr** and **nc** here.)

The safest way to specify **nr** and **nc** is to indicate the number of rows and columns in the first line of the file, as illustrated in
the code snippet below (this is the beginning of _chgd.cr_{: style="color: green"} used in an [**fplot**{: style="color: blue"}
exercise](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr)).
**nr** and/or **nc** (the number of rows and columns) can be stipulated in the file as shown in the first line of _chgd.cr_{: style="color: green"}:

~~~~
% rows 101 cols 101
      0.0570627197      0.0576345670      0.0595726102      0.0628546738
...
~~~

_Note:_{: style="color: red"} `% rows...` is not a preprocessor instruction because **rows** is not a
directive the [preprocessor recognizes](/docs/input/preprocessor/#preprocessor-directives).

The reader attempts to work out **nr** and **nc** in the following sequence:

+ The reader  checks to see whether the first nonblank, non-preprocessor directive, begins with `% ... rows nr` or `% ... cols nc`.\\
  If either or both are supplied to set **nr** and/or columns to **nc** are set accordingly.
  + In some cases **nr** or **nc** is known in advance, for example a file containing site positions has **nc=3**.
    In such case the reader is told of the dimension in advance; if redundant information is given the reader checks that the two are consistent.\\
    If they are not, usually the program aborts with an error message.
+ If **nc** has not been stipulated, the parser will count the number of elements in the first line containing data elements, and assign **nc** to it.\\
  For the particular file _chgd.cr_{: style="color: green"}, the reader would incorrectly infer **nc**=4: so **nc** must be stipulated in this case.
+ If **nr** has not been stipulated in some manner, the reader works out a sensible guess from the file contents.\\
  If it knows **nc**, the reader can count the total number of values (or expressions more generally) in the file and deduce **nr** from it.\\
  If the number of rows it deduces is not an integer, a warning is given.

##### _Complex arrays_

If the array contains complex numbers, the first line should contain **complex**, e.g.

~~~
% ... complex
~~~

The entire real part of the array must occur first, followed by the imginary part.

#### Site files
[//]: (/docs/input/data_format/#site-files)

Site files can assume a variety of formats.
Their structure is documented [here](/docs/input/sitefile/).

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### File formats for k-point lists
[//]: (/docs/input/data_format/#file-formats-for-k-point-lists)

<i>k</i>-points and which energy bands or quasiparticles are to be generated
are specified in one of three types, or modes.

+ (default) [symmetry line mode](symmetry-line-mode)
is designed for plotting energy bands along symmetry lines.  In this
case <i>k</i>-points are specifed by a sequences of lines with start
and end points.  The output is a bands file in a specially adapted format.

+ [List mode](#list-mode) is a general purpose mode
to be used when energy levels are sought at some arbitrary set of
<i>k</i>-points, specified by the user.  Data is written in a standard
format with k-points followed by eigenvalues.

+ [Mesh mode](#mesh-mode) is a mode that
generates states on a uniform mesh of <i>k</i>-points in a plane.  Its
purpose is to generate contour plots of constant energy surfaces,
e.g. the Fermi surface. Data file output is written in a special mode, with 
levels for a particular band at all <i>k</i> written as a group.

##### Symmetry line mode
[//]: (/docs/input/data_format/#symmetry-line-mode)

This is the default mode.  The <i>k</i>-points file consists of a list
of symmetry lines and the number of <i>k</i>-points in each line.
Each line of text in the file specifies one symmetry line with the syntax

<pre>
#pts  start-k   end-k
</pre>

**start-k** and **end-k** each consist of three numbers specifying a <i>k</i>-point.
You can terminate the list with a line beginning with **0**.
For example:

<pre>
51   0  0  0    0  0  1
51   0  0  1    0 .5 .5
0    0  0  0    0  0  0
</pre>

{::nomarkdown} <a name="symmetry-line-output"></a> {:/}

<i>Output, symmetry-line mode</i> <BR>

Bands are written to file _bnds.ext_{: style="color: green"} in a
format specially tailored to symmetry lines.

The file begins with
<pre>
 36  -0.02136     2  col= 5:9,14:18  col2= 23:27,32:36
   41                                           &larr; number of points on this line
   0.50000   0.50000   0.50000                  &larr; first k point&thinsp; &darr; energy levels
 -4.3011 -4.2872 -4.2872 -0.6225 -0.4363 -0.4363 -0.2342 -0.2342 -0.1355  0.1484
  0.9784  1.2027  1.2027  1.7702  1.7702  1.8940  2.3390  2.3390  2.4298  2.9775
  2.9775  3.0605  3.1020  3.1020  3.6589  3.7134  4.1113  4.1494  4.1494  4.6987
  5.3267  5.3267  5.6162  5.6162  5.9457  6.4435  6.4435  8.6484  8.6484 10.1458
</pre>
The header line consists of the (maximum) number of bands (**36**);
the Fermi level (**-0.02136**); and the number of color weights (**2**).
The remainder of the line is for informational purposes only and is not needed.

Next follow data for each symmetry line, one line after the other.
The data structure for a single symmetry line has this form:

+  A line with specifying the number of points for the current symmetry line.
   Next follow for each point <i>i</i>:
   1. a line containing <i>k<sub>i</sub></i> (3 numbers).
   2. one or more lines with the energy levels for <i>k<sub>i</sub></i>
   3. If color weights are present, information about color weights, consisting of
      + a line containing <i>k<sub>i</sub></i> (3 numbers) (should be the same as (1))
      + one or more lines with the color weights (should have the same format as (2)
   4. If a second set of color weights is present, there are lines similar to (3).
   5. If in a spin-polarized calculation with both spins present, the same information (1-4)
      is written for the second spin.
^

<i>Making figures, symmetry-line mode</i> <BR>

Use [**plbnds**{: style="color: blue"}](/docs/misc/plbnds/) to read this file format.  It can generate directly a (not very pretty)
[picture](/docs/misc/plbnds/#example-1) rendered in postscript.  Better, **plbnds**{: style="color: blue"} can generate data files and a
[script](/docs/misc/fplot/#example-22-nbsp-reading-fplot-commands-from-a-script-file) for the Questaal graphics tool [**fplot**{:
style="color: blue"}](/docs/misc/fplot/).  **plbnds**{: style="color: blue"} generates energy bands in a simple to read, [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays). You can use **fplot**{: style="color: blue"} or your favorite
graphics package.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

##### List mode
[//]: (/docs/input/data_format/#list-mode)

This mode is specifed by, e.g. command line argument [**-\-band~qp**](/docs/input/commandline/#band).
Use this mode to generate energy levels for a discrete list of
<i>k</i>-points.  The <i>k</i>-points file consists of a list of points in [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays), e.g.

<pre>
-.01  0  0
  0   0  0
 .01  0  0
</pre>

This file must have 3 columns, corresponding to the <i>x,y,z</i>, components of <b>k</b>.  Unless you specify otherwise the number of rows
in the array are the number of <i>k</i> points.

<i>Alternative file format</i> <BR>

There is an alternative format available for this mode: it is the
format automatically generated if &thinsp;**BZ_PUTQP**&thinsp; is set or if the command-line switch &thinsp;**--putqp**&thinsp; is prsent.

<div onclick="elm = document.getElementById('putqp'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description of this format.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="putqp">{:/}

When this switch is set, <b>lm</b> (or similar programs that do numerical
integrations over the Brillouin zone) will save information about the
<i>k</i>-points it uses for integration to file _qpts.ext_{: style="color: green"}.
List mode can read this format;
there is some flexibility in the format also.  As a minimum the first
line should consist of <FONT size="+1"><tt>nkp=#</tt></FONT>, which
specifies the number of
<i>k</i>-points in the file.  Then follows a list of <i>k</i>-points,
e.g.

<pre>
 nkp=2  
  1  0.100000000000D+00  0.000000000000D+00  0.000000000000D+00
  2 -2.600000000000D-01  2.500000000000D-01  2.500000000000D-01
</pre>

{::nomarkdown}</div>{:/}

The <i>k</i>-points file reader will automatically distinguish between these formats.

<i>Output, list mode</i>

Bands are written in [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays), used, e.g.  by the matrix
calculator **mc**{: style="color: blue"}.  The first three columns are the <i>k</i> point; the remaining columns are the bands.  If color
weights are specified, an additional group of columns are appended.

<i>Plotting, list mode</i>

Because the <i>k</i>-points need not follow any particular pattern, there is no generic plotting scheme.  As noted, the file
is in [standard Questaal format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) which
can be easily read by programs such as MATLAB.

<i>Additional options, list mode</i>

The list mode has additional sub-options, that make it convenient to
collate distinct groups of <i>k</i>-points into a single list.
Switch
<pre>
--band~qp~...
</pre>
may be extended with any of these switches:
<pre>
--band~qp[,inc=<i>expr</i>][,merge=fnam][,save=fnam]~...
</pre>

+ [,inc=expr] causes the list reader to
  parse each <i>k</i>-point, and exclude those for which <i>expr</i> is zero.
  <i>expr</i> is an ASCII string containing an [algebraic expression](/docs/input/preprocessor/#expr-syntax).
  <i>expr</i> can (and is expected to) contain <i>k</i>-point specific variables, which include:
  <pre>
  iq   <i>k</i>-point index
  qx   <i>k<sub>x</sub></i>
  qy   <i>k<sub>y</sub></i>
  qz   <i>k<sub>z</sub></i>
  q    |<b>k</b>|=[<i>k<sub>x</sub></i><sup>2</sup>+<i>k<sub>y</sub></i><sup>2</sup>+<i>k<sub>z</sub></i><sup>2</sup>]<sup>1/2</sup>
  </pre>
  The expression should be integer (returning 0 or nonzero). 
  Example: **--band~qp,inc=q<1/2**\\
  In this case only <i>k</i>-points read from the file whose magnitude is less than 0.5 will be retained.

+ [,merge=_fnam_] causes the list reader
  to read a <i>second</i> file _fnam.ext_{: style="color: green"} (in [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays) and append the list read from it to the original list.

+ [,save=_fnam_] causes the list reader to
  write the final <i>k</i>-points list to _fnam.ext_{: style="color: green"}. After writing this file the program automatically stops.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

##### Mesh mode

In this mode <i>k</i>-points are generated on a uniform 2D mesh,
useful for [contour plots](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr).  Invoke with
<pre>
  --band~con~...
</pre>

The mesh is specified by a file containing lines of the form
<pre>
<i>v<sub>x</sub>     range  n<sub>x</sub>     v<sub>y</sub>     range  n<sub>y</sub>   height  band</i>
</pre>      
where:

+  **<i>v<sub>x</sub></i>** and **<i>v<sub>y</sub></i>** are two reciprocal lattice vectors defining a plane
+  **<i>range</i>** is a pair of numbers marking starting and ending points along each vector
+  **<i>n<sub>x</sub></i>** and **<i>n<sub>y</sub></i>** are the number of divisions along the first and second vectors
+  **<i>height</i>** specifies the offset normal to the plane
+  **<i>band</i>** specifies which band is to be saved. 

Example:
<pre>
 1 0 0   -1 1   51   0 1 0   -1 1   51   0.00    4,5
</pre>

<i>Output, mesh mode</i> <BR>

Bands are written in [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays)
used by matrix calculator **mc**{: style="color: blue"} and the graphics package **fplot**{: style="color: blue"}.
The number of rows is the number of divisions in the first vector; the
number of columns is the number of divisions in the second vector.  No
<i>k</i> point information is written (it is implicit in the uniform
mesh).

<i>Plotting, mesh mode</i> <BR>

See [this example](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr).

##### Transformation of the supplied _k_-points

The <i>k</i>-points as supplied from the input file can be transformed.

This is useful in several contexts.  If spin-orbit coupling is present
on the bands depend on the relative orientation of the coordinate
system and spin quantization axis (the <i>z</i> axis by default).

In an angle-resolved photoemission experiment, <b>k</b> normal to the
surface (<i>k</i><sub>&perp;</sub>) is modified on exiting the
surface, whereas <b>k</b><sub>&#8741;</sub> is conserved.  This means that
<b>k</b> measured by ARPES slightly different from <b>k</b> calculated
from the band structure.  The larger the kinetic energy the smaller
the effect, but in typical photoemission experiments it is not negligible.

<div onclick="elm = document.getElementById('transformk'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="transformk">{:/}

There are two ways to transform the <b>k</b> point.  The first is to use
the **~rot** options to the [**\-\-band** switch](/docs/input/commandline/#switches-for-lmf).
The second expressions which you specify in the
first line of the <i>k</i>-points input file.  This line consists of a sequence of algebraic expressions,
which generate one or more of <i>k</i><sub><i>x</i></sub>, <i>k</i><sub><i>y</i></sub>, or 
<i>k</i><sub><i>z</i></sub>, which modifies one of more of the Cartesian components of <b>k</b>.

To modify <i>k</i><sub><i>x</i></sub>, <i>k</i><sub><i>y</i></sub>, or <i>k</i><sub><i>z</i></sub>
insert a line at the beginning of the file.
The first character must be a **'%'**, followed by one or more strings with algebraic expressions defining the <i>x</i>-, 
<i>y</i>, and <i>z</i> components of the modified <b>q</b>:
<pre>
% [var=<i>expr</i> var=<i>expr</i> ...]   kx=<i>expr</i>  ky=<i>expr</i>  kz=<i>expr</i>
</pre>

**kx**, **ky**, **kz** are the Cartesian coordinates of the modified <i>k</i>-point.  _expr_
are algebraic expressions involving these variables:
<pre>
  qx   <i>k<sub>x</sub></i>
  qy   <i>k<sub>y</sub></i>
  qz   <i>k<sub>z</sub></i>
  q    |<b>k</b>|=[<i>k<sub>x</sub></i><sup>2</sup>+<i>k<sub>y</sub></i><sup>2</sup>+<i>k<sub>z</sub></i><sup>2</sup>]<sup>1/2</sup>
</pre>

The expression should be integer (returning 0 or nonzero). 
Example: let **qx**, **qy**, **qz**, **q** be the Cartesian components and absolute value of the unmodified <i>k</i>-point.
Any of the &thinsp; **kx=**<i>expr</i> &nbsp; **ky=**<i>expr</i> &nbsp; **kz=**<i>expr</i>&thinsp;
may be present; any missing component will be left unchanged from its original value.

This example (in symmetry line mode) modifies <i>k<sub>x</sub></i> such that the kinetic energy is increased by 0.1<sup>2</sup> a.u.
<pre>
% map kx=(q^2+.1^2-qy^2-qz^2)^.5
41  .5 .5 .5     0  0 0                L to Gamma
...
</pre>

You should verify that code reading the k-points modified the q points by inspecting the output.
It should contain the following lines:

<pre>
 suqlst: map qp using the following:
 kx=(q^2+.1^2-qy^2-qz^2)^.5
</pre>

The <b>~rot</b> option may be used in conjuction with the modification through alegbraic expresssions.  For example suppose you want to modify
<i>k</i><sub>&perp;</sub> normal to the (1,-1,0) direction, while preserving <b>k</b><sub>&#8741;</sub> in the (1,1,0),(0,0,1) plane.

Take Cu as a concrete example.  If &thinsp;**lm**&thinsp; is your top-level directory, set up the calculation for Cu with
<pre>
~/lm/fp/test/test.fp cu 1
</pre>
This should set up a self-consistent potential for Cu and save generate energy bands in file
_bnds.cu-pwmode11_{: style="color: green"}.

The input file as constructed uses the normal Cartesian coordinates for a cube.  But if
you invoke **lmf**{: style="color: blue"} with **-vrot=t**, viz
<pre>
lmf -vrot=t cu --showp 
</pre>
you will see that tag &thinsp;**STRUC\_ROT=z:pi/4**&thinsp; appears in the preprocessed input file.
This tells **lmf**{: style="color: blue"} to rotate the crystal axes, the basis vectors, and the symmetry group operations.
This rotates (1/2,1/2,0) to the -z axis.  Do the following:
<pre>
$ lmf -vrot=t cu --quit=ham
</pre>
and you should see:
<pre>
           Lattice vectors:                         Transformed to:
   0.0000000   0.5000000   0.5000000     0.1035534   0.6035534  -0.3535534
   0.5000000   0.0000000   0.5000000     0.6035534   0.1035534  -0.3535534
   0.5000000   0.5000000   0.0000000     0.0000000   0.0000000  -0.7071068
</pre>

Run the band calculation exactly as was done in the test case, but modify it as follows.
Replace the original
<pre>
$ lmf  --no-iactiv cu -vnk=8 -vbigbas=t -vpwmode=11 -voveps=0d-7 --band:fn=syml
</pre>
with:
<pre>
$  lmf  --no-iactiv cu -vnk=8 -vbigbas=t -vpwmode=11 -voveps=0d-7 -vrot=t --rs=101 '--band~rot=(1,-1,0)pi/2~fn=syml'
</pre>
+ **--rs=101** tells the charge density reader to rotate the local densites (the density was generated in the unrotated coordinate system).
+ **--band~rot=** is necessary because **lmf**{: style="color: blue"} will not automatically rotate
the k-points read from the _syml.ext_{: style="color: green"}.

Run a modifed band pass calculation and compare
_bnds.cu_{: style="color: green"} with
_bnds.cu-pwmode11_{: style="color: green"}.
You should see that the <i>k</i>-points are different, but that the
bands are essentially identical.  (There are slight differences
relating to the numerical instabilities in the overlap originating from the
addition of APW's.)

This shows that the bands are replicated in the rotated coordinate system.

Finally, modify _syml.cu_{: style="color: green"} by uncommenting the first line so it reads:
<pre>
% map kz=(q^2+.01^2-qx^2-qy^2)^.5*(qz>0?1:-1)
</pre>
and repeat the **lmf**{: style="color: blue"} band pass.  You should see that <i>k<sub>x</sub></i> and
<i>k<sub>y</sub></i> are unchanged, but <i>k<sub>z</sub></i> is slightly modified.
Similarly the bands are slightly modified.

{::nomarkdown}</div>{:/}

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### The basp file
[//]: (/docs/input/data_format/#the-basp-file)

File _basp.ext_{: style="color: green"} contains information about the **lmf**{: style="color: blue"} basis set.
In the [Bi<sub>2</sub>Te<sub>3</sub> tutorial](tutorial/lmf/lmf_bi2te3_tutorial/#making-the-atomic-density) it reads:

~~~
BASIS:
Te RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
Bi RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 5.089 PZ= 0 0 15.936
~~~

The file consists of one line for each species (it is not an error if a species is missing).
The line begins with the species name, optionally followed by 

+ envelope shape parameters **RSMH=&hellip;** and **EH=&hellip;** and possibly **RSMH2=&hellip;** and **EH2=&hellip;**
+ augmentation sphere boundary conditions **P=&hellip;**
+ Local orbital information **PZ=&hellip;**.

I/O is performed by routine iobzwt in **subs/ioorbp.f**{: style="color: green"}.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### The wkp file
[//]: (/docs/input/data_format/#the-wkp-file)

_wkp.ext_{: style="color: green"} keeps Fermi level **efermi** and band weights **wtkb(nevx,nsp,nq)** for Brillouin zone integration.

This binary file consists of a header in a single record,  followed by second record containing **wtkb(nevx,nsp,nq)**.\\
The header contains a dimensioning parameter, number of spins and irreducible _k_ points in the Brillouin zone:\\
**&emsp; nevx&thinsp; nq&thinsp; nsp&thinsp; efermi**

I/O is performed by routine iobzwt in **subs/suzbi.f**{: style="color: green"}.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### The save file
[//]: (/docs/input/data_format/#the-save-file)

_save.ext_{: style="color: green"} keeps a log of summary information for each iteration in iterations to self-consistency.

Each line records data for one iteration, including algebraic variables declared on the command line,
followed by variables kept in the ctrl file by the [**% save**](/docs/input/preprocessor/#other-directives) directive,
system magnetic moment (in magnetic systems) and total energy.

Example from the [basis set tutorial](/tutorial/lmf/lmf_bi2te3_tutorial):

~~~
h gmax=4.4 nkabc=3 ehf=-126808.3137885 ehk=-126808.2492178
i gmax=4.4 nkabc=3 ehf=-126808.3039837 ehk=-126808.2781451
i gmax=4.4 nkabc=3 ehf=-126808.2952016 ehk=-126808.2925665
...
c gmax=4.4 nkabc=3 ehf=-126808.2950696 ehk=-126808.2950608
i gmax=4.4 nkabc=3 ehf=-126808.2950731 ehk=-126808.2950686
i gmax=6 nkabc=3 ehf=-126808.294891 ehk=-126808.294886
~~~

It is further explained in the [annotated lmf output](/docs/outputs/lmf_output/#end-of-self-consistency-loop).

Operations are performed in **subs/iosave.f**{: style="color: green"}.

#### The se file
[//]: (/docs/input/data_format/#the-se-file)

The _se_{: style="color: green"} file contains the frequency-dependent self-energy generated by the _GW_ code.  It is generated by
**spectral**{: style="color: blue"} from raw _GW_ output files _SEComg.UP_{: style="color: green"} (and _SEComg.DN_{: style="color: green"}
in the magnetic case), for use by **lmfgws**{: style="color: blue"}.  _se_{: style="color: green"} must be renamed to _se.ext_{: style="color: green"}.

The file contains a header and a body.  In ASCII keywords are given in the file.  The format consists of:

1.  header, 3 records
    1. **0&thinsp; version-number&thinsp; mode&thinsp; units**\\
       mode = 0 for format A or 1 for format B (see below)
    2. **nsp&thinsp; nband&thinsp; nqp&thinsp; nw&thinsp; ommin&thinsp; ommax**\\
       Number of spins, bands, _k_-points, frequencies; first and last frequency
    3. list of bands entering into spectral function, or 0 if bands are 1..nband
2.  vector of k-points **qp(3,nqp)**, in one record
3.  quasiparticle levels, <i>E</i><sub>qp</sub> **eig(nband,nqp,nsp)**, in one record
4.  &Sigma;(<b>k</b>,<i>E</i><sub>qp</sub>), i.e. QP sigma **sgq(nband,nqp,nsp)**, in one record
5.  <i>&omega;</i>-dependent self-energy &Sigma;(<b>k</b>,<i>&omega;</i>) **sigm(1:nw,1:nband,1:nq)** in one record (format A) or in a succession (formats B,C)

See <b>subs/ioseh.f</b>{: style="color: green"}.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### Files sdos, seia, pes, pesqp
[//]: (/docs/input/data_format/#files-sdos-seia-pes-pesqp)

These files are generated by **lmfgws**{: style="color: blue"}.  All files are written in [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays).  There are also files _sdos2.ext_{: style="color: green"} etc
corresponding to the second spin.

File _sdos.ext_{: style="color: green"} (_sdos2.ext_{: style="color: green"})
: Density-of-states, i.e. _k_ integrated spectral functions.  Columns are <i>&omega;</i>&thinsp; <i>A</i>(<i>&omega;</i>)&thinsp; <i>A</i><sup>0</sup>(<i>&omega;</i>).
^
File _seia.ext_{: style="color: green"} (_seia2.ext_{: style="color: green"})
: Spectral function at a specific q-point.  The header describes each column.
Note that &Sigma;(<b>k</b>,<i>&omega;</i>) is not the true self-energy.  It is
<span style="text-decoration: overline">&Sigma;(<b>k</b>,<i>&omega;</i>)</span> = &Sigma;(<b>k</b>,<i>&omega;</i>) &minus; &Sigma;<sup>0</sup>(<b>k</b>).
the last is subtracted so that <span style="text-decoration: overline">&Sigma;(<b>k</b>,<i>&omega;</i>)</span> = 0 at the QP level.
^
File _pes.ext_{: style="color: green"} (_pes2.ext_{: style="color: green"})
: Simulation of photoemission spectra.
^
File _pesqp.ext_{: style="color: green"} (_pesqp2.ext_{: style="color: green"})
: Simulation of photoemission spectra from noninteracting <i>A</i><sup>0</sup>(<i>&omega;</i>).  Works with SO coupling.

See [Table of Contents](/docs/input/data_format/#table-of-contents)

#### The spf file
[//]: (/docs/input/data_format/#the-spf-file)

File _spf.ext_{: style="color: green"}, and site-specific files _spf_{: style="color: green"}n<i>.ext</i>{: style="color: green"} contain
spectral functions along [symmetry lines](/docs/input/data_format/#symmetry-line-mode) generated by **lmgf**{: style="color: blue"}, with
the [**-\-band** switch](/docs/input/commandline/#band).  

How to make _spf.ext_{: style="color: green"} is explained in 
[this document](/docs/code/spectral-functions).
It contains a 1-line header consisting of values for **qcut** to be explained below, e.g.

~~~
#  1.19592  1.19592  2.19592  2.90302  3.61013
~~~

The header is followed by a sequence of lines:

~~~
[   E          q-q0        A(up)          A(dn)    ( this line is not present in the file)]
  -1.00000   0.00000      0.004900      0.004423
  -1.00000   0.01040      0.004896      0.004420
  -1.00000   0.02080      0.004886      0.004411
  ...
  -1.00000   3.61013      0.001589      0.001327
  -0.99800   0.00000      0.005079      0.004586
  -0.99800   0.01040      0.005075      0.004583
  ...
~~~

_Notes:_{: style="color: red"} 

1. *A* is the [spectral function](/tutorial/gw/gw_self_energy/#coherent-part-of-the-spectral-function).
2. The frequency is <i>&omega;</i> = <i>E&minus;E</i><sub><i>F</i></sub>.
3. The second column is the distance from the first q-point of the first [symmetry line](/docs/input/data_format/#symmetry-line-mode)
   i.e. the position in a band figure relative to the left edge.
   A panel begins/ends where points coincide with **qcut**.
4. Bash script [**SpectralFunction.sh**{: style="color: blue"}](/docs/input/commandline/#switches-for-spectralfunctionsh) will generate figures directly from _spf.ext_{: style="color: green"}.


Routine iospf in <b>gf/specfun.f</b>{: style="color: green"} reads and writes _spf.ext_{: style="color: green"}.

_Example_:  **qcut** shown above was generated from the following symmetry lines file:

~~~
116  0  0  0    0  0  1.195917          Gamma to H
97   1  0  0    0  0  0                 M to Gamma
68   0  0  0    .5 .5 0                 Gamma to X
68   .5 .5 0    1  0  0                 X to M
~~~

See [Table of Contents](/docs/input/data_format/#table-of-contents)
