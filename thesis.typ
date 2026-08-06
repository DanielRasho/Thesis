// ==============================================================================
// Plantilla para Trabajos de Graduación IE-MT 2019v3 -- réplica en Typst
// Traducido desde la plantilla LaTeX original (z-main.tex y archivos anexos)
// Autor original de la plantilla: MSc. Miguel Zea
// ==============================================================================
// Este archivo único reúne el contenido que originalmente estaba repartido en
// los archivos .tex (0-datos_estudiante, 1-opciones_adicionales, a-prefacio,
// b-resumen, c-abstract, d-introduccion, ..., o-glosario). Cada sección se
// marca con un comentario equivalente al nombre del archivo .tex original.

// ------------------------------------------------------------------------------
// 0-datos_estudiante.tex -- Datos del estudiante y del trabajo de graduación
// ------------------------------------------------------------------------------
#let nombreestudiante = "Daniel Alfredo Rayo Roldán"
#let uvgcarne = "22933"
#let uvgfacultad = "Ingeniería"
#let uvgcarrera = "Ingeniería en Ciencias de la Computación y Tecnologías de la Información"

#let titulotesis = "Nix para todos: Impacto del uso de un lenguaje de propósito general en la usabilidad de Nix"
#let anoentrega = "2026"
#let nombreasesor = "Ing. Gabriel Brolo Tobar"

#let nombreprimerex = "Dr. Gabriel Antonio Barrientos Rodriguez"
#let nombresegundoex = "Ing. Luis Pedro Montenegro"
#let anoaprobacion = "2026"

#let imagenportada = "media/template/portadacit.jpg"

// ------------------------------------------------------------------------------
// 1-opciones_adicionales.tex -- Capítulos incluidos (todas las secciones se
// incluyen por defecto, igual que en la plantilla original)
// ------------------------------------------------------------------------------

// 
// ============ METHODS

#let cite-range(first, ..middle, last) = {
  cite(label(first))
  for c in middle.pos() {
    box(width: 0pt, text(fill: white, cite(label(c))))
  }
  text("\u{2013}")
  cite(label(last))
}

// ==============================
// METHODS
// ==============================
#import "utilities.typ"

// ------------------------------------------------------------------------------
// Definiciones generales de la plantilla
// ------------------------------------------------------------------------------
#let uvg-green = rgb("#114734")

#set document(title: titulotesis, author: nombreestudiante)
#set page(paper: "us-letter", margin: (top: 1in, left: 1.5in, right: 1in, bottom: 1in))
#set text(lang: "es", size: 11pt)
#set par(justify: true, leading: 0.65em, spacing: 1.2em)

// Numeración de encabezados: capítulo.sección.subsección
#set heading(numbering: "1.1")

// Cuadros (tablas): en español "es" (no "es-MX") la plantilla original usa
// "Cuadro" en vez de "Tabla" para los captions.
#show figure.where(kind: table): set figure(supplement: "Cuadro")
#show figure.where(kind: table): set figure.caption(position: top)

// Estilo de encabezados de capítulo (equivalente a \usepackage[Sonny]{fncychap})
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(1em)
  if it.numbering != none {
    block(text(size: 13pt, tracking: 2pt, fill: uvg-green)[
      CAPÍTULO #counter(heading).display("1")
    ])
    v(0.3em)
  }
  text(size: 20pt, weight: "bold")[#it.body]
  v(0.3em)
  line(length: 100%, stroke: 0.6pt + uvg-green)
  v(1em)
}
#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 14pt, weight: "bold")[#it.body]
  v(0.4em)
}
#show heading.where(level: 3): it => {
  v(0.6em)
  text(size: 12pt, weight: "bold", style: "italic")[#it.body]
  v(0.3em)
}

// Formato de párrafo por defecto (\defaultparformat en la plantilla original:
// espaciado entre párrafos en vez de sangría)
#set par(first-line-indent: 0pt)

// Salto de página en blanco (equivalente a \blankpage), no se usa en la
// versión digital pero se deja disponible.
#let blankpage() = {
  pagebreak()
  [ ]
  pagebreak()
}

// Glosario manual (Typst no trae un paquete de glosarios como
// \usepackage{glossaries}; se simula con un diccionario + funciones gls/Gls).
#let glossary = (
  latex: (name: "latex", desc: "Es un lenguaje de marcado adecuado especialmente para la creación de documentos científicos"),
  formula: (name: "fórmula", desc: "Una expresión matemática"),
)
#let gls(key) = glossary.at(key).name
#let Gls(key) = {
  let n = glossary.at(key).name
  upper(n.slice(0, 1)) + n.slice(1)
}

// ==============================================================================
// PORTADA
// ==============================================================================
#page(
  fill: uvg-green,
  margin: (left: 3cm, right: 3cm, top: 1in, bottom: 0in),
  numbering: none,
)[
  #set text(fill: white)
  #line(length: 100%, stroke: 0.6pt + white)
  #v(0.1in)
  #text(size: 26pt, weight: "bold")[#titulotesis]
  #v(0.3em)
  #line(length: 100%, stroke: 0.6pt + white)
  #v(0.3em)
  #text(size: 18pt)[#nombreestudiante]

  #v(1fr)
  #box(width: 100%, height: 13.25cm)[
    #box(width: 100%, height: 100%, clip: true)[
      #image(imagenportada, height: 13.25cm, width: 100%, fit: "cover")
    ]
    // Logo institucional con fondo (fondologo_grande.png), esquina inferior derecha
    #place(bottom + right, dx: -1cm, dy: -0.2cm)[
      #image("media/template/fondologo_grande.png", height: 1.15in)
    ]
    // TODO: logoUVGblanco.eps -- Typst no soporta el formato EPS de forma
    // nativa. Convierta el archivo a PNG o SVG (por ejemplo con
    // `inkscape plantilla/logoUVGblanco.eps --export-type=svg` o
    // `pdftocairo`/`magick`) y luego descomente e inserte:
    #place(bottom + right, dx: -1.6cm, dy: -0.8cm)[
      #image("media/template/logoUVGblanco.svg", height: 0.55in)
    ]
  ]
]

