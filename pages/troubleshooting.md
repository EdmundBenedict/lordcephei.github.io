---
layout: page-fullwidth
title: "Solutions To Common Problems"
permalink: "/docs/troubleshooting/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This page serves as a list of common issues and their solutions. It is by no means complete and we welcome any additions. If your problem is not listed here then you should seek help through the normal channels (issues page, email, search the site).   

The [general](#general) section below contains solutions that fix a large number of problems. You may find that a solution for your problem, which may have its own category, is the same as the solution found in general. It is a good idea to follow the advice in the general section before narrowing down your problem, as not only could this fix your problem straight away, but following the solutions provided in general is good practise and should be incorporated in to all your simulation runs - error or not.

### _Solutions_
_____________________________________________________________

##### _General_
Generally, your directory should be cleaned after every complete simulation. What this means is, if you run a simulation involving, e.g. _si_, and then edit the input files and rerun the _si_ simulation, you may get conflicts as old information about _si_ simulation runs exists in the directory.   

It is thus good practise to clean your directory of unnecessary files before a new simulation (only files related to the material in question need be cleaned), especially cleaning the _rst.*_{: style="color: green"} files.

##### _Unexpected Energy_
If you ever get an error of the form "unexpected value # for file rmt ... expected #", it is probably because you have an old _rst.*_{: style="color: green"} file (a restart file) which contains information from previous runs. This information, should you change your input files, could become invalid for the current simulation and thus cause errors.   

Generally, when running a simulation that involves different/edited input files, you should delete the _rst.*_{: style="color: green"} file for that simulation. E.g., if you're running a simulation for _si_

    rm rst.si

