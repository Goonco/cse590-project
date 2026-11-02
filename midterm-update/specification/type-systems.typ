#import "../specification/settings.typ": *

#let conclusion(s) = $Gamma ⊢ #s$
#let deriv(p, c, nickname) = $frac(#p, conclusion(#c)) quad (#nickname)$

#h1[Type System]

#h2[Type Environments]

$
  "Type Environments" quad
  Gamma = (R, Sigma, Pi) in
  bb(R)
  times lr((bb(X) limits(harpoon.rt)^"fin" bb(S)))
  times lr((bb(X) limits(harpoon.rt)^"fin" bb(T)))
  quad "(TypeEnv)"
$

A type environment $Gamma = (R, Sigma, Pi)$ consists of
three components:

+ A base record $R$ that specifies the packet fields and their
  bit widths.
+ A schema mapping $Sigma$ that maps schema names to their
  definitions.
+ A policy mapping $Pi$ that maps policy names to their types.

We write $R(x)$ for the type of field $x$ in the base record, $Sigma(x)$ for the definition of schema $x$, and $Pi(x)$ for the type of policy $x$.

We write $Gamma[x = sigma]$ for an update to the schema mapping and $Gamma[x : tau]$ for an update to the policy mapping. Each update adds or replaces the corresponding binding and leaves the other components unchanged. The base record $R$ remains fixed throughout the program.

Schema names are expanded using the current environment before a binding is stored. For policy bindings, this expansion applies to both the input and output schemas.

#h2[Type Checking]

#pad(y: 12pt)[
  #align(center)[
    #box(stroke: 0.5pt, inset: (x: 5pt, y: 5pt))[
      $Gamma tack.r e : tau$
    ]
  ]
]

#let rule-flow(gap: 1.5em, row-gap: 1.8em, ..rules) = block(width: 100%)[
  #set align(center)
  #set par(
    justify: false,
    first-line-indent: 0pt,
    leading: row-gap,
    linebreaks: "simple",
  )

  #rules.pos().map(rule => box($display(#rule)$)).join(h(gap, weak: true))
]

#rule-flow(
  gap: 3.0em,
  row-gap: 3.0em,

  $deriv(Gamma tack.r sigma, 0 : top arrow.r bot, ".")$,
  $deriv(Gamma tack.r sigma, 1 : top arrow.r top, ".")$,
  $deriv(x in op("Domain")(R) quad v in lr(⟦ R(x) ⟧), x ~ v : sigma and \{ x = v \}, ".")$,
  $deriv(x in op("Domain")(R) quad v in lr(⟦ R(x) ⟧), x := v : sigma and \{ x = v \}, ".")$,

  $deriv(
    Gamma tack.r rho_1 : sigma_1 arrow.r sigma_2
    quad
    Gamma tack.r rho_2 : sigma_3 arrow.r sigma_4
    quad
    sigma_2 <: sigma_3,
    rho_1 \; rho_2 : sigma_1 arrow.r sigma_4, "."
  )$,

  $deriv(
    Gamma tack.r rho_1 : sigma_1 arrow.r sigma_2
    quad
    Gamma tack.r rho_2 : sigma_1 arrow.r sigma_3,
    rho_1 + rho_2 : sigma_1 arrow.r \(sigma_2 or sigma_3\), "."
  )$,

  $deriv(
    Gamma tack.r sigma
    quad
    Gamma[x = sigma] tack.r e : tau,
    "schema" x = sigma "in" e : tau,
    ""
  )$,

  $deriv(
    Gamma tack.r rho : tau'
    quad
    Gamma[x ↦ tau] tack.r e : tau,
    "let" x : tau' = rho "in" e : tau,
    "."
  )$,
)

$lr(⟦ op("Bit")(n) ⟧) = lr({0, 1}^n)$

#h2[Type Well-Formedness]

The judgment $Gamma tack.r sigma$ states that $sigma$ is a well-formed schema under $Gamma$.

#pad(y: 12pt)[
  #align(center)[
    #box(stroke: 0.5pt, inset: (x: 5pt, y: 5pt))[
      $Gamma tack.r sigma$
    ]
  ]
]

#rule-flow(
  gap: 3em,
  row-gap: 3em,

  $deriv(
    r = R,
    r,
    ""
  )$,

  $deriv(
    x in op("Domain")(Sigma) quad Gamma tack.r Sigma(x),
    x,
    ""
  )$,

  $deriv(
    Gamma tack.r sigma
    quad
    x_i in op("Domain")(R)
    quad
    v_i in lr(⟦ R(x_i) ⟧),
    sigma and (\{x_1 = v_1, dots.h, x_m = v_m\}),
    ""
  )
  quad text("where") m >= 0, forall 1 <= i <= m$,

  $deriv(
    Gamma tack.r sigma_1
    quad
    Gamma tack.r sigma_2,
    sigma_1 or sigma_2,
    ""
  )$,
)

#h2[Schema Subtyping]

Schema subtyping is defined for well-formed schemas over the fixed base record $R$.

We write $lr(⟦ sigma ⟧)_Gamma$ for the set of packets described
by $sigma$ under $Gamma = (R, Sigma, Pi)$.
The base record $R$ describes all packets with exactly its declared fields and bit widths.
A schema name $x$ denotes the set described by $Sigma(x)$. A refinement retains only packets satisfying all its field constraints, and a union denotes the union of its packet sets.

A schema is a subtype of another schema if every packet
described by the former is also described by the latter.

#pad(y: 12pt)[
  #align(center)[
    #box(stroke: 0.5pt, inset: (x: 5pt, y: 5pt))[
      $Gamma tack.r sigma_1 <: sigma_2$
    ]
  ]
]

$
  frac(
    Gamma tack.r sigma_1
    quad
    Gamma tack.r sigma_2
    quad
    lr(⟦ sigma_1 ⟧)_Gamma subset.eq lr(⟦ sigma_2 ⟧)_Gamma,
    Gamma tack.r sigma_1 <: sigma_2
  )
  quad ("S-Subset")
$