// ==============================================================================
// CARÁTULA
// ==============================================================================
#page(numbering: none)[
  #align(center)[
    #text(size: 18pt)[UNIVERSIDAD DEL VALLE DE GUATEMALA] \
    #text(size: 18pt)[Facultad de #uvgfacultad]
  ]
  #v(0.75cm)

  #align(center)[
    // TODO: escudoUVGnegro.eps -- Typst no soporta EPS de forma nativa.
    // Convierta el archivo a PNG o SVG y descomente la siguiente línea:
    #image("media/template/escudoUVGnegro.svg", height: 5.5cm)
    #v(5.5cm)
  ]
  #v(0.5in)

  #align(center)[
    #text(size: 15pt, weight: "bold")[#titulotesis]
    #v(1fr)
    #text(size: 13pt)[
      Modalidad de trabajo profesional presentado por #nombreestudiante para optar al
      grado académico de Licenciado en #uvgcarrera
    ]
    #v(1fr)
    #text(size: 12pt)[Guatemala,]
    #v(1em)
    #text(size: 12pt)[#anoentrega]
  ]
]

// ==============================================================================
// HOJA DE FIRMAS
// ==============================================================================
#page(numbering: none)[
  #v(0.5in)
  #text(size: 13pt)[Vo.Bo.:]
  #v(1cm)
  #align(center)[
    #line(length: 4in, stroke: 0.5pt)
    #nombreasesor
  ]
  #v(1in)

  #text(size: 13pt)[Tribunal Examinador:]
  #v(1cm)
  #align(center)[
    #line(length: 4in, stroke: 0.5pt)
    #nombreasesor
    #v(1in)
    #line(length: 4in, stroke: 0.5pt)
    #nombreprimerex
    #v(1in)
    #line(length: 4in, stroke: 0.5pt)
    #nombresegundoex
  ]
  #v(1in)

  Fecha de aprobación: Guatemala, #box(width: 0.5in, line(length: 100%, stroke: 0.5pt))
  de #box(width: 1in, line(length: 100%, stroke: 0.5pt)) de #anoaprobacion.
]

// ==============================================================================
// CONTENIDO DEL TRABAJO -- numeración romana para las primeras páginas
// ==============================================================================
#set page(numbering: "i")
#counter(page).update(1)

// ------------------------------------------------------------------------------
// a-prefacio.tex -- AGRADECIMIENTOS
// ------------------------------------------------------------------------------
#heading(level: 1, numbering: none, outlined: true)[Reconocimientos]

Pendientes

// ------------------------------------------------------------------------------
// b-resumen.tex -- RESUMEN
// ------------------------------------------------------------------------------
#heading(level: 1, numbering: none, outlined: true)[Resumen]

El problema de llevar _software_ de una computadora a otra y que siga funcionando (proceso conocido como Despliegue de _Software_) es un yugo con el que las Ciencias de Computación no han dado una solución definitiva, esencialmente porque para que una pieza de _software_ funcione correctamente no solamente depende del código fuente en el que esta escrita, sino del contexto que le rodea (_hardware_, sistema operativo, dependencias, etc.), bajo ese contexto surgen Nix como un manejador de paquetes y sistema de construcción #footnote[Sistemas que automatizan la ejecución de tareas repetitivas, usualmente para crear artefactos de _software_ que pueden ser desplegados] que utiliza un enfoque inspirado en la pureza funcional, donde cada paquete define explícitamente el contexto en el que espera ser construido y ejecutado. Este enfoque a demostrado poder crear más de 700 mil artefactos binariamente idénticos en diferentes computadoras y contar con unos de los repositorio de paquetes más grande a fecha de este documento. La idea evolucionó al punto de definir el estado casi completo de un sistema operativo mediante un solo archivo de configuración.

Sin embargo, a pesar de sus capacidades prometedoras, Nix no ha gozado de la misma adopción que otras herramientas que abordan los mismos problemas de reproducibilidad como Docker, Conda o VirtualEnv u otros manejadores de paquetes. Las causas de acuerdo a la comunidad son varias: Documentación compleja, errores crípticos, o un lenguaje de programación difícil de dominar; muchos de ellos no siendo problemas técnicos sino de experiencia de uso, y que cae en el rango de estudio del "DX" (Experiencia de Desarrollo por sus siglas en inglés). Este trabajó se enfoca en verificar si proveer una nueva forma de interactuar con Nix a través de un lenguaje de propósito general como Typescript, puede reducir la barrera de entrada para nuevos usuarios y por ende mejorar su DX.

// ------------------------------------------------------------------------------
// c-abstract.tex -- ABSTRACT
// ------------------------------------------------------------------------------
#heading(level: 1, numbering: none, outlined: true)[Abstract]

