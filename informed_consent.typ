#set page(
  paper: "us-letter",
  numbering: "1",
  margin: 1.5cm
)

#set text(size: 10pt, lang: "es")
#set par(justify: true, leading: 0.75em)

#set heading(numbering: none)
#show heading.where(level: 2): it => {
  v(0.5em)
  text(size: 10pt, weight: "bold", it.body)
  v(0.2em)
}

// ---------- Encabezado ----------
#align(center)[
    #text(size: 10pt, weight: "bold")[Consentimiento Informado - Fase 1]
]

#v(0.5em)

#let campo(label) = text(style: "italic")[#label]

#grid(
  columns: (auto, 1fr),
  row-gutter: 0.6em,
  column-gutter: 0.6em,
  [*PROYECTO:*], [#campo[Nix para todos: Impacto del uso de un lenguaje de propósito general en la usabilidad de Nix]],
  [*Investigador:*], [#campo[Daniel Alfredo Rayo Roldán - 22933]],
  [*Supervisor:*], [#campo[Gabriel Brolo Tobar - gbrolo\@uvg.edu.gt]],
)


// ---------- 1. Introducción ----------
== 1. Introducción

Gracias por considerar participar en nuestro estudio. Este formulario de consentimiento
informado tiene como objetivo proporcionarle información importante sobre el propósito, los
procedimientos y los posibles riesgos y beneficios de participar en este estudio. Por favor, lea
cuidadosamente este documento antes de aceptar participar. Si tiene alguna pregunta, no
dude en preguntar al investigador.

// ---------- 2. Propósito del Estudio ----------
== 2. Propósito del Estudio

El propósito de este estudio es recopilar información sobre *la experiencia de uso en lenguajes de programación*.

La información obtenida en este estudio se utilizará para *comprender las necesidades y puntos de mejorar que tienen los lenguajes de configuración para administración de paquetes de _software_*.

// ---------- 3. Procedimientos del Estudio ----------
== 3. Procedimientos del Estudio

Si decide participar en este estudio, se le pedirá que *proporcione información sobre su experiencia general en desarrollo de software y administración de paquetes*.

El procedimiento tomará aproximadamente *2 hora y 30 minutos* para completarse y hará preguntas sobre *sobre *.

La toma de muestra implicará *responder llenar una encuesta sobre tu conocimiento en manejo de paquetes de _software_ y un prueba de usabilidad en la herramienta Nix*.

// ---------- 4. Posibles Riesgos y Beneficios ----------
== 4. Posibles Riesgos y Beneficios

No se conocen riesgos asociados con la participación en este estudio. Sin embargo, puede
experimentar cierta incomodidad o molestia al responder preguntas sobre temas sensibles o
personales. Los posibles beneficios de participar en este estudio incluyen #campo[inserte los posibles beneficios del estudio].

// ---------- 5. Confidencialidad y Protección de Datos ----------
== 5. Confidencialidad y Protección de Datos

Toda la información recopilada durante este estudio se mantendrá confidencial y anónima.
Los datos se almacenarán de forma segura y solo el investigador y el equipo de investigación
tendrán acceso a ellos. No se utilizará información identificable en ninguna publicación o
presentación que resulte del estudio.

// ---------- 6. Participación Voluntaria ----------
== 6. Participación Voluntaria

La participación en este estudio es voluntaria. Tiene el derecho de negarse a participar o de
retirarse del estudio en cualquier momento sin penalización o pérdida de beneficios a los que
tiene derecho de otra manera.

// ---------- 7. Compensación ----------
== 7. Compensación

#v(0.3em)

Su participación en este estudio será compensada con un caramelo al terminar la actividad.


// ---------- 8. Información de Contacto ----------
== 8. Información de Contacto

Si tiene alguna pregunta o inquietud sobre este estudio, comuníquese con el supervisor del
proyecto en al *contacto ray22933\@uvg.edu.gt* . Si tiene alguna inquietud acerca de sus
derechos como participante de investigación, comuníquese con *Carlos Gabriel Escobar Polanco* al correo cgescobarp\@uvg.edu.gt.

// ---------- 9. Reconocimiento ----------
== 9. Reconocimiento

He leído y entiendo la información anterior sobre el estudio. He tenido la oportunidad de hacer
preguntas y he recibido respuestas satisfactorias. Al aceptar participar en este estudio, doy
libremente mi consentimiento informado para participar en el estudio.

#v(2em)

#grid(
  columns: (1fr,),
  row-gutter: 1.8em,
  [
    Nombre del participante: #box(width: 1fr, line(length: 50%, stroke: 0.5pt))
  ],
  [
    Firma: #box(width: 1fr, line(length: 50%, stroke: 0.5pt))
  ],
  [
    Fecha: #box(width: 1fr, line(length: 50%, stroke: 0.5pt))
  ],
)
