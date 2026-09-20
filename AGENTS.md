# AGENTS.md — PAWPrints Frontend

Reglas operativas para agentes de IA que trabajen en este repositorio.
Aplica al orquestador, a los agentes SDD de Gentle (`sdd-*`) y al revisor de GGA
(`.gga` → `RULES_FILE="AGENTS.md"`).

Documentos normativos que este archivo **no reemplaza** y que deben leerse antes de actuar:

- [`docs/lineamientos-desarrollo.md`](./docs/lineamientos-desarrollo.md) — normativa técnica
- [`docs/plan-tp2-estilos.md`](./docs/plan-tp2-estilos.md) — plan y fases del TP2
- `docs/Manual básico Identidad PAWPrints VIoleta.pdf` — identidad corporativa

---

## 1. Contexto del proyecto

Sitio web estático de la librería **PAWPrints**, trabajo práctico de PAW (UNLu).
Construcción incremental: cada TP parte del anterior.

- **TP1** ✅ — maquetado HTML5 semántico, sin CSS ni JS.
- **TP2** 🔨 — **etapa actual**: aplicar CSS a todo el front según el manual Violeta.
- TP3–TP5 — pendientes.

Stack: **HTML5 + CSS3. Nada más.** Sin build, sin package manager, sin runtime.

---

## 2. Reglas absolutas — violarlas invalida el trabajo

### R1 — Solo CSS vanilla 🔴

Es la regla número uno del proyecto, impuesta por el equipo y por la consigna.

**Prohibido introducir:** Bootstrap, Tailwind, Bulma, Pico, Sass/SCSS/Less, PostCSS,
normalize.css, Font Awesome, Google Fonts por `<link>`, cualquier CDN, cualquier
`package.json`, cualquier bundler.

**Permitido:** CSS nativo completo (custom properties, Grid, Flex, `@media`, `@supports`,
`@font-face`, `@layer`, `clamp()`, `:has()`, `:is()`, `:where()`) y tipografías
auto-hospedadas en `assets/fonts/`.

Antes de cerrar cualquier tarea que toque HTML o CSS:

```bash
./scripts/verificar.sh   # debe imprimir TODO OK y salir con 0
```

Ese script es la verificación de record. Cubre las reglas R1, R2, R4, R5 y R6.
Su fuente está documentada en la §0 de `docs/lineamientos-desarrollo.md`.

**No lo reemplaces por comandos sueltos encadenados con `&&`/`||`:** esa forma dio
falsos resultados tres veces (`fd` sale con 0 sin encontrar nada; los globs de `rg`
se resuelven contra el cwd; `!important` aparece dentro de comentarios). Si tocás un
chequeo, probalo antes contra un caso que **debe** fallar.

Un `<a href="https://...">` a redes sociales es legítimo y lo pide la consigna del
TP1: un link de navegación no es una dependencia externa. El script ya lo contempla.

### R2 — Nada de JavaScript

El TP2 es solo estilos. Ningún `.js`, ningún `<script>`, ningún `onclick`.
Si una interacción no se puede resolver con CSS, **no se resuelve**: se documenta como
limitación y se propone para el TP siguiente. No se inventan hacks con `:target`
o checkboxes ocultos que rompen accesibilidad.

### R3 — No se degrada la semántica del TP1

El TP1 se evaluó por su semántica. Está prohibido:

- Cambiar un tag semántico por `<div>` o `<span>`.
- Eliminar o vaciar cualquier atributo `aria-*`, `role`, `alt`, `for`, `datetime`.
- Romper la asociación `<label for>` ↔ `id`.
- Eliminar un `<fieldset>`/`<legend>`.

**Sí está permitido** agregar atributos `class`. Es la estrategia acordada (§3.4 de
lineamientos) y el enunciado del TP2 la habilita explícitamente.

### R4 — Todo valor visual sale de `tokens.css`

Ningún color hex, ningún espaciado en `px`/`rem`, ningún `font-size` literal fuera de
`assets/css/01-settings/tokens.css`. Sin excepciones.

Color de marca: **`#5c068c`** (violeta) y **`#ffffff`** (blanco). Son los **únicos** dos
colores corporativos. Todo lo demás es derivado de interfaz y se declara como tal.

Tipografía: **Montserrat** auto-hospedada (equivalente oficial de Argentum Sans según el
propio manual). Pesos 300/400/500/600/700.

### R5 — Sin `!important`

Única excepción: dentro de `06-print/print.css` y en el bloque
`@media (prefers-reduced-motion: reduce)`.

### R6 — Sin estilos por `id`

Los `id` del HTML existen para `for` y `aria-labelledby`. Estilar por `id` los acopla y
rompe la cascada.

### R7 — Mobile first

