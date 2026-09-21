# Lineamientos de desarrollo — PAWPrints Frontend

Documento normativo del equipo. Aplica a **todo** el código del repositorio a partir del TP2.
Si algo no está contemplado acá, se resuelve respetando los criterios genéricos definidos en
este documento y se documenta después.

---

## 0. Regla número 1 — CSS vanilla

> **Solo se permite CSS escrito a mano. Cero frameworks. Cero librerías. Cero preprocesadores.**

Esto significa **prohibido**:

| Prohibido | Ejemplos |
|---|---|
| Frameworks CSS | Bootstrap, Tailwind, Bulma, Foundation, Pico, Water.css |
| Librerías de componentes | Material, DaisyUI, Shoelace |
| Preprocesadores | Sass, SCSS, Less, Stylus |
| Post-procesadores / build | PostCSS, autoprefixer, cssnano, Vite, Parcel |
| Resets de terceros | normalize.css, sanitize.css, reset.css de Meyer |
| Icon fonts / kits externos | Font Awesome, Bootstrap Icons, Material Symbols |
| CSS servido desde CDN | `<link href="https://cdn...">` de cualquier tipo |
| JavaScript | cualquier `.js`, cualquier `<script>` (el TP2 es solo estilos) |

Esto significa **permitido**:

- CSS nativo: custom properties, `@media`, `@supports`, `@font-face`, `@import`,
  Grid, Flexbox, `clamp()`, `min()`, `max()`, `calc()`, `:has()`, `:is()`, `:where()`,
  anidamiento CSS nativo, capas (`@layer`).
- Tipografías **auto-hospedadas** en `assets/fonts/` mediante `@font-face`.
  Una tipografía no es un framework. Lo que está prohibido es la **dependencia externa**
  (Google Fonts por `<link>`), no el archivo `.woff2` versionado en el repo.
- SVG inline o como archivo en `assets/img/`. Los íconos se dibujan, no se importan.

**Cómo se verifica antes de cada entrega:**

Guardá esto como `scripts/verificar.sh` y corrélo desde la raíz del repo:

```bash
#!/usr/bin/env bash
# Verificación de la regla número 1 y de las convenciones de CSS.
# Cada chequeo debe producir salida VACÍA. Devuelve 1 si algo falla.

fallas=0
check() { # check "<nombre>" "<salida del comando>"
  if [ -z "$2" ]; then
    printf '  OK   %s\n' "$1"
  else
    printf '  FALLA %s\n' "$1"; printf '%s\n' "$2" | sed 's/^/        /'
    fallas=$((fallas + 1))
  fi
}

check "sin recursos externos cargados" "$(
  rg -n '(<link[^>]*href|<script[^>]*src|<img[^>]*src|<iframe[^>]*src|@import|url\()[^>]*https?://' \
     --glob '*.html' --glob '*.css' . )"

check "sin JavaScript" "$(
  rg -n '<script|\son[a-z]+\s*=|\.js"' --glob '*.html' . )"

check "sin manifiestos de dependencias" "$(
  fd -H '^(package|package-lock|yarn|bun|pnpm)' . )"

check "sin hex fuera de tokens.css" "$(
  rg -n '#[0-9a-fA-F]{3,8}\b' assets/css --glob '!**/tokens.css' )"

check "sin !important fuera de print.css" "$(
  rg -n '!important\s*;' assets/css --glob '!**/print.css' )"

check "sin estilos por id" "$(
  rg -n '^\s*#[a-zA-Z][\w-]*\s*[,{]' assets/css )"

[ "$fallas" -eq 0 ] && echo "TODO OK" || echo "$fallas chequeo(s) fallaron"
exit $((fallas > 0))
```

