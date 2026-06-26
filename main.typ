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

  
  Trabajo de graduación presentado por Daniel Alfredo Rayo Roldán para optar al grado 
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


= Resumen
El problema de llevar _software_ de una computadora a otra y que siga funcionando (proceso conocido como Despliegue de _Software_) es un yugo con el que las Ciencias de Computación no han dado una solución definitiva, esencialmente porque para que una pieza de _software_ funcione correctamente no solamente depende del código fuente en el que esta escrita, sino del contexto que le rodea (_hardware_, sistema operativo, dependencias, etc.), bajo ese contexto surgen Nix como un manejador de paquetes y sistema de construcción #footnote[Sistemas que automatizan la ejecución de tareas repetitivas, usualmente para crear artefactos de _software_ que pueden ser desplegados] que utiliza un enfoque inspirado en la pureza funcional, donde cada paquete define explícitamente el contexto en el que espera ser construido y ejecutado. Este enfoque a demostrado poder crear más de 700 mil artefactos binariamente identicos en diferentes computadoras y contar con el repositorio de paquetes más grande a fecha de este documento. La idea evolucionó al punto de definir el estado casi completo de un sistema operativo mediante un solo archivo de configuración.

Sin embargo, a pesar de sus capacidades prometedoras, Nix no ha gozado de la misma adopción que otras herramientas que abordan los mismos problemas de reproducibilidad como Docker, Conda o VirtualEnv u otros manejadores de paquetes. Las causas de acuerdo a la comunidad son varias: Documentación compleja, errores cripticos, o un lenguaje de programación díficil de dominar; muchos de ellos no siendo problemas técnicos sino de experiencia de uso, y que cae en el rango de estudio del "DX" (Experiencia de Desarrollo por sus siglas en inglés). Este trabajó se enfoca en verificar si proveer una nueva forma de interactuar con Nix a travez de un lenguaje de proposito general como Typescript, puede reducir la barrera de entrada para nuevos usuarios y por ende mejorar su DX.

#pagebreak()

= Introducción

El distribuir _software_ de las cocinas de los ingenieros a las mesas de los usuarios finales no ha sido una tarea sencilla  @mantylaSoftwareDeploymentActivities2011, los artefactos de _software_ se comportan igual a las plantas exóticas cuando son transplantadas a un hábitat diferente al que están acostumbradas: se marchitan @Dolstra2006. Como las plantas, el _software_ "crece y evoluciona" en el _hardware_, sistema operativo y librerias específicas, de la computadora del ingeniero, pero en el momento que esos artefactos son llevados a los ecosistemas extraños, que son los dispositivos de los usuarios finales, el que funcione o no se vuelve una apuesta ante la que no se tiene control... o si? @Dolstra2006.

El problema anteriormente descrito, es el sujeto de estudio del campo de "Manejo de Configuracion de _Software_" (o CSM por sus siglas en íngles), donde se reconoce que la ejecucición correcta de _software_ no solamente depende de su código fuente, sino del contexto que le rodea @Dolstra2006. Con los años se ha desarrollado una familia de _software_, llamada *manejadores de paquetes* responsable de modificar el entorno global de las computadoras objetivo para conseguir las condiciones ideales para cada aplicación. Al día de hoy se han convertido en una familia tan variada que se han vuelto una característica diferenciadora en las diferentes distribuciones de Linux o lenguajes de programación @Gibb2026. Una corriente opuesta es la *virtualización*, que consiste en empaquetar las aplicaciones junto a los entornos completos que necesitan y ejecutarlas de forma aislada, soluciones de este tipo son muy usadas en servicios de la nube @PDFInfrastructureCode.

Sin embargo, como se ilustra en la @figura1, los manejadores de paquetes lidian con el problema que intentar satisfacer a varias aplicaciones en un entorno global puede llevar a conflictos irresolubles: cuando `FOO` y `BAR` dependen de versiones distintas de Node, el entorno global obliga a elegir una sola versión compatible (Node v23.8). La virtualización elimina ese conflicto permitiendo que cada aplicación lleve su propia versión en entornos separados, pero a cambio puede duplicar dependencias compartidas como Clang 19.2 @Zwinger2026, incrementando el consumo de almacenamiento @Sobieraj2024 @Lingayat2018.

#figure(image("media/Figure1.svg"), caption: [
  Dependencias de dos programas ficticios `FOO` y `BAR` en manejadores de paquetes vs. virtualización.
])<figura1>