The problem of moving software from one computer to another and having it keep working (a process known as Software Deployment) is a burden that Computer Science has not yet found a definitive solution to, essentially because for a piece of software to work correctly it depends not only on the source code in which it is written, but also on the surrounding context (hardware, operating system, dependencies, etc.). It is in this context that Nix emerges as a package manager and build system #footnote[Systems that automate the execution of repetitive tasks, usually to create software artifacts that can be deployed.] that uses an approach inspired by functional purity, where each package explicitly defines the context in which it expects to be built and run. This approach has demonstrated the ability to create more than 700,000 binarily identical artifacts on different computers and boasts one of the largest package repositories as of the writing of this document. The idea evolved to the point of being able to define the nearly complete state of an operating system through a single configuration file.

However, despite its promising capabilities, Nix has not enjoyed the same adoption as other tools that address the same reproducibility problems, such as Docker, Conda, VirtualEnv, or other package managers. According to the community, the causes are several: complex documentation, cryptic errors, or a programming language that is difficult to master; many of these are not technical problems but rather user-experience ones, falling within the scope of "DX" (Developer Experience) studies. This work focuses on verifying whether providing a new way of interacting with Nix through a general-purpose language such as TypeScript can lower the barrier to entry for new users and thereby improve its DX.

// ------------------------------------------------------------------------------
// ÍNDICE GENERAL
// ------------------------------------------------------------------------------
#pagebreak()
#heading(level: 1, numbering: none, outlined: true)[Índice]
#outline(title: none, indent: auto)

// ------------------------------------------------------------------------------
// LISTADO DE FIGURAS
// ------------------------------------------------------------------------------
#pagebreak()
#heading(level: 1, numbering: none, outlined: true)[Lista de figuras]
#outline(title: none, target: figure.where(kind: image))

// ------------------------------------------------------------------------------
// LISTADO DE CUADROS
// ------------------------------------------------------------------------------
#pagebreak()
#heading(level: 1, numbering: none, outlined: true)[Lista de cuadros]
#outline(title: none, target: figure.where(kind: table))


// ==============================================================================
// A partir de aquí inicia la numeración arábiga y el conteo de capítulos
// ==============================================================================
#set page(numbering: "1")
#counter(page).update(1)
#counter(heading).update(0)

// ------------------------------------------------------------------------------
// d-introduccion.tex -- INTRODUCCIÓN
// ------------------------------------------------------------------------------
= Introducción

El distribuir _software_ de las cocinas de los ingenieros a las mesas de los usuarios finales no ha sido una tarea sencilla  @mantylaSoftwareDeploymentActivities2011, los artefactos de _software_ se comportan igual a las plantas exóticas cuando son trasplantadas a un hábitat diferente al que están acostumbradas: se marchitan @Dolstra2006. Como las plantas, el _software_ "crece y evoluciona" en el _hardware_, sistema operativo y librerías específicas, de la computadora del ingeniero, pero en el momento que esos artefactos son llevados a los ecosistemas extraños, que son los dispositivos de los usuarios finales, el que funcione o no se vuelve una apuesta ante la que no se tiene control... o si? @Dolstra2006.

El problema anteriormente descrito, es el sujeto de estudio del campo de "Manejo de Configuración de _Software_" (o CSM por sus siglas en ingles), donde se reconoce que la ejecución correcta de _software_ no solamente depende de su código fuente, sino del contexto que le rodea @Dolstra2006. Con los años se ha desarrollado una familia de _software_, llamada *manejadores de paquetes* responsable de modificar el entorno global de las computadoras objetivo para conseguir las condiciones ideales para cada aplicación. Al día de hoy se han convertido en una familia tan variada que se han vuelto una característica diferenciadora en las diferentes distribuciones de Linux o lenguajes de programación @Gibb2026. Una corriente opuesta es la *virtualización*, que consiste en empaquetar las aplicaciones junto a los entornos completos que necesitan y ejecutarlas de forma aislada, soluciones de este tipo son muy usadas en servicios de la nube @PDFInfrastructureCode.

Sin embargo, como se ilustra en la @figura1, los manejadores de paquetes lidian con el problema que intentar satisfacer a varias aplicaciones en un entorno global puede llevar a conflictos irresolubles: cuando `FOO` y `BAR` dependen de versiones distintas de Node, el entorno global obliga a elegir una sola versión compatible (Node v23.8). La virtualización elimina ese conflicto permitiendo que cada aplicación lleve su propia versión en entornos separados, pero a cambio puede duplicar dependencias compartidas como Clang 19.2 @Zwinger2026, incrementando el consumo de almacenamiento @Sobieraj2024 @Lingayat2018.

#figure(image("media/figures/Figure1.svg"), caption: [
  Dependencias de dos programas ficticios `FOO` y `BAR` en manejadores de paquetes vs. virtualización.
])<figura1>

_La unión hace la fuerza_, dando origen en 2003 a Nix como una tercera alternativa que fusiona ideas de ambas corrientes partiendo de la idea que: Usar los mismos ingredientes y pasos debería producir el mismo resultado sin importar la computadora. Nix garantiza lo primero mediante identificadores (ID) únicos en un entorno aislado (_Nix Store_) que, como se ve en la @figura2, permiten la coexistencia de versiones distintas del mismo paquete y la reutilización de dependencias compartidas, resolviendo los problema previos de `FOO` y `BAR`; y lo segundo mediante entornos aislados que aseguran la reproducibilidad @Dolstra2006. La elegancia de Nix reside en cómo construye estos identificadores y entornos aislados.

