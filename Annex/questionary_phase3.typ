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

#align(center)[= Prueba de Usabilidad en Lenguajes de Programación]
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

== Instrucciones

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

== Respuestas Libres
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