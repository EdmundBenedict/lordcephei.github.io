---
layout: page-fullwidth
title: "Annotated standard output, program lmfg"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/docs/outputs/lmgf-output/"
header: no
---

_____________________________________________________________

### _Purpose_
{:.no_toc}

This page details the output generated by the free atomic code **lmgf**{: style="color: blue"}.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

The output documented here is mostly taken from the **lmgf**{: style="color: blue"}
[tutorial](/tutorial/lmgf/lmgf/).
Some portions are adapted from other calculations, as will be indicated.

The standard output is organised by blocks.  The sections below
annotate each block approximately in the order they are made.
Some parts are similar to the [**lmf**{: style="color: blue"} output](/docs/outputs/lmf_output/); in places where they are similar a cursory
treatment is given here; the reader is referred to that page.

_Note:_{: style="color: red"} This document is annotated for an [output vebosity](/docs/input/commandline/#switches-common-to-most-or-all-programs) of 35 (medium verbosity)
Raising the verbosity causes **lmgf**{: style="color: blue"} to print additional information.
Verbosity 31 is a little terse; verbosity 41 is a little verbose.


### _Preprocessor's transformation of the input file_
{::comment}
/docs/outputs/lmgf-output/#preprocessors-transformation-of-the-input-file
{:/comment}

The input file is run through the [preprocessor](/docs/input/preprocessor/), which modifies the ctrl file before it it is parsed for tags.
Normally it does this silently.  To see the effects of the preprocessor use `lmgf --showp ...`

<div onclick="elm = document.getElementById('preprocessor'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
<button type="button" class="button tiny radius">Click here to see the action of the preprocessor on ctrl.copt.</button>
</div>{::nomarkdown}<div style="display:none;padding:0px;"id="preprocessor">{:/}
{::comment}
<span style="text-decoration:underline;">Click here to see the action of the preprocessor on ctrl.pbte.</span>
{:/comment}

Append `--showp` to the **lmgf**{: style="color: blue"} command in the [lmgf-tutorial](/tutorial/lmgf/lmgf/)

~~~
$ lmgf ctrl.copt -vnit=30 --pr31,20 --iactiv -vef=-.1293 --showp
~~~
The box below compares side by side the original _ctrl.pbte_{: style="color: green"}
and its transformation by the preprocessor (the original file was edited slightly)

~~~
% const nit=1 les=1
% const met=1
% const nsp=2 so=0
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const nkabc=8
% const ccor=T sx=0 gamma=sx scr=4 # ASA-specific
% const gfmode=1 nz=16 ef=0 c3=t   # lmgf-specific variables

VERS  LM:7 ASA:7 # FP:7                              |  VERS  LM:7 ASA:7
IO    SHOW=f HELP=f IACTIV=f VERBOS=35,35  OUTPUT=*  |  IO    SHOW=f HELP=f IACTIV=f VERBOS=35,35  OUTPUT=*
EXPRESS                                              |  EXPRESS
  file=   site                                       |    file=   site
# file= essite                                       |
                                                     |
# Self-consistency                                   |
  nit=    {nit}                                      |    nit=    30
  mix=    B2,b=.3,k=7                                |    mix=    B2,b=.3,k=7
  conv=   1e-5                                       |    conv=   1e-5
  convc=  3e-5                                       |    convc=  3e-5
                                                     |
# Brillouin zone                                     |
  nkabc=  {nkabc}                                    |    nkabc=  8
  metal=  {met}                                      |    metal=  1
                                                     |
# Potential                                          |
  nspin=  {nsp}                                      |    nspin=  2
  so=     {so}                                       |    so=     0
  xcfun=  {lxcf},{lxcf1},{lxcf2}                     |    xcfun=  2,0,0
                                                     |
#SYMGRP i*r3d r2(0,1,1)                              |
OPTIONS                                              |  OPTIONS
    ASA[ CCOR={ccor} ADNF=F GAMMA={gamma}]           |      ASA[ CCOR=1 ADNF=F GAMMA=0]
    SCR={scr} SX={sx}                                |      SCR=4 SX=0
                                                     |
GF MODE={gfmode} GFOPTS={?~c3~p3;~p2;}               |  GF    MODE=1 GFOPTS=p3;
BZ    EMESH={nz},10,-1,{ef},.5,.3                    |  BZ    EMESH=16,10,-1,-.1293,.5,.3
SPEC                                                 |  SPEC
  SCLWSR=11 WSRMAX=3.3 OMAX1=0.16,0.18,0.2           |    SCLWSR=11 WSRMAX=3.3 OMAX1=0.16,0.18,0.2
  ATOM=Pt Z= 78  R= 2.613200  LMX=3  IDXDN=0 0 0 2   |    ATOM=Pt Z= 78  R= 2.613200  LMX=3  IDXDN=0 0 0 2
  ATOM=Co Z= 27  R= 2.468493  LMX=2  MMOM=0 0 2.2    |    ATOM=Co Z= 27  R= 2.468493  LMX=2  MMOM=0 0 2.2
START CNTROL={nit==0} BEGMOM={nit==0}                |  START CNTROL=0 BEGMOM=0
~~~

{::nomarkdown}</div>{:/}

### _Display tags parsed in the input file_
{::comment}
/docs/outputs/lmf_output/#display-tags-parsed-in-the-input-file
{:/comment}