_La unión hace la fuerza_, dando origen en 2003 a Nix como una tercera alternativa que fusiona ideas de ambas corrientes partiendo de la idea que: Usar los mismos ingredientes y pasos debería producir el mismo resultado sin importar la computadora. Nix garantiza lo primero mediante identificadores (ID) únicos en un entorno aislado (_Nix Store_) que, como se ve en la @figura2, permiten la coexistencia de versiones distintas del mismo paquete y la reutilización de dependencias compartidas, resolviendo los problema previos de `FOO` y `BAR`; y lo segundo mediante entornos aislados que aseguran la reproducibilidad @Dolstra2006. La elegancia de Nix reside en cómo construye estos identificadores y entornos aislados.

#figure(image("media/Figure2.svg", width: 70%), caption: [
  Manejo de paquetes en Nix con identificadores únicos permite coexistencia y reutilización de paquetes.
])<figura2>

Fue esta enfoque centrado en seguir recetas explícitas que permitió a Nix conseguir una serie de hitos importantes al contar con unos de los repositorios de paquetes generales más grandes de Linux @marakasovRepositoryStatistics, de los cuales 700 mil han demostrado poder replicarse de forma binariamente identica en diferentes computadoras @Malka2025. Aconteció que mucha de las ideas podían generalizarse hasta al punto de reproducir casi por completo un sistema operativo, dando origen a la distribución NixOS @Dolstra2008.

A pesar de ello , Nix ha gozado de una adopción bastante reducida en comparación a las otras herramientas discutidas @stackoverflowMostPopularTechnologies ¿Cuál es entonces su talón de Aquiles? Tal parece que no son necesariamente problemas técnicos, sino de experiencia de uso; en encuestas hechas en el foro oficial, la comunidad resaltaba problemas importantes con la documentación, errores crípticos y un _Domain Specific Language_ (DSL) díficil de dominar @2022NixSurvey2022 @NixCommunitySurvey2023; además, en otra encuesta, se estimó que los usuarios perciben requerir un tiempo de 5 años para dominar la herramienta a pesar que la mayoría lo usa a diario. Llevando a un raro caso donde a pesar que la comunidad le encanta la idea detrás de Nix @NixCommunitySurvey2024  sus problemas de usabilidad son tan severos que podrían estar impidiendo su uso, lo que concuerda con observaciones de otros estudio en herramientas son situaciones similares @goodwinFunctionalityUsability1987.

El concepto que los desarrolladores también son usuarios dio origen al campo de estudio de Experiencia de Desarrollo (o DX por sus siglas en inglés), donde el estudio sobre como los desarrolladores perciben sus herramientas ha sido un tema frecuente @Razzaq2024 sobre el que ya se han desarrollado algunos instrumentos como DEXI para evaluar dichas dimensiones@Kuusinen2016. Y dado el trayecto de intentos por mejorar la DX en Nix #cite-range("caddetNixNickel", "gagarinFourMonthsNix", "hufschmittCurrentStatePtyx", "fricklerhandwerk2022") el presente trabajo, busca ser una aplicación de las técnicas aprendidas en el campo de DX, en conjunto con el diseño de lenguajes, para evaluar si un Lenguaje de Proposito Específico Embebido (eDSL por sus siglas en inglés) en Typescript @Typescript podría ayudar a reducir la barra de entrada para nuevos desarrolladores en la herramienta.

#pagebreak()

= Objetivos

== General
Evaluar si un eDSL en TypeScript reduce la barrera de entrada a Nix —referente funcional y declarativo en gestión de paquetes, limitado por su curva de aprendizaje— frente a Nixlang, mediante tiempo de completación de tareas y experiencia de usuario.

== Específicos
1. Identificar los principales puntos de dolor cognitivos que presenta el lenguaje de Nix, para fundamenter el diseño de un eDSL, mediante sesiones de pensar-en-alto y "Programación Natural" con estudiantes de Ciencias de la Computación que no hayan utilizado Nix previamente.
2. Desarrollar un eDSL en TypeScript que sirva de prototipo funcional para la evaluación comparativa, capaz de generar archivos de configuración en Nixlang, cubriendo al menos las funcionalidades de la libreria estándar, verificado con una batería de pruebas.
3. Comparar Nixlang frente al eDSL desarrollado, para determinar si la familiaridad con Typescript reduce la carga cognitiva de adopción mediante un cuestionario estructurado, y el uso de Short AttrakDiff 2 y DEXI aplicados a estudiantes de Ciencias de la Computación sin experiencia previa, con análisis de diferencia estadística.

#pagebreak()

= Justificación