Estilos base = mobile. Se escala con `min-width`. `max-width` solo para revertir algo que
aplica exclusivamente a desktop.

Breakpoints (literales — las custom properties **no funcionan** dentro de `@media`):
`30rem` · `48rem` · `64rem` · `80rem`.

### R8 — Tres medios, no dos

La consigna pide mobile, desktop **e impresión**. `@media print` no es opcional
ni se deja para el final.

### R9 — Accesibilidad no negociable

Contraste AA (4.5:1 texto normal, 3:1 texto grande). Foco siempre visible
(`:focus-visible`, nunca `outline: none` sin reemplazo). El color nunca es el único
portador de información. Labels ocultos con `.u-visually-hidden`, jamás con
`display: none`.

### R10 — Header y footer son componentes copiados a mano

`components/header.html` y `components/footer.html` son el markup canónico.
Al modificar uno, **propagarlo a las 21 páginas** y verificar con el script de §7 de
lineamientos. Una edición inline en una sola página sin propagar es un defecto.

Única divergencia admitida: `aria-current="page"`.

### R11 — Sin atribución de IA en commits

**Prohibido** `Co-Authored-By`, `Generated with`, o cualquier firma de IA en mensajes de
commit o descripciones de PR de este repositorio. Solo Conventional Commits limpios.

---

## 3. Estado de las ramas — leer antes de tocar git

La divergencia entre `dev` y `main` **se resolvió el 2026-09-19**. Decisión del equipo
(T-00): **gana la versión de `main`**.

Estado actual — las tres ramas en `841d627`:

```
origin/main ──→ dev ──→ feature/estilados   ← rama de trabajo del TP2
```

- `dev` fue **borrada y recreada** desde `origin/main`.
- El `dev` viejo (`73bce4c`, 5 páginas con maquetado extendido) está respaldado en el
  tag **`backup/dev-descartado-tp1`**. No se borra ese tag.
- `feature/estilados` sale del nuevo `dev`. **Todo el TP2 se implementa ahí.**

### Reglas de git para agentes

- **Trabajar siempre en `feature/estilados`.** Verificar con `git branch --show-current`
  antes de cualquier commit.
- **Nunca** commitear directo a `dev` ni a `main`.
- La integración a `dev` es por **Pull Request**, tras validación del equipo humano.
  Un agente no abre ni mergea ese PR por su cuenta.
- `dev` **no tiene upstream configurado a propósito**: cuando trackeaba `origin/main`,
  un `git push` desde `dev` iba directo a `main`. No volver a setear ese upstream.
  Al publicarla: `git push -u origin dev`.
- **Prohibido** `git push --force`, `git reset --hard` sobre ramas compartidas, borrar
  ramas remotas, o borrar el tag de respaldo. Son decisiones humanas.

### Progreso

- **Fase 0** cerrada en lo bloqueante: T-00 a T-03 ✅. Quedan T-04/T-05 (inventario
  del Figma), que no bloquean el CSS pero sí afinan los tokens.
- **Fase 1 (Cimientos)** cerrada: `assets/css/` con la cascada de 6 capas,
  Montserrat variable auto-hospedada, `tokens.css`, y el `<link>` en las 21 páginas.
- **Siguiente: Fase 2 (Base)** — reset, tipografía, elementos, foco. Todo por selector
  de elemento, sin una sola clase.

---

## 4. Flujo de trabajo

### 4.1 Antes de cualquier cambio

1. Leer `docs/lineamientos-desarrollo.md` y `docs/plan-tp2-estilos.md`.
2. Identificar la **fase y el ID de tarea** (`T-xx`) que corresponde.
3. Verificar que las fases previas estén cerradas. Si no, detenerse y reportar.
4. Confirmar que se está parado en la rama de trabajo del TP2:
   ```bash
   git branch --show-current   # debe devolver: feature/estilados
   ```

### 4.2 Durante

- Una tarea `T-xx` = una unidad de trabajo = al menos un commit.
- Commits en formato Conventional Commits, en español, imperativo:
  ```
  feat(tokens): definir paleta violeta y escala tipografica del manual
  fix(catalogo): corregir desborde horizontal de la grilla a 320px
  ```
- Alcances válidos: `tokens`, `base`, `layout`, `header`, `footer`, `catalogo`,
  `detalle`, `form`, `nosotros`, `print`, `a11y`, `docs`.
- Nunca commitear directo a `main` ni a `dev`.
- Si `feature/estilados` empieza a acumular más de ~400 líneas sin integrar, avisar:
  conviene partir el PR por fase antes de que se vuelva irrevisable.

### 4.3 Antes de reportar una tarea como terminada

Correr y exigir salida vacía:

```bash
./scripts/verificar.sh
```

