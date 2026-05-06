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
El problema de llevar software de una computadora a otra y que siga funcionando (proceso conocido como _Despliege de Software_ @Dolstra2006) es un yugo con el que las Ciencias de Computación no han dado una solución definitiva, esencialmente porque para que una pieza de software funcione correctamente no solamente depende del código fuente en el que esta escrita, sino del contexto que le rodea (hardware, sistema operativo, dependencias, etc.), bajo ese contexto surgen Nix como un manejador de paquetes y sistema de construcción #footnote[Sistemas que automatizan la ejecución de tareas repetitivas, usualmente para crear artefactos de software que pueden ser desplegados @mokhovBuildSystemsCarte2018] que utiliza un enfoque inspirado en la pureza funcional, donde cada paquete define explícitamente el contexto en el que espera ser construido y ejecutado. Este enfoque a demostrado poder crear más de 700 mil artefactos binariamente identicos en diferentes computadoras @Malka2025 y contar con el repositorio de paquetes más grande a fecha de este documento @marakasovRepositoryStatistics. La idea evolucionó al punto de definir el estado casi completo de un sistema operativo mediante un solo archivo de configuración @Dolstra2008.

Sin embargo, a pesar de sus capacidades prometedoras, Nix no ha gozado de la misma adopción que otras herramientas que abordan los mismos problemas de reproducibilidad como Docker, Conda o VirtualEnv u otros manejadores de paquetes @stackoverflowMostPopularTechnologies. Las causas de acuerdo a la comunidad son varias: Documentación compleja, errores cripticos, o un lenguaje de programación díficil de dominar; muchos de ellos no siendo problemas técnicos sino de experiencia de uso, y que cae en el rango de estudio del DX (_Developer Experience_) @Fagerholm2012. Este trabajó se enfocó en verificar si proveer una nueva forma de interactuar con Nix a travez de un lenguaje de proposito general como Typescript, puede reducir la barrera de entrada para nuevos usuarios y por ende mejorar su DX.

#pagebreak()

= Introducción

El distribuir software de las _cocinas_ de los ingenieros a _las mesas de los usuarios finales_ nunca a sido una tarea sencilla, los artefactos de software se comportan igual a las plantas exóticas cuando son transplantadas a un hábitat diferente al que están acostumbradas: se marchitan. Como las plantas, el software "crece y evoluciona" en el hardware, sistema operativo y librerias específicas, de la computadora del ingeniero, pero en el momento que esos artefactos son llevados a los ecosistemas extraños, que son los dispositivos de los usuarios finales, el que funcione o no se vuelve una apuesta ante la que no se tiene control... o si? 

El problema anteriormente descrito, es el sujeto de estudio del campo de "Manejo de Configuracion de Software" (o CSM por sus siglas en íngles), donde se reconoce que la ejecucición correcta de software no solamente depende de su código fuente, sino del contexto que le rodea @Dolstra2006. Con los años se ha desarrollado una familia de software, llamada *manejadores de paquetes* responsable de modificar el entorno global de las computadoras objetivo para conseguir las condiciones ideales para cada aplicación. Al día de hoy se han convertido en una familia tan variada que han se vuelto una característica diferenciadora en las diferentes distribuciones de Linux o lenguajes de programación @Gibb2026. Una corriente opuesta es la *virtualización*, que consiste en empaquetar las aplicaciones junto a los entornos completos que necesitan y ejecutarlas de forma aislada, soluciones de este tipo son muy usadas en servicios de la nube @PDFInfrastructureCode.

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

El concepto que los desarrolladores también son usuarios dio origen al campo de estudio de _Developer Experience_ o _DX_ (Experiencia de desarrollo), donde el estudio sobre como los desarrolladores perciben sus herramientas ha sido un tema frecuente @Razzaq2024 sobre el que ya se han desarrollado algunos instrumentos como DEXI para evaluar dichas dimensiones@Kuusinen2016. Y dado el trayecto de intentos por mejorar la DX en Nix @caddetNixNickel @gagarinFourMonthsNix @hufschmittCurrentStatePtyx @fricklerhandwerk2022 el presente trabajo, busca ser una aplicación de las técnicas aprendidas en el campo de DX, en conjunto con el diseño de lenguajes, para evaluar si un Lenguaje de Proposito Específico Embebido (EDSL por sus siglas en inglés @vandeursenDomainspecificLanguagesAnnotated2000) en Typescript @Typescript podría ayudar a reducir la barra de entrada para nuevos desarrolladores en la herramienta.

#pagebreak()

= Objetivos

== General
Evaluar en qué medida el uso de TypeScript como lenguaje de propósito general podría reducir la barrera de entrada para nuevos usuarios del manejador de paquetes Nix, en comparación con el DSL de Nix, medido a través de métricas de usabilidad percibida, tiempo de completación de tareas y experiencia de usuario.

== Específicos
1. Conducir sesiones de pensar-en-alto con estudiantes de Ciencias de la Computación que no hayan utilizado Nix previamente, aplicando la técnica de Programación Natural, con el fin de identificar y categorizar los principales puntos de dolor cognitivos que presenta el lenguaje de Nix.
2. Desarrollar un EDSL en TypeScript que genere archivos de configuración, válidos en el lenguaje de Nix, cubriendo al menos las funcionalidades de la libreria estándar.
3. Comparar el lenguaje de Nix frente a la librería TypeScript desarrollada, en una muestra de estudiantes de Ciencias de la Computación sin experiencia previa en Nix, mediante sesiones de pensar-en-alto y la aplicación de los instrumentos SDFS-2 (motivación), IMI (motivación intrínseca) y DEXI (experiencia de desarrollo), analizando las diferencias entre ambas soluciones a través de Mann-Whitney.

#pagebreak()

= Justificación

En el pasado montar un servicio de TI (Tecnologías de la información) [TODO: es esta una abreviatura que hay que explicar?] requería no solamente de programar el código fuente, sino también el montar manualmente los servidores, redes , años después la nube popularizo un modelo donde los

El control del ambiente en que fueron 

¿Por que Nix de todas Las herramientas?\
Porque ha demostrado ser una herramienta muy poderasa, y que la comunidad ama a pesar de su dificultad de uso.

¿Y porque es dificil de usar?\
mala documentacion, mal lenguaje, y contar con un paradigma funcional. Es en este ultimo en que quiero enfocar. Y eso afecta el DevEx

¿Porque el lenguaje de programación?\
Porque es con el que mas estaras interactuando en tu dia a dia, y la principal interfaz para interactuar con nix. Es por eso que lo quiero llevar a un lenguaje general.

¿Porque un lenguaje general?\
En la actualidad con el mercado y la variedad de lenguajes de programacion, apreder un nuevo lenguaje tan complejo como nix es complicado, herramientas como nvim con lua o aws cdk son un claro ejemplo de exito de lenguajes generales que cuentaron 

¿Porque Typescript?\
Nix esta inpsirado fuertemente en el formato JSON proveniente de javascript, ademas que la comuniad a intentado traer tipos que mejoren la experiencia sin exito (Niquel).

#pagebreak()

= Metodología

#pagebreak()

= Plan de Trabajo

#pagebreak()

= Marco Teórico

== Despliegue de software y sus problemas

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

#quote("Sección vacía")

= Anexos


#bibliography(title: "Referencias", ("ref.yml", "ref.bib"))