#figure(image("media/figures/Figure2.svg", width: 70%), caption: [
  Manejo de paquetes en Nix con identificadores únicos permite coexistencia y reutilización de paquetes.
])<figura2>

Fue esta enfoque centrado en seguir recetas explícitas que permitió a Nix conseguir una serie de hitos importantes al contar con unos de los repositorios de paquetes generales más grandes de Linux @marakasovRepositoryStatistics, de los cuales 700 mil han demostrado poder replicarse de forma binariamente idéntica en diferentes computadoras @Malka2025. Aconteció que mucha de las ideas podían generalizarse hasta al punto de reproducir casi por completo un sistema operativo, dando origen a la distribución NixOS @Dolstra2008.

A pesar de ello , Nix ha gozado de una adopción bastante reducida en comparación a las otras herramientas discutidas @stackoverflowMostPopularTechnologies ¿Cuál es entonces su talón de Aquiles? Tal parece que no son necesariamente problemas técnicos, sino de experiencia de uso; en encuestas hechas en el foro oficial, la comunidad resaltaba problemas importantes con la documentación, errores crípticos y un _Domain Specific Language_ (DSL) difícil de dominar @2022NixSurvey2022 @NixCommunitySurvey2023; además, en otra encuesta, se estimó que los usuarios perciben requerir un tiempo de 5 años para dominar la herramienta a pesar que la mayoría lo usa a diario. Llevando a un raro caso donde a pesar que la comunidad le encanta la idea detrás de Nix @NixCommunitySurvey2024  sus problemas de usabilidad son tan severos que podrían estar impidiendo su uso, lo que concuerda con observaciones de otros estudio en herramientas son situaciones similares @goodwinFunctionalityUsability1987.

El concepto que los desarrolladores también son usuarios dio origen al campo de estudio de Experiencia de Desarrollo (o DX por sus siglas en inglés), donde el estudio sobre como los desarrolladores perciben sus herramientas ha sido un tema frecuente @Razzaq2024 sobre el que ya se han desarrollado algunos instrumentos como DEXI para evaluar dichas dimensiones@Kuusinen2016. Y dado el trayecto de intentos por mejorar la DX en Nix #cite-range("caddetNixNickel", "gagarinFourMonthsNix", "hufschmittCurrentStatePtyx", "fricklerhandwerk2022") el presente trabajo, busca ser una aplicación de las técnicas aprendidas en el campo de DX, en conjunto con el diseño de lenguajes, para evaluar si un Lenguaje de Propósito Específico Embebido (eDSL por sus siglas en inglés) en Typescript @Typescript podría ayudar a reducir la barra de entrada para nuevos desarrolladores en la herramienta.

// ------------------------------------------------------------------------------
// f-justificacion.tex -- JUSTIFICACIÓN
// ------------------------------------------------------------------------------
= Justificación

Con el crecimiento del mercado de los servicios de infraestructura como código @grandviewresearchInfrastructureCodeMarket, se ha aprendido que el poder definir el estado de sistemas completos a través de código, trae ventajas importantes en velocidad de desarrollo, escalabilidad y costos @pandyaIntroductionInfrastructureCode2022. La misma idea también se ha aplicado a entornos de desarrollo @ghanbariUsingDevelopmentEnvironment2026 o flujos de despliegue continuo @wesselGitHubActionsImpact2023; todo lo anterior sugiere que herramientas que permiten definir entidades o procesos de forma declarativa pueden facilitar el ciclo de desarrollo de _software_. En el manejo de paquetes, el panorama es fragmentado: habiendo alternativas por lenguaje, o indirectas como Docker @Zwinger2026; y una solución declarativa de propósito general no es de el todo clara. Nix lleva años intentando llenar ese espacio — y las cifras sugieren que esta haciendo algo bien: al tener uno de los repositorios de paquetes más grandes de Linux, con 115 mil paquetes @marakasovRepositoryStatistics un crecimiento del 264% en número de mantenedores en los últimos seis años @gg-solutionsLinuxSilentTech2026.

Por medio de su lenguaje de configuración, Nix permite describir: la construcción, instalación y composición de paquetes de _software_ @Dolstra2006, habilidad que se ha mostrado aplicable en configuración de ambientes de Computación de Alto Rendimiento @guilloteauPainlessTranspositionReproducible2022 @Gomez2020, sistemas operativos @Thiberg2025 despliege de _software_ @VanDerBurg2014, orquestación de servicios @FloxKubernetesUncontained o entornos de desarrollo @replitReplitHowWe2021. 

No obstante, a pesar de su versatilidad, Nix presenta una barrera de entrada considerable. Reportes sugieren una curva de aprendizaje pronunciada @NixCommunitySurvey2024, atribuida en parte a la complejidad de su lenguaje de configuración (Nixlang) para ciertos usuarios @fricklerhandwerk2022, aspecto que también su creador ha identificado como susceptible de mejora @Dolstra2018. Estas dificultades podrían estar incidiendo en su adopción relativamente limitada frente a herramientas como Docker @stackoverflowMostPopularTechnologies.

