#import "./settings.typ": *

#h1[Abstract Syntax]

The abstract syntax of #tk is defined as follows:

#block(breakable: false)[
  #let tag(name) = raw("(" + name + ")")
  #let bar = ([], [], $|$)

  #grid(
    columns: (auto, auto, auto, auto, auto),
    column-gutter: (1em, 0.6em, 0.4em, 1.2em),
    rows: 1.2em,
    row-gutter: 0.2em,
    align: (left, left, center, left, left),

    [*Expressions*], $bb(E) ∋ e$, $colon.double.eq$,
    $x$, tag(""),
    ..bar, $text("schema") x = tau text("in") e$, tag(""),
    ..bar, $text("let") x : tau = rho text("in") e$, tag(""),

    grid.cell(colspan: 5)[#v(0.3em)],

    [*Field Types*], $bb(B) ∋ beta$, $colon.double.eq$,
    $op("Bit")(n)$, tag(""),

    [*Record Types*], $r$, $in$, $bb(R) = bb(X) limits(harpoon.rt)^"fin" bb(B)$, tag(""),

    [*Schema Types*], $bb(S) ∋ sigma$, $colon.double.eq$,
    $x$, tag(""),
    ..bar, $r$, tag(""),
    ..bar, $sigma and \{x_1 = v_1, dots.h, x_m = v_m\}$, tag(""),
    ..bar, $sigma_1 or sigma_2$, tag(""),

    [*Policy Types*], $bb(T) ∋ tau$, $colon.double.eq$,
    $sigma_1 -> sigma_2$, tag(""),

    grid.cell(colspan: 5)[#v(0.3em)],

    [*Identifiers*], $x$, $in$, $bb(X)$, tag(""),
    [*Number*], $n$, $in$, $bb(Z)_+$, tag(""),
    [*Bit*], $v$, $in$, $lr({0, 1}^+)$, tag(""),
    [*Policies*], $bb(P) ∋ rho$, $colon.double.eq$, $0$, tag(""),
    ..bar, $1$, tag(""),
    ..bar, $x ~ v$, tag(""),
    ..bar, $x := v$, tag(""),
    ..bar, $rho_1 ; rho_2$, tag(""),
    ..bar, $rho_1 + rho_2$, tag(""),
  )
]
