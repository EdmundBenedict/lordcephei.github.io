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
{::comment}
(/docs/input/data_format/#site-files)
{:/comment}

Site files can assume a variety of formats.
Their structure is documented [here](/docs/input/sitefile/).


#### File formats for k-point lists
{::comment}
(/docs/input/data_format/#file-formats-for-k-point-lists)
{:/comment}

<i>k</i>-points and which energy bands or quasiparticles are to be generated
are specified in one of three types, or modes.  

+ (default) [symmetry line mode](#symmetrylinemode)
is designed for plotting energy bands along symmetry lines.  In this
case <i>k</i>-points are specifed by a sequences of lines with start
and end points.  The output is a bands file in a specially adapted format.

+ [List mode](#listmode) is a general purpose mode
to be used when energy levels are sought at some arbitrary set of
<i>k</i>-points, specified by the user.  Data is written in a standard
format with k-points followed by eigenvalues.

+ [Mesh mode](#contourmode) is a mode that
generates states on a uniform mesh of <i>k</i>-points in a plane.  Its
purpose is to generate contour plots of constant energy surfaces,
e.g. the Fermi surface. Data file output is written in a special mode, with 
levels for a particular band at all <i>k</i> written as a group.

{::nomarkdown}
<FONT color="#bb3300">
{:/nomarkdown}

##### Symmetry line mode

{::nomarkdown}
</FONT>
{:/nomarkdown}

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

<i>Output, symmetry-line mode</i> <BR>

Bands are written to file <FONT size="+1"><tt>bnds.ext</tt></FONT> in
a format specially tailored to symmetry lines.
The first line consists of of a header, which contains the (maximum) number of
bands, the Fermi level, and the number of color weights, e.g.:
<pre>
 36  -0.02136     2  col= 5:9,14:18  col2= 23:27,32:36
</pre>
Next follow, for each symmetry line:

+  A line with specifying the number of points for the current symmetry line.
   Next follow for each point <i>i</i>:
   + a line containing <i>k<sub>i</sub></i> (3 numbers).
   + one or more lines with the energy levels for <i>k<sub>i</sub></i>
^

<i>Making figures, symmetry-line mode</i> <BR>

Use [**plbnds**{: style="color: blue"}](/docs/misc/plbnds/) to read this file format.  It can generate directly a (not very pretty)
[picture](/docs/misc/plbnds/#example-1) rendered in postscript.  Better, **plbnds**{: style="color: blue"} can generate data files and a
[script](/docs/misc/fplot/#example-22-nbsp-reading-fplot-commands-from-a-script-file) for the Questaal graphics tool [**fplot**{:
style="color: blue"}](/docs/misc/fplot/).  **plbnds**{: style="color: blue"} generates energy bands in a simple to read, [standard Questaal
format](/docs/input/data_format/#standard-data-formats-for-2d-arrays). so that you can use **fplot**{: style="color: blue"} or your favorite
graphics package.

##### List mode

{::comment}
<H2><A name="listmode"><FONT size="+1" color="#bb3300">List mode</FONT></A></H2>
{:/comment}

This mode is specifed by, e.g. command line argument **--band~qp**.  Use this mode to generate energy levels for a discrete list of
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
format automatically generated if **BZ_PUTQP** is set or if the command-line switch **--putqp** is prsent.

<div onclick="elm = document.getElementById('putqp'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<span style="text-decoration:underline;">Click here for a description of this format.</span>
</div>{::nomarkdown}<div style="display:none;padding:0px;" id="putqp">{:/}

When this switch is set, <b>lm</b> (or similar programs that do numerical
integrations over the Brillouin zone) will save information about the
<i>k</i>-points it uses for integration to file <FONT
size="+1"><tt>qpts.ext</tt></FONT>.  "List" mode can read this format;
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

The file reader will automatically distinguish between these formats.

<i>Output, list mode</i>

Bands are written in the standard 2D array format used by matrix
calculator <b>mc</b>.  The first three columns are the <i>k</i> point;
the remaining columns are the bands.  If color weights are specified,
an additional group of columns are appended.

<i>Plotting, list mode</i>

Because the <i>k</i>-points need not follow any particular pattern,
there is no generic plotting scheme.  As noted, the format can be read by
<b>fplot</b>, and easily read by other programs such as MATLAB.


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
  parse each <i>k</i>-point, and exclude those for which <i>expr</i> is
  not satisfied.  <i>expr</i> is an ASCII string containing an algebraic
  expression.  <i>expr</i> can (and is expected to) contain <i>k</i>-point
  specific variables, which include:
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

+ [,merge=fnam] causes the list reader
  to read a <i>second</i> file (named <FONT
  size="+1"><tt>fnam.ext</tt></FONT>, (in an acceptable qp format mode)
  and append the list read from it to the original list.

+ [,save=fnam] causes the list reader to
  write the final <i>k</i>-points list to file <FONT
  size="+1"><tt>fnam.ext</tt></FONT>.  After writing the program automatically stops.

^

##### Mesh mode

{::comment}
<H2><A name="contourmode"><FONT size="+1" color="#bb3300">Mesh mode</FONT></A></H2>
{:/comment}

In this mode <i>k</i>-points are generated on a uniform 2D mesh,
intended for contour plots.  Invoke with
<pre>
  --band~con~...
</pre>

The mesh is specified by a file containing lines of the form
<pre>
                    <i>v<sub>x</sub>     range  n<sub>x</sub>     v<sub>y</sub>     range  n<sub>y</sub>   height  band</i>
</pre>      
where:
<pre>
                   <i>v<sub>x</sub></i> and <i>v<sub>y</sub></i> are two reciprocal lattice vectors defining a plane
                   <i>range</i> is a pair of numbers marking starting and ending points along each vector
                   <i>n<sub>x</sub></i> and <i>n<sub>y</sub></i> are the number of divisions along the first and second vectors
                   <i>height</i> specifies the offset normal to the plane
                   <i>band</i> specifies which band is to be saved. 
</pre>
Example:
<pre>
       1 0 0   -1 1   51   0 1 0   -1 1   51   0.00    4,5
</pre>

<BR> <i>Output, mesh mode</i> <BR>

Bands are written in the standard 2D array format used by matrix
calculator <b>mc</b> and the <i>xy</i> plotting program <b>fplot</b>.
The number of rows is the number of divisions in the first vector; the
number of columns is the number of divisions in the second vector.  No
<i>k</i> point information is written (it is implicit in the uniform
mesh).

<BR> <i>Plotting, mesh mode</i> <BR>

If you have the graphics package <b>fplot</b> installed, you can
easily plot Fermi surfaces in conjunction with the files generated in the mesh mode.


<H2><A name="deform"><FONT size="+1">Transformation of the supplied <i>k</i>-points</FONT></A></H2>

The <i>k</i>-points as supplied from the input file can be transformed.

This is useful in several contexts.  If spin-orbit coupling is present
on the bands depend on the relative orientation of the coordinate
system and spin quantization axis (the <i>z</i> axis by default).

In an angle-resolved photoemission experiment, <b>k</b> normal to the
surface (<i>k</i><sub>&perp;</sub>) is modified on exiting the
surface, whereas <b>k</b><sub>&#8741;</sub> is conserved.  This means that
<b>k</b> measured by ARPES slightly different from <b>k</b> calculated
from the band structure.  The larger the kinetic energy the smaller
the effect, but in typical PE experiments it is not negligible.

<P>

There are two ways to transform the <b>k</b> point.  The first is to use
the <FONT size="+1"><tt>~rot=</tt></FONT> option to
the <FONT size="+1"><tt>--band</tt></FONT> switch (see above).  The second
is through a sequence of algebraic expressions which you specify in the
first line of the <i>k</i>-points input file.  This line consists of a sequence of algebraic expressions,
which generate one or more of <i>k</i><sub><i>x</i></sub>, <i>k</i><sub><i>y</i></sub>, or 
<i>k</i><sub><i>z</i></sub>, which modifies one of more of the Cartesian components of <b>k</b>.

<P>

To modify <i>k</i><sub><i>x</i></sub>, <i>k</i><sub><i>y</i></sub>, or <i>k</i><sub><i>z</i></sub>
insert a line at the beginning of the file.
The first character must be a '%', followed by one or more strings with algebraic expressions defining the <i>x</i>-, 
<i>y</i>, and <i>z</i> components of the modified <b>q</b>:
<pre>
%   [var=<i>expr</i> var=<i>expr</i> ...]   kx=<i>expr</i>  ky=<i>expr</i>  kz=<i>expr</i>
</pre>
<FONT size="+1"><tt>kx,ky,kz</tt></FONT> are the Cartesian coordinates of the modified <i>k</i>-point.

<FONT size="+1"><tt><i>expr</i></tt></FONT> are algebraic expressions involving these variables:
<pre>
  qx   <i>k<sub>x</sub></i>
  qy   <i>k<sub>y</sub></i>
  qz   <i>k<sub>z</sub></i>
  q    |<b>k</b>|=[<i>k<sub>x</sub></i><sup>2</sup>+<i>k<sub>y</sub></i><sup>2</sup>+<i>k<sub>z</sub></i><sup>2</sup>]<sup>1/2</sup>
</pre>
The expression should be integer (returning 0 or nonzero). 
Example:
<FONT size="+1"><tt>qx,qy,qz,q</tt></FONT> are the cartesian components and absolute value of the unmodified <i>k</i>-point.

Any of the 
<FONT size="+1"><tt>kx=<i>expr</i>  ky=<i>expr</i>  kz=<i>expr</i></tt></FONT>
may be present; any missing component will be left unchanged from its original value.

This example in symmetry line mode modifies <i>k<sub>x</sub></i> such that the kinetic energy is increased by .1^2 a.u.
<pre>
% map kx=(q^2+.1^2-qy^2-qz^2)^.5
41  .5 .5 .5     0  0 0                L to Gamma
...
</pre>

<P> You should verify that code reading the k-points modified the q points by inspecting the output.
It should contain the following lines:

<pre>
 suqlst: map qp using the following:
 kx=(q^2+.1^2-qy^2-qz^2)^.5
</pre>

The <FONT size="+1"><tt>~rot=</tt></FONT> switch may be used in conjuction
with the modification through alegbraic expresssions.  For example suppose
you want to modify <i>k</i><sub>&perp;</sub> normal to the (1,-1,0) direction,
while preserving <b>k</b><sub>&#8741;</sub> in the (1,1,0),(0,0,1) plane.

<P> Take Cu as a concrete example.  If <FONT size="+1"><tt>lm</tt></FONT>
is your top-level directory, set up the calculation for Cu with
<pre>
~/lm/fp/test/test.fp cu 1
</pre>
This should set up a self-consistent potential for Cu and save generate energy bands in file
<FONT size="+1"><tt>bnds.cu-pwmode11</tt></FONT>.

The input file as constructed uses the normal Cartesian coordinates for a cube.  But if
you invoke <b>lmf</b> with <FONT size="+1"><tt>-vrot=t</tt></FONT>, viz
<pre>
lmf -vrot=t cu --showp 
</pre>
you will see that token <FONT size="+1"><tt>STRUC_ROT=z:pi/4</tt></FONT> appears in the preprocessed input file.
This tells <b>lmf</b> to rotate the crystal axes, the basis vectors, and the symmetry group operations.
Rotation <FONT size="+1"><tt>(1,-1,0)pi/2</tt></FONT> rotates (1/2,1/2,0) to the -z axis.
Do this:
<pre>
lmf -vrot=t cu --quit=ham
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
  lmf  --no-iactiv cu -vnk=8 -vbigbas=t -vpwmode=11 -voveps=0d-7 --band:fn=syml
</pre>
with:
<pre>
  lmf  --no-iactiv cu -vnk=8 -vbigbas=t -vpwmode=11 -voveps=0d-7 -vrot=t --rs=101 '--band~rot=(1,-1,0)pi/2~fn=syml'
</pre>
<FONT size="+1"><tt>--rs=101</tt></FONT> tells the charge density reader to rotate the local densites (the density was generated in the unrotated coordinate system).
<P>
<FONT size="+1"><tt>--band~rot=</tt></FONT> is necessary because lmf will not automatically rotate
the k-points read from the <FONT size="+1"><tt>syml</tt></FONT> file.

<P>
Run modifed band pass calculation and compare
<FONT size="+1"><tt>bnds.cu</tt></FONT> with 
<FONT size="+1"><tt>bnds.cu-pwmode11</tt></FONT>.
You should see that the <i>k</i>-points are different, but that the
bands are essentially identical.  (There are slight differences
relating to the numerical instabilities in the overlap originating from the
addition of APW's.)

This shows that the bands are replicated in the rotated coordinate system.

<P>

Finally, modify <FONT size="+1"><tt>syml.cu</tt></FONT> by uncommenting the first line so it reads:
<pre>
% map kz=(q^2+.01^2-qx^2-qy^2)^.5*(qz>0?1:-1)
</pre>
and repeat the <b>lmf</b> band pass.  You should see that <i>k<sub>x</sub></i> and
<i>k<sub>y</sub></i> are unchanged, but <i>k<sub>z</sub></i> is slightly modified.
Similarly the bands are slightly modified.

{:/}