Con el crecimiento del mercado de los servicios de infrastructura como código @grandviewresearchInfrastructureCodeMarket, se ha aprendido que el poder definir el estado de sistemas completos a través de código, trae ventajas importantes en velocidad de desarrollo, escalabilidad y costos @pandyaIntroductionInfrastructureCode2022. La misma idea también se ha aplicado a entornos de desarrollo @ghanbariUsingDevelopmentEnvironment2026 o flujos de despliegue continuo @wesselGitHubActionsImpact2023; todo lo anterior sugiere que herramientas que permiten definir entidades o procesos de forma declarativa pueden facilitar el ciclo de desarrollo de _software_. En el manejo de paquetes, el panorama es fragmentado: habiendo alternativas por lenguaje, o indirectas como docker @Zwinger2026; y una solución declarativa de propósito general no es de el todo clara. Nix lleva años intentando llenar ese espacio — y las cifras sugieren que esta haciendo algo bien: al tener uno de los repositorios de paquetes más grandes de Linux, con 115 mil paquetes @marakasovRepositoryStatistics un crecimiento del 264% en número de mantenedores en los últimos seis años @gg-solutionsLinuxSilentTech2026.

Por medio de su lenguaje de configuración, Nix permite describir: la construcción, instalación y composición de paquetes de _software_ @Dolstra2006, habilidad que se ha mostrado aplicable en configuración de ambientes de Computacion de Alto Rendimiento @guilloteauPainlessTranspositionReproducible2022 @Gomez2020, sistemas operativos @Thiberg2025 despliege de _software_ @VanDerBurg2014, orquestación de servicios @FloxKubernetesUncontained o entornos de desarrollo @replitReplitHowWe2021. 

No obstante, a pesar de su versatilidad, Nix presenta una barrera de entrada considerable. Reportes sugieren una curva de aprendizaje pronunciada @NixCommunitySurvey2024, atribuida en parte a la complejidad de su lenguaje de configuración (Nixlang) para ciertos usuarios @fricklerhandwerk2022, aspecto que también su creador ha identificado como susceptible de mejora @Dolstra2018. Estas dificultades podrían estar incidiendo en su adopción relativamente limitada frente a herramientas como Docker @stackoverflowMostPopularTechnologies.

Nixlang es la principal interfaz para interactuar con el ecosistema Nix, es un lenguaje de dominio específico (DSL por sus siglas en inglés) diseñado  directamente para expresar los constructos de la herramienta, y es, en gran medida, responsable de la flexibilidad que la caracteriza @NixdevDocumentation. Sin embargo, esta misma especialización introduce complejidades que afectan su accesibilidad y usabilidad @Dolstra2018. Como respuesta, la comunidad ha explorado diversas estrategias para mitigar estas limitaciones, como : extensiones al lenguaje, con la incorporación de tipado estático —esfuerzos que han sido abandonados debido a su complejidad técnica— @caddetNixNickel @hufschmittCurrentStatePtyx; agentes de inteligencia artificial para generar configuraciones, aún sin validación empírica sólida en términos de usabilidad @Schwaighofer2026; y, en un enfoque más radical, la sustitución del lenguaje por Guile, un lenguaje de propósito general @Courts2013, aunque tampoco es un lenguaje muy conocido @stackoverflowMostPopularTechnologies, sabiendo que pertenece a la familia de Lisp @IntroductionGuileReference.

Con base en las propuestas anteriores se hizó un análisis comparativo (véase @Appendix1), donde se observa que las soluciones existentes tienden a introducir nuevas fuentes de complejidad o dependen de factores externos, sin abordar las causas estructurales de la fricción en Nix; esto sugiere que un posible buen enfoque consistiría en interactuar con Nix usando un lenguaje ampliamente conocido, y Typescript encaja muy bien en ese molde dada su popularidad @stackoverflowMostPopularTechnologies y similitud sintáctica con Nixlang, siendo descrito en ocasiones como "JSON con funciones" (siendo JSON una notación usada en Typescript) @NixdevDocumentation.

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
- *Anonimización*: Los datos recolectados serán disociados de la identidad de
  los participantes mediante el uso de códigos de identificación internos. Ningún
  dato publicado o analizado contendrá información que permita identificar a los
  participantes. Las transcripciones de los fragmentos verbales citados en el
  análisis serán igualmente anonimizadas.
- *Confidencialidad*: Los datos serán almacenados en dispositivos protegidos con
  contraseña, accesibles únicamente por el equipo investigador.
- *Destrucción de datos sensibles*: Las grabaciones de pantalla y voz obtenidas
  durante las sesiones serán destruidas una vez concluido el análisis de datos.
  Las transcripciones anonimizadas podrán conservarse como parte del registro
  de investigación por un período de 15 semanas tras su recolección.
