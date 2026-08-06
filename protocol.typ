// ============ SETUP
#set document(
    title: "Nix para todos: Impacto del uso de un lenguaje de propósito general en la usabilidad de Nix", 
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
  numbering: "1.",
)
#show heading: set block(below: 1em)


#show heading.where(level: 4): it =>[
    #block(it.body)
]

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

  #v(50pt)

  
  Modalidad de trabajo profesional presentado por Daniel Alfredo Rayo Roldán para optar al grado 
  académico en Ingeniería en Ciencias de la Computación y Tecnologías de la Información
  
]

#pagebreak()
// ============ CONTENT

#outline(depth: 3)

#set page(
  paper: "a4",
  number-align: center,
  numbering: "1"
)
#counter(page).update(1)


// ==============================
// METHODS
// ==============================

#let answer-box(height: 3cm, label: "") = {
  if label != "" { text(weight: "bold")[#label]; v(0.2cm) }
  rect(width: 100%, height: height, stroke: 0pt)
}

#let cb(label) = {
  box(width: 0.45cm, height: 0.45cm, stroke: 0.7pt + black, radius: 1pt)
  h(0.4cm)
  label + "    "
}

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

#let code_block(content: "") = {
    block(
      fill: luma(97%),
      inset: 12pt,
      radius: 4pt,
    )[
      #content
    ]
}

#let choice_item(
  label : "a", 
  content : "") = {
  grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    [*#label*],
  )[
    #code_block(content : [#content])
  ]
};

// ==============================
// ==============================


= Resumen
El problema de llevar _software_ de una computadora a otra y que siga funcionando (proceso conocido como Despliegue de _Software_) es un yugo con el que las Ciencias de Computación no han dado una solución definitiva, esencialmente porque para que una pieza de _software_ funcione correctamente no solamente depende del código fuente en el que esta escrita, sino del contexto que le rodea (_hardware_, sistema operativo, dependencias, etc.), bajo ese contexto surgen Nix como un manejador de paquetes y sistema de construcción #footnote[Sistemas que automatizan la ejecución de tareas repetitivas, usualmente para crear artefactos de _software_ que pueden ser desplegados] que utiliza un enfoque inspirado en la pureza funcional, donde cada paquete define explícitamente el contexto en el que espera ser construido y ejecutado. Este enfoque a demostrado poder crear más de 700 mil artefactos binariamente idénticos en diferentes computadoras y contar con unos de los repositorio de paquetes más grande a fecha de este documento. La idea evolucionó al punto de definir el estado casi completo de un sistema operativo mediante un solo archivo de configuración.

Sin embargo, a pesar de sus capacidades prometedoras, Nix no ha gozado de la misma adopción que otras herramientas que abordan los mismos problemas de reproducibilidad como Docker, Conda o VirtualEnv u otros manejadores de paquetes. Las causas de acuerdo a la comunidad son varias: Documentación compleja, errores crípticos, o un lenguaje de programación difícil de dominar; muchos de ellos no siendo problemas técnicos sino de experiencia de uso, y que cae en el rango de estudio del "DX" (Experiencia de Desarrollo por sus siglas en inglés). Este trabajó se enfoca en verificar si proveer una nueva forma de interactuar con Nix a través de un lenguaje de propósito general como Typescript, puede reducir la barrera de entrada para nuevos usuarios y por ende mejorar su DX.

#pagebreak()

= Introducción

El distribuir _software_ de las cocinas de los ingenieros a las mesas de los usuarios finales no ha sido una tarea sencilla  @mantylaSoftwareDeploymentActivities2011, los artefactos de _software_ se comportan igual a las plantas exóticas cuando son trasplantadas a un hábitat diferente al que están acostumbradas: se marchitan @Dolstra2006. Como las plantas, el _software_ "crece y evoluciona" en el _hardware_, sistema operativo y librerías específicas, de la computadora del ingeniero, pero en el momento que esos artefactos son llevados a los ecosistemas extraños, que son los dispositivos de los usuarios finales, el que funcione o no se vuelve una apuesta ante la que no se tiene control... o si? @Dolstra2006.

El problema anteriormente descrito, es el sujeto de estudio del campo de "Manejo de Configuración de _Software_" (o CSM por sus siglas en ingles), donde se reconoce que la ejecución correcta de _software_ no solamente depende de su código fuente, sino del contexto que le rodea @Dolstra2006. Con los años se ha desarrollado una familia de _software_, llamada *manejadores de paquetes* responsable de modificar el entorno global de las computadoras objetivo para conseguir las condiciones ideales para cada aplicación. Al día de hoy se han convertido en una familia tan variada que se han vuelto una característica diferenciadora en las diferentes distribuciones de Linux o lenguajes de programación @Gibb2026. Una corriente opuesta es la *virtualización*, que consiste en empaquetar las aplicaciones junto a los entornos completos que necesitan y ejecutarlas de forma aislada, soluciones de este tipo son muy usadas en servicios de la nube @PDFInfrastructureCode.

Sin embargo, como se ilustra en la @figura1, los manejadores de paquetes lidian con el problema que intentar satisfacer a varias aplicaciones en un entorno global puede llevar a conflictos irresolubles: cuando `FOO` y `BAR` dependen de versiones distintas de Node, el entorno global obliga a elegir una sola versión compatible (Node v23.8). La virtualización elimina ese conflicto permitiendo que cada aplicación lleve su propia versión en entornos separados, pero a cambio puede duplicar dependencias compartidas como Clang 19.2 @Zwinger2026, incrementando el consumo de almacenamiento @Sobieraj2024 @Lingayat2018.

#figure(image("media/Figure1.svg"), caption: [
  Dependencias de dos programas ficticios `FOO` y `BAR` en manejadores de paquetes vs. virtualización.
])<figura1>

_La unión hace la fuerza_, dando origen en 2003 a Nix como una tercera alternativa que fusiona ideas de ambas corrientes partiendo de la idea que: Usar los mismos ingredientes y pasos debería producir el mismo resultado sin importar la computadora. Nix garantiza lo primero mediante identificadores (ID) únicos en un entorno aislado (_Nix Store_) que, como se ve en la @figura2, permiten la coexistencia de versiones distintas del mismo paquete y la reutilización de dependencias compartidas, resolviendo los problema previos de `FOO` y `BAR`; y lo segundo mediante entornos aislados que aseguran la reproducibilidad @Dolstra2006. La elegancia de Nix reside en cómo construye estos identificadores y entornos aislados.

#figure(image("media/Figure2.svg", width: 70%), caption: [
  Manejo de paquetes en Nix con identificadores únicos permite coexistencia y reutilización de paquetes.
])<figura2>

Fue esta enfoque centrado en seguir recetas explícitas que permitió a Nix conseguir una serie de hitos importantes al contar con unos de los repositorios de paquetes generales más grandes de Linux @marakasovRepositoryStatistics, de los cuales 700 mil han demostrado poder replicarse de forma binariamente idéntica en diferentes computadoras @Malka2025. Aconteció que mucha de las ideas podían generalizarse hasta al punto de reproducir casi por completo un sistema operativo, dando origen a la distribución NixOS @Dolstra2008.

A pesar de ello , Nix ha gozado de una adopción bastante reducida en comparación a las otras herramientas discutidas @stackoverflowMostPopularTechnologies ¿Cuál es entonces su talón de Aquiles? Tal parece que no son necesariamente problemas técnicos, sino de experiencia de uso; en encuestas hechas en el foro oficial, la comunidad resaltaba problemas importantes con la documentación, errores crípticos y un _Domain Specific Language_ (DSL) difícil de dominar @2022NixSurvey2022 @NixCommunitySurvey2023; además, en otra encuesta, se estimó que los usuarios perciben requerir un tiempo de 5 años para dominar la herramienta a pesar que la mayoría lo usa a diario. Llevando a un raro caso donde a pesar que la comunidad le encanta la idea detrás de Nix @NixCommunitySurvey2024  sus problemas de usabilidad son tan severos que podrían estar impidiendo su uso, lo que concuerda con observaciones de otros estudio en herramientas son situaciones similares @goodwinFunctionalityUsability1987.

