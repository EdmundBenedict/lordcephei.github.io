---
layout: page-fullwidth
title: "Finding extremal points in k-space"
permalink: "/tutorial/lmf/lmf_bandedge/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This tutorial demonstrates how to find extremal points in k-space using the band-edge program. This is done for silicon and the starting point is a self-consistent LDA density.

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
    
    $ band-edge part

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Preliminaries_

The starting point is a self-consistent LDA density. 

_____________________________________________________________

### _Tutorial_

The starting point is a self-consistent LDA calculation. You may want to review the [lmf tutorial for Si](/tutorial/lmf/lmf_tutorial/). A summary 

    $ mkdir si 
    $ cd si
