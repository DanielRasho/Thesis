// ============ SETUP
#set document(
    title: "Usabilidad en Lenguajes de Programación de Dominio Específico (DSL): El caso de Nix", 
    author:"Daniel Alfredo Rayo Roldán",
    keywords: ("Nix, Usability"),
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

#set par(
  justify: true
)

#set heading(
  numbering: "1.a.",
)
#show heading: set block(below: 1em)

// ============ STYLES
#show heading: it => if it.level == 1 [
    #align(center)[
        #it
    ]
    ] else [
        #it
    ]
    
// ============ FUNCTIONS

#let cite-range(first, ..middle, last) = {
  cite(label(first))
  for c in middle.pos() {
    box(width: 0pt, text(fill: white, cite(label(c))))
  }
  text("\u{2013}")
  cite(label(last))
}
 
// ============ COVER

#align(center)[
  #text(size: 16pt)[#smallcaps()[Universidad del valle de guatemala\
  Facultad de Ingeniería]]

  #v(30pt)

  #image("./media/UVG-Logo.jpg", width: 45%)

  #v(30pt)

  #title()
  #text(fill: red)[(Version Alpha)]

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
El problema de llevar _software_ de una computadora a otra y que siga funcionando (proceso conocido como Despliege de Software) es un yugo con el que las Ciencias de Computación no han dado una solución definitiva, esencialmente porque para que una pieza de _software_ funcione correctamente no solamente depende del código fuente en el que esta escrita, sino del contexto que le rodea (_hardware_, sistema operativo, dependencias, etc.), bajo ese contexto surgen Nix como un manejador de paquetes y sistema de construcción #footnote[Sistemas que automatizan la ejecución de tareas repetitivas, usualmente para crear artefactos de _software_ que pueden ser desplegados] que utiliza un enfoque inspirado en la pureza funcional, donde cada paquete define explícitamente el contexto en el que espera ser construido y ejecutado. Este enfoque a demostrado poder crear más de 700 mil artefactos binariamente identicos en diferentes computadoras y contar con el repositorio de paquetes más grande a fecha de este documento. La idea evolucionó al punto de definir el estado casi completo de un sistema operativo mediante un solo archivo de configuración.

Sin embargo, a pesar de sus capacidades prometedoras, Nix no ha gozado de la misma adopción que otras herramientas que abordan los mismos problemas de reproducibilidad como Docker, Conda o VirtualEnv u otros manejadores de paquetes. Las causas de acuerdo a la comunidad son varias: Documentación compleja, errores cripticos, o un lenguaje de programación díficil de dominar; muchos de ellos no siendo problemas técnicos sino de experiencia de uso, y que cae en el rango de estudio del DX (Experiencia de Desarrollo por sus siglas en inglés). Este trabajó se enfoca en verificar si proveer una nueva forma de interactuar con Nix a travez de un lenguaje de proposito general como Typescript, puede reducir la barrera de entrada para nuevos usuarios y por ende mejorar su DX.

#pagebreak()

= Introducción

El distribuir _software_ de las cocinas de los ingenieros a las mesas de los usuarios finales sido una tarea sencilla  @mantylaSoftwareDeploymentActivities2011, los artefactos de _software_ se comportan igual a las plantas exóticas cuando son transplantadas a un hábitat diferente al que están acostumbradas: se marchitan @Dolstra2006. Como las plantas, el _software_ "crece y evoluciona" en el _hardware_, sistema operativo y librerias específicas, de la computadora del ingeniero, pero en el momento que esos artefactos son llevados a los ecosistemas extraños, que son los dispositivos de los usuarios finales, el que funcione o no se vuelve una apuesta ante la que no se tiene control... o si? @Dolstra2006.

El problema anteriormente descrito, es el sujeto de estudio del campo de "Manejo de Configuracion de _Software_" (o CSM por sus siglas en íngles), donde se reconoce que la ejecucición correcta de _software_ no solamente depende de su código fuente, sino del contexto que le rodea @Dolstra2006. Con los años se ha desarrollado una familia de _software_, llamada *manejadores de paquetes* responsable de modificar el entorno global de las computadoras objetivo para conseguir las condiciones ideales para cada aplicación. Al día de hoy se han convertido en una familia tan variada que han se vuelto una característica diferenciadora en las diferentes distribuciones de Linux o lenguajes de programación @Gibb2026. Una corriente opuesta es la *virtualización*, que consiste en empaquetar las aplicaciones junto a los entornos completos que necesitan y ejecutarlas de forma aislada, soluciones de este tipo son muy usadas en servicios de la nube @PDFInfrastructureCode.