> **Por qué un script y no seis comandos sueltos.** Encadenar
> `comando && echo "mal" || echo "OK"` **da resultados falsos**, y nos pasó tres veces:
>
> - `fd` sale con **código 0 aunque no encuentre nada**, así que el `&&` reportaba
>   "hay manifiestos" cuando no había ninguno.
> - `rg --glob '!01-settings/tokens.css'` **no excluye nada**: los globs de `rg` se
>   resuelven contra el directorio actual, no contra la ruta buscada. Hay que usar
>   `'!**/tokens.css'`.
> - `rg -n '!important'` marcaba como violación la palabra escrita **dentro de un
>   comentario** que justamente documenta la prohibición. Por eso ahora se busca
>   `!important\s*;`, que solo aparece en una declaración real.
>
> Una verificación que da falsos positivos es peor que no tener verificación: entrena
> al equipo a ignorarla. Si cambiás un chequeo, **probalo contra un caso que debe fallar**
> antes de darlo por bueno.

> **Ojo con el comando 1:** busca recursos *cargados*, no cualquier URL.
> Los `<a href="https://...">` a redes sociales en `contacto.html` y el footer son
> **legítimos y obligatorios** — el TP1 pide explícitamente dar peso a las redes de la
> librería. Un link de navegación no es una dependencia. Un `<link rel="stylesheet">`
> a un CDN sí.

---

## 1. Estado del proyecto

- **Etapa actual:** TP2 — Estilos.
- **Base:** TP1 entregado (maquetado HTML5 semántico, sin CSS).
- **Entrega:** tag `tp2` sobre este mismo repositorio.
- **Figma de referencia:** `OVQUC7OFmjIB2e0KPmntXe`
- **Manual de identidad:** opción **Violeta** (Universidad de La Laguna),
  `docs/Manual básico Identidad PAWPrints VIoleta.pdf`.

### 1.1 Divergencia de ramas — resuelta el 2026-09-19

**Qué pasó.** `dev` y `main` no compartían historia reciente. No era que `dev`
estuviera atrasada: eran dos trabajos paralelos que nunca se integraron.

| | `main` (`841d627`) | `dev` viejo (`73bce4c`) |
|---|---|---|
| Origen | PR #1 `feature/maquetado-tp1` | commit inicial `9e97b73` |
| Autoría | Agustina Ortiz + MateoPonti | MateoPonti |
| Páginas | **21** + `index.html` + `img/` | **5**, sin `index.html` |
| `catalogo.html` | 302 líneas | 544 líneas |
| `categorias.html` | 210 líneas | 391 líneas |
| `detalle-libro.html` | 291 líneas | 537 líneas |
| `nosotros.html` | 186 líneas | 356 líneas |

`git merge-base main dev` devolvía el commit inicial; un merge directo daba
**27 archivos en conflicto**.

**Decisión del equipo (T-00):** gana la versión de **`main`**, por cobertura —
el sitio completo pesa más que 5 páginas con maquetado más extenso.

**Qué se hizo:**

1. Se respaldó el `dev` viejo en el tag **`backup/dev-descartado-tp1`** → `73bce4c`.
   Los 4 commits descartados siguen siendo recuperables.
2. Se borró `dev` y se recreó desde `origin/main` (`841d627`).
3. Se creó `feature/estilados` desde el nuevo `dev`. Ahí va todo el TP2.

Si alguna vez se quiere rescatar maquetado del `dev` viejo:

```bash
git show backup/dev-descartado-tp1:pages/catalogo.html
git diff backup/dev-descartado-tp1 dev -- pages/nosotros.html
```

**Regla permanente que sale de acá:** toda rama `feature/` sale de `dev`, y `dev`
se sincroniza con `main` **antes** de abrir cualquier feature. Nunca más se
ramifica desde un commit arbitrario.

### 1.2 Flujo de ramas del TP2

```
origin/main ──→ dev ──→ feature/estilados ──(PR, con validación del equipo)──→ dev
```

- Todo el TP2 se implementa en **`feature/estilados`**.
- Se integra a `dev` **por Pull Request**, no por merge directo, y recién cuando el
  equipo validó los cambios.
- `dev` **no tiene upstream configurado** a propósito: cuando tenía `origin/main`
  como upstream, un `git push` desde `dev` habría ido directo a `main`. Al publicarla,
  usar explícitamente `git push -u origin dev`.

---

## 2. Identidad corporativa — lo que dice el manual

Fuente única de verdad. Cualquier valor de color o tipografía que no salga de acá
tiene que estar justificado en este documento como **derivado**.