Nixlang es la principal interfaz para interactuar con el ecosistema Nix, es un lenguaje de dominio específico (DSL por sus siglas en inglés) diseñado  directamente para expresar los constructos de la herramienta, y es, en gran medida, responsable de la flexibilidad que la caracteriza @NixdevDocumentation. Sin embargo, esta misma especialización introduce complejidades que afectan su accesibilidad y usabilidad @Dolstra2018. Como respuesta, la comunidad ha explorado diversas estrategias para mitigar estas limitaciones, como : extensiones al lenguaje, con la incorporación de tipado estático —esfuerzos que han sido abandonados debido a su complejidad técnica— @caddetNixNickel @hufschmittCurrentStatePtyx; agentes de inteligencia artificial para generar configuraciones, aún sin validación empírica sólida en términos de usabilidad @Schwaighofer2026; y, en un enfoque más radical, la sustitución del lenguaje por Guile, un lenguaje de propósito general @Courts2013, aunque tampoco es un lenguaje muy conocido @stackoverflowMostPopularTechnologies, sabiendo que pertenece a la familia de Lisp @IntroductionGuileReference.

Con base en las propuestas anteriores se hizo un análisis comparativo (véase @Appendix1), donde se observa que las soluciones existentes tienden a introducir nuevas fuentes de complejidad o dependen de factores externos, sin abordar las causas estructurales de la fricción en Nix; esto sugiere que un posible buen enfoque consistiría en interactuar con Nix usando un lenguaje ampliamente conocido, y Typescript encaja muy bien en ese molde dada su popularidad @stackoverflowMostPopularTechnologies y similitud sintáctica con Nixlang, siendo descrito en ocasiones como "JSON con funciones" (siendo JSON una notación usada en Typescript) @NixdevDocumentation.

El uso de lenguajes de propósito general para expresar dominios específicos —conocido como lenguaje de propósito específico embebido (eDSL) @vandeursenDomainspecificLanguagesAnnotated2000— no es un enfoque novedoso y ha demostrado ser efectivo en contextos similares. Un caso ilustrativo es Neovim, que en 2021 introdujo un eDSL en Lua como alternativa a Vimscript @NeovimNews112021, lo cual coincidió con un incremento notable en su interés (véase @Appendix2). En el ecosistema de Nix, existe también una propuesta de eDSL en JavaScript ; no obstante, se trata de un proyecto sin actividad reciente, limitado a un subconjunto de funcionalidades —principalmente la creación de paquetes— y sin evidencia empírica que respalde mejoras en la experiencia de desarrollo @burgNiJSInternalDSL2026.

En este contexto, persiste la ausencia de una propuesta que combine un eDSL basado en un lenguaje ampliamente adoptado, con cobertura funcional mas amplia de Nixlang y validación empírica de mejoras en la experiencia de desarrollo.

// ------------------------------------------------------------------------------
// g-objetivos.tex -- OBJETIVOS
// ------------------------------------------------------------------------------
= Objetivos

== Objetivo general
Evaluar si un eDSL en TypeScript reduce la barrera de entrada a Nix —referente funcional y declarativo en gestión de paquetes, limitado por su curva de aprendizaje— frente a Nixlang, mediante tiempo de completación de tareas y experiencia de usuario.

== Objetivos específicos
1. Identificar los principales puntos de dolor cognitivos que presenta el lenguaje de Nix, para fundamentar el diseño de un eDSL, mediante sesiones de pensar-en-alto y "Programación Natural" con estudiantes de Ciencias de la Computación que no hayan utilizado Nix previamente.
2. Desarrollar un eDSL en TypeScript que sirva de prototipo funcional para la evaluación comparativa, capaz de generar archivos de configuración en Nixlang, cubriendo al menos las funcionalidades de la librería estándar, verificado con una batería de pruebas.
3. Comparar Nixlang frente al eDSL desarrollado, para determinar si la familiaridad con Typescript reduce la carga cognitiva de adopción mediante un cuestionario estructurado, y el uso de Short AttrakDiff 2 y DEXI aplicados a estudiantes de Ciencias de la Computación sin experiencia previa, con análisis de diferencia estadística.

// ------------------------------------------------------------------------------
// i-marco_teorico.tex -- MARCO TEÓRICO
// ------------------------------------------------------------------------------
= Marco teórico

- Origenes despliegue de software
- Tipos de dependencias
- Tipos de dependencias
- Problemas enfrentados
- Soluciones existentes

== Despliegue de software

#quote[Uno de de los principios fundamentales de la ingeniería de _sofware_ es promover la reutilización sobre la reimplementación de soluciones existentes.] @jaimeAnalysisEvolutionDependencies, se pueden encontrar indicios de esto en los primeros programas aritméticos en 1947 @goldstainPlanningCodingProblems1947, Y hoy en día a evolucionado a que varias de las herramientas usadas por desarrolladores de sofware dependan en mayor o medida de otros piezas de código desarrollados por terceros como React, Vuejs or Scikit-Learn @jaimeAnalysisEvolutionDependencies. 

Estas piezas de código reutilizable reciben el nombre de librerías, dependencias o paquetes @mensSoftwareEcosystemsTooling2023, y son un método eficaz para disminuir el tiempo de desarrollo y permitir a los desarrolladores a enfocarse en el producto final @societyGuideSoftwareEngineering2026. Programas como Mozilla Firefox, depende de más de 2,000 paquetes @Appendix5; cantidad que se podría volverse complicada de mantener manualmente.

=== Tipos de librerías

=== Manejo de Librerías en Linux


== Nix como solución

=== Intentos para mejorar Nix

== Experiencia de desarrollo

== Transpiladores

=== Como se prueba su usabilidad

= Metodología