- *Responsable del resguardo de datos*: Es autor principal de este estudio.
- *Compensación*: Como agradecimiento por su tiempo, los participantes recibirán
  una compensación simbólica en forma de un caramelo al finalizar la sesión. Esta
  compensación no condiciona la participación ni sus respuestas.
Antes de empezar, todos los participantes deberán leer y firmar un
*Consentimiento Informado* en el cual el equipo investigador se compromete a
cumplir los puntos anteriores. El formato utilizado se adjunta como anexo.

\
== Fase 1: Investigación preliminar <phase1>
El propósito de la primera fase es identificar los puntos de dolor que cuenta Nixlang, siendo la base para construir una solución los reduzca, a travez de un estudio cualitativo exploratorio.

=== Población y muestra

Se seleccionan estudiantes de Ciencias de la Computación de entre 18 y 24 años con experiencia limitada o nula en Nix y en el empaquetado de aplicaciones. Esta población fue elegida porque, según la encuesta más reciente de la comunidad Nix , representa el segundo grupo de usuarios más numeroso por edad (26.6%)@NixCommunitySurvey2024. Además, su perfil principiante permite evaluar las barreras de aprendizaje y los desafíos de usabilidad de Nixlang durante las etapas iniciales de adopción.

Se usa una muestra de N=10 participantes fundamenta en dos precedentes: un estudio pensar-en-alto sobre la experiencia de onboarding en Nix @fricklerhandwerk2022, que empleó la misma metodología con usuarios principiantes y produjo hallazgos relevantes sobre usabilidad de documentación, y un estudio de programación natural @paneStudyingLanguageStructure2001 que utilizó N = 14 para examinar cómo usuarios sin experiencia previa abordan tareas de programación; así como con estudio de saturación de relevancia en evaluaciones de usabilidad @wutichSampleSizes102024. Dado el carácter exploratorio y cualitativo de esta fase, dicho tamaño muestral es apropiado, sin pretensiones de generalización estadística.

=== Instrumentos

- *Formulario de perfil*: Recoge datos sobre la experiencia previa del
  participante con herramientas de gestión de paquetes y lenguajes de
  programación, así como su edad y semestre cursado.
- *Formulario de programación natural*: Presenta al participante una serie de
  problemas relacionados con el dominio del empaquetado de aplicaciones,
  solicitándole que describa con sus propias palabras un algoritmo para
  resolverlos. Está basado en la técnica de Programación Natural
  @panePDFMoreNatural2006, y se entrega de forma impresa junto con hojas en
  blanco para que el participante responda libremente.
- *Guía rápida de Nix*: Resumen de la sintaxis de Nixlang basado en la
  documentación oficial @NixdevDocumentation, presentado después del formulario
  de programación natural para evitar que el conocimiento del lenguaje influya
  en las respuestas previas.
- *Guía de actividades de pensar en alto*: Conjunto de tareas a resolver con
  Nixlang, siguiendo el protocolo de pensar en alto @PDFThinkAloud.

=== Procedimiento

Antes de iniciar la sesión, el participante lee y firma el consentimiento
informado y completa el formulario de perfil.

A continuación, se entrega el formulario de programación natural de forma
impresa. Esta actividad se realiza antes de presentar cualquier material sobre
Nixlang, con el propósito de capturar la intuición natural del participante sin
sesgo previo de exposición al lenguaje.

Una vez completado el formulario, se presenta la guía rápida de Nix para que el
participante pueda familiarizarse con las estructuras y reglas del lenguaje.

Por último, se inicia la sesión de pensar en alto utilizando una computadora
provista por el investigador. El participante verbaliza su proceso de
pensamiento mientras resuelve las tareas propuestas en Nixlang. Durante esta
sesión se graban la pantalla y el audio, previa autorización explícita en el
consentimiento informado.

=== Análisis de datos

Los datos recolectados se analizan con los siguientes objetivos: caracterizar el
perfil de los participantes, identificar patrones en sus respuestas de
programación natural, y categorizar los puntos de dolor cognitivos observados
durante las sesiones de pensar en alto. Los fragmentos verbales más
representativos pueden ser citados de forma textual en el análisis, previa
anonimización. Los hallazgos de esta fase orientaran el diseño del eDSL en la
Fase 2.

\
== Fase 2: Desarrollo del eDSL

Con base en los hallazgos de la Fase 1, se desarrollá un eDSL en TypeScript
capaz de generar archivos de configuración válidos en Nixlang. El diseño del
eDSL buscó abordar directamente los puntos de dolor identificados en la fase
anterior, cubriendo al menos las funcionalidades de la biblioteca estándar de
Nix. Esta fase no involucra participantes humanos y el código fuente se encuentra bajo la licencia MIT @MITLicense.