### 2.1 Color

| Rol | Valor |
|---|---|
| **Violeta corporativo** | `#5c068c` — PANTONE 2597 C — CMYK 82/100/0/0 — RGB 87/6/140 |
| **Blanco** | `#ffffff` — CMYK 0/0/0/0 |

Estrategia que impone el manual, textual:

> *"El color principal es el fondo —tanto si es el Blanco como el Violeta—, que es el espacio
> sobre el que se sitúa la información. El segundo color acentúa la información. Es el detalle
> que destaca sobre el fondo."*
>
> *"El color es un elemento fundamental de la identidad y la estrategia de color se usará de
> manera intensiva y consistente."*

Traducción a reglas de diseño para el sitio:

1. Toda superficie es **blanca o violeta**. No hay una tercera superficie de marca.
2. El violeta **acentúa**: títulos, links, botones primarios, bordes activos, estados.
3. Las secciones "en negativo" (fondo violeta, texto blanco) se usan para destacar:
   hero de inicio, franja de promociones, footer. Es una decisión de contraste, no decorativa.
4. No se introducen colores de marca nuevos. Los grises y tintes de la §2.3 son
   **derivados utilitarios de interfaz**, no colores corporativos, y solo existen para
   legibilidad y jerarquía.

### 2.2 Tipografía

- Corporativa: **Argentum Sans**, licencia Open Font License.
- El propio manual establece el equivalente: **Montserrat** (Argentum Sans es una evolución
  de Montserrat). Usamos Montserrat auto-hospedada.
- Pesos definidos como corporativos: **Light 300**, Regular 400, Medium 500,
  **SemiBold 600**, Bold 700.
- Los pesos identificativos principales son **SemiBold y Light**. Regular, Medium y Bold
  también son corporativos.

Regla práctica: títulos en **600**, cuerpo en **400**, textos grandes de display en **300**,
énfasis puntual en **500**. El **700** se reserva para casos muy puntuales (precio destacado).

### 2.3 Usos incorrectos — prohibiciones explícitas del manual

El manual prohíbe expresamente sobre la **marca**:

- Alteraciones de la marca, cambios de tipografía, cambios de color.
- Rotaciones, baja calidad, **efectos (sombra, 3D, etc.)**.
- Tramas sobre la marca, mala legibilidad sobre fondos, deformaciones.

Consecuencias directas para nuestro CSS:

- El logotipo (`.l-header__brand img`, SVG oficial en `assets/img/logo/`) **nunca** recibe `transform`, `text-shadow`,
  `filter`, ni cambio de color fuera de las versiones oficiales (violeta sobre blanco /
  blanco sobre violeta).
- El logotipo respeta un **área de reserva**: padding mínimo alrededor, no se apoya contra
  otros elementos.
- Preferencia cromática para la marca, en este orden: colores corporativos → blanco y negro
  → sobre imagen → colores no corporativos. En el sitio usamos siempre la 1ª.

---

## 3. Arquitectura CSS

### 3.1 Estructura de archivos

```
assets/
├── fonts/
│   ├── montserrat-300.woff2
│   ├── montserrat-400.woff2
│   ├── montserrat-500.woff2
│   ├── montserrat-600.woff2
│   └── montserrat-700.woff2
├── img/
│   ├── logo/
│   └── libros/
└── css/
    ├── main.css                  ← ÚNICO archivo enlazado desde el HTML
    ├── 01-settings/
    │   ├── fonts.css             @font-face
    │   └── tokens.css            :root { --* }
    ├── 02-base/
    │   ├── reset.css             reset propio, escrito a mano
    │   ├── typography.css        h1-h6, p, ul, small, address, time
    │   └── elements.css          a, img, table, hr, figure, input base
    ├── 03-layout/
    │   ├── container.css         .l-container, anchos máximos
    │   ├── header.css            .l-header
    │   ├── footer.css            .l-footer
    │   └── page.css              .l-page, .l-sidebar, .l-grid
    ├── 04-components/
    │   ├── button.css            .c-button
    │   ├── breadcrumb.css        .c-breadcrumb
    │   ├── card-book.css         .c-card-book
    │   ├── form.css              .c-form, .c-field
    │   ├── filters.css           .c-filters
    │   ├── pagination.css        .c-pagination
    │   ├── badge.css             .c-badge
    │   └── rating.css            .c-rating
    ├── 05-utilities/
    │   └── utilities.css         .u-visually-hidden, .u-flow, .u-text-center
    └── 06-print/
        └── print.css             @media print
```