La investigación se divide en tres fases ejecutadas de forma secuencial, con el
objetivo de desarrollar y evaluar un lenguaje de dominio específico embebido
(eDSL, por sus siglas en inglés) en TypeScript como alternativa al lenguaje de
configuración original de Nix (en adelante, Nixlang).

\
== Confidencialidad y Seguridad
Todas las fases que involucran participantes humanos se rigen por los siguientes
principios:
- *Participación voluntaria*: La participación es completamente voluntaria. Los
  participantes pueden retirarse en cualquier momento sin consecuencia alguna.
- *Mayoría de edad*: Todos los participantes deben ser mayores de 18 años.
- *Riesgos*: La participación conlleva riesgos mínimos. Los participantes podrían
  experimentar leve fatiga cognitiva o incomodidad al verbalizar su razonamiento
  durante las tareas. Para minimizarlos, las sesiones tienen una duración acotada,
  el participante puede solicitar pausas en cualquier momento.
- *Anonimización:*  Los  datos  recolectados  serán  disociados  de  la  identidad  de  los  participantes mediante el uso de códigos de identificación internos. Ningún dato publicado o analizado contendrá información  que  permita  identificar  a  los  participantes.  Las  transcripciones  de  los  fragmentos verbales citados en el análisis serán igualmente anonimizadas.
- *Responsable del resguardo de datos*: El autor principal de este estudio.
- *Compensación*: Como agradecimiento por su tiempo, los participantes recibirán
  una compensación simbólica en forma de un caramelo al finalizar la sesión. Esta
  compensación no condiciona la participación ni sus respuestas.
Antes de empezar, todos los participantes deberán leer y firmar un
*Consentimiento Informado* en el cual el equipo investigador se compromete a
cumplir los puntos anteriores.

=== Reclutamiento de Participantes
El reclutamiento se realizará mediante visitas a las aulas de estudiantes de quinto año. Los investigadores presentarán el estudio e invitarán a participar de forma voluntaria. Los investigadores no tienen relación docente ni de autoridad con los participantes. La participación o no participación no afectará las calificaciones, evaluaciones, situación académica, relación con docentes ni el acceso a servicios o beneficios institucionales.


=== Codificación de participantes

A cada participante se le asignará un código con el formato `PXX` (por ejemplo, P01, P02 o P03), el cual será utilizado para identificar toda la información recolectada durante el estudio. *Se mantendrá una tabla de correspondencia entre los códigos y la identidad de los participantes*, accesible únicamente al investigador, la cual será eliminada de forma permanente una vez finalizada la recolección de datos de la Fase 3.

=== Almacenamiento y Eliminación de Datos

Toda la información recopilada durante este estudio será tratada de forma confidencial. Los datos serán inicialmente identificados mediante un código asignado a cada participante en una tabla de correspondencia con su identidad y *se almacenarán en una computadora protegida por contraseña, con acceso restringido al investigador; la tabla será eliminada al finalizar la recolección de datos en la fase 3*. 

En la fase 1, las grabaciones de voz, pantalla y sus transcripciones serán almacenadas en la computadora mencionada. En la fase 2, las respuestas de los cuestionarios serán almacenadas temporalmente en un servidor de Amazon Web Services (AWS) y posteriormente transferidas a la computadora del investigador, mientras que las grabaciones de interacción en pantalla serán almacenadas mediante la plataforma Microsoft Clarity. Dado que los cuestionarios no recopilan información que permita identificar a los participantes, el almacenamiento temporal de las respuestas no representa un riesgo significativo para su privacidad. Una vez finalizada la recolección de datos se eliminará la tabla de correspondencia y la información utilizada para el análisis y la presentación de resultados será anonimizada.

Todas las grabaciones, independientemente de la fase del estudio o de la plataforma en la que se almacenen, se conservarán durante un máximo de *cuatro semanas* después de finalizada la recolección de datos y serán eliminadas al concluir ese período. La información anonimizada, incluidas las transcripciones y los datos derivados del proceso de recolección, se conservará durante *16 semanas* para su análisis. La eliminación de todos los archivos será realizada por el investigador al finalizar los períodos de conservación correspondientes.

=== Medidas de Privacidad durante las grabaciones

Durante la fase 1 de investigación, se grabará la pantalla y voces de los participantes durante la actividad, para evitar la captura accidental de información personal los participantes trabajaran en una computadora entregada por el investigador con las aplicaciones necesarias para el ejercicio, el participante podrá acceder a internet solamente desde sesiones en modo incognito y sin permiso a acceder a cuentas personales.

En la fase 2, los participantes accederán al cuestionario web mediante un usuario y contraseña asignados por el investigador. Durante la interacción con el cuestionario se utilizará Microsoft Clarity @MicrosoftClarityFree para registrar únicamente la navegación dentro del sitio web del estudio, incluyendo el movimiento del cursor, los clics realizados, la hora de acceso y el tipo de dispositivo utilizado. No se recopilarán credenciales de acceso, información personal introducida por el participante ni la actividad realizada fuera del cuestionario. Los datos recopilados serán almacenados en la plataforma segura de Microsoft Clarity y estarán accesibles únicamente por el investigador mediante una cuenta protegida. Microsoft Clarity actúa como un servicio de terceros para el procesamiento y almacenamiento de esta información con fines exclusivamente analíticos relacionados con la investigación, de conformidad con sus políticas de privacidad y seguridad.

\
== Fase 1: Investigación preliminar <phase1>
El propósito de la primera fase es identificar los puntos de dolor que tiene Nixlang, siendo la base para construir una solución los reduzca, a través de un estudio cualitativo exploratorio.

