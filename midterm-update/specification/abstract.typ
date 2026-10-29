#import "../specification/settings.typ": *


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

    [*Expressions*], $bb(E) ∋ e$, $colon.double.eq$, $dots.h$, [],
    ..bar, $op("SchemaDecl")(x, tau, e)$, [],
    ..bar, $op("PacketDecl")(x, tau, e)$, [],

    grid.cell(colspan: 5)[#v(0.3em)],

    [*Field Type*], $beta$, $colon.double.eq$, $op("BitT")(n)$, [],
    [*Types*],
    $bb(T) ∋ tau$,
    $colon.double.eq$,
    $op("SchemaT")(lr(
        [
          (x_1, beta_1), thin dots.h, thin (x_k, beta_k)
        ]
      ))$,
    [],

    ..bar,
    $op("PacketT")(tau, lr(
        [
          (x_1, v_1), thin dots.h, thin (x_m, v_m)
        ]
      ))$,
    [],

    ..bar,
    $op("PolicyT")(tau_"in", tau_"out")$, [],

    grid.cell(colspan: 5)[#v(0.3em)],

    [*Identifiers*], [], [], $x in bb(X)$, tag("String"),
    [*Number*], [], [], $n in bb(Z)_+$, tag("Number"),
    [*Bit*], [], [], $v in lr({0, 1}^+)$, tag(""),
  )
]