`main.css` es lo único que se enlaza. Su contenido es exclusivamente imports, en orden:

```css
/* main.css — orden de la cascada. NO reordenar. */
@import url("01-settings/fonts.css");
@import url("01-settings/tokens.css");
@import url("02-base/reset.css");
/* ...resto en el orden de las carpetas... */
@import url("06-print/print.css");
```

**Por qué un solo `<link>`:** el header y el footer se copian a mano en cada página
(ver §5). Un solo punto de inserción significa un solo lugar donde equivocarse.
Sí, `@import` serializa requests — en un TP estático de 13 páginas el costo es
irrelevante frente a la claridad. No se optimiza lo que no duele.

En cada página, dentro de `<head>`, exactamente una línea:

```html
<link rel="stylesheet" href="/assets/css/main.css">
```

### 3.2 Orden de la cascada

`settings → base → layout → components → utilities → print`.

Especificidad creciente. Una utilidad puede pisar un componente; un componente
nunca pisa una utilidad. Esto se sostiene por **orden**, no por `!important`.

**`!important` está prohibido**, con una única excepción: dentro de `06-print/print.css`,
donde es aceptable para forzar el modo impresión.

### 3.3 Convención de nombres

Prefijos, sin excepciones:

| Prefijo | Significado | Ejemplo |
|---|---|---|
| `l-` | Layout — ubica y distribuye, no decora | `.l-container`, `.l-grid` |
| `c-` | Componente — pieza reutilizable con identidad propia | `.c-card-book` |
| `u-` | Utilidad — una sola responsabilidad, puede pisar | `.u-visually-hidden` |
| `is-` / `has-` | Estado | `.is-active`, `.has-error` |

Dentro de un componente, BEM simplificado:

```css
.c-card-book { }              /* bloque   */
.c-card-book__title { }       /* elemento */
.c-card-book--featured { }    /* modifier */
```

Reglas duras:

- **Nunca** estilar por `id`. Los `id` del HTML existen para `for`/`aria-labelledby`.
- **Máximo 2 niveles** de anidamiento en un selector. Si necesitás tres, falta una clase.
- **Nada de selectores descendentes largos** tipo `main section aside form fieldset p label`.
- Los selectores de elemento se permiten **solo** en `02-base/` y dentro del alcance
  de un componente para elementos sin clase (`.c-form fieldset`, `.c-breadcrumb li`).

### 3.4 Sobre agregar `class` al HTML del TP1

El TP1 se entregó con HTML semántico puro, sin ninguna clase. Estilarlo entero con
selectores de elemento es posible pero frágil: cualquier `<section>` nueva rompe reglas
escritas para otra `<section>`.

**Decisión del equipo:** se agregan clases al HTML, con dos límites innegociables.

1. **No se cambia la semántica.** Ni un `<section>` pasa a `<div>`, ni un `<article>` a
   `<section>`, ni se elimina un `aria-*`. Lo que se entregó en el TP1 sigue siendo
   válido después del TP2.
2. **Se agregan solo las clases necesarias** para layout y componentes. Tipografía,
   links, tablas y formularios base se resuelven por selector de elemento en `02-base/`
   y no llevan clase.

El TP2 autoriza esto textualmente: *"En caso de ser necesario, ajustar las características
de los mismos para que se adapten al manual de identidad corporativa."*

Si alguien prefiere el camino sin clases, tiene que proponerlo **antes** de que empiece
la Fase 3 del plan, no después.

---

## 4. Design tokens

Todos los valores viven en `01-settings/tokens.css`, en `:root`, como custom properties.
**Prohibido escribir un hex, un `px` de espaciado o un `font-size` literal fuera de ese archivo.**