=== Población y muestra

Se seleccionan estudiantes de Ciencias de la Computación de entre 18 y 24 años con experiencia limitada o nula en Nix y en el empaquetado de aplicaciones. Esta población fue elegida porque, según la encuesta más reciente de la comunidad Nix , representa el segundo grupo de usuarios más numeroso por edad (26.6%)@NixCommunitySurvey2024. Además, su perfil principiante permite evaluar las barreras de aprendizaje y los desafíos de usabilidad de Nixlang durante las etapas iniciales de adopción.

Se usa una muestra de N=10 participantes, fundamenta en dos precedentes: un estudio pensar-en-alto sobre la experiencia de incorporación en Nix @fricklerhandwerk2022, que empleó la misma metodología con usuarios principiantes y produjo hallazgos relevantes sobre usabilidad de documentación, y un estudio de programación natural @paneStudyingLanguageStructure2001 que utilizó N = 14 para examinar cómo usuarios sin experiencia previa abordan tareas de programación; otro meta estudio sugiera N=10 para investigaciones de este tipo (saturación de relevancia en evaluaciones de usabilidad) @wutichSampleSizes102024. Dado el carácter exploratorio y cualitativo de esta fase, dicho tamaño muestral es apropiado, sin pretensiones de generalización estadística.

=== Instrumentos

- *Formulario de perfil*: Recoge datos sobre la experiencia previa del
  participante con herramientas de gestión de paquetes y lenguajes de
  programación, así como su edad y semestre cursado.
- *Formulario de programación natural*: Disponible en la @Appenddix3, presenta al participante una serie de
  problemas relacionados con el dominio del empaquetado de aplicaciones,
  solicitándole que describa con sus propias palabras un algoritmo para
  resolverlos. Está basado en la técnica de Programación Natural
  @panePDFMoreNatural2006, y se entrega de forma impresa junto con hojas en
  blanco para que el participante responda libremente.
- *Guía de actividades de pensar en alto*: Disponible en la @Appenddix3, Conjunto de tareas a resolver con
  Nixlang, siguiendo el protocolo de pensar en alto @PDFThinkAloud.

=== Procedimiento

Antes de iniciar la sesión, el participante lee y firma el consentimiento
informado y completa el formulario de perfil.

A continuación, se entrega el formulario de programación natural de forma
impresa. Esta actividad se realiza antes de presentar cualquier material sobre
Nixlang, con el propósito de capturar la intuición natural del participante sin
sesgo previo de exposición al lenguaje.

Por último, se inicia la sesión de pensar en alto utilizando una computadora
provista por el investigador. El participante verbaliza su proceso de
pensamiento mientras resuelve las tareas propuestas en Nixlang. Durante esta
sesión se graban la pantalla y el audio, previa autorización explícita en el
consentimiento informado. Si el usuario necesita información de Nix puede puede buscarla en internet, mientras no utilize asistentes de Inteligencia Artificial.

=== Análisis de datos

Los datos recolectados se analizan con los siguientes objetivos: caracterizar el
perfil de los participantes, identificar patrones en sus respuestas de
programación natural, y categorizar los puntos de dolor cognitivos observados
durante las sesiones de pensar en alto. Los fragmentos verbales más
representativos pueden ser citados de forma textual en el análisis, con previa
anonimización. Los hallazgos de esta fase orientaran el diseño del eDSL en la
Fase 2.

\
== Fase 2: Desarrollo del eDSL

Con base en los hallazgos de la Fase 1, se desarrolla un eDSL en TypeScript
capaz de generar archivos de configuración válidos en Nixlang. El diseño del
eDSL buscó abordar directamente los puntos de dolor identificados en la fase
anterior, cubriendo al menos las funcionalidades de la biblioteca estándar de
Nix. Esta fase no involucra participantes humanos y el código fuente se encuentra bajo la licencia MIT @MITLicense.

\
== Fase 3: Evaluación comparativa
La Fase 3 adopta un estudio cuantitativo basado en la ingeniería de software empírica
propuesto por @PDFComparisonXAML2026, adaptado al contexto de
comparación entre un DSL (Nixlang) y un eDSL en TypeScript. La fase se estructura en dos partes: una evaluación de comprensión cognitiva mediante un cuestionario estructurado, y una evaluación de experiencia de desarrollo mediante instrumentos de Experiencia de Usuario.


=== Población y muestra
Se reclutaran participantes con el mismo perfil que la Fase 1 (@phase1): estudiantes de Ciencias de la Computación con escasa o nula experiencia en Nix. Dado el carácter exploratorio del estudio y las limitaciones prácticas propias de una investigación a escala de un investigador, se permitió la participación de sujetos que hubiesen tomado parte en la Fase 1, considerando que ambas fases estuvieron separadas por un período de 3 meses y que las tareas fueron diseñadas de forma independiente, minimizando así posibles efectos de aprendizaje directo. No obstante, esto constituye una limitación del estudio.

Se usa una muestra de N = 20 fue obtenido mediante un análisis de potencia realizado en G*Power @GPower para diseños intra-sujetos comparando medias, asumiendo un tamaño de efecto grande (dz = 0.8, α = 0.05, potencia = 0.90), el cual arrojó un mínimo de 19 participantes, redondeado a 20. Los resultados deben interpretarse en consecuencia y replicarse en trabajos futuros con muestras de mayor tamaño.

=== Instrumentos

