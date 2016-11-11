---
layout: page-fullwidth
title: "Brillouin zone integration"
permalink: "/docs/numerics/bzintegration/"
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
Numerical integrations over the Brillouin zone (BZ) occur in several contexts, such as the sum of single particle energies. Care must be taken when performing this integration. In practice the first BZ is divided into a uniform mesh of ($n_{1}$, $n_{2}$, $n_{3}$) **k**-points parallel to the three primitive reciprocal lattice vectors, $G_{1}$, $G_{2}$, $G_{3}$.

The definition of the **G** vectors is standard: define **G**=(**P**$^{-1})$^†$ where **P** is 3×3 matrix constructed from the three primitive lattice vectors **P**$_{-1}$, **P**$_{-2}$, **P**$_{-3}$. $G_{1}$, $G_{2}$, $G_{3}$ are the three vectors composing the 3×3 matrix **G**.   

Dividing $G_{1}$, $G_{2}$, $G_{3}$ respectively into $n_{1}$, $n_{2}$, $n_{3}$ sections creates a set of ($n_{1}$x $n_{2}$x$n_{3}$) microcells all of the same shape and size. The BZ integration is performed numerically by summing over each of the microcells. You specify ($n_{1}$, $n_{2}$, $n_{3}$) through _BZ\_NKABC_. Thus the total number of *k* points in the Z is $n_{1}n_{2}n_{3}$. If symmetry operations apply, this number may be reduced.    

A uniform mesh is the optimal general purpose quadrature for analytic, periodic functions, in the following sense. Consider the 1D case; the 3D case is exactly analogous. A numerical quadrature from a set of *n* uniformly spaced points integrates exactly any function representable by a Fourier series of *n* Fourier components or fewer, i.e.   
    
$$f(x)=\Sigma_{i=0:n-1} C_{i}cos(2\pi ix/L) + S_{i}sin(2\pi ix/L)$$

for a function periodic in *L*.      

Thus when integrating analytic functions, such as the single particle sum for the energy bands of an insulator, the uniform mesh is a good general purpose quadrature. In order to return the discussion to the three dimensional BZ, make the substitution $i \if G$ where **G** is a reciprocal lattice vector (some integer multiple of $G_{1}$, $G_{2}$, $G_{3}$). The band energy can be represented in a Fourier series 

$$E(k)=\Sigma_{T} C_{T}e^{2\pi i k \dot T}$$