```css
:root {
  /* ---- Marca (manual de identidad — NO TOCAR) ---- */
  --color-brand:        #5c068c;
  --color-white:        #ffffff;

  /* ---- Derivados de interfaz (NO son colores corporativos) ---- */
  --color-brand-dark:   #3d045e;   /* hover / pressed */
  --color-brand-soft:   #8b3fb8;   /* bordes, estados sutiles */
  --color-brand-tint:   #f4eef9;   /* fondos suaves */
  --color-ink:          #1c1020;   /* texto cuerpo */
  --color-ink-muted:    #5b4b66;   /* texto secundario */
  --color-border:       #e3d8ec;
  --color-danger:       #a4133c;   /* validación de formularios */
  --color-success:      #1b5e3f;

  /* ---- Superficies semánticas ---- */
  --surface:            var(--color-white);
  --surface-invert:     var(--color-brand);
  --on-surface:         var(--color-ink);
  --on-surface-invert:  var(--color-white);

  /* ---- Tipografía ---- */
  --font-base: "Montserrat", "Segoe UI", system-ui, -apple-system, sans-serif;
  --fw-light: 300;  --fw-regular: 400;  --fw-medium: 500;
  --fw-semibold: 600;  --fw-bold: 700;

  --fs-xs:   0.75rem;
  --fs-sm:   0.875rem;
  --fs-base: 1rem;
  --fs-md:   clamp(1.125rem, 1rem + 0.5vw,  1.25rem);
  --fs-lg:   clamp(1.375rem, 1.1rem + 1vw,  1.75rem);
  --fs-xl:   clamp(1.75rem,  1.3rem + 2vw,  2.5rem);
  --fs-2xl:  clamp(2.25rem,  1.6rem + 3vw,  3.5rem);

  --lh-tight: 1.2;
  --lh-base:  1.6;

  /* ---- Espaciado — escala base 4px ---- */
  --sp-1: 0.25rem;  --sp-2: 0.5rem;   --sp-3: 0.75rem;
  --sp-4: 1rem;     --sp-5: 1.5rem;   --sp-6: 2rem;
  --sp-7: 3rem;     --sp-8: 4rem;     --sp-9: 6rem;

  /* ---- Layout ---- */
  --container-max: 75rem;   /* 1200px */
  --prose-max:     65ch;
  --radius-sm: 4px;  --radius-md: 8px;  --radius-lg: 16px;

  /* ---- Bordes y foco ---- */
  --border-width: 1px;
  --focus-ring: 3px solid var(--color-brand-soft);
  --focus-offset: 2px;
}
```

**Gotcha a recordar:** las custom properties **no funcionan dentro de `@media`**.
`@media (min-width: var(--bp-md))` no existe. Los breakpoints van escritos literales
y documentados acá:

| Nombre | Valor | Uso |
|---|---|---|
| `sm` | `30rem` / 480px | ajustes menores de mobile grande |
| `md` | `48rem` / 768px | tablet — el layout empieza a abrirse |
| `lg` | `64rem` / 1024px | desktop — sidebar + contenido |
| `xl` | `80rem` / 1280px | desktop ancho |

---

## 5. Responsive — mobile, desktop e impresión

El TP2 lo pide explícitamente: *"generar el código necesario para que las pantallas se
adapten a las versiones mobile, desktop y de impresión."*

### 5.1 Mobile first, sin excepción

Los estilos base son los de mobile. Se sube con `min-width`.
**Prohibido `max-width` como estrategia principal.** Solo se admite `max-width`
puntual para revertir algo que únicamente aplica a desktop.

```css
/* ✅ correcto */
.l-grid { display: grid; gap: var(--sp-4); }
@media (min-width: 48rem) { .l-grid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 64rem) { .l-grid { grid-template-columns: repeat(4, 1fr); } }
```

### 5.2 Reglas de layout responsive

