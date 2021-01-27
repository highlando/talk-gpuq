---
author: 
 - Jan Heiland (MPI Magdeburg)
 - Peter Benner (MPI Magdeburg)
title: Space and Chaos-Expansion Galerkin POD for UQ of PDEs with Random Parameters
title-slide-attributes:
    data-background-image: pics/MPI_bridge.jpg
parallaxBackgroundImage: pics/csc-en.svg
parallaxBackgroundSize: 1000px 1200px
---
# Introduction

---

## Example Problem Setup

 * The *heat equation* with uncertainty in the coefficient $\kappa$:
$$
-\kappa(\alpha) \Delta y = f,
$$
where $\alpha$ is a random variable.

 * Then, *the* solution $y$ is a random variable depending of $\alpha$.

 * Of interest
 $$
 \mathbb E_\alpha y
 $$
 the expected value of the solution $y$.

## Sampling Approach (Monte Carlo)

1. Draw a sample of $\alpha$: $$(\alpha^{(1)}, \alpha^{(2)}, \alpha^{(3)}, \alpha^{(4)})$$

2. Compute the sample of $y(\alpha)$:  $$(y(\alpha^{(1)}), y(\alpha^{(2)}), y(\alpha^{(3)}), y(\alpha^{(4)}))$$

3. Compute the empirical expected value
$$
\hat {\mathbb E}_\alpha = \frac{1}{4}(y(\alpha^{(1)})+ y(\alpha^{(2)})+ y(\alpha^{(3)})+ y(\alpha^{(4)}))
$$

## Collocation/Galerkin Approaches

1. *Discretize* the uncertainty, e.g., by shape functions $\eta_i$
$$
\hat y(\alpha) = \sum_{i=1}^4 y_i \eta_i(\alpha)
$$

2. Compute the coefficient functions $y_i$, e.g., through solving
$$
-\kappa(\alpha^{(i)})\Delta \hat y = f
$$
at given collocation points.

3. Compute the expected value of $\hat y$
$$
\mathbb E_\alpha y \approx \mathbb E_\alpha \hat y = \sum_{i=1}^4 y_i \mathbb E_\alpha \eta_i.
$$

## Overview of approaches

* Monte Carlo Methods

* Galerkin/Collocation Methods


# Multidimensional Galerkin POD

## Setup
$$
\DeclareMathOperator{\spann}{span}
\def\xkotkn{{\mathbf x^{k_1 k_2 \dotsm k_N}}}
\def\Vec{\mathop{\mathrm {vec}}\nolimits}
\def\Ltt{L^2((0,T))}
\def\Lto{L^2(\Omega)}
\def\Ltg{L^2(\Gamma;d\mathbb P_\alpha)}
\def\by{\mathbf y}
$$
Consider a multivariable function $y(t,x;\alpha)$:
$$
y\colon (0,T) \times \Omega \times \Gamma \to \mathbb R
$$

and the separated spaces for time, space, and uncertainty:
$$
\Ltt,\quad \Lto, \quad\text{and}\quad\Ltg.
$$

## Time-Space-PCE Galerkin

Finite dimensional "subspaces":

* $S = \spann\{\psi_1, \dotsc, \psi_s\} \subset \Ltt$,
* $X = \spann\{\phi_1, \dotsc, \phi_r\} \subset \Lto$,
* $W = \spann\{\eta_1, \dotsc, \eta_p\}~`\subset\mspace{-4mu}`~ \Ltg$,

and the Galerkin ansatz in $\by \in S\otimes X \otimes W$:
$$
\by = \sum\sum\sum
$$

---

Consider the discrete product space with bases
$$
    \mathcal V = \prod_{i=1}^N \mathcal V_{i}, \quad
    \mathcal V_i = \spann\{\psi_i^k\}_{k=1,\dots,d_i}, \quad
    \Psi_i:=[\psi_i^1, \dotsc, \psi_i^{d_i}]^T