El concepto que los desarrolladores también son usuarios dio origen al campo de estudio de Experiencia de Desarrollo (o DX por sus siglas en inglés), donde el estudio sobre como los desarrolladores perciben sus herramientas ha sido un tema frecuente @Razzaq2024 sobre el que ya se han desarrollado algunos instrumentos como DEXI para evaluar dichas dimensiones@Kuusinen2016. Y dado el trayecto de intentos por mejorar la DX en Nix #cite-range("caddetNixNickel", "gagarinFourMonthsNix", "hufschmittCurrentStatePtyx", "fricklerhandwerk2022") el presente trabajo, busca ser una aplicación de las técnicas aprendidas en el campo de DX, en conjunto con el diseño de lenguajes, para evaluar si un Lenguaje de Propósito Específico Embebido (eDSL por sus siglas en inglés) en Typescript @Typescript podría ayudar a reducir la barra de entrada para nuevos desarrolladores en la herramienta.

#pagebreak()

= Objetivos

== General
Evaluar si un eDSL en TypeScript reduce la barrera de entrada a Nix —referente funcional y declarativo en gestión de paquetes, limitado por su curva de aprendizaje— frente a Nixlang, mediante tiempo de completación de tareas y experiencia de usuario.

== Específicos
1. Identificar los principales puntos de dolor cognitivos que presenta el lenguaje de Nix, para fundamentar el diseño de un eDSL, mediante sesiones de pensar-en-alto y "Programación Natural" con estudiantes de Ciencias de la Computación que no hayan utilizado Nix previamente.
2. Desarrollar un eDSL en TypeScript que sirva de prototipo funcional para la evaluación comparativa, capaz de generar archivos de configuración en Nixlang, cubriendo al menos las funcionalidades de la librería estándar, verificado con una batería de pruebas.
3. Comparar Nixlang frente al eDSL desarrollado, para determinar si la familiaridad con Typescript reduce la carga cognitiva de adopción mediante un cuestionario estructurado, y el uso de Short AttrakDiff 2 y DEXI aplicados a estudiantes de Ciencias de la Computación sin experiencia previa, con análisis de diferencia estadística.

#pagebreak()

= Justificación

Con el crecimiento del mercado de los servicios de infraestructura como código @grandviewresearchInfrastructureCodeMarket, se ha aprendido que el poder definir el estado de sistemas completos a través de código, trae ventajas importantes en velocidad de desarrollo, escalabilidad y costos @pandyaIntroductionInfrastructureCode2022. La misma idea también se ha aplicado a entornos de desarrollo @ghanbariUsingDevelopmentEnvironment2026 o flujos de despliegue continuo @wesselGitHubActionsImpact2023; todo lo anterior sugiere que herramientas que permiten definir entidades o procesos de forma declarativa pueden facilitar el ciclo de desarrollo de _software_. En el manejo de paquetes, el panorama es fragmentado: habiendo alternativas por lenguaje, o indirectas como Docker @Zwinger2026; y una solución declarativa de propósito general no es de el todo clara. Nix lleva años intentando llenar ese espacio — y las cifras sugieren que esta haciendo algo bien: al tener uno de los repositorios de paquetes más grandes de Linux, con 115 mil paquetes @marakasovRepositoryStatistics un crecimiento del 264% en número de mantenedores en los últimos seis años @gg-solutionsLinuxSilentTech2026.

Por medio de su lenguaje de configuración, Nix permite describir: la construcción, instalación y composición de paquetes de _software_ @Dolstra2006, habilidad que se ha mostrado aplicable en configuración de ambientes de Computación de Alto Rendimiento @guilloteauPainlessTranspositionReproducible2022 @Gomez2020, sistemas operativos @Thiberg2025 despliege de _software_ @VanDerBurg2014, orquestación de servicios @FloxKubernetesUncontained o entornos de desarrollo @replitReplitHowWe2021. 

No obstante, a pesar de su versatilidad, Nix presenta una barrera de entrada considerable. Reportes sugieren una curva de aprendizaje pronunciada @NixCommunitySurvey2024, atribuida en parte a la complejidad de su lenguaje de configuración (Nixlang) para ciertos usuarios @fricklerhandwerk2022, aspecto que también su creador ha identificado como susceptible de mejora @Dolstra2018. Estas dificultades podrían estar incidiendo en su adopción relativamente limitada frente a herramientas como Docker @stackoverflowMostPopularTechnologies.

Nixlang es la principal interfaz para interactuar con el ecosistema Nix, es un lenguaje de dominio específico (DSL por sus siglas en inglés) diseñado  directamente para expresar los constructos de la herramienta, y es, en gran medida, responsable de la flexibilidad que la caracteriza @NixdevDocumentation. Sin embargo, esta misma especialización introduce complejidades que afectan su accesibilidad y usabilidad @Dolstra2018. Como respuesta, la comunidad ha explorado diversas estrategias para mitigar estas limitaciones, como : extensiones al lenguaje, con la incorporación de tipado estático —esfuerzos que han sido abandonados debido a su complejidad técnica— @caddetNixNickel @hufschmittCurrentStatePtyx; agentes de inteligencia artificial para generar configuraciones, aún sin validación empírica sólida en términos de usabilidad @Schwaighofer2026; y, en un enfoque más radical, la sustitución del lenguaje por Guile, un lenguaje de propósito general @Courts2013, aunque tampoco es un lenguaje muy conocido @stackoverflowMostPopularTechnologies, sabiendo que pertenece a la familia de Lisp @IntroductionGuileReference.

Con base en las propuestas anteriores se hizo un análisis comparativo (véase @Appendix1), donde se observa que las soluciones existentes tienden a introducir nuevas fuentes de complejidad o dependen de factores externos, sin abordar las causas estructurales de la fricción en Nix; esto sugiere que un posible buen enfoque consistiría en interactuar con Nix usando un lenguaje ampliamente conocido, y Typescript encaja muy bien en ese molde dada su popularidad @stackoverflowMostPopularTechnologies y similitud sintáctica con Nixlang, siendo descrito en ocasiones como "JSON con funciones" (siendo JSON una notación usada en Typescript) @NixdevDocumentation.

El uso de lenguajes de propósito general para expresar dominios específicos —conocido como lenguaje de propósito específico embebido (eDSL) @vandeursenDomainspecificLanguagesAnnotated2000— no es un enfoque novedoso y ha demostrado ser efectivo en contextos similares. Un caso ilustrativo es Neovim, que en 2021 introdujo un eDSL en Lua como alternativa a Vimscript @NeovimNews112021, lo cual coincidió con un incremento notable en su interés (véase @Appendix2). En el ecosistema de Nix, existe también una propuesta de eDSL en JavaScript ; no obstante, se trata de un proyecto sin actividad reciente, limitado a un subconjunto de funcionalidades —principalmente la creación de paquetes— y sin evidencia empírica que respalde mejoras en la experiencia de desarrollo @burgNiJSInternalDSL2026.

En este contexto, persiste la ausencia de una propuesta que combine un eDSL basado en un lenguaje ampliamente adoptado, con cobertura funcional mas amplia de Nixlang y validación empírica de mejoras en la experiencia de desarrollo.

#pagebreak()

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

= Plan de Trabajo