- Grid para estructuras bidimensionales, Flexbox para filas/columnas simples.
- Nada de anchos fijos en `px` para contenedores. `max-width` + `width: 100%`.
- Imágenes: `max-width: 100%; height: auto; display: block;` desde `02-base/elements.css`.
- Tablas anchas y bloques que no achican van dentro de un wrapper con `overflow-x: auto`.
- **El `<body>` nunca scrollea horizontalmente.** Se verifica a 320px de ancho.
- Área táctil mínima de botones y links de navegación: 44×44px.

### 5.3 Impresión

`06-print/print.css`, dentro de `@media print`:

- Ocultar: `header nav`, buscador del header, `footer nav`, breadcrumb, paginación,
  filtros, botones de acción, carrito.
- Fondo blanco, texto negro. Nada de fondos violetas en impresión (gasta tinta y
  el manual prioriza legibilidad).
- Expandir links: `a[href^="http"]::after { content: " (" attr(href) ")"; }`.
- `@page { margin: 2cm; }`.
- Evitar cortes: `h1, h2, h3 { break-after: avoid; }`, `article { break-inside: avoid; }`.

### 5.4 Preferencias del usuario

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

(Única excepción a la prohibición de `!important` fuera de print — es el patrón estándar
para respetar la preferencia del sistema.)

---

## 6. Accesibilidad

No es un extra. El TP1 se hizo con semántica y `aria-*` — el CSS no puede destruirlo.

- **Contraste mínimo AA:** 4.5:1 en texto normal, 3:1 en texto grande.
  `#5c068c` sobre `#ffffff` da ~11:1. Blanco sobre `#5c068c`, lo mismo. Ambos sobran.
  Todo derivado nuevo se verifica antes de entrar a `tokens.css`.
- **Foco siempre visible.** Prohibido `outline: none` sin reemplazo.
  ```css
  :focus-visible { outline: var(--focus-ring); outline-offset: var(--focus-offset); }
  ```
- **El color nunca es el único portador de información.** Un error de formulario lleva
  texto, no solo borde rojo.
- Los `<label>` que el diseño esconde se ocultan con `.u-visually-hidden`,
  **nunca** con `display: none` ni `visibility: hidden` (los saca del árbol de accesibilidad).
  ```css
  .u-visually-hidden {
    position: absolute; width: 1px; height: 1px;
    padding: 0; margin: -1px; overflow: hidden;
    clip-path: inset(50%); white-space: nowrap; border: 0;
  }
  ```
- El orden visual (`order`, `grid-area`) no debe contradecir el orden del DOM.
- `aria-current="page"` ya existe en el HTML: se estila con `[aria-current="page"]`,
  no con una clase nueva.

---

## 7. Componentes compartidos — header y footer

Sigue vigente `components/README.md`: `components/header.html` y `components/footer.html`
son el **markup canónico**, y cada página lleva una copia entre los marcadores
`#region` / `#endregion`.

Flujo obligatorio cuando se toca el header o el footer:

1. Editar **solo** `components/header.html` (o `footer.html`).
2. Propagar la copia a **todas** las páginas.
3. Verificar que no quedó ninguna divergencia:

```bash
# Extrae el bloque de una página: quita las líneas marcadoras (1d;$d)
# y descuenta la sangría de 2 espacios que tiene dentro de <body>.
extraer() {
  sed -n "/#region components\/$2/,/#endregion components\/$2/p" "$1" \
    | sed '1d;$d' \
    | sed 's/^  //'
}

# HEADER — se normaliza aria-current="page", que legítimamente difiere por página
for f in index.html pages/*.html; do
  diff <(extraer "$f" header.html | sed 's/ aria-current="page"//') \
       <(sed 's/ aria-current="page"//' components/header.html) >/dev/null \
    && echo "OK      $f" || echo "DIVERGE $f"
done

# FOOTER — idéntico en todas, sin excepciones
for f in index.html pages/*.html; do
  diff <(extraer "$f" footer.html) components/footer.html >/dev/null \
    && echo "OK      $f" || echo "DIVERGE $f"
done
```

Las 21 páginas deben devolver `OK`. Un solo `DIVERGE` significa que alguien editó el
bloque inline en vez de editar el componente y re-propagar.