\
== Fase 3: Evaluación comparativa
La Fase 3 adopta un estudio cuantitativo basado en la ingeniería de software empírica
propuesto por @PDFComparisonXAML2026, adaptado al contexto de
comparación entre un DSL (Nixlang) y un eDSL en TypeScript. La fase se estructura en dos partes: una evaluación de comprensión cognitiva mediante un cuestionario estructurado, y una evaluación de experiencia de desarrollo mediante instrumentos de UX.


=== Población y muestra
Se reclutaron participantes con el mismo perfil que la Fase 1 (@phase1): estudiantes de Ciencias de la Computación con escasa o nula experiencia en Nix. Dado el carácter exploratorio del estudio y las limitaciones prácticas propias de una investigación a escala de tesis, se permitió la participación de sujetos que hubiesen tomado parte en la Fase 1, considerando que ambas fases estuvieron separadas por un período de 3 meses y que las tareas fueron diseñadas de forma independiente, minimizando así posibles efectos de aprendizaje directo. No obstante, esto constituye una limitación del estudio.

Se usa una muestra de N = 20 fue obtenido mediante un análisis de potencia realizado en G*Power @GPower para diseños intra-sujetos ccomparando medias, asumiendo un tamaño de efecto grande (dz = 0.8, α = 0.05, potencia = 0.90), el cual arrojó un mínimo de 19 participantes, redondeado a 20. Los resultados deben interpretarse en consecuencia y replicarse en trabajos futuros con muestras de mayor tamaño.

=== Instrumentos

- *Formulario de perfil*: Idéntico al utilizado en la Fase 1. Incluye una
  autoevaluación del nivel general de programación, experiencia en TypeScript y
  familiaridad previa con DSLs.
- *Tutoriales de Nixlang y eDSL*: Presentación del dominio del problema (gestión y
  empaquetado de aplicaciones) y de la sintaxis de Nixlang y el eDSL desarrollado, con ejemplos
  representativos.
- *Cuestionarios de comprensión cognitiva*: Instrumento structurado con
  preguntas que evalúaran el uso de Nixlang y el eDSL en tres categorías cognitivas basadas en el marco de
  Dimensiones Cognitivas @PDFComparisonXAML2026:
  - *Aprendizaje*: Selección de declaraciones sintácticamente correctas y
    programas válidos para un resultado dado.
  - *Percepción*: Identificación de constructos del lenguaje y
    significados correctos de programas.
  - *Evolución*: Preguntas de tipo ensayo donde se solicita al
    participante expandir, eliminar o modificar la funcionalidad de código
    existente.
  Además tambien se mide el tiempo de respuesta y tasa de éxito.

- *DEXI (Indice de Experiencia de Desarrollo)*: Instrumento para medir la experiencia de
  desarrollo @Kuusinen2016.
- *AttrakDiff-2 corto*: Instrumento para evaluar los aspectos hedónicos y emocionales de
    la experiencia con ambas herramientas @PDFNeedsAffect.
- *OUX (Evaluación general de la experiencia de usuario)*: Cuestionario para medir la percepción general de le experiencia de usuario usando una escala de Likert de 7 puntos basado en @Kuusinen2016.

=== Diseño experimental

Se empleó un diseño intra-sujetos en el que cada participante interactuó con ambas herramientas: Nixlang y el eDSL desarrollado. El orden de presentación fue contrabalanceado, de modo que la mitad de los participantes comenzó con Nixlang y la otra mitad con el eDSL, con el fin de controlar posibles efectos de orden. Cada herramienta fue evaluada en una sesión independiente, pudiendo realizarse en días distintos, con el fin de adaptarse a la disponibilidad de los participantes.
=== Procedimiento

Al inicio de cada sesión, el participante firma el consentimiento informado si es su primera sesión, o confirma su continuidad si es la segunda, y completa el formulario de perfil correspondiente. A continuación, se le presenta el tutorial de la herramienta asignada para esa sesión. Una vez revisado el material, el participante resuelve las tareas propuestas y responde el cuestionario de comprensión cognitiva para esa condición. Inmediatamente al finalizar, completa los cuestionarios DEXI, OUX y AttrakDiff evaluando su experiencia con dicha herramienta. Este procedimiento se repite de forma idéntica en la sesión correspondiente a la segunda herramienta.

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

== Soluciones existentes a NixLang <Appendix1>



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
  [Dependencia de funciones de la libreria estándar con muchos parámetros no documentados.],
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