---
layout: page-fullwidth
title: "LMF band-edge: finding extremal points in k-space"
permalink: "/tutorial/lmf/lmf_bandedge/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This tutorial is a simple introduction to finding extremal points in k-space using the band-edge program. We will use silicon as

_____________________________________________________________

### _Command summary_

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ mkdir si; cd si                               #create working directory and move into it
    $ nano init.si                                  #copy and paste init file from box   
    $ blm init.si --express                         #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                           #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si                                  #use lmfa to make basp file, atm file and to get gmax
    $ cp basp0.si basp.si                           #copy basp0 to recognised basp prefix   
    $ nano ctrl.si                                  #set iterations number nit, k mesh nkabc and gmax
    $ lmf ctrl.si > out.lmfsc                       #make self-consistent

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Preliminaries_

Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path.  The source code for all Questaal executables can be found [here](https://bitbucket.org/lmto/lm).

_____________________________________________________________

### _Tutorial_

To get started, create a new working directory and move into it; here we will call it "si".

    $ mkdir si 
    $ cd si
