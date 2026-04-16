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
  numbering: none
)

#set text(
  size: 11pt,
)

#set heading(
  numbering: "1.a."
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
  #text(size: 16pt)[#smallcaps()[Universidad del valle de guatemala\
  Facultad de Ingeniería]]

  #v(30pt)

  #image("media/UVG-Logo.jpg", width: 45%)

  #v(30pt)

  #title()

  #v(50pt)

  
  Trabajo de graduación presentado por Daniel Alfredo Rayo Roldán para optar al grado 
  académico en Ingeniería en Ciencias de la Computación y Tecnologías de la Información
]

#pagebreak()
// ============ CONTENT

#outline()

#set page(
  paper: "a4",
  number-align: center,
  numbering: "1"
)
#counter(page).update(1)

= Resumen

#lorem(50)

= Introducción

#lorem(120)

= Objetivos

== General

#lorem(30)

== Específicos

+ sadfasdf
+ sdfasdf
+ asdfsdf

#pagebreak()

= Marco Teórico

#lorem(120)

#bibliography(title: "Referencias", ("ref.yml", "ref.bib"))