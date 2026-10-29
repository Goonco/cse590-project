#import "../specification/settings.typ": *

#h1[Concrete Syntax]

#let nt(s) = box(
  raw("<") + text(fill: rgb("#0000ff"), raw(s)) + raw(">"),
)
#let t(s) = box(raw("\"" + s + "\""))
#let defop = $colon.double.eq$
#let buttnot = box(text(fill: rgb("#ff0000"), raw("butnot")))

#let declr(s) = $& #nt(s) && quad #defop quad$
#let cont = $& && quad quad$

#let alt = text(fill: rgb("#ff0000"), raw("|"))

#let rule(name, ..alternatives) = {
  let parts = ()

  for (i, alternative) in alternatives.pos().enumerate() {
    parts.push(if i == 0 {
      alternative
    } else {
      box[#alt #alternative]
    })
  }

  (nt(name), defop, parts.join([ ]))
}

#let grammar-table(..rules) = block(
  width: 100%,
  inset: 10pt,
  stroke: 0.5pt + black,
  breakable: false,
)[
  #set par(justify: false, first-line-indent: 0pt)

  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 1em,
    align: left + top,
    ..rules.pos().flatten(),
  )
]

The concrete syntax of #tk is written in a variant of the extended Backus–Naur form (EBNF). The notation #nt("nt") denotes a nonterminal, and #t("t") denotes a terminal. We use #raw("?") for an optional element, and #raw("+") and #raw("*") for one or more and zero or more repetitions, respectively. We use #buttnot to exclude strings from a producible set, and the ellipsis $(dots.h)$ to omit obvious alternatives. The fragment specified here supports packet declarations, policy bindings, exact-match filters, modifications, union, and sequential composition.

#grammar-table(
  rule("expr", [#nt("policy")], [#nt("packet-decl") #t("in") #nt("expr")]),

  rule("packet-decl", [#t("packet") #nt("id") #t("=") #nt("packet-type")]),

  rule(
    "packet-type",
    [#nt("id")],
    [#t("{") #nt("field-decl")#raw("+") #t("}")],
    [#nt("packet-type") #t("&") #t("{") #nt("field-binding")#raw("*") #t("}")],
    [#nt("packet-type") #t("|") #nt("packet-type")],
  ),

  rule("field-decl", [#nt("id") #t(":") #t("Bits") #t("[") #nt("number") #t("]")]),

  rule("field-binding", [#nt("id") #t("==") #nt("field-val")]),

  rule("field-val", [#nt("binary")], [#nt("hex")], [#nt("ipv4")]),
)

#grammar-table(
  rule("binary", [#t("0b") #nt("bit-digit")#raw("+")]),

  rule("bit-digit", [#t("0")], [#t("1")]),

  rule("hex", [#t("0x") #nt("hex-digit")#raw("+")], [#t("0X") #nt("hex-digit")#raw("+")]),

  rule("hex-digit", [#nt("digit")], [#t("a")], [$dots.h$], [#t("f")], [#t("A")], [$dots.h$], [#t("F")]),

  rule("ipv4", [#nt("number") #t(".") #nt("number") #t(".") #nt("number") #t(".") #nt("number")]),

  rule("digit", [#t("0")], [#t("1")], [$dots.h$], [#t("9")]),

  rule("number", [#nt("digit")#raw("+")]),

  rule("alphabet", [#t("A")], [#t("B")], [$dots.h$], [#t("Z")], [#t("a")], [#t("b")], [$dots.h$], [#t("z")]),

  rule("id_start", [#nt("alphabet")], [#t("_")]),

  rule("id_cont", [#nt("id_start")], [#nt("digit")]),

  rule("id", [#nt("id_start") #nt("id_cont")#raw("*") #buttnot #nt("keyword")]),

  rule("keyword", []),
)