Para poder llevar a cabo la investigación las diferentes fases fueron divididas en tareas más pequeñas y se calendarizaron luego en el siguiente cronograma.

#let phases = (
  (
    label: "Fase 1 · Investigación preliminar",
    color: rgb("#CEDFFF"),
      text-color: rgb("#000"),
    bar-color: rgb("#5484DF"),
    tasks: (
      ("Diseño de instrumentos",          (1, 2)),
      ("Reclutamiento participantes",      (3, 3)),
      ("Sesiones pensar-en-alto y programacion natural",          (4, 4)),
      ("Análisis cualitativo de las sesiones",          (5, 5)),
    ),
  ),
  (
    label: "Fase 2 · Desarrollo eDSL",
    color: rgb("#C8EEC6"),
    text-color: rgb("#000"),
    bar-color: rgb("#42B33C"),
    tasks: (
      ("Diseño arquitectura eDSL",         (6, 7)),
      ("Implementación core eDSL",         (8, 10)),
      ("Cobertura stdlib Nix",             (10, 12)),
      ("Pruebas y validación",             (12, 13)),
    ),
  ),
  (
    label: "Fase 3 · Evaluación comparativa",
    color: rgb("#FAECE7"),
    text-color: rgb("#000"),
    bar-color: rgb("#D85A30"),
    tasks: (
      ("Diseño cuestionarios cognitivos",  (14, 14)),
      ("Reclutamiento participantes",      (14, 14)),
      ("Sesiones evaluación cognitiva",    (15, 15)),
      ("Sesiones AttrakDiff / DEXI / OUX", (15, 15)),
      ("Análisis estadístico",             (16, 17)),
      ("Síntesis de resultados",           (17, 18)),
    ),
  ),
)

#let total-weeks = 18
#let cell-width = 1.6em

#let gantt-row(task-name, span, bar-color) = {
  let (start, end) = span
  (
    table.cell(align: left + horizon)[#text(size: 8pt)[#task-name]],
    ..range(1, total-weeks + 1).map(w => {
      if w >= start and w <= end {
        table.cell(fill: bar-color)[]
      } else {
        table.cell()[]
      }
    })
  )
}

#figure(
table(
  columns: (10em, ..range(total-weeks).map(_ => cell-width)),
  rows: auto,
  stroke: (x, y) => (
    left: if x == 0 { 0.5pt + gray } else { none },
    right: if x == total-weeks { 0.5pt + gray } else { none },
    top: 0.4pt + luma(220),
    bottom: 0.4pt + luma(220),
  ),
  inset: (x: 3pt, y: 4pt),

  // Header row
  table.cell(align: left + horizon)[#text(weight: "bold", size: 8pt)[Tarea/ Semanas]],
  ..range(1, total-weeks + 1).map(w =>
    table.cell(align: center + horizon)[#text(size: 7pt, weight: "bold")[#w]]
  ),

  // Phases and tasks
  ..phases.map(phase => (
    table.cell(
      colspan: total-weeks + 1,
      fill: phase.color,
      align: left + horizon,
    )[#text(weight: "bold", size: 8pt, fill: phase.text-color)[#phase.label]],
    ..phase.tasks.map(task => {
      let (name, span) = task
      gantt-row(name, span, phase.bar-color)
    }).join()
  )).join()
), caption: [Diagrama de Gannt de la ejecución de tareas a lo largo del tiempo])

#pagebreak()

= Índice preliminar

1. Dedicatorio
2. Resumen/Abstract
3. Tabla de Contenido
4. Introducción
5. Objetivos
6. Marco Teórico\
    6.1. Despliegue de *software* y sus problemas\
    6.2. Nix como una solución\
    6.3. Experiencia de Desarrollo\
    6.4. Intentos para mejorar Nix\
    6.5. Transpiladores\
7. Metodología\
   7.1. Fase 1: Investigación preliminar\
   7.2. Fase 2: Desarrollo del eDSL\
   7.2.1. Arquitectura\
   7.3. Fase 3: Evaluación comparativa\
   7.3.1. Cuestionario estructurado\
   7.3.2. AttrakDiff-2\
   7.3.3. DEXI\
8. Resultados
9. Discusión
10. Referencias
11. Anexos

#pagebreak()

#bibliography(
  title: "Referencias", 
  ("ref.yml", "ref.bib"), 
  style: "ieee",
  full: false)
#pagebreak()

= Anexos

== Soluciones existentes a Nixlang <Appendix1>



#figure(
  table(
  columns: (25pt, 1fr, 1fr, 1fr, 1fr),
  table.header[][*Problema*][*Soluciones \ existentes*][*Limitaciones*][*Propuesta*],
  [@Courts2013], 
  [Necesidad de aprender un lenguaje exclusivo de Nix],
  [Uso de lenguajes de propósito general (e.g., Guile en Guix)],
  [Lenguajes poco adoptados mantienen la barrera de entrada @stackoverflowMostPopularTechnologies],
  [Adoptar un lenguaje ampliamente conocido],
  
  [@gagarinFourMonthsNix], 
  [Escasez de documentación y ejemplos],
  [Reescritura de la documentación en un lugar centralizado],
  [Alto costo de mantenimiento y dependencia de aprobación ],
  [Que la estructura del código en sí permite su documentación como el tipado estático],
  
  [@caddetNixNickel \ @hufschmittCurrentStatePtyx],
  [Dependencia de funciones de la librería estándar con muchos parámetros no documentados.],
  [Extensiones al lenguaje para tipado estático],
  [Alta complejidad de implementación],
  [Delegar el tipado a herramientas externas maduras],
  
  [@Schwaighofer2026],
  [Alta complejidad general del ecosistema],
  [Generación de código con Inteligencia Artificial],
  [No aborda causas estructurales; depende de datos de entrenamiento],
  [Evitar soluciones basadas en generación automática],
  stroke: 0.5pt + black, 
),
caption: "Una tabla comparativa sobre algunas de las soluciones propuestas por la comunidad de Nix que buscan mejorar la experiencia en Nixlang de forma directa o indirecta, incluyendo sus limitaciones y una propuesta derivada.")

== Interés en Neovim <Appendix2>

Con datos extraídos de Google Trends para la búsqueda “Neovim - Programa” en su modo clásico, se obtuvieron series históricas correspondientes a los últimos años. Los datos utilizados se muestran en @googleNeovimInterestTrends.

#figure(
image("media/indice de interes de Neovim en el tiempo.png", width: 74%),
caption: [Índice de interés de búsqueda de Neovim en Google entre 2014 y 2026. Se observa un aumento a finales de 2021, aproximadamente seis meses después de la introducción del soporte para Lua @NeovimNews112021.]
)

== Cuestionarios Fase 1 <Appenddix3>

=== Formulario de Programación Natural

==== Instrucciones
Esta actividad forma parte de una investigación sobre cómo las personas expresan ideas de configuración y automatización de forma espontánea, antes de aprender un lenguaje formal.

No existe una respuesta correcta ni incorrecta. Lo que nos interesa es cómo tú lo pensarías naturalmente.

*¿En qué consiste?*

*Se te presentará una serie de problemas que debe resolver un Manejador De Paquetes ficticio. Tu tarea es inventar, en el momento, la sintaxis o notación que usarías para resolverlos*. Puedes usar:

- texto libre o pseudocódigo
- diagramas, flechas o dibujos
- anotaciones al margen explicando tu razonamiento
- cualquier combinación de lo anterior

No es necesario que la sintaxis pertenezca a ningún lenguaje real, ni que sea consistente entre problemas. Exprésate con espontaneidad — *si cambias de idea a mitad, tacha y sigue. Esos cambios también nos interesan.*