**k** is the analog of *x*; it is periodic in the **G** vectors. Provided that the Fourier coefficients $C_{T}$ decay exponentially with \|**G**\|, integration with a uniform quadrature converges exponentially with the number of **k** points. $C_{T}$ does more or less decay this way, typically. In one-band tight-binding theory $C_{T}$ would correspond to a hopping matrix element a separated by distance 1/\|**G**\|. For each of the $G_{1}$, $G_{2}$, $G_{3}$ directions independently, there are two ways to choose a uniform mesh: it may contain a point that coincides with the origin, or it is offset so that the points straddle the origin. You specify this choice through _BZ\_BZJOB_. Under what circumstances does this matter? For band calculations the main reason is that sometimes a staggered mesh will yield fewer irreducible *k* points, even while the total number of points is unchanged. In the somewhat different context of linear response calculations, the response function as **q**$\if 0$ is difficult to treat. The *GW* code has an option to supply a staggered *k* for calculating $\eta(r,r',\omega)$. Sometimes an offset mesh can significantly improve matters. One striking example of this is the recently discovered solar cell material, NH4PbI3.

_Note:_{: style="color: red"}: Meshes generated by _BZ\_NKABC_ and _BZ\_BZJOB_ are identical to meshes generated by the Monkhorst Pack scheme, with suitably chosen parameters. But the present specification is simpler and more transparent.

#### _The Singe Particle Sum_

 Numerical integration over the BZ is necessary for band calculations,
to obtain charge densities and the sum of single particle energies for
total energy. The single-particle sum is the energy-weighted integral of
the density-of-states *D*(*E*), 

$$E_{band} = \int_{-\infinity}^{E_{F}} ED(E)dE = \int_{-\infinity}^{\infinity} f(E)ED(E)dE$$

where  *f*(*E*) is the Fermi function.  *D*(*E*) itself is given by a sum over eigenstates *i* as  *D*(*E*) = $\Sigma_{i}\delta(E-E_{i})$. In a crystal with Bloch states, **k** is a good quantum number we can write it as an integral over the BZ for each band: 

$$D(E) = \frac{V}{(2\pi)^{3}}\sum_{n} \int_{BZ} \delta \left(E_{n}(k) - E \right)d^{3} \bf k$$. 

When the material is an insulator, sum over occupied states means sum over all the filled bands. Then *E*band can be written simply as 

$$E_{band} = \frac{V}{(2\pi)^{3}}\sum_{BZ} E_{n}(k)d^{3}k$$

Each band is an analytic, periodic function of **k**, so numerical integration on the uniform mesh enables the band sum to converge with the **k** mesh in proprtion to how quickly the $C_{T}$ of the fourier series above decay.   

For a metal the situation is more complicated. There is an abrupt truncation of the occupied part of the band at the Fermi level $E_{F}$. At 0K the behavior is non-analytic; at normal finite temperatures the non-analyticity is only a little softened.
 
### _Choices in Numerical Integration Methods_

The band codes have three integration schemes that determine integration weights for every QP level at each **k**.   

1. Tetrahedron integration, enhanced by Peter Bloechl's improved treatment of the Fermi surface. It divides space into tetrahedra (there are 6 tetra for each parallelepiped) and interpolates the energy linearly between the points of the tetrahedron. To use the tetrahedron integration scheme, set _BZ\_TETRA_.
2. [Gaussian-broadened sampling integration](#sampling), as extended by [Methfessel and Paxton][1]. The basic idea of Gaussian broadening is that a quasiparticle level, which is a δ-function of the energy in band theory, is smeared out into a Gaussian function. This makes properties analytic again. Methfessel and Paxton extended definition of the δ-function from the traditional choice of a simple Gaussian of width w, to the product a Gaussian and a Hermite polynomial of order 2N. The resulting form of δ-function has a richer shape: it is still peaked at the quasiparticle level and decays as a Gaussian, but it oscillates as it decays. The generalized gaussian can rather dramatically improve convergence, as we show below. To use this method, turn off the tetrahedron method (_BZ\_TETRA_=0) and specify N and w with _BZ\_N_ and _BZ\_W_
3. Fermi-Dirac-broadened sampling integration. This is the correct description for finite temperature. But for rapid convergence, artificially high temperatures are often used. To employ FD sampling, turn off the tetrahedron method (_BZ\_TETRA_=0) and set _BZ\_N_=−1. This tells the integrator to broaden the QP level with the (derivative of a) Fermi Dirac function instead of a Gaussian function. Specify the electron temperature $k_{b}T$ through _BZ\_W_ (in Ry). For a test case that illustrates Fermi-Dirac sampling, try

        fp/test/test.fp copt

#### _Tetrahedron Integration_
For self-consistent LDA calculations, Blöchl-enhanced tetrahedron integration is usually the method of choice for small metallic systems. The Figure on the left shows the power of the tetrahedron integration, especially when enhanced with the Bloechl weights. It shows the integration error Δ*E* in the Harris-Foulkes total energy for a fixed density (equivalent to the convergence of the single-particle sum) in MnBi, as a function of the number of *k* divisions. The *x* axis is scaled so that points are uniformly spaced in 1/*n*2 with the origin corresponding to *n*=∞. MnBi forms in the NiAs structure, which is hexagonal with *c*/*a* slightly less than 3/2. Accordingly, the number of divisions along the three directions was chosen to be (*n*,*n*,2*n*/3), for an approximately uniform mesh spacing in the three directions. With Bloechl corrections, the single particle sum is converged to better than 2 μRy at 48 divisions. Without the Bloechl correction term this term convergence is only 100 μRy at 60 divisions. The integration error from the regular tetrahedron method scales as 1/*n*2; the Bloechl correction knocks out the leading 1/*n*2 term, as is evident from the Figure. For a simple band the scaling improves to 1/*n*3.   

There are caveats to keep in mind with respect to this method. Sometimes a pair of bands can cross near $E_{F}$. The tetrahedron integrator, which must interpolate a single band between the four corners of a tetrahedron, expects the band to behave in an analytic way. If two bands cross inside the tetrahedron, the both the lower band and upper band are non-analytic (in reality both are analytic but the integrator isn't smart enough to detect that there is a band crossing and switch the levels). When this occurs usually the integrator yields a non-integral number of electrons. It will detect this and print out a warning message:

    (warning): non-integral number of electrons --- possible band crossing at E_f

When you get this message usually (not always!) it is because of a band crossing problem. As you proceed to self-consistency it may go away. If not, you need to modify your **k** mesh. The larger the system with a denser mesh of bands, the more serious this issue becomes.   

Another drawback with the tetrahedron scheme is that *all* the eigenvalues must be known before the weight for any one can be determined. This is because integrals are done over tetrahedra, each of which involves four **k** points. Thus unless some trickery is used, *two* band passes are required: one pass to get all the eigenvalues to determine integration weights, and a second pass to accumulate quantities that depend on eigenfunctions, such as the charge density. The FP code has a "mixed" scheme available: the charge density is calculated by sampling while the band sum is calculated by the tetrahedron method. This avoids a double band pass, and is effective because, thanks to the variational principle, density can be evaluated to less precision than $E_{band}$.  

#### _Sampling_

As the mesh spacing becomes infinitely fine (*n*→∞), the quadrature estimate for integrated property of interest (e.g. $E_{band}$) becomes independent of *n*. But with sampling the converged result at the 1/*n*→0 limit is not exact, but depends on w: the exact (or 0K) result is obtained only for *n*→∞ and w→0. This should be immediately obvious on physical grounds: the band energy should depend e.g. on temperature. Thus with sampling there are two independent issues to contend with: how rapidly the result converges with *n*, and the error in the converged result. These issues are not entirely independent: how rapidly the quadrature convergences with *n* also depends on w: the larger w, the more rapid the convergence. This is also easy to understand: the greater the broadening, the smoother and more analytic the behavior at $E_{F}$. 

##### _Methfessel-Paxton sampling_
If the δ-function is broadened with a gaussian in the standard manner, good results are obtained only when _w_ is very small, and the situation would seem to be hopeless. What saves the day is [Methfessel and Paxton's \[1\]](#references) generalization of the broadening function. It starts from the representation of the exact δ-function as bilinear combinations of Hermite polynomials and a gaussian

$$ \delta(x) = \lim_{N \to \infinity} D_{N}(x), D_{N}(x) = \sum_{m=0}^{N} A_{m}H_{2m}(x)e^{-x^{2}}$$

Standard gaussian broadening represents δ(*x*) by the *m*=0 term alone. But by truncating the series at some low order N larger than 0, better representations of the δ-function are possible (figure above, right) and the integration quality can be dramatically improved. $E_{band}$ can be well converged without requiring an excessively small _w_.      

Choosing *any* N>0 can dramatically improve the quality of sampling integration. The figure on the left shows how |Δ*E*| for MnBi depends on N, for a relatively coarse *k* mesh (*n*=12), a very fine one (*n*=90), and intermediate one (*n*=42). For the coarse mesh no advantage is found by varying _N_. This is because the *k* mesh integration error (i.e. the number of $C_{T}$ in Eq.(1) integrated exactly by the mesh is finite, and essentially equal to $n_{1}n_{2}n_{3}$) is larger than the error originating from approximations to the δ-function. For the intermediate mesh (*n*=42) the situation is a bit different. If N=0, the approximation to the δ-function dominates Δ*E*: increasing N from 0→1 reduces it by a factor of almost 100! But increasing N above 1 has no additional effect: the error remains fixed in the 3-4μRy range. It has already become dominated by the fineness of the *k*-mesh, any adequate (_N_≥1) representation of the δ-function will serve equally well. Not insignificantly, Δ*E* from the tetrahedron method is in the same range (4μRy). For the very fine mesh (*n*=90) much the same story appears, only now that the transition from Δ*E* being dominated by δ-function error to the discreteness of the *k* mesh doesn't occur until N=4. Because the mesh is so fine, Δ*E* is tiny, of order 0.1μRy. MP makes it possible to perform quality integrations with sampling. The right figure shows the MnBi test case, now fixing w at 0.015 and varying N. (N=0 is not shown: Δ*E* is a couple orders of magnitude larger for this w.) In the *n*→∞ limit, increasing the polynomial order _N_ has an effect somewhat analogous to decreasing _w_. The discrepancy with the exact (0K) result decreases, but the quadrature converges more slowly with *n*.    
 
There is tradeoff: another parameter is available to tinker with. Δ*E* is now a function of an additional variable: $\Delta E = \Delta E(n_{1},n_{2},n_{3},N,w)$. The optimum combination of ()$n_{1},n_{2},n_{3},N,w$) depends on the precision you need and computer time available. While there is no universal prescription that can be worked out in advance, the following guidelines seem to work fairly well: 

1. Choose the ratios $n_{1}:n_{2}:n_{3}$ as closely as possible to the ratios $G_{1}$:$G_{2}$:$G_{3}$, where the latter are the lengths primitive reciprocal lattice vectors.
2. Use at least N =1 and unless you are looking for energy resolution (see next section) preferably N=3 or 4 with w~0.01. There doesn't seem to be much downside to using a sizeable N, but there can be a significant gain.
3. If you want very hiqh quality integration, use a fine mesh with w~0.005 and N around 3 or 4.

### _Comparing Sampling to Tetrahedron Integration_
Which method should you choose? The answer depends strongly on context. 

#### _Response Functions_      
Consider first the calculation of quantities that involve transitions between two states, such as the joint density-of-states or dielectric function. The Figure on the right compares Im ε(ω) calculated for Ag, tetrahedron to MP sampling (_N_=1, W=0.02). Calculations for 24, and 48 *k* divisions are shown. The sharp shoulder at 0.2 Ry marks the onset of transitions from the Ag *d* states to conduction band states. This shoulder is seen in experiment, at a slightly higher energy; this is because the LDA puts the Ag *d* states too shallowly.    

In the tetrahedron case, doubling the mesh affects Im ε(ω) only slightly, showing that it is already well converged at 24 divisions. Sampling with 24 divisions shows Im ε(ω) oscillating around the converged result. With 48 divisions, the oscillations are much weaker, but you can still see Im ε(ω) dip below 0 just before the onset of the shoulder, and round off the first peak around ω=0.28 Ry.    

It is possible to get good definition in Im ε(ω) via MP sampling, by increasing N or reducing W, or some judicious combination of the two.
However, many more _k_-points are required. The left hand figure shows
that Im ε(ω), calculated with _N_=1, W=.01, can pick up the shoulder at ω=0.28 Ry, but there is ringing around the converged result. This is because *D*$_{N}$(*x*) oscillates around 0 for N≥1, as seen in the figure for *DN*([sampling section](#sampling)). Increasing *n* to 96 divisions yields Im ε(ω) with definition almost as good as the tetrahedron method. In general, the larger _N_ you choose, the better definition you will have if your k mesh is sufficiently fine. But the larger _N_, the more 'wiggly' response function will be when you haven't converged the *k* mesh sufficiently.     

Generally speaking, for linear response calculations the tetrahedron method is superior. But, be advised: 

*Note:*{: style="color: red"} the existing implementations of tetrahedron may have a problem for tetrahedra that contain multiple bands crossing $E_{F}$. We have not fully understood the problem yet, but have discovered that for some metals, (e.g. a four-atom supercell of Ag), a spurious peak in Im ε(ω) can appear for ω→0. A peak actually should exist there, but it originates from the Drude term which is not properly accounted for in this method. So if the peak appears, it does so for spurious reasons. 

#### _The Self Consistency Cycle_
BZ integration is also required to make the ordinary density-of-states (either total, or resolved by orbital) for the self-consistency cycle or to calculate the single-particle sum for total energy. Here also tetrahedron integration is generally superior, and is usually preferred unless problems arise, e.g. issues with band crossings.    

Nevertheless there are circumstances where sampling is a better choice, even apart from the band crossing issue. To calculate the shear modulus of Al, tetrahedron integration requires a very fine *k* mesh. But doing integrations with Fermi Dirac statistics at a rather high temperature, rapidly convergent results can be obtained. To check convergence you can use several temperatures and extrapolate to 0K.    

Another example is the magnetic anisotropy. As with the Al shear constant, it is the absolute value of the energy (mostly single particle sum) that matters, but its variation with some perturbation such as a shear or the addition *L*·*S* coupling to the hamiltonian. In such cases the error of the energy *difference* can be smaller, and more stable, with a suitably chosen sampling method. The table below shows the magnetic anisotropy, in Ry, for CoPt in the L10 structure, using a *k* mesh of 30x30x24 divisions. (A check was made with 40x40x32 divisions using sampling, and essentially the same results were found.) Calculations were carried out in the LDA with both tetrahedron and sampling methods, either by evaluating the change in the Harris-Foulkes total energy, or by calculating the energy through coupling constant integration of *L*·*S*. Calculations were both of the non-self-consistent variety (frozen density at some suitable starting point) and also self-consistent. While all the numbers are fairly similar, there is more variation in the tetrahedron results. Note especially the '_ehf' and 'cc-int' column. They should give the same answer in all cases.

              
                                                     ehf(tet)   cc-int(tet)  ehf(samp)  cc-int(samp) 
    non self-consistent, rho from L.S=0             -0.000084   -0.000077   -0.000078   -0.000077  
    non self-consistent, rho from full L.S || z     -0.000076   -0.000069   -0.000075   -0.000075    
    self consistent with 8 symmetry operations      -0.000077   -0.000070   -0.000078   -0.000078    
    self consistent with no symmetry                -0.000078               -0.000077   -0.000076  

### _References_

[1]: [M. Methfessel and A.T. Paxton, Phys. Rev. B, 40, 3616 (1989)](http://link.aps.org/doi/10.1103/PhysRevB.40.3616)
[2]: [P.E. Bloechl, O. Jepsen and O.K. Andersen, Phys. Rev. B 49, 16223 (1994)](http://link.aps.org/doi/10.1103/PhysRevB.49.16223)