Sin embargo, como veremos en siguientes capitulos los manejadores de paquetes lidian con el problema que intentar satisfacer a varias aplicaciones en un entorno global puede llevar a conflictos irresolubles cuando las necesidades de una contradicen la de otra @Zwinger2026; por otro lado, la virtualización elimina las posibilidades de conflictos a cambio de un mayor consumo de recursos @Sobieraj2024 @Lingayat2018. 

#figure(image("media/Figure1.svg"), caption: [
  Dos paquetes (```txt FOO``` y ```txt BAR```) dependen de ```txt Node``` y ```txt Clang```. En manejadores de paquetes, el entorno global obliga a usar una sola versión compatible (```txt Node v23.8```); en la virtualizacion ambas versiones coexisten, pero se pueden duplicar dependencias como ```txt Clang 19.2```. Elaboración propia.
])<figura1>


_La unión hace la fuerza_, dando origen en 2003 a *Nix* como una tercera alternativa que fusiona ideas de ambas corrientes partiendo de la idea que: Usar los mismos ingredientes y pasos debería producir el mismo resultado sin importar la computadora, Nix garantiza lo primero mediante identificadores (ID) únicos que permiten la coexistencia de dependencias, y lo segundo mediante entornos aislados que aseguran la reproducibilidad @Dolstra2006. La elegancia de Nix reside en cómo construye estos identificadores y entorno aislados, tema que se abordará en las siguientes secciones.

#figure(image("media/Figure2.svg", width: 70%), caption: [
  Siguiento la @figura1, Nix almacena los paquetes en un entorno global (_Nix store_) con identificadores únicos, permitiendo la coexistencia de versiones del mismo paquete (```txt Node```), pero tambien la reutilización de dependencias (```txt Clang```). Elaboración propia
  ])

Fue esta enfoque centrado en seguir recetas explícitas que permitió a Nix conseguir una serie de hitos importantes al contar con unos de los repositorios de paquetes generales más grandes de Linux @marakasovRepositoryStatistics, de los cuales 700 mil han demostrado poder replicarse de forma binariamente identica en diferentes computadoras @Malka2025. Aconteció que mucha de las ideas podían generalizarse hasta al punto de reproducir casi por completo un sistema operativo, dando origen a la distribución NixOS @Dolstra2008.

A pesar de ello , Nix ha gozado de una adopción bastante reducida en comparación a las otras herramientas discutidas @stackoverflowMostPopularTechnologies ¿Cuál es entonces su talón de Aquiles? Tal parece que no son problemas necesariamente técnicos, sino de experiencia de uso; en encuestas hechas en el foro oficial, la comunidad resaltaba problemas importantes con la documentación, errores crípticos y un DSL (_Domain Specific Language_ @vandeursenDomainspecificLanguagesAnnotated2000) díficil de dominar @2022NixSurvey2022 @NixCommunitySurvey2023; además, en otra encuesta, se estimó que los usuarios perciben requerir un tiempo de 5 años para dominar la herramienta a pesar que la mayoría lo usa a diario. Llevando a un raro caso donde a pesar que la comunidad le encanta la idea detrás de Nix @NixCommunitySurvey2024  sus problemas de usabilidad son tan severos que impiden su uso, lo que concuerda con observaciones de otros estudio en herramientas son situaciones similares @goodwinFunctionalityUsability1987.

El concepto que los desarrolladores también son usuarios dio origen al campo de estudio de Experiencia de Desarrollo (o DX por sus siglas en inglés), donde el estudio sobre como los desarrolladores perciben sus herramientas ha sido un tema frecuente @Razzaq2024 sobre el que ya se han desarrollado algunos instrumentos como DEXI para evaluar dichas dimensiones@Kuusinen2016. Y dado el trayecto de intentos por mejorar la DX en Nix #cite-range("caddetNixNickel", "gagarinFourMonthsNix", "hufschmittCurrentStatePtyx", "fricklerhandwerk2022") el presente trabajo, busca ser una aplicación de las técnicas aprendidas en el campo de DX, en conjunto con el diseño de lenguajes, para evaluar si un Lenguaje de Proposito Específico Embebido (EDSL por sus siglas en inglés @vandeursenDomainspecificLanguagesAnnotated2000) en Typescript @Typescript podría ayudar a reducir la barra de entrada para nuevos desarrolladores en la herramienta.

#pagebreak()

= Objetivos

== General
Evaluar en qué medida el uso de TypeScript como lenguaje de propósito general podría reducir la barrera de entrada para nuevos usuarios del manejador de paquetes Nix, en comparación con su lenguaje de configuración original, medido a través de métricas de tiempo de completación de tareas y experiencia de usuario.

== Específicos
1. Conducir sesiones de pensar-en-alto con estudiantes de Ciencias de la Computación que no hayan utilizado Nix previamente, aplicando la técnica de "Programación Natural", con el fin de identificar y categorizar los principales puntos de dolor cognitivos que presenta el lenguaje de Nix.
2. Desarrollar un EDSL en TypeScript que genere archivos de configuración, válidos en el lenguaje de Nix, cubriendo al menos las funcionalidades de la libreria estándar.
3. Comparar el lenguaje de Nix frente a la librería desarrollada con estudiantes de Ciencias de la Computación sin experiencia previa en Nix, mediante sesiones de pensar-en-alto y la aplicación de los instrumentos SDFS-2 (motivación), IMI (motivación intrínseca) y DEXI (experiencia de desarrollo), analizando las diferencias entre ambas soluciones a través de Mann-Whitney.

#pagebreak()

= Justificación

Con el crecimiento del mercado de los servicios de infrastructura como código @grandviewresearchInfrastructureCodeMarket, se ha aprendido que el poder definir el estado de sistemas completos a travéz de código, trae ventajas importantes en velocidad de desarrollo, escalabilidad y costos @pandyaIntroductionInfrastructureCode2022. La misma idea también se ha aplicado a entornos de desarrollo @ghanbariUsingDevelopmentEnvironment2026 o flujos de despliegue continuo @wesselGitHubActionsImpact2023; todo lo anterior *sugiere que herramientas que permiten definir entidades o procesos de forma declarativa pueden facilitar el ciclo de desarrollo de _software_*. Nix a mostrado ser una de esas herramientas en el ambito de manejo de paquetes.

Por medio de su lenguaje de configuración, Nix permite describir: la construcción, instalación y composición de paquetes de _software_ @Dolstra2006, habilidad que se ha mostrado aplicable en configuración de ambientes de Computacion de Alto Rendimiento @guilloteauPainlessTranspositionReproducible2022 @Gomez2020, sistemas operativos @Thiberg2025 despliege de _software_ @VanDerBurg2014, orquestación de servicios @FloxKubernetesUncontained o entornos de desarrollo @replitReplitHowWe2021. 

No obstante, a pesar de su versatilidad, Nix presenta una barrera de entrada considerable. Reportes sugieren una curva de aprendizaje pronunciada @NixCommunitySurvey2024, atribuida en parte a la complejidad de su lenguaje de configuración (Nixlang) para ciertos usuarios @fricklerhandwerk2022, aspecto que incluso su creador ha identificado como susceptible de mejora @Dolstra2018. Estas dificultades podrían estar incidiendo en su adopción relativamente limitada frente a herramientas comparables, como Docker @stackoverflowMostPopularTechnologies.

Nixlang es la principal interfaz para interactuar con el ecosistema Nix, es un lenguaje de dominio específico (DSL por sus siglas en inglés) diseñado  directamente para expresar los constructos de la herramienta, y es, en gran medida, responsable de la flexibilidad que la caracteriza @NixdevDocumentation. Sin embargo, esta misma especialización introduce complejidades que afectan su accesibilidad y usabilidad @Dolstra2018. Como respuesta, la comunidad ha explorado diversas estrategias para mitigar estas limitaciones, como : extensiones al lenguaje, como la incorporación de tipado estático —esfuerzos que han sido abandonados debido a su complejidad técnica— @caddetNixNickel @hufschmittCurrentStatePtyx; agentes de inteligencia artificial para generar configuraciones, aún sin validación empírica sólida en términos de usabilidad @Schwaighofer2026; y, en un enfoque más radical, la sustitución de Nixlang por Guile, un lenguaje de propósito general @Courts2013, aunque tampoco es un lenguaje muy conocido @stackoverflowMostPopularTechnologies, sabiendo que pertenece a la familia de Lisp @IntroductionGuileReference.

