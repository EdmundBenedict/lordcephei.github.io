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

_Note:_{: style="color: red"} The site file is normally run
through the [file preprocessor](/docs/input/preprocessor/).


The first nonblank, non-preprocessor directive, should begin with:

~~~
% site-data vn=#
~~~

_Note:_{: style="color: red"} Version 7 of the Questaal suite writes version 3.0 site files, and it can read
earlier versions.

This first line must also contain token **io=#**.  **io=14** tells the reader
that minimal information is available in the file: 
+ the number of sites in the lattice
+ the lattice vectors
+ the basis vectors

Usually the first line contains the lattice constant as well.  For example:

~~~
% site-data vn=3.0 xpos fast io=62 nbas=64 alat=7.39563231 plat= 2.0 0.0 0.0 0.0 2.0 0.0 1.0 1.0 3.58664656
~~~

This line tells the parser the following:

+ **io=62** indicates that in addition to the basis vectors, the following information is available for each site:
  + velocities (needed for molecular dynamics)
  + Euler angles (the noncollinear ASA code makes a rigid spin approximation; there quantization axis is fixed by a single rotation)
  + Site potential shifts, also applicable to the ASA
  + Principal layer index, for the layer Green's function code
  + Three binary integers specifying which of Cartesian components are allowed to
    change in spin or molecular dynamics
+ **xpos** indicates that the basis vectors are written as fractional multiples of lattice vectors.
  By default these vectors are written in Cartesian coordinates in units of the lattice constant **alat**.
+ **fast** tells the parser to omit reading the file through the preprocessor.  The read is much faster, but you lose the programming language capability of the preprocessor.
+ **nbas=64** tells the parser that there are 64 atoms in the crystal.
+ **alat=3** specifies the lattice constant.
+ **plat=...** specifies the lattice vectors, P<sub>1</sub>, followed by P<sub>2</sub> and P<sub>3</sub>.

### _Other resources_

The source code to **ccomp**{: style="color: blue"} can be found [here](https://bitbucket.org/lmto/lm/src/e82e155d8ce7eb808a9a6dca6d8eea5f5a095bd6/startup/ccomp.c).
