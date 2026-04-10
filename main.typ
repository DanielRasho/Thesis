// ============ SETUP
#set document(
    title: "Usabilidad en Lenguajes de Programación: El caso de Nix", 
    author:"Daniel Alfredo Rayo Roldán",
    keywords: ("Nix"),
    date: auto)

#set text(lang: "es")

#set page(
  paper: "a4",
  number-align: center,
)

#set text(
  size: 11pt,
)

// ============ STYLES
#show heading: it => if it.level == 1 [
    #align(center)[
        #it
    ]
    ] else [
        #it
    ]

// ============ COVER

#align(center)[
  #title()

  #v(12pt)

  Daniel Alfredo Rayo Roldán  

  Universidad del Valle de Guatemala
]

#v(20pt)

// ============ CONTENT

= Abstract

#lorem(50)

= Resumen

#lorem(50)

= Introducción

#lorem(120)

= Marco Teórico

#lorem(120)

#bibliography(title: "Referencias", ("ref.yml", "ref.bib"))