*Antes de comenzar*: Resuelve los problemas en orden y no leas el siguiente hasta haber terminado el actual. No hay límite de tiempo, pero intenta no pensarlo demasiado — la primera idea que tengas suele ser la más valiosa para esta investigación.

#linebreak()


==== Contexto

Un paquete de _software_ es un conjunto de programas, archivos e instrucciones pensados para ser distribuidos e instalados en otros sistemas. Por ejemplo, un editor de texto, o una librería como NumPy.

Un manejador de paquetes es el programa encargado de instalar, actualizar, configurar y eliminar paquetes en un sistema. Una de sus responsabilidades más importantes es gestionar las dependencias: un paquete raramente funciona solo — casi siempre requiere que otros paquetes estén instalados previamente y configurados de una manera específica, generando una grafo de paquetes de dependencias como en la  @diagram1.

#figure(image("./media/Diagram1.svg", width: 60%), caption: [Dependencias ficticias de `VS Code` y `Discord`; ambos tienen una dependencia compartida en `Electron`, a su vez estas dependencias dependen de otras.])<diagram1>

*El manejador de paquetes que tú vas a crear funciona de manera diferente a los tradicionales*. En lugar de ejecutar un comando como `instalar paquete-X`, *tú describes lo que quieres en un archivo de configuración*, y el manejador de paquetes se encarga de llevarlo a cabo. Esto significa que toda la información sobre qué instalar, cómo construirlo y de qué depende queda registrada explícitamente en ese archivo.

Para describir un paquete en este sistema, necesitas especificar al menos:

- *De dónde obtenerlo* — la URL o repositorio desde donde se descarga su código fuente o ejecutables.
- *Sus dependencias* — otros paquetes que deben estar presentes para que este funcione.
- *Cómo construirlo* — los pasos necesarios para compilarlo o instalarlo una vez descargado.

- *Para qué arquitectura construirlo* — los paquetes se compilan para un tipo de procesador específico, como x86_64 (la mayoría de computadores de escritorio) o arm (dispositivos móviles y algunos computadores modernos). Un paquete compilado para una arquitectura no funcionará en otra.

Puedes imaginar cada paquete como una receta de cocina: tiene ingredientes (dependencias) que obtienes de algúna tienda (fuentes), se prepara en una cocina específica (arquitectura), y sigue una serie de pasos (instrucciones de instalación) que van desde preparar los ingredientes hasta tener el plato listo para servir.


#figure(image("./media/diagram2.png", width: 80%), caption: [Los diferentes componentes a tomar en cuanta para describir un paquete de _software_])<diagram2>

==== Información del Participante
#linebreak()

1. *Cual es tu edad*: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
2. *En que semestre de la universidad te encuentras (indica número)*: \_\_\_\_\

3.*Tienes experiencia utilizando manejadores de paquetes (ej: pacman, npm, pip, apt...)*

#cb[Si] #cb[No]

4.*Haz empaquetado algun aplicación de _software_ (librería o aplicación) para su consumo por otros usuarios *

#cb[Si] #cb[No]

5. *¿Cuáles de estos lenguajes te sientes cómodo para realizar un proyecto?* 
#cb[Bash] #cb[C] #cb[Elixir] #cb[Java] #cb[Javascript]

#cb[Typescript] #cb[Python] #cb[Lisp]

\

==== Sección 1 - Manejo de paquetes externos
Tú manejador de paquetes instala todo dentro de un entorno aislado: cada proyecto tiene su propio espacio con sus propias herramientas, sin interferir con el resto del sistema, similar a un contenedor.

1. Estas empezando un nuevo proyecto y quieres que todo tu equipo usen las mismas herramientas, tu manejador de paquetes puede hacerlo por ti. Sin embargo, primero tienes que indicar de que fuente obtenerlos. Escribe la sintaxis para indicar que `fuente1` proviene de `github.com/example/repo`, `fuente2` de `librerias.com/search` y fuente de un archivo ZIP en `./home/user/hello`. 

2. Antes de indicar que paquetes deseas instalar tienes que indicar para que arquitecturas de computadora debe ser disponible en la sintaxis, sabes que tus compañeros usan `x86-64-linux` y `arm64-macos`.

3. Con la configuración previa, escribe la sintaxis para indicar que quieres instalar 
- `node-v1.0` de `fuente1`
- `reactjs-v2.1` y `tailwindcss-v3.0` de `fuente2`
- `vitejs-v1.0` de `fuente3`.

4. Necesitas actualizar `node` de `v1.0` a `v2.0`. Escribe cómo modificarías la declaración anterior.

5. Decidiste que `vitejs-v1.0` ya no es necesario. Escribe cómo lo eliminarías de la configuración.
6. Un colaborador externo necesita su propio conjunto de herramientas: `node v2.0` y `vitest v3.0` pero no quieres reescribir toda la lógica de nuevo para este miembro ¿Cómo escribirías el código para *reutilizar* lo que ya tienes y definir este  `ambiente de desarollo`?

==== Sección 2 - Manejo de paquetes externos
Ahora eres tú quien crea un paquete para que otros lo usen. Tienes una aplicación llamada `mi-app` en `github.com/yo/mi-app` que quieres distribuir.

Construir un paquete ocurre en fases, por ahora trabaja con dos:

- *build* — compilar el código fuente del programa
- *install* — copiar el programa compilado en las carpetas especificas al sistema para que pueda ser usado (`C:/Program Files` en Windows o `/usr/bin` en Linux).

1. Escribe la sintaxis para declarar este paquete: su nombre, versión `1.0` de dónde descargarlo y las arquitecturas en donde es soportado.

2. Tu aplicación necesita `node-v2.0` y `reactjs-v2.1` para funcionar. Escribe cómo agregarías esas dependencias a la declaración anterior, recuerda que también tienes que indicar de dónde obtenerlas.

3. Escribe la sintaxis para describir la fase *build* de `mi-app`: compilar el código ejecutando `npm run build`.

4. Escribe la sintaxis para describir la fase *install*: copiar el resultado de la compilación al sistema ejecutando `npm run install`.

5. Ahora, en `x86-64-linux` necesitas `openssl-v1` pero en `arm64-macos` necesitas `openssl-v2`. ¿Cómo expresarías que una dependencia cambia según la arquitectura?


6. Como generalizarías tus ideas anteriores para que pudieras definir varios paquetes en un archivo sin tener que repetir tanto código.

=== Guía de actividades de pensar en alto

==== Antes de comenzar

- Entrega al participante el formulario de consentimiento, y confirmar si esta de acuerdo a participar.
- Recordar que se grabará la voz y pantalla durante la actividad.
- Confirma que la grabación de voz y pantalla está activa.

==== Introducción

_Leer en voz alta al participante:_

#block(
  fill: luma(230),
  inset: 12pt,
  radius: 4pt,
)[
  Gracias por participar. Esta sesión nos ayuda a entender cómo las personas aprenden y razonan con un nuevo lenguaje de programación.

  Lo que harás es resolver una serie de pasos para construir un archivo de configuración en Nix. No es un examen --- no hay respuestas correctas o incorrectas, nos interesa tu proceso.

  Lo más importante es que hables en voz alta mientras trabajas. Queremos escuchar lo que piensas en cada momento: lo que estás leyendo, lo que esperas que pase, cuando algo no tiene sentido, o cuando crees haber encontrado la solución.

  Tu voz y pantalla serán grabadas durante toda la sesión.

  ¿Tienes alguna pregunta antes de comenzar?
]

==== Recursos disponibles

_Entregar al participante los siguientes enlaces:_

- #link("https://nix.dev")[nix.dev]
- #link("https://search.nixos.org/packages")[search.nixos.org/packages]
- #link("https://wiki.nixos.org/wiki/Flakes")[wiki.nixos.org/wiki/Flakes]
- #link("https://noogle.dev")[noogle.dev]

