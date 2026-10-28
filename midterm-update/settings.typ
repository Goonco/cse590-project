#let course-code = "CSE 590"
#let course-name = "Advanced Programming Language"
#let title = "Project Midterm Update"
#let names = ("Matthew Song", "Theo Ma")
#let emails = ("songkh@gmail.com", "jane@gmail.com")
#let tk = "Typed NetKat"

#let h1(title) = heading(
  level: 1,
  numbering: "I.",
  title,
)

#let h2(title) = heading(
  level: 2,
  numbering: (section, item) => numbering("a.", item),
  title,
)

#let h3(title) = heading(
  level: 3,
  numbering: (section, item, subitem) => numbering("i.", subitem),
  title,
)

#let h4(title) = heading(
  level: 4,
  numbering: (section, item, subitem, detail) => numbering("1.", detail),
  title,
)

#let setup(body) = {
  set document(
    title: course-code + " — " + title,
    author: names,
  )

  set page(
    paper: "us-letter",
    margin: 1in,
    numbering: "1",
  )

  set text(font: "Libertinus Serif", size: 11pt, lang: "en")
  set par(leading: 0.65em)
  set heading(numbering: none)
  set math.equation(numbering: none)

  show heading.where(level: 1): set text(size: 15pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 12pt)
  show heading.where(level: 4): set text(size: 11pt)

  show heading.where(level: 1): set block(above: 2em)
  show heading.where(level: 1): set block(below: 1em)
  show heading.where(level: 2): set block(above: 2em)
  show heading.where(level: 2): set block(below: 1em)
  show heading.where(level: 3): set block(above: 2em)
  show heading.where(level: 3): set block(below: 1em)
  show heading.where(level: 4): set block(above: 2em)
  show heading.where(level: 4): set block(below: 1em)

  align(center)[
    #text(size: 17pt, weight: "bold")[#title]
    #v(0.3em)
    #course-code · #course-name \
    #for (name, email) in names.zip(emails) [
      #name (#email) \
    ]
  ]

  v(0.8em)

  body
}