- *Formulario de perfil*: Idéntico al utilizado en la Fase 1. Incluye una
  autoevaluación del nivel general de programación, experiencia en TypeScript y
  familiaridad previa con DSLs.
- *Tutoriales de Nixlang y eDSL*: Presentación del dominio del problema (gestión y
  empaquetado de aplicaciones) y de la sintaxis de Nixlang y el eDSL desarrollado, con ejemplos
  representativos.
- *Cuestionarios de comprensión cognitiva*: Disponible en la @Appendix4 Instrumento estructurado con
  preguntas que evaluarán el uso de Nixlang y el eDSL en tres categorías cognitivas basadas en el marco de
  Dimensiones Cognitivas @PDFComparisonXAML2026:
  - *Aprendizaje*: Selección de declaraciones sintácticamente correctas y
    programas válidos para un resultado dado.
  - *Percepción*: Identificación de constructos del lenguaje y
    significados correctos de programas.
  - *Evolución*: Preguntas de tipo ensayo donde se solicita al
    participante expandir, eliminar o modificar la funcionalidad de código
    existente.
  Además también se mide el tiempo de respuesta y tasa de éxito.

- *Encuesta de Satisfacción*: Disponible en la @Appendix4 Instrumento para medir la experiencia de los usuarios, fusiona 3 pruebas estandárizadas: OUX (Evaluación general de experiencia de usuario) @Kuusinen2016, AttrakDiff-2 corto @PDFNeedsAffect y DEXI (Índice de Experiencia de Desarrollo) @Kuusinen2016.

=== Diseño experimental

Se empleó un diseño intra-sujetos en el que cada participante interactuó con ambas herramientas: Nixlang y el eDSL desarrollado. El orden de presentación fue contrabalanceado, de modo que la mitad de los participantes comenzó con Nixlang y la otra mitad con el eDSL, con el fin de controlar posibles efectos de orden. Cada herramienta fue evaluada en una sesión independiente, pudiendo realizarse en días distintos, con el fin de adaptarse a la disponibilidad de los participantes.
=== Procedimiento

Al inicio de cada sesión, el participante firma el consentimiento informado si es su primera sesión, o confirma su continuidad si es la segunda, y completa el formulario de perfil correspondiente. A continuación, se le presenta el tutorial de la herramienta asignada para esa sesión. Una vez revisado el material, el participante responde el cuestionario de comprensión cognitiva.  Inmediatamente al finalizar, completa la encuesta de satisfación evaluando su experiencia con dicha herramienta. Este procedimiento se repite de forma idéntica en la sesión correspondiente a la segunda herramienta.

Durante cada sesión se graban las interacciones del usuario en pantalla, utilizando Microsoft Clarity @MicrosoftClarityFree, la cual ya anonimiza cualquier información sensible, estó con el fin de observar a que secciones el usuario pone más atención.

=== Métricas y análisis de datos

==== Comprensión cognitiva

Para cada cuestionario se calcula la tasa de éxito $S_j$, definida como el
porcentaje promedio de respuestas correctas para cada pregunta $j$. Las
dimensiones cognitivas se evalúan mediante la fórmula:

$ D_i = sum_(j=1)^(N) frac(Q_(i j) dot S_j, C_j) $

Donde N es la cantidad de participantes, $Q_(i j)$ indica si la dimensión $i$ está asociada a la pregunta $j$,
$S_j$ es la tasa de éxito en la pregunta $j$, y $C_j$ es el número de
dimensiones relevantes para esa pregunta @PDFComparisonXAML2026. Las dimensiones evaluadas
incluyen: cercanía de mapeo, viscosidad, dependencias
ocultas, operaciones mentales difíciles, difusión y
expresividad de rol @PDFCognitiveDimensions.

==== Experiencia de desarrollo

Las diferencias entre condiciones en los instrumentos DEXI, OUX y AttrakDiff se
analizan mediante la prueba no paramétrica de Mann-Whitney, apropiada dado el
tamaño reducido de la muestra.
#pagebreak()

// ------------------------------------------------------------------------------
// k-conclusiones.tex -- CONCLUSIONES (sin contenido en el original)
// ------------------------------------------------------------------------------
= Conclusiones

// ------------------------------------------------------------------------------
// l-recomendaciones.tex -- RECOMENDACIONES (sin contenido en el original)
// ------------------------------------------------------------------------------
= Recomendaciones

// ------------------------------------------------------------------------------
// m-bibliografia.bib -- BIBLIOGRAFÍA (estilo IEEE, igual que el original)
// ------------------------------------------------------------------------------
#heading(level: 1, numbering: none, outlined: true)[Bibliografía]
#bibliography("ref.bib", title: none, style: "ieee")

// ------------------------------------------------------------------------------
// n-anexos.tex -- ANEXOS
// ------------------------------------------------------------------------------
= Anexos
#include "annex/annex.typ"

// ------------------------------------------------------------------------------
// o-glosario.tex -- GLOSARIO
// ------------------------------------------------------------------------------
#pagebreak(weak: true)
#heading(level: 1, numbering: none, outlined: true)[Glosario]

// Typst no incluye un paquete de glosarios equivalente a \usepackage{glossaries};
// esta sección lista manualmente las entradas definidas en el diccionario
// `glossary` de arriba, ordenadas alfabéticamente por término.
#for key in glossary.keys().sorted(key: k => glossary.at(k).name) [
  #strong[#glossary.at(key).name] #h(0.5em) --- #glossary.at(key).desc
  #v(0.5em)
]