_Leer al participante:_

#block(
  fill: luma(230),
  inset: 12pt,
  radius: 4pt,
)[
  Puedes consultar estos recursos o buscar en internet libremente. No se permite el uso Inteligencia Artificial como ChatGPT o similares durante la sesión.
]

==== Durante la sesión

- No ofrecer pistas ni confirmar si el participante va bien
- Si el participante guarda silencio por más de 15 segundos, preguntar: _"¿Qué estás pensando ahora?"_
- Tomar nota de momentos de confusión, bloqueos o sorpresa

==== Al finalizar

- Detener la grabación
- Agradecer al participante
- Abrir espacio para preguntas o comentarios

==== Actividades

1. Crear un archivo `flake.nix` con los campos `description`, `inputs` y `outputs`. Hazlo de tal manera que puedas correr `nix flake show` sin errores.

2. Agrega `nixpkgs` como `input` apuntando a `github:NixOS/nixpkgs/release-26.05`.

3. Has que `outputs` sea una función que reciba los parámetros `self` y `nixpkgs` y retorne un _attribute set_ con una llave `version` y valor `nixpkgs.lib.version`. Verifica que corre sin errores con `nix eval .#version`

4. Modifica tu función `outputs` para que declaré una variable `pkgs` que guarde los resultados de importar `nixpkgs` configurado para `x84_64-linux`.

5. Quieres crear un entorno de desarollo (`devShell`) para la arquitectura `x84_64-linux`. Utiliza la función `pkgs.mkShell` para construirla, basta con que especifiques el atributo `name`. Entra a ella con el comando `nix develop`.

6. Agrega aplicaciones `jp` y `tree` a tu entorno de desarrollo. Verifica que estan disponibles dentro del entorno. 

7. Quisieras que este mismo entorno de desarrollo estuviera disponible para otras arquitecturas, pero no quieres repetir la configuración para cada una. ¿Cómo lo resolverías?

== Cuestionarios Fase 2 <Appendix4>

=== Cuestionarios de comprensión cognitiva

\
*Marca en una escala del 1 al 5 tu nivel de experiencia en el dominio de Manejo de Paquetes. *

#linkert(pairs: (
    ("Muy Poca", "Muy avanzada"),
  ),
  grades: 5
)

*Marca en una escala del 1 al 5 tu nivel de experiencia en Typescript.*

#linkert(pairs: (
    ("Muy Poca", "Muy avanzada"),
  ),
  grades: 5
)

*Marca en una escala del 1 al 5 tu nivel de experiencia en NixLang.*

#linkert(pairs: (
    ("Muy Poca", "Muy avanzada"),
  ),
  grades: 5
)

*Marca en una escala del 1 al 5 tu nivel de experiencia en Lenguajes Funcionales.*

#linkert(pairs: (
    ("Muy Poca", "Muy avanzada"),
  ),
  grades: 5
)

==== Instrucciones

Se te presentaran una serie de ejercicios para poner a prueba tu aprendizaje en Nixlang. Durante la prueba puedes consultar el contenido de aprendizaje dado por los investigadores, como buscar por internet, más no se permite el uso de asistentes de inteligencia artificial.


*PA1-1*. Escoge el código correcto (Sin errores sintácticos).

#choice_item(label: "a)", content: [
  ```nix
{
  description = "A simple development environment"

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.python3 pkgs.git ];
        shellHook = ''
          echo "Welcome to the dev shell"
        '';
      };
    };
}
  ```
])

#choice_item(label: "b)", content: [
  ```nix
{
  description := "A simple development environment";

  inputs.nixpkgs.url := "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system := "x86_64-linux";
      pkgs := nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs := [ pkgs.python3, pkgs.git ];
        shellHook := "echo Welcome to the dev shell";
      };
    };
}
  ```
])

#choice_item(label: "c)", content: [
  ```nix
{
  description = "A simple development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.$(system);
    in
    {
      devShells.$(system).default = pkgs.mkShell {
        buildInputs = [ pkgs.python3 pkgs.git ];
        shellHook = ''
          echo "Welcome to the dev shell"
        '';
      };
    };
}
  ```
])

#choice_item(label: "d)", content: [
  CORRECTA
  ```nix
{
  description = "A simple development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python3
          pkgs.git
        ];

        shellHook = ''
          echo "Welcome to the dev shell"
        '';
      };
    };
}
  ```
])

#choice_item(label: "e)", content: [
  ```nix
{
  description = "A simple development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python3
          pkgs.git
        ]
        shellHook = ''
          echo "Welcome to the dev shell"
        '';
      };
    };
}
  ```
])

*PA1-2*. Escoge el código correcto (Sin errores sintácticos).

#choice_item(label: "a)", content: [
```nix
# more code...
packages.${system}.default = pkgs.stdenv.mkDerivation {
  pname = "greet"
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "example";
    repo = "greet";
    rev = "v1.0.0";
    sha256 = "AAAA...";
  };
  buildPhase = ''
    gcc -O2 -o greet main.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp greet $out/bin/greet
  '';
};
# more code...
```
])

#choice_item(label: "b)", content: [
CORRECTA
```nix
# more code...
packages.${system}.default = pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "example";
    repo = "greet";
    rev = "v1.0.0";
    sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  nativeBuildInputs = [ pkgs.gcc ];
  buildPhase = ''
    gcc -O2 -o greet main.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp greet $out/bin/greet
  '';
};
# more code...
```
])

#choice_item(label: "c)", content: [
```nix
# more code...
packages.${system}.default := pkgs.stdenv.mkDerivation {
  pname := "greet";
  version := "1.0.0";
  src := pkgs.fetchFromGitHub(owner: "example", repo: "greet", rev: "v1.0.0", sha256: "AAAA...");
  buildPhase := "gcc -O2 -o greet main.c";
  installPhase := "mkdir -p $out/bin; cp greet $out/bin/greet";
};
# more code...
```
])

#choice_item(label: "d)", content: [
```nix
# more code...
packages.${system}.default = pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0"
  src = pkgs.fetchFromGitHub {
    owner: "example";
    repo: "greet";
    rev: "v1.0.0";
    sha256: "AAAA...";
  }
  buildPhase = ''
    gcc -O2 -o greet main.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp greet $out/bin/greet
  '';
};
# more code...
```
])
#choice_item(label: "e)", content: [
```nix
# more code...
packages.${system}.default = pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "example",
    repo = "greet",
    rev = "v1.0.0",
    sha256 = "AAAA...",
  };
  buildPhase = ''
    gcc -O2 -o greet main.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp greet $out/bin/greet
  '';
};
# more code...
```
])

*PA2-1*. Selecciona el trozo de código que no tiene sentido.

#choice_item(label: "a)", content: [
  ```nix
#  ...
devShells.${system}.default = pkgs.mkShell {
  buildInputs = [pkgs.python3];
  shellHook = ''
    echo "Welcome to the dev shell"
  '';
};
#  ...
  ```
])

#choice_item(label: "b)", content: [
  ```nix
#  ...
devShells.${system}.default = pkgs.mkShell {
  buildInputs = [ pkgs.python3 pkgs.git ];
  shellHook = [ "echo" "Welcome to the dev shell" ];
};
#  ...
  ```
])

#choice_item(label: "c)", content: [
  CORRECTA
```nix
#  ...
system = pkgs.git;
pkgs = nixpkgs.legacyPackages.${system};
devShells.${system}.default = pkgs.mkShell {
  buildInputs = [ pkgs.python3 pkgs.git ];
};
#  ...
```
])