$$

. . .

and write $x\in \mathcal V$ as
$$
    x = \sum_{k_1 = 1}^{d_1}\sum_{k_2 = 1}^{d_2} \dotsm \sum_{k_N = 1}^{d_N} \xkotkn \psi_1^{k_1}\psi_2^{k_2}\dotsm\psi_N^{k_N}
$$

. . .

or

$$
    x = \Vec(\mathbf X)^T \bigl [\Psi_N \otimes \dotsm \otimes \Psi_2 \otimes \Psi_1 \bigr], \quad \text{where }
    \mathbf X = \bigl[ \xkotkn  \bigr].
$$

## That is...

$$
    x \in \prod_{i=1}^N \mathcal V_{i} \longleftrightarrow \mathbf X \in \mathbb R^{d_1 \times d_2 \times \dotsm \times d_N}
$$

and the tensor $\mathbf X$ can be reduced by 

$$
\text{HOSVD} \longleftrightarrow \text{multidimensional (Galerkin) POD}
$$

# Application Example

## {data-background-image="pics/N7-physregs.png"}

## {data-background-image="pics/N7.png"}

. . .

::: {style="position: absolute; width: 60%; right: 0; box-shadow: 0 1px 4px rgba(0,0,0,0.5), 0 5px 25px rgba(0,0,0,0.2); background-color: rgba(0, 0, 0, 0.9); color: #fff; padding: 20px; font-size: 40px; text-align: left;"}
A generic *convection-diffusion* problem
$$
    b\cdot \nabla y- \nabla\cdot ( \kappa_\alpha \nabla y) = f,
$$
where we assume that the diffusivity coefficient depends on a random vector $\alpha=(\alpha_1, \alpha_2, \alpha_3, \alpha_4)$.
:::

## Ansatz


\def\Hoi{H_0^1(\Omega)}
\providecommand\Ltgi[1]{L^2(\Gamma _ {#1};\nspinva{#1})}
\providecommand{\nspinva}[1]{\mathsf{d} \mathbb P _ {#1}}


Locate the solution $y$ (depending on space $x$ and the random variable
$\alpha$) in
$$
    \Hoi \cdot \Ltgi 1 \cdot \Ltgi 2 \cdot \dotsm \cdot \Ltgi 4.
$$

and use standard FEM and *Polynomial Chaos Expansion* (PCE) for discretization.

## Approach

 * Can train the POD for low-dimensional PCE discretizations

 * And recover, e.g., the expected value of high-order PCE discretizations

 * Speedup factor of about $16$, huge memory savings

## Result {data-background-image="pics/pcepoddiff.png"}

. . .

::: {style="position: absolute; width: 60%; right: 0; box-shadow: 0 1px 4px rgba(0,0,0,0.5), 0 5px 25px rgba(0,0,0,0.2); background-color: rgba(0, 0, 0, 0.9); color: #fff; padding: 20px; font-size: 40px; text-align: left;"}

 * Error in *expected value* over space.

 * Full order model: $5^4 \times 90'000$ (`PCE x FEM`)

 * Red order model: $2^4 \times 90'000$ + $5^4 \times 12$

 * Error level $\approx 10^{-6}$

 * Monte Carlo: No convergence after $10^6 \times 90'000$

:::

# Resources

* Submitted to *Int. J. Numerical Methods in Engineering*

* Preprint: [arxiv:2009.01055](https://arxiv.org/abs/2009.01055)

* Code: [doi:10.5281/zenodo.4005724](https://doi.org/10.5281/zenodo.4005724)

# CSC tech talks

* Idea: A topic and **everyone** brings his workflow

  * can be hand-drawn flow chart

  * plan for 5 minutes presentation time

* In the session, we draw will **randomly choose 3** candidates

* After that, we will discuss the workflows

* Dates and topics:

  * November 26: **paper writing**

  * December 3: **code writing**
