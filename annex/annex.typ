#import "../utilities.typ" : cb, linkert, answer-box, choice_item, code_block

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
image("1/indice de interes de Neovim en el tiempo.png", width: 74%),
caption: [Índice de interés de búsqueda de Neovim en Google entre 2014 y 2026. Se observa un aumento a finales de 2021, aproximadamente seis meses después de la introducción del soporte para Lua @NeovimNews112021.]
)

== Número de dependencias de Firefox <Appendix5>
Con datos extraidos de Github del repositorio de `mozilla-firefox/firefox` para el commit `ac91bfcce1bf3240e2dce40f47c372e76bc4f26c` se descargaron las dependencias detectadas por Github en formato SBOM en la sección de "Grafo de Dependencias", revelando una total de 22,732 dependencias. Los datos utilizados se encuentran en.

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

#figure(image("3/diagram1.svg", width: 60%), caption: [Dependencias ficticias de `VS Code` y `Discord`; ambos tienen una dependencia compartida en `Electron`, a su vez estas dependencias dependen de otras.])<diagram1>

*El manejador de paquetes que tú vas a crear funciona de manera diferente a los tradicionales*. En lugar de ejecutar un comando como `instalar paquete-X`, *tú describes lo que quieres en un archivo de configuración*, y el manejador de paquetes se encarga de llevarlo a cabo. Esto significa que toda la información sobre qué instalar, cómo construirlo y de qué depende queda registrada explícitamente en ese archivo.

Para describir un paquete en este sistema, necesitas especificar al menos:

- *De dónde obtenerlo* — la URL o repositorio desde donde se descarga su código fuente o ejecutables.
- *Sus dependencias* — otros paquetes que deben estar presentes para que este funcione.
- *Cómo construirlo* — los pasos necesarios para compilarlo o instalarlo una vez descargado.

- *Para qué arquitectura construirlo* — los paquetes se compilan para un tipo de procesador específico, como x86_64 (la mayoría de computadores de escritorio) o arm (dispositivos móviles y algunos computadores modernos). Un paquete compilado para una arquitectura no funcionará en otra.

Puedes imaginar cada paquete como una receta de cocina: tiene ingredientes (dependencias) que obtienes de algúna tienda (fuentes), se prepara en una cocina específica (arquitectura), y sigue una serie de pasos (instrucciones de instalación) que van desde preparar los ingredientes hasta tener el plato listo para servir.


#figure(image("3/diagram2.png", width: 80%), caption: [Los diferentes componentes a tomar en cuanta para describir un paquete de _software_])<diagram2>

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
