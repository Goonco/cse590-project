#import "./settings.typ": *

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
    row-gutter: 0.8em,
    align: left + top,
    ..rules.pos().flatten(),
  )
]

The concrete syntax of #tk is written in a variant of the extended Backus–Naur form (EBNF). The notation #nt("nt") denotes a nonterminal, and #t("t") denotes a terminal. We use #raw("?") for an optional element, and #raw("+") and #raw("*") for one or more and zero or more repetitions, respectively. We use #buttnot to exclude strings from a producible set, and the ellipsis $(dots.h)$ to omit obvious alternatives. The fragment specified here supports packet declarations, policy bindings, exact-match filters, modifications, union, and sequential composition.

#grammar-table(
  rule("program", [#t("schema") #nt("id") #t("=") #t("{") #nt("field-decl")#raw("+") #t("}") #t("in") #nt("expr")]),

  rule("expr", [#nt("id")], [#t("schema") #nt("id") #t("=") #nt("schema") #t("in") #nt("expr")], [#t("let") #nt(
      "id",
    ) #t(":") #nt("schema") #t("->") #nt("schema") #t("=") #nt("policy") #t("in") #nt("expr")]),

  // [#t("{") #nt("field-decl")#raw("+") #t("}")],

  rule(
    "schema",
    [#nt("id")],
    [#t("(") #nt("schema") #t(")")],
    [
      #nt("schema") #t("&")
      #t("{") #nt("field-binding")#raw("*") #t("}")
    ],
    [#nt("schema") #t("|") #nt("schema")],
  ),

  rule("field-decl", [#nt("id") #t(":") #t("Bits") #t("[") #nt("number") #t("]")]),

  rule("field-binding", [#nt("id") #t("==") #nt("field-val")]),

  rule("field-val", [#nt("number")], [#nt("binary")], [#nt("hex")], [#nt("ipv4")]),

  rule(
    "policy",
    [#t("0")],
    [#t("1")],
    [#nt("id")],
    [#nt("id") #t("~") #nt("field-val")],
    [#nt("id") #t(":=") #nt("field-val")],
    [#t("dup")],
    [#t("(") #nt("policy") #t(")")],
    [#t("!") #nt("policy")],
    [#nt("policy") #t("*")],
    [#nt("policy") #t(";") #nt("policy")],
    [#nt("policy") #t("+") #nt("policy")],
  ),
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

  rule(
    "keyword",
    [#t("schema")],
    [#t("let")],
    [#t("Bits")],
    [#t("in")],
    [#t("dup")],
  ),
)

#block(breakable: false)[
  For policies, operator precedence and associativity are defined as follows. Higher precedence values indicate tighter binding. Parentheses override the default grouping.

  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      stroke: 0.5pt + black,
      inset: (x: 12pt, y: 4pt),

      table.header([Operator], [Associativity], [Precedence]),

      [#raw("*") (postfix)], [left], [4],
      [#raw("!") (prefix)], [right], [3],
      [#raw(";")], [left], [2],
      [#raw("+")], [left], [1],
    )
  ]
]
