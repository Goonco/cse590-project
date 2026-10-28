#import "settings.typ": *
#show: setup

#h1[Introduction]

#h1[Concrete Syntax]

#let nt(s) = box(
  raw("<") + text(fill: rgb("#0000ff"), raw(s)) + raw(">"),
)
#let t(s) = box(raw("\"" + s + "\""))
#let alt = box(text(fill: rgb("#000000"), raw("|")))
#let defop = $colon.double.eq$
#let buttnot = box(text(fill: rgb("#ff0000"), raw("butnot")))

The concrete syntax of #tk is written in a variant of the extended Backus–Naur form (EBNF).
The notation #nt("nt") denotes a nonterminal, and #t("t") denotes a terminal.
We use #raw("?") to denote an optional element and #raw("+") (or #raw("*")) to denote one or more
(zero or more) repetitions of the preceding element. We use #buttnot to denote a set difference to exclude some strings from a producible set of strings.
We omit some obvious terminals using the ellipsis $(dots.h)$ notation.


#block(
  width: 100%,
  inset: 12pt,
  stroke: 0.5pt + black,
  breakable: false,
)[
  #show math.equation: set align(left)
  #show math.equation: set block(above: 0pt, below: 0pt)

  #let declr(s) = $& #nt(s) && quad #defop quad$

  $
    #declr("schema-decl") #t("schema") #nt("id") #t("{") #nt("field-decl")#raw("+") #t("}") \
    #declr("field-decl") #nt("id") #t(":") #nt("bits") \
    #declr("bits") #t("Bits[") #nt("number") #t("]") \
    \
    \
    #declr("packet-decl") #nt("id") #t("where {") #nt("field-binding")#raw("+") #t("}") \
    #declr("field-binding") #nt("id") #t("=") #nt("bitval") \
    #declr("bitval") #nt("number") #alt #nt("binary") #alt #nt("hex") #alt #nt("ipv4") \
    #declr("binary") #t("0b") #nt("bit-digit")#raw("+") \
    #declr("bit-digit") #t("0") #alt #t("1") \
    #declr("hex") #t("0x") #nt("hex-digit")#raw("+") #alt #t("0X") #nt("hex-digit")#raw("+") \
    #declr("hex-digit") #nt("digit") #alt #t("a") #alt dots.h #alt #t("f") #alt #t("A") #alt dots.h #alt #t("F") \
    #declr("ipv4") #nt("number") #t(".") #nt("number") #t(".") #nt("number") #t(".") #nt("number") \
    \
    \
    #declr("digit") #t("0") #alt #t("1") #alt dots.h #alt #t("9") \
    #declr("number") #nt("digit")#raw("+") \
    #declr("alphabet") #t("A") #alt #t("B") #alt dots.h #alt #t("Z") #alt #t("a") #alt #t("b") #alt dots.h #alt #t("z") \
    #declr("id_start") #nt("alphabet") #alt #t("_") \
    #declr("id_cont") #nt("id_start") #alt #nt("digit") \
    #declr("id") #nt("id_start") #nt("id_cont")#raw("*") #buttnot #nt("keyword") \
    #declr("keyword")
    \
    \
    #declr("expr") #nt("schema-decl") #alt #nt("packet-decl") \
  $
]


#h1[Abstract Syntax]

The abstract syntax of Typed NetKAT is defined as follows:

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

    [*Types*], $bb(T) ∋ tau$, $colon.double.eq$,
    $op("BitT")(n)$, [],

    ..bar,
    $op("SchemaT")(lr(
        [
          (x_1, tau_1), thin dots.h, thin (x_k, tau_k)
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
    $op("PolicyT")(tau_1, tau_2)$, [],

    grid.cell(colspan: 5)[#v(0.3em)],

    [*Identifiers*], [], [], $x in bb(X)$, tag("String"),
    [*Number*], [], [], $n in bb(Z)_+$, tag("Number"),
    [*Bit*], [], [], $v in lr({0, 1}^+)$, tag(""),
  )
]


#h1[Type System]

$
  Delta in lr(bb(X) ⇀_"fin" bb(T))
$

$
  frac(
    tau = op("SchemaT")(F)
    quad
    Delta[x ↦ tau] ⊢ e : tau,
    Delta ⊢ op("SchemaDecl")(x, tau, e) : tau,
  )
  quad ("T-Schema")
$

#h1[Semantics]