En base a las propuestas anteriores se hizó un análisis comparativo (véase @Appendix1), donde se observa que las soluciones existentes tienden a introducir nuevas fuentes de complejidad o dependen de factores externos, sin abordar las causas estructurales de la fricción en Nix; esto sugiere que un posible buen enfoque consistiría en interactuar con Nix usando un lenguaje ampliamente conocido, y Typescript encaja muy bien en ese molde dada su popularidad @stackoverflowMostPopularTechnologies y similitud sintáctica con Nixlang, siendo descrito en ocasiones como "JSON con funciones" (siendo JSON una notación usada en Typescript) @NixdevDocumentation.

El uso de lenguajes de propósito general para expresar dominios específicos —conocido como lenguaje de propósito específico embebido (eDSL) @vandeursenDomainspecificLanguagesAnnotated2000— no es un enfoque novedoso y ha demostrado ser efectivo en contextos similares. Un caso ilustrativo es Neovim, que en 2021 introdujo un eDSL en Lua como alternativa a Vimscript @NeovimNews112021, lo cual coincidió con un incremento notable en su interés (véase @Appendix2). En el ecosistema de Nix, existe también una propuesta de eDSL en JavaScript ; no obstante, se trata de un proyecto sin actividad reciente, limitado a un subconjunto de funcionalidades —principalmente la creación de paquetes— y sin evidencia empírica que respalde mejoras en la experiencia de desarrollo @burgNiJSInternalDSL2026.

En este contexto, persiste la ausencia de una propuesta que combine un eDSL basado en un lenguaje ampliamente adoptado, con cobertura funcional mas amplia de Nixlang y validación empírica de mejoras en la experiencia de desarrollo.

#pagebreak()

= Metodología

#pagebreak()

= Plan de Trabajo

#pagebreak()

= Marco Teórico

== Despliegue de _software_ y sus problemas

== Nix como una solucion

El construir un paquete se puede ver como una receta, el seguir los mismos pasos e ingredientes debería dar el mismo resultado, para asegurarse que se usan los mismos ingredientes se les puede asignar un identificador único a cada uno, al ser único varios ingredientes pueden coexistir en el mismo entorno global sin conflictos (manejadores de paquetes); a su vez para asegurar que se siguen los mismos pasos, el paquete, debe ser construido en un entorno aislado donde, como los entornos virtuales; 

=== Soluciones comunes del mercado

=== Funcionamiento general (como se diferencia del resto)

=== Flakes

== Experiencia de Desarrollo (DevEx)

=== Que es (es una cualidad mostrada como abandonada)

=== Porque es importante

=== Como se mide

=== Intentos para mejorar Nix

=== Transpiladores

=== Arquitectura


#pagebreak()

= Anexos

== Soluciones existentes a NixLang <Appendix1>

#table(
  columns: 4,
  table.header[*Problema*][*Soluciones \ existentes*][*Limitaciones*][*Propuesta*],
  [Necesidad de aprender un lenguaje exclusivo de Nix],
  [Uso de lenguajes de propósito general (e.g., Guile en Guix)],
  [Lenguajes poco adoptados mantienen la barrera de entrada],
  [Adoptar un lenguaje ampliamente conocido],
  
  [Escasez de documentación y ejemplos],
  [Producción centralizada de documentación],
  [Alto costo de mantenimiento y dependencia del equipo core],
  [Desacoplar la documentación del desarrollo del núcleo],
  
  [Dependencia de funciones complejas de la stdlib sin tipado],
  [Extensiones del lenguaje para tipado estático],
  [Alta complejidad de implementación],
  [Delegar el tipado a herramientas externas maduras],
  
  [Alta complejidad general del ecosistema],
  [Generación de código con Inteligencia Artificial],
  [No aborda causas estructurales; depende de datos de entrenamiento],
  [Evitar soluciones basadas en generación automática],
  stroke: 0.5pt + black, 
)

== Popularidad <Appendix2>

#figure(image("media/indice de interes de Neovim en el tiempo.png"), caption: "sdafsd")


#pagebreak()
#bibliography(
  title: "Referencias", 
  ("ref.yml", "ref.bib"), 
  style: "ieee",
  full: false)