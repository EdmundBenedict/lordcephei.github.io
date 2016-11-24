---
layout: page-fullwidth
title: "Spherical Harmonics"
permalink: "/docs/numerics/spherical_harmonics/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
{:.no_toc}

### _Documentation_
_____________________________________________________________


The Questaal codes uses real harmonics $$Y_{lm}(\hat{\bf r})$$,
instead of the usual spherical (complex) harmonics $$\mathrm{Y}_{lm}(\hat{\bf r})$$.

Hamiltonians, eigenfunctions, and objects with basis sets defined 
by spherical harmonics (e.g. LMTOs) order them as
<i>m</i>=&minus;<i>l</i>, &minus;<i>l</i>+1, &hellip; 0, &hellip; <i>l</i>.

\begin{equation}
 Y_{l0}(\hat{\bf r}) \equiv \mathrm{Y}_{l0}(\hat{\bf r})
\end{equation}

\begin{equation}
 Y_{lm}(\hat{\bf r}) \equiv \frac{1}{\sqrt{2}}
           [ (-1)^m \mathrm{Y}_{lm}(\hat{\bf r}) + \mathrm{Y}_{l-m}(\hat{\bf r}) ].
\end{equation}

\begin{equation}
 Y_{l-m}(\hat{\bf r})
  \equiv \frac{1}{\sqrt{2}i}
           [ (-1)^m \mathrm{Y}_{lm}(\hat{\bf r}) - \mathrm{Y}_{l-m}(\hat{\bf r}) ].
\end{equation}

where $$m>0$$. 

Or equivalently,
\begin{equation}
 \mathrm{Y}_{l0}(\hat{\bf r}) \equiv Y_{l0}(\hat{\bf r})
\end{equation}

\begin{equation}
 \mathrm{Y}_{lm}(\hat{\bf r}) \equiv \frac{(-1)^m}{\sqrt{2}}
           [ Y_{lm}(\hat{\bf r}) + iy_{l-m}(\hat{\bf r}) ]. \\
\end{equation}

\begin{equation}
 \mathrm{Y}_{l-m}(\hat{\bf r}) \equiv \frac{1}{\sqrt{2}}
           [ Y_{lm}(\hat{\bf r}) - iy_{l-m}(\hat{\bf r}) ].
\end{equation}

The definition of $$\mathrm{Y}_{lm}(\hat{\bf r})$$ are
\begin{equation}
\mathrm{Y}_{lm}(\theta, \phi)
=(-1)^m \left[ \frac{(2l+1)(l-m)!}{4 \pi (l+m)!} \right]^{\frac{1}{2}} P^m_l(\cos(\theta)) e^{i m \phi}, \\
\end{equation}
\begin{equation}
P^m_l(x) = \frac{(1-x^2)^{m/2}}{2^l l!}\frac{d^{l+m} \ \ }{dx^{l+m}} (x^2-1)^l
\end{equation}

\noindent See\\
(1) A.R.Edmonds, Angular Momentum in quantum Mechanics, 
Princeton University Press, 1960,\\
(2) M.E.Rose, Elementary Theory of angular Momentum,
John Wiley \& Sons, INC. 1957,\\
(3) Jackson, Electrodynamics.\\

Definitions (7) and (8) of spherical harmonics are the same in these books.
Jackson's definition of $$P_l^m$$ differs by a phase factor $$(-1)^m$$, 
but his $$\mathrm{Y}_{lm}$$ are the same as Eq. 7.

Wikipedia (wiki/Associated\_Legendre\_polynomials) follows Jackson's convention for $$P_l^m$$.

Wikipedia (wiki/Spherical\_harmonics) refer to a ``quantum
qmechanics'' defnition of spherical harmonics (following Messiah;
Tannoudji).  It differs from Jackson by a factor $$(-1)^m$$.  This is
apparently the definition K. Haule uses in his CTQMC code.