Más el checklist de 12 puntos de §9 de lineamientos para las páginas tocadas.

**No se marca un checkbox sin haber verificado el resultado.** Reportar
"hecho" sin evidencia es un defecto más grave que no haberlo hecho.

---

## 5. Cómo reportar

Formato obligatorio al cerrar una tarea:

```
Tarea:      T-xx — <título>
Rama:       feature/estilados
Commits:    <hash> <mensaje>
Archivos:   <rutas>
Verificado: <comando> → <resultado observado>
Pendiente:  <lo que NO se hizo y por qué>
```

Reglas de honestidad:

- Si un comando falló, se reporta el output real. No se resume como "OK".
- Si algo se saltó, se dice explícitamente cuál y por qué.
- Si una verificación no se pudo correr, se dice "no verificado", nunca "verificado".
- No se inventa evidencia de nada que no se haya ejecutado.

---

## 6. Guía para el orquestador

### 6.1 Antes de implementar

El orquestador **explora primero** y no escribe hasta tener autorización explícita de
cambio. Pedidos de investigación, explicación, revisión o comparación son **solo lectura**.

### 6.2 Delegación

| Situación | Ruta |
|---|---|
| Decidir/verificar leyendo 1–3 archivos | inline |
| Entender algo que requiere 4+ archivos | delegar 1 explorador acotado |
| Editar 1 archivo mecánico ya entendido | inline |
| Editar 2+ archivos no triviales | delegar 1 escritor |
| Correr validaciones/tests | worker por acción |

Al delegar, **siempre** pasar: el ID de tarea, las reglas R1–R11 que apliquen, la ruta de
los archivos, y los comandos exactos de verificación.

### 6.3 Preguntas al usuario

Una por vez, y **parar**. No inventar respuestas ni asumir decisiones de producto.
Casos que requieren decisión humana y que un agente **nunca** resuelve solo:

- T-00 — qué versión de las páginas compartidas gana.
- Cambiar la estrategia de clases acordada en §3.4 de lineamientos.
- Alterar tokens de marca (`#5c068c`, `#ffffff`) o la tipografía.
- Cualquier cosa que toque `main` o el tag `tp2`.

### 6.4 SDD

SDD (`sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`,
`sdd-verify`, `sdd-archive`) es **opcional** y se usa solo si el usuario lo pide
explícitamente o acepta una propuesta.

Para este TP2 el plan ya está escrito en `docs/plan-tp2-estilos.md` con fases y tareas
numeradas. **Ese documento hace de backlog.** No se generan artefactos SDD paralelos que
dupliquen y desincronicen el plan.

Si se usa SDD, los artefactos generados se escriben en **español**, coherentes con el
resto de la documentación del repositorio.

---

## 7. Idioma

- Conversación con el equipo: **español rioplatense**.
- Documentación, comentarios de CSS, mensajes de commit, nombres de página: **español**
  (registro neutro/profesional), coherente con el resto del repositorio.
- Nombres de clases CSS, archivos y carpetas: **inglés** (`.c-card-book`, `assets/css/`),
  siguiendo la convención de `l-` / `c-` / `u-` / `is-`.
- Texto de la interfaz visible al usuario: **español**.

---

## 8. Configuración de GGA

`.gga` apunta a este archivo como `RULES_FILE`. Sus `FILE_PATTERNS` deben cubrir el stack
real del proyecto:

```
FILE_PATTERNS="*.html,*.css"
EXCLUDE_PATTERNS=""
```

Si siguen en `*.ts,*.tsx,*.js,*.jsx` (valores por defecto de la plantilla), el revisor
**no revisa nada** de este repositorio.

---

## 9. Estructura del repositorio

```
/
├── AGENTS.md                      ← este archivo
├── README.md
├── index.html
├── .gga                           configuración del revisor
├── components/                    markup canónico de header y footer
│   ├── README.md                  flujo de propagación
│   ├── header.html
│   └── footer.html
├── pages/                         21 páginas del sitio
├── img/
├── assets/                        ← se crea en Fase 1 del TP2
│   ├── fonts/                     Montserrat .woff2 auto-hospedada
│   ├── img/
│   └── css/
│       ├── main.css               único archivo enlazado desde el HTML
│       ├── 01-settings/           fonts.css · tokens.css
│       ├── 02-base/               reset · typography · elements
│       ├── 03-layout/             container · header · footer · page
│       ├── 04-components/         button · card-book · form · ...
│       ├── 05-utilities/
│       └── 06-print/
└── docs/
    ├── lineamientos-desarrollo.md ← normativa técnica
    ├── plan-tp2-estilos.md        ← plan y backlog del TP2
    ├── sitemap.md
    └── Manual básico Identidad PAWPrints VIoleta.pdf
```
