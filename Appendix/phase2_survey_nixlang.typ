
#set text(lang: "es")

#set page(
  paper: "a4",
  number-align: center,
  numbering: none
)

#set text(
  size: 11pt,
)

#set par(
  justify: true
)

#let linkert(
  pairs: (), 
  grades : 7) = {
  
  let columns = (auto,) + (1fr,) * grades + (auto,)
  
  let rows = ()
  
  for pair in pairs {
    let (left, right) = pair
    rows.push(table.cell()[#left])
    for i in range(grades) {
      rows.push(table.cell(align: center)[#box(width: 0.45cm, height: 0.45cm, stroke: 0.7pt + black, radius: 1pt)
])
    }
    rows.push(table.cell()[#right])
  }

  table(
    stroke: none,
    columns: columns,
    align: center,
    fill: (x, y) => if calc.odd(y) { luma(245) } else { white },
    ..rows
    )
}


#align(center)[= Evaluación de Nix Lang]

Gracias por tu tiempo. Con tu ayuda, nos gustaría examinar como usuarios perciben la usabilidad de _Nixlang_. Esto nos ayudara a encontrar areas de optimización de una manera que sea tan eficiente y comprensible como sea posible.

No te detengas demasiado en las combinaciones de palabras y realiza tu evaluación de forma espontánea. Puede que algunas combinaciones no te parezcan del todo adecuadas para el producto. Sin embargo, te pedimos que des tu opinión de todos modos. Recuerda que no hay respuestas correctas ni incorrectas; lo que cuenta es tu opinión personal.

*¿ Cómo calificarias la experiencia de usuario de NixLang?*

#linkert(pairs: (
    ("Bueno", "Malo"),
  ),
  grades: 7
)

*¿ Qué tan bien NixLang respondió a tus necesidades?*

#linkert(pairs: (
    ("Para nada", "Completamente"),
  ),
  grades: 7
)

*Con la ayuda de los pares de palabras marca cual considerarias seria la descripción para NixLang.*
#linkert(pairs: (
    ("Malo", "Bueno"),
    ("Feo", "Bonito"),
    ("Recomendable", "No recomendable"),
    ("Confuso", "Estructurado"), 
    ("Practico", "Impráctico"),
    ("Impredecible", "Predecible"),
    ("Simple", "Complicado"),
    ("Antipático", "Cautivador"),
    ("Elegante", "Tosco"),
    ("Barato", "Prémium"),
    ("Elegante", "Tosco"),
    ("Creativo", "No Imaginativo"),
    ("Eficiente", "Ineficiente"),
    ("Flexible", "Rígido"),
    ("Facil de aprender", "Díficil de aprender"),
    ("Limitado", "Extensivo"),
    ("Desinformativo", "Informativo"),
    ("Motivador", "Desmotivador"),
    ("Genera respeto", "Genera desconfianza"),
    ("Agradable", "Desagradable"),
    ("Promueve la creatividad", "Suprime la creatividad"),
    ("Envolvente", "Aburrido"),
    ("Me acerca a otros", "Me aleja de otros"),
  ),
  grades: 7
)

*¿Algún comentario adicional que quieras destacar sobre tu experiencia usando Nixlang? (Opcional)*