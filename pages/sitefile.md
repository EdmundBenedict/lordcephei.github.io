---
layout: page-fullwidth
title: "Site file"
permalink: "/docs/input/sitefile/"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

To describe how to use a site file to read lattice information or site information.

_____________________________________________________________

### _Introduction_

Structural data (lattice and site data) can be read from the **ctrl** file,
**ctrl._ext_**{: style="color: green"}.

You can alternatively read either lattice information, or site information,
or both from a site file.  That file has no predetermined name; it is 
given in the **ctrl** file.

To read lattice information from **sname._ext_**{: style="color: green"},
use the **FILE** token in **STRUC**.

To read site information from **sname._ext_**{: style="color: green"},
use the **FILE** token in **SITE**.  The following snippet does both:

~~~
STRUC  FILE=sname
       ...
SITE   FILE=sname
       ...
~~~

If you use the **file** token in the EXPRESS category, it performs the function
of both **STRUC_FILE** and **SITE_FILE**, and supersedes both of these tags.

The first nonblank, non-preprocessor directive, should begin with:

~~~
% site-data vn=#
~~~

_Note:_{: style="color: red"} Version 7 of the Questaal suite writes version 3.0 site files; it can read
versions 3.0 and prior versions.

This first line must also contain token **io=#**.  **io=14** tells the reader
that minimal information is available in the file: 
+ the number of sites in the lattice
+ the lattice vectors
+ the basis vectors

Usually the first line contains the lattice constant as well, as in the following snippet:

~~~
% site-data vn=3.0 xpos fast io=62 nbas=64 alat=7.39563231 plat= 2.0 0.0 0.0 0.0 2.0 0.0 1.0 1.0 3.58664656
#                        pos                                vel                     eula              vshft   PL rlx
 K1        0.0000000   0.0000000   0.0000000    0.0000000    0.0000000    0.0000000    0.0000000    0.0000000    0.0000000 0.000000  0 111
 Fe1       0.3750000   0.1250000   0.2500000    0.0000000    0.0000000    0.0000000    0.0000000    0.0000000    0.0000000 0.000000  0 111
~~~

The first line tells the parser the following:

+ **io=62** indicates that in addition to the basis vectors, the following information is available for each site:
  + velocities (used in molecular dynamics)
  + Euler angles (the spin quantization axis used by noncollinear parts of the ASA code)
  + Site potential shifts (may be used by the ASA)
  + Principal layer index (layer Green's function code)
  + Three binary integers ***rlx*** specifying which of Cartesian components are allowed to
    change molecular dynamics or statics. **1** allows to relax while **0** freezes that coordinate.
+ **xpos** indicates that the basis vectors are written as fractional multiples of lattice vectors.
  By default these vectors are written in Cartesian coordinates in units of the lattice constant **alat**.
+ **fast** tells the parser to read basis information with FORTRAN read.  By default
  it parses each element as an algebraic expression.  The former is much faster (recommended for files with many atoms), but you lose the capability of using expressions.
+ **nbas=64** tells the parser that there are 64 atoms in the crystal.
+ **alat=7.39563231** specifies the lattice constant, in atomic units.
+ **plat=...** specifies the lattice vectors, P<sub>1</sub>, followed by P<sub>2</sub> and P<sub>3</sub>.

The second line is a comment line.  Then follow a sequence of lines, one line for each atom.
As a minimum, the row must contain a species lable and the site position (**io=14**).
In snippet above (**io=62**) it contains the velocity, Euler angles, site potential shifts, principal layer index and relaxation flags.

### _Other resources_

Refer to some tutorials ...

