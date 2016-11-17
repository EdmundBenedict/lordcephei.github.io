---
layout: page-fullwidth
title: "1-shot GW tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/gw/gw1shot/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />

### _Purpose_
{:.no_toc}
_____________________________________________________________


This tutorial carries out a 1-shot GW calculation for silicon. 

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### _Preliminaries_
_____________________________________________________________


Executables **blm**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path;
similarly for the GW script **lmgw1-shot**{: style="color: blue"}; and the binaries it requires should be in subdirectory **code2**.

### _Introduction to a QSGW calculation_
________________________________________________________________________________________________

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a 1-shot GW calculation. Click on the 'GW' dropdown menu below for a brief description of the GW scheme. A complete summary of the commands used throughout is provided in the 'Commands' dropdown menu. Theory for GW and QSGW, and its implementation in the Questaal suite, can be found in [Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106).


<div onclick="elm = document.getElementById('qsgwsummary'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Click for description.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgwsummary">{:/}

One-shot GW calculations are perturbations to a DFT calculation (such as LDA). They are simpler than QSGW calculations, because only the diagonal part of &Sigma;<sup>0</sup> is normally calculated (this is an approximation) and only a single iteration is carried out. On the other hand, one-shot calculations are sensitive to the starting point and you also no longer have the luxury of interpolating betwee k points to get full bandstructures. As a result, it is only possible to calculate 1-shot corrections for k points that lie on the k-mesh use in the self-energy calculation. 

The DFT executable is **lmf**{: style="color: blue"}.  **lmfgwd**{: style="color: blue"} is similar
to **lmf**{: style="color: blue"}, but it is a driver whose purpose is to set up inputs for the _GW_ code.
&Sigma;<sup>0</sup> is made by a shell script **lmgw1-shot**{: style="color: blue"}.


{::nomarkdown}</div>{:/} 