> **Por qué el `extraer()` hace esas dos limpiezas.** Un `sed -n '/#region/,/#endregion/p'`
> a secas devuelve **también las líneas marcadoras**, y el bloque copiado dentro de
> `<body>` lleva **2 espacios más de sangría** que el archivo canónico. Sin descontar
> ambas cosas el `diff` da `DIVERGE` en las 21 páginas aunque estén perfectas —
> un falso positivo que hace desconfiar de una verificación que en realidad está bien.
>
> El `aria-current="page"` se normaliza en vez de "anotarlo a mano": una excepción que
> depende de que alguien la recuerde no es una verificación, es una ceremonia.

Esta duplicación es deuda técnica asumida por la restricción del TP (sin includes,
sin server-side). Se salda en el TP3 cuando entre backend.

---

## 8. Git

### 8.1 Ramas

```
main                → base estable, solo recibe merges desde test
test                → validación previa a main
dev                 → integración continua del equipo
feature/<tema>      → trabajo individual, sale de dev y vuelve a dev
```

**Para el TP2 la rama de trabajo es una sola: `feature/estilados`** (ver §1.2).
Todas las fases del plan se implementan ahí y entran a `dev` por Pull Request.
No se abre una rama por fase ni por área: multiplicar ramas sobre un mismo trabajo
secuencial genera merges cruzados que nadie necesita.

El esquema `feature/<tema>` por área queda para los TP siguientes, cuando haya
trabajo realmente paralelo.

**Nunca se commitea directo a `main` ni a `dev`.**

### 8.2 Commits — Conventional Commits, obligatorio

```
<tipo>(<alcance>): <descripción en imperativo, minúscula, sin punto final>
```

Tipos: `feat`, `fix`, `style`, `refactor`, `docs`, `chore`.

Alcance sugerido: `tokens`, `base`, `layout`, `header`, `footer`, `catalogo`,
`detalle`, `form`, `nosotros`, `print`, `a11y`.

```
feat(tokens): definir paleta violeta y escala tipográfica del manual
feat(header): maquetar header responsive mobile-first
fix(catalogo): corregir desborde horizontal de la grilla a 320px
docs(lineamientos): documentar breakpoints
```

**Prohibido** agregar líneas de coautoría de IA (`Co-Authored-By`, `Generated with`)
en los commits de este repositorio.

Un commit = una unidad de trabajo coherente. No se mezcla "estilo del header"
con "arreglo del footer".

### 8.3 Entrega

Al cerrar el TP2, tag anotado sobre `main`:

```bash
git tag -a tp2 -m "TP2 — Estilos CSS según manual de identidad PAWPrints Violeta"
git push origin tp2
```

---

## 9. Checklist antes de dar una página por terminada

Ninguna página se marca como hecha sin los 12 puntos:

- [ ] Se ve correctamente a **320px**, 768px, 1024px y 1440px.
- [ ] **Cero scroll horizontal** en cualquier ancho.
- [ ] Vista de impresión revisada (`Ctrl+P`): legible, sin navegación, sin fondos oscuros.
- [ ] Ningún valor hardcodeado: todos los colores/espacios/tamaños salen de `tokens.css`.
- [ ] Ningún `!important` fuera de `print.css` y `prefers-reduced-motion`.
- [ ] Ningún estilo aplicado por `id`.
- [ ] Foco visible en todos los elementos interactivos, navegable solo con teclado.
- [ ] Contraste AA verificado en cada combinación nueva de texto/fondo.
- [ ] La semántica del TP1 intacta: ningún tag ni `aria-*` eliminado.
- [ ] El HTML valida en https://validator.w3.org (sin errores).
- [ ] El CSS valida en https://jigsaw.w3.org/css-validator (sin errores).
- [ ] Los 3 comandos de verificación de la §0 devuelven vacío.

---

## 10. Definición de "listo"

Una tarea está terminada cuando:

1. Cumple el checklist de la §9 en las páginas que toca.
2. Está commiteada en su `feature/` con mensaje Conventional Commit.
3. Está mergeada a `dev` sin conflictos pendientes.
4. Otro integrante la revisó y la abrió en su navegador.

Marcar un checkbox sin haber abierto el navegador no es "listo". Es mentira.