#choice_item(label: "d)", content: [
  ```nix
#  ...
devShells.${system}.default = pkgs.mkShell {
  buildInputs = [ pkgs.python3 pkgs.git ];
  shellHook = ''
    echo "Welcome to the dev shell"
  '';
  buildInputs = [ pkgs.nodejs ];
};
#  ...
  ```
])

#choice_item(label: "e)", content: [
  ```nix
#  ...
devShells.${system}.default = pkgs.mkShell {
  buildInputs = [pkgs.python3 pkgs.git];

  shellHook = ''
    echo "Welcome to the dev shell"
  '';
};
#  ...
  ```
])

*PA2-2*. Selecciona el trozo de código que no tiene sentido.

#choice_item(label: "a)", content: [
  CORRECTA
  ```nix
#  ...
  pkgs.stdenv.mkDerivation{
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub { owner = "example"; repo = "greet"; rev = "v1.0.0"; sha256 = "AAAA..."; };
  nativeBuildInputs = with pkgs; [gcc];
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = ''mkdir -p $out/bin; cp greet $out/bin/greet'';
}
#  ...
  ```
])

#choice_item(label: "b)", content: [
  ```nix
#  ...
  pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub { owner = "example"; repo = "greet"; rev = "v1.0.0"; sha256 = "AAAA..."; };
  nativeBuildInputs = pkgs.gcc;
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = ''mkdir -p $out/bin; cp greet $out/bin/greet'';
}
#  ...
  ```
])

#choice_item(label: "c)", content: [
  ```nix
#  ...
  pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub { owner = "example"; repo = "greet"; rev = "v1.0.0"; sha256 = "AAAA..."; };
  nativeBuildInputs = [ pkgs.gcc ];
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = $out;
}
#  ...
  ```
])

#choice_item(label: "d)", content: [
  ```nix
#  ...
  pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = "main.c";
  nativeBuildInputs = [ pkgs.gcc ];
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = ''mkdir -p $out/bin; cp greet $out/bin/greet'';
}
#  ...
  ```
])

#choice_item(label: "e)", content: [
  ```nix
#  ...
  pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub { owner = "example"; repo = "greet"; rev = "v1.0.0"; sha256 = "AAAA..."; };
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = ''mkdir -p $out/bin; cp greet $out/bin/greet'';
  buildPhase = ''make'';
}
#  ...
  ```
])

*PA3-1*. Selecciona el programa correcto con el resultado solicitado. 
_"Dado `x = 10`, seleciona el programa que evalúa correctamente a \"grande\"."_

#choice_item(label: "a)", content: [
  CORRECTA
  ```nix  
  let
    x = 10;
  in
  if x < 5 then "pequeño"
  else if x < 10 then "mediano"
  else "grande"
  ```
])
#choice_item(label: "b)", content: [
 ```nix  
 let
    x = 10;
  in
  if x < 5 then "pequeño"
  else if x <= 10 then "mediano"
  else "grande"
  ```
])
#choice_item(label: "c)", content: [
```nix  
let
    x = 10;
  in
  if x > 10 then "grande"
  else if x > 5 then "mediano"
  else "pequeño"
  ```
])
#choice_item(label: "d)", content: [
```nix  
let
    x = 10;
  in
  if x < 5 then "manzanas"
  else if x < 10 then "peras"
  else "bananos"
  ```
])
#choice_item(label: "e)", content: [
```nix  
let
    x = 10;
  in
  if x < 5 then "pequeño"
  else if x < 10 then "mediano"
  ```
])

*PA3-2*. Selecciona el programa correcto con el resultado solicitado.
_"Un programa de nix que produzca un entorno de desarrollo para linux, y construya un paquete para macos."_

#choice_item(label: "a)", content: [
  ```nix
    out = {} : let 
      pkgsLinux = import nixpkgs { system = "x86_64-linux"; };
      pkgsMacos = import nixpkgs { system = "x86_64-darwin"; };
    in {
      devShells.x86_64-linux.default = pkgsMacos.stdenv.mkDerivation {
        #...
      };
      packages.x86_64-darwin.default = pkgsLinux.stdenv.mkDerivation {
        #...
      };
    };
  ```
])

#choice_item(label: "b)", content: [
  ```nix
  {
    outputs = { self, nixpkgs }:
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in {
        devShells.default = pkgs.mkShell {
          #...
        };
        packages.default = pkgs.stdenv.mkDerivation {
          #...
        };
      };
  }
  ```
])

#choice_item(label: "c)", content: [
  CORRECTA
  ```nix
  {
    outputs = { self, nixpkgs }:
      let
        pkgsLinux = import nixpkgs { system = "x86_64-linux"; };
        pkgsMacos = import nixpkgs { system = "x86_64-darwin"; };
      in {
        devShells.x86_64-linux.default = pkgsLinux.mkShell {
          #...
        };
        devShells.x86_64-darwin.default = pkgsMacos.stdenv.mkDerivation {
          #...
        };
      };
  }
  ```
])

#choice_item(label: "d)", content: [
  ```nix
  {
    outputs = { self, nixpkgs }:
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in {
        devShells.x86_64-linux.default = pkgs.mkShell {
          #...
        };
        packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
          #...
        };
      };
  }
  ```
])

#choice_item(label: "e)", content: [
  ```nix
{
  outputs = { self, nixpkgs }:
    let
      pkgsLinux = import nixpkgs { system = "x86_64-linux"; };
      pkgsMacos = import nixpkgs { system = "x86_64-darwin"; };
    in {
      packages.x86_64-darwin.default = pkgsMacos.stdenv.mkDerivation {
        #...
      };
    };
}
  ```
])

*PP4-1*. Selecciona el valor final de `[ f a ]` tras ser evaluado.
#block(
  fill: luma(97%),
  inset: 12pt,
  radius: 4pt,
)[
  ```nix
  let
  f = x: x + 1;
  a = 1;
  in [ f a ]
  ```]
*a)* `[ <lambda> 1 ]` CORRECTA\ 
*b)* `[ 2 ]`\
*c)* `2`\
*d)* `[ <lambda> ]`\
*e)* Error de evaluación\

*PP4-2*. Selecciona el resultado correcto para cuando se corre `nix build .#default` con el programa dado:
#block(
  fill: luma(97%),
  inset: 12pt,
  radius: 4pt,
)[
  ```nix
packages.${system}.default = pkgs.stdenv.mkDerivation {
  pname = "greet";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "example"; repo = "greet"; rev = "v1.0.0"; sha256 = "AAAA...";
  };
  nativeBuildInputs = [ pkgs.gcc ];
  buildPhase = ''gcc -O2 -o greet main.c'';
  installPhase = ''
    mkdir -p $out/bin
    cp greet $out/bin/greet
  '';
}; 
  ```
]
*a)* Nix compila usando el código fuente del directorio de trabajo actual en lugar de GitHub, ya que `fetchFromGitHub` solo se usa con fines de documentación.\
*b)* Nix obtiene el código fuente de GitHub en la revisión fijada, lo verifica con el hash sha256 proporcionado, compila main.c con gcc y genera un enlace simbólico que apunta a una ruta de almacenamiento que contiene `bin/greet`. (CORRECTO)\
*c)* Nix crea un entorno de desarrollo (dev shell) con `gcc` disponible.\
*d)* Nix obtiene el código fuente, pero omite la verificación del hash porque sha256 es un valor de marcador de posición, y se ejecuta correctamente sin mostrar ningún error, independientemente del contenido real.\
*e)* Nix compila el programa correctamente, pero el binario resultante se llama main, no greet, porque ese es el nombre del archivo fuente (`main.c`).\

*PP5-1*. Identifica cuantas variables son accesibles desde el bloque señalado en el comentario:

#code_block(content: [
  ```nix
{

  description = { };

  inputs = {
    nixpkgs.url = "";
    myconfigs.url = "";
  };

  outputs = { self, nixpkgs, mycofigs }:
    let
      a = "A";
    in
    let
      b = "B";
      c = "C";
    in
    {
      a = let d = "D"; in d;
      b = let
          e = "E";
        in
        {
          # <= HERE
        };
    };
}

  ```
])

*a)* 6\
*b)* 7 CORRECTA\
*c)* 8\
*d)* 5\
*e)* 4\


*PP5-2*. En base a la estructura del siguiente código que puedes decir de los tipos de `x, y, z, a`:

#code_block(content: [{ x, y, z }: (x y).a z;])

*a)* `x` es una función | `y` es un tipo cualquiera | `z` es un _attribute set_ | `a` es una función.\
*b)* `x` es una función | `y` es un tipo cualquiera | `z` es un tipo cualquiera | `a` es una función (CORRECTA).\
*c)* `x` es un _attribute set_ | `y` es una función | `z` es un tipo cualquiera | `a` es un tipo cualquiera.\
*d)* `x` es una función | `y` es un _attribute set_ | `z` es un tipo cualquiera | `a` es una función.\
*e)* `x` es una función | `y` es un tipo cualquiera | `z` es un tipo cualquiera | `a` es un _attribute set_.\

*PP6-1*. Selecciona el programa que evalué una expresión equivalente a :
#code_block(content: [
  ```nix
  {
    pname = "hello";
    version = "0.1";
    meta = {
      mantainers = [ ["1" "1"] ["2" "2"] ];
      source = {
        type = "github";
        remote = "github.com/example/repo";
      };
    };
  }
  ```
])

#choice_item(label: "a)", content: [
  ```nix
  {
    pname = "hello";
    version = "0.1";
    meta = {
      mantainers = [ ["1" "1"] ["2" "2"] ];
    };
    meta.source.type = "github";
  }
  ```
])
#choice_item(label: "b)", content: [
  ```nix
  let
    data = {
      mantainers = [ ["1" "1"] ["2" "2"] ];
      source = {
        type = "github";
        remote = "github.com/example/repo";
      };
    };
  in  {
    pname = "hello";
    version = "0.1";
    meta = { inherit data; };
  };
  ```
])
#choice_item(label: "c)", content: [
  ```nix
  let 
    info = {
      type = "github";
      remote = "github.com/example/repo";
    };
  in {
    pname = "hello";
    version = "0.1";
    meta.mantainers = [ ["1" "1"] ["2" "2"] ];
    meta.source = {inherit (info) type remote; };
  };
  ```
])
#choice_item(label: "d)", content: [
  ```nix
  {
    pname = "hello";
    version = "0.1";
    meta = {
      mantainers = [ ["1" "1"] ["2" "2"] ];
      source = {
        type = /github;
        remote = ./github.com/example/repo;
      };
    };
  }
  ```
])
#choice_item(label: "e)", content: [
  ```nix
  {
    pname = "hello";
    version = "0.1";
    meta.mantainers = let 
      _a = "1";
      _b = "2";
    in [ _a _a _b _b ] ; 
    meta.source = {
      type = "github";
      remote = "github.com/example/repo";
    };
  };
  ```
])


*PP6-2*. Selecciona el programa que evalúa a una expresión equivalente a:
```nix
{ x = "PKGS-A"; y = "OVERRIDE-B"; z = "OVERRIDE-C"; }
```

#choice_item(label: "a)", content: [
```nix  
let
    pkgs = { a = "PKGS-A"; b = "PKGS-B"; };
    overrides = { b = "OVERRIDE-B"; c = "OVERRIDE-C"; };
  in
  with overrides;
  with pkgs;
  {
    x = a;
    y = b;
    z = c;
  }
```
])
#choice_item(label: "b)", content: [
  CORRECTA
```nix  
let
    pkgs = { a = "PKGS-A"; b = "PKGS-B"; };
    overrides = { b = "OVERRIDE-B"; c = "OVERRIDE-C"; };
    b = "LET-B";
  in
  with pkgs;
  with overrides;
  {
    x = a;
    y = b;
    z = c;
  }
```
])
#choice_item(label: "c)", content: [
```nix  
let
    pkgs = { a = "PKGS-A"; b = "PKGS-B"; };
    overrides = { b = "OVERRIDE-B"; c = "OVERRIDE-C"; };
  in
  with pkgs;
  with overrides;
  {
    x = a;
    y = a;
    z = a;
  }
```
])
#choice_item(label: "d)", content: [
```nix
let
    pkgs = { a = "PKGS-A"; b = "PKGS-B"; };
    overrides = { b = "OVERRIDE-B"; c = "OVERRIDE-C"; };
  in
  with overrides // pkgs;
  {
    x = a;
    y = b;
    z = c;
  }
```
])

#choice_item(label: "e)", content: [
```nix
let
    base = { a = "PKGS-A"; b = "PKGS-B"; };
    patch = { b = "PKGS-A"; c = "PKGS-B"; };
  in
  with base;
  with patch;
  {
    x = a;
    y = b;
    z = c;
  }
```
])

*PP7-1*. En qué orden crees que se van a evaluar los diferentes atributos de esta expresión *recuerda que Nix evalua perezosamente*.

#code_block(content: [
  ```nix
let 
  content = rec {
    a = 1;      
    b = a + 2;
    c = b * 3;
  };
in 
content.c # La evaluación empieza aquí.
  ```
])
*a)* c #sym.arrow.r b #sym.arrow.r a (CORRECTA)\
*b)* a #sym.arrow.r b #sym.arrow.r c \
*c)* c & b #sym.arrow.r a\
*d)* a & b & c  \
*e)* c & a #sym.arrow.r b

*PP7-2*. Indica cual será el resultado de evaluar la siguiente expresión, *recuerda que Nix evalua perezosamente*.

#code_block(content: [
```nix
let
  list = [ (1 / 0) (2 / 0) ];
  x = computingThisTakesVeryLong;
in
  if builtins.length list == 2
    then "it's all good!"
    else x
```
])

*a)* Evalúa a `"it's all good!"`. (CORRECTA)\
*b)* Falla por división por cero.\
*c)* Falla por variable indefinida.\
*d)* Evalúa a `"it's all good!"`, pero porque Nix elimina automáticamente la rama else no usada.\
*e)* Tarda mucho en responder, porque Nix calcula `x`.\

*PP8-1*. Indica cual será el resultado de la siguiente operación.

#code_block(content: [
```nix
let
  numbers = [ 1 2 3 ];
  labels = [
    { name = "a"; value = 1; }
    { name = "b"; value = 2; }
  ];
in
{
  # map aplica una función a cada elemento de una lista,
  # devolviendo una nueva lista con los resultados
  a = map (n: n * 2) numbers;

  # listToAttrs convierte una lista de { name = ...; value = ...; }
  # en un attribute set, usando `name` como clave y `value` como valor
  b = builtins.listToAttrs labels;
}
```
])

#choice_item(label: "a)", content: [
  ```nix
{
  a = [ 1 2 3 ];
  b = [ { name = "a"; value = 1; } { name = "b"; value = 2; } ];
}
  ```
])

#choice_item(label: "a)", content: [
  ```nix
{
  a = [ 2 4 6 ];
  b = [ 1 2 ];
}
  ```
])

#choice_item(label: "b)", content: [
  ```nix
{
  a = 6;
  b = { a = 1; b = 2; };
}
  ```
])

#choice_item(label: "c)", content: [
  ```nix
{
  a = [ 2 4 6 ];
  b = { a = 1; b = 2; };
}
  ```
])

#choice_item(label: "d)", content: [
  ```nix
{
  a = [ 2 4 6 ];
  b = { name = "b"; value = 2; };
}
  ```
])

*PP8-2*. Indica cual será el resultado de la siguiente operación. Revisar el ejercicio anterior te puede ayudar a comprender el comportamiento de `map` y `builtins.listToAttrs`.

#code_block(content: [
```nix
let
  inventoryCreator =
    items: # Lista de nombres de items.
    # El resultado de map es dado a la funcion listToAttrs.
    (builtins.listToAttrs (
      map (item: {
        name = item;    # Nombre del elemento;
        quantity = 100; # Cantidad de dicho item;
      }) items
    ));
in
inventoryCreator [ "banana" "apple" ]
```
])


#choice_item(label: "a)", content: [
```nix
error: attribute 'value' missing
```
])
#choice_item(label: "b)", content: [
```nix
{ banana = 100; apple = 100; }
```
])

#choice_item(label: "c)", content: [
```nix
[
  { name = "banana"; quantity = 100; }
  { name = "apple"; quantity = 100; }
]
```
])

#choice_item(label: "d)", content: [
```nix
{ banana = null; apple = null; }
```
])
#choice_item(label: "e)", content: [
```nix
{ name = "apple"; quantity = 100; }
```
])

==== Respuestas Libres
En esta sección trabajarás con un programa ya empaquetado en Nix. En cada ejercicio deberás modificar el código siguiendo las instrucciones.

Se te proporcionará un entorno de desarrollo en línea (Codespaces) con todas las herramientas necesarias, por lo que no necesitas instalar nada en tu computadora.

Para cada ejercicio:

1. Lee la instrucción.
2. Modifica el código proporcionado.
3. Guarda los cambios y verifica que la solución funcione.
4. Cuando estés conforme con tu respuesta, copia el código solicitado y pégalo en el cuestionario.

*Los ejercicios son independientes entre sí. Si no logras resolver uno, puedes continuar con el siguiente*.
\
\
\
*PE9-1*. 
Has empaquetado correctamente un script de terminal que consulta el clima. Actualmente el paquete solo está disponible para la plataforma `x86_64-linux`.

Modifica el flake para que también soporte las siguientes plataformas:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

Evita duplicar código.

*Pista*: Puedes definir primero una lista con las plataformas y luego usar `nixpkgs.lib.genAttrs` para generar automáticamente los atributos para cada una de ellas.

#code_block(content: [
```nix
  {
    description = "weathercli — reporte del clima en la terminal";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs =
      { self, nixpkgs }:
      {
        packages.x86_64-linux =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;

            defaultConfig = pkgs.writeText "weathercli-config.json" (
              builtins.toJSON {
                city = "Tokyo";
                units = "metric";
                format = "compact";
              }
            );
          in
          {
            default = pkgs.stdenv.mkDerivation {
              pname = "weathercli";
              version = "1.0.0";

              src = ./.;

              nativeBuildInputs = [ pkgs.makeWrapper ];

              dontBuild = true;

              installPhase = ''
                mkdir -p $out/bin $out/share/weathercli
                install -m755 weathercli.sh $out/bin/weathercli
                install -m644 ${defaultConfig} $out/share/weathercli/config.json
              '';

              postFixup = ''
                wrapProgram $out/bin/weathercli \
                  --prefix PATH : ${
                    pkgs.lib.makeBinPath [
                      pkgs.curl
                      pkgs.jq
                    ]
                  } \
                  --set-default WEATHERCLI_CONFIG "$out/share/weathercli/config.json"
              '';
            };
          };
      };
  }
```
])

*PE10-1*. Tu script de clima utiliza un archivo de configuración llamado `weathercli-config.json` para indicar la ciudad a consultar. Sin embargo, el programa *también funciona si ese archivo no existe*.

Actualmente ese archivo es generado automáticamente por Nix.

*Modifica el código para que Nix deje de generar el archivo de configuración.*

*Pista:* Busca la parte del código donde se crea o escribe el archivo `weathercli-config.json` y los lugares donde son usadas.

#code_block(content: [
```nix
{
  description = "weathercli — reporte del clima en la terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Genera el archivo de configuración por defecto como JSON,
          # a partir de un attribute set de Nix.
          defaultConfig = pkgs.writeText "weathercli-config.json" (
            builtins.toJSON {
              city = "Roma";
              units = "metric";
              format = "compact";
            }
          );
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "weathercli";
            version = "1.0.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/bin $out/share/weathercli
              install -m755 weathercli.sh $out/bin/weathercli
              install -m644 ${defaultConfig} $out/share/weathercli/config.json
            '';

            postFixup = ''
              wrapProgram $out/bin/weathercli \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.curl
                    pkgs.jq
                  ]
                } \
                --set-default WEATHERCLI_CONFIG "$out/share/weathercli/config.json"
            '';

            meta = {
              description = "Reporte del clima en la terminal, configurable vía un archivo JSON";
              mainProgram = "weathercli";
              platforms = pkgs.lib.platforms.unix;
              license = pkgs.lib.licenses.mit;
            };
          };
        }
      );
    };
}
```
])

*PE11-1*. Tu script de clima ya está correctamente empaquetado. Ahora quieres crear un entorno de desarrollo donde ese paquete esté disponible.

Modifica el código para crear una devShell que incluya el paquete que definiste en el mismo flake.

*Pista:* Puedes acceder a ese paquete mediante el atributo `self`, por ejemplo: `self.packages.<sistema>.<nombre-del-paquete>`.

#code_block(content: [
```nix
{
  description = "weathercli — reporte del clima en la terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Genera el archivo de configuración por defecto como JSON,
          # a partir de un attribute set de Nix.
          defaultConfig = pkgs.writeText "weathercli-config.json" (
            builtins.toJSON {
              city = "Roma";
              units = "metric";
              format = "compact";
            }
          );
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "weathercli";
            version = "1.0.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/bin $out/share/weathercli
              install -m755 weathercli.sh $out/bin/weathercli
              install -m644 ${defaultConfig} $out/share/weathercli/config.json
            '';

            postFixup = ''
              wrapProgram $out/bin/weathercli \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.curl
                    pkgs.jq
                  ]
                } \
                --set-default WEATHERCLI_CONFIG "$out/share/weathercli/config.json"
            '';

            meta = {
              description = "Reporte del clima en la terminal, configurable vía un archivo JSON";
              mainProgram = "weathercli";
              platforms = pkgs.lib.platforms.unix;
              license = pkgs.lib.licenses.mit;
            };
          };
        }
      );
    };
}
```
])


=== Encuesta de Satisfacción 

Gracias por tu tiempo. Con tu ayuda, nos gustaría examinar como usuarios perciben la usabilidad de un Lenguaje Embebido de proposito específico (eDSL por sus siglas en inglés). Esto nos ayudará a encontrar areas de optimización de una manera que sea tan eficiente y comprensible como sea posible.

No te detengas demasiado en las combinaciones de palabras y realiza tu evaluación de forma espontánea. Puede que algunas combinaciones no te parezcan del todo adecuadas para el producto. Sin embargo, te pedimos que des tu opinión de todos modos. Recuerda que no hay respuestas correctas ni incorrectas; lo que cuenta es tu opinión personal.

*¿ Cómo calificarias la experiencia de usuario de eDSL?*

#linkert(pairs: (
    ("Bueno", "Malo"),
  ),
  grades: 7
)

*¿ Qué tan bien eDSL respondió a tus necesidades?*

#linkert(pairs: (
    ("Para nada", "Completamente"),
  ),
  grades: 7
)

*Con la ayuda de los pares de palabras marca cual considerarias seria la descripción para eDSL.*
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

*¿Algún comentario adicional que quieras destacar sobre tu experiencia usando eDSL? (Opcional)*