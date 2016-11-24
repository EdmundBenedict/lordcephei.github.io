---
layout: page-fullwidth
title: "Spherical Harmonics"
permalink: "/docs/numerics/spherical_harmonics/"
header: no
---

Objects with basis sets defined 
by spherical harmonics, such as LMTOs, order the harmonics as
<i>m</i>=&minus;<i>l</i>, &minus;<i>l</i>+1, &hellip; 0, &hellip; <i>l</i>.

The Questaal codes use real harmonics $$Y_{lm}(\hat{\bf r})$$,
instead of the usual spherical (complex) harmonics $$\mathrm{Y}_{lm}(\hat{\bf r})$$.
The
<i>Y<sub>lm</sub></i> are functions of solid angle, while
<i>Y<sub>lm</sub>r<sup>l</sup></i> are polynomials in _x_, _y_, and
_z_.  These polynomials (apart from a normalization) are ordered as
follows for _l_=0&hellip;3:

   |-|-|-|-|
  index  | l |   m |    polynomial
   |-:|-|-:|:-
     1   | 0 |   0 |       1
     2   | 1 |  -1 |       _y_
     3   | 1 |   0 |       _z_
     4   | 1 |   1 |       _x_
     5   | 2 |  -2 |       _xy_
     6   | 2 |  -1 |       _yz_
     7   | 2 |   0 |       3_z_<sup>2</sup>&minus;1
     8   | 2 |   1 |       <i>xz</i>
     9   | 2 |   2 |       <i>x</i><sup>2</sup>&minus;<i>y</i><sup>2</sup>
     10  | 3 |  -3 |       <i>y</i>(3<i>x</i><sup>2</sup>&minus;<i>y</i><sup>2</sup>)
     11  | 3 |  -2 |       <i>xyz</i>
     12  | 3 |  -1 |       <i>y</i>(5<i>z</i><sup>2</sup>&minus;1)
     13  | 3 |   0 |       <i>z</i>(5<i>z</i><sup>2</sup>&minus;3)
     14  | 3 |   1 |       <i>x</i>(5<i>z</i><sup>2</sup>&minus;1)
     15  | 3 |   2 |       <i>z</i>(<i>x</i><sup>2</sup>&minus;<i>y</i><sup>2</sup>)
     16  | 3 |   3 |       <i>x</i>(<i>x</i><sup>2</sup>&minus;3<i>y</i><sup>2</sup>)



The <i>Y<sub>lm</sub></i> and Y<i><sub>lm</sub></i> are related as follows:

$$
 Y_{l0}(\hat{\bf r}) \equiv \mathrm{Y}_{l0}(\hat{\bf r})
 \quad\quad\quad\quad (1)
$$

$$
 Y_{lm}(\hat{\bf r}) \equiv \frac{1}{\sqrt{2}}
           [ (-1)^m \mathrm{Y}_{lm}(\hat{\bf r}) + \mathrm{Y}_{l-m}(\hat{\bf r}) ].
 \quad\quad\quad\quad (2)
$$

$$
 Y_{l-m}(\hat{\bf r})
  \equiv \frac{1}{\sqrt{2}i}
           [ (-1)^m \mathrm{Y}_{lm}(\hat{\bf r}) - \mathrm{Y}_{l-m}(\hat{\bf r}) ].
 \quad\quad\quad\quad (3)
$$

where $$m>0$$. 

Or equivalently,

$$
\mathrm{Y}_{l0}(\hat{\bf r}) \equiv Y_{l0}(\hat{\bf r})
\qquad
\quad\quad\quad\quad (4)
\\
\mathrm{Y}_{lm}(\hat{\bf r}) \equiv \frac{(-1)^m}{\sqrt{2}}
           [ Y_{lm}(\hat{\bf r}) + iY_{l-m}(\hat{\bf r}) ]
\quad\quad\quad\quad (5)
\\
\mathrm{Y}_{l-m}(\hat{\bf r}) \equiv \frac{1}{\sqrt{2}}
           [ Y_{lm}(\hat{\bf r}) - iY_{l-m}(\hat{\bf r}) ].
\quad\quad\quad\quad (6)
$$

The definition of $$\mathrm{Y}_{lm}(\hat{\bf r})$$ are

$$
\mathrm{Y}_{lm}(\theta, \phi)
=(-1)^m \left[ \frac{(2l+1)(l-m)!}{4 \pi (l+m)!} \right]^{\frac{1}{2}} P^m_l(\cos(\theta)) e^{i m \phi}, \\
 \quad\quad\quad\quad (1)
$$

$$
P^m_l(x) = \frac{(1-x^2)^{m/2}}{2^l l!}\frac{d^{l+m} \ \ }{dx^{l+m}} (x^2-1)^l
$$

See\\
(1) A.R.Edmonds, Angular Momentum in quantum Mechanics, 
Princeton University Press, 1960,\\
(2) M.E.Rose, Elementary Theory of angular Momentum,
John Wiley \& Sons, INC. 1957,\\
(3) Jackson, Electrodynamics.

Definitions (7) and (8) of spherical harmonics are the same in these books.
Jackson's definition of $$P_l^m$$ differs by a phase factor $$(-1)^m$$, 
but his $$\mathrm{Y}_{lm}$$ are the same as Eq. 7.

Wikipedia (wiki/Associated\_Legendre\_polynomials) follows Jackson's convention for $$P_l^m$$.

Wikipedia (wiki/Spherical\_harmonics) refer to a ``quantum
qmechanics'' defnition of spherical harmonics (following Messiah;
Tannoudji).  It differs from Jackson by a factor $$(-1)^m$$.  This is
apparently the definition K. Haule uses in his CTQMC code.



