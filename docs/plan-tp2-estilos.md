# Plan de implementación — TP2 Estilos

Plan de trabajo para aplicar CSS a todo el frontend de PAWPrints según el
**Manual básico de Identidad Corporativa — opción Violeta**.

Normativa de trabajo: [`lineamientos-desarrollo.md`](./lineamientos-desarrollo.md).
**Regla número 1: solo CSS vanilla. Cero frameworks, cero librerías.**

---

## Consigna que estamos cumpliendo

Del enunciado del TP2, textual:

1. *"Agregar el contenido CSS necesario para lograr que el maquetado se vea tal como se
   diseñaron los Wireframes."*
2. *"En caso de ser necesario, ajustar las características de los mismos para que se adapten
   al manual de identidad corporativa."* → habilita tocar el HTML.
3. *"Generar el código necesario para que las pantallas se adapten a las versiones mobile,
   desktop y de impresión."* → tres medios, no dos.
4. Entrega con etiqueta **`tp2`** sobre el mismo repositorio del TP1.

---

## Estado de partida

| Ítem | Estado |
|---|---|
| Maquetado HTML5 semántico | ✅ Hecho en TP1 — 21 páginas |
| Wireframes en Figma | ✅ `OVQUC7OFmjIB2e0KPmntXe` |
| Manual de identidad elegido | ✅ Violeta |
| Ramas `dev` / `main` reconciliadas | ✅ **2026-09-19** — gana `main` |
| Rama de trabajo | ✅ `feature/estilados` (desde el nuevo `dev`) |
| CSS | 🔨 F1 a F4 cerradas: tokens, base, header, footer, contenedores y componentes; F5 (layout por página) y F6 (impresión) pendientes |
| Clases en el HTML | ❌ Cero. Semántica pura |
| Tipografía auto-hospedada | ✅ Montserrat variable en `assets/fonts/` |

Un hecho condiciona todo el plan: **el HTML no tiene ni una `class`.**
Estrategia definida en §3.4 de los lineamientos: se agregan clases, sin tocar
semántica ni `aria-*`.

**Flujo de ramas del TP2:**

```
origin/main ──→ dev ──→ feature/estilados ──(PR + validación del equipo)──→ dev
```

Todo el trabajo va en `feature/estilados` y se integra a `dev` **por Pull Request**,
recién cuando el equipo validó.

---

## Fases

Dependencias estrictas. Una fase no arranca hasta que la anterior está cerrada y
commiteada en `feature/estilados`. **Todas las fases viven en esa única rama**; a `dev`
se llega una sola vez, por PR, al final.

```
F0 Reconciliar ramas      ──┐
                            ├─→ F1 Cimientos ─→ F2 Base ─→ F3 Chrome ─┬─→ F4 Componentes ─→ F5 Páginas ─→ F6 Impresión ─→ F7 QA
F0 Inventario de diseño   ──┘                                          │
                                                                       └─ (F4 y F5 pueden solaparse por página)
```

---

### Fase 0 — Reconciliar ramas e inventariar el diseño

| ID | Tarea | Entregable | Estado |
|---|---|---|---|
| **T-00** | Decidir qué versión gana en las 5 páginas compartidas | **Gana `main`** — por cobertura: el sitio completo pesa más que 5 páginas más extensas | ✅ 2026-09-19 |
| T-01 | Reconciliar ramas según T-00 | `dev` recreada desde `origin/main` (`841d627`); `dev` viejo respaldado en el tag `backup/dev-descartado-tp1`; `feature/estilados` creada desde el nuevo `dev` | ✅ 2026-09-19 |
| T-02 | Verificar que `components/header.html` y `footer.html` están propagados sin divergencias en las 21 páginas (script §7 de lineamientos) | Salida `OK` en todas | ✅ 2026-09-19 |
| T-03 | Validar las 21 páginas en el validador W3C. Arreglar errores de HTML **antes** de estilar | 0 errores | ✅ 2026-09-19 |
| T-04 | Inventario de diseño: recorrer el Figma y listar cada componente visual recurrente con su nombre de clase `c-*` | Tabla en este documento (§Inventario) | ⬜ |
| T-05 | Extraer del Figma: espaciados reales, tamaños de fuente por breakpoint, radios de borde, anchos de columna | Valores volcados a `tokens.css` en F1 | ⬜ |

**Criterio de salida:** las 21 páginas validan y existe una lista cerrada de componentes.

> **T-02 y T-03 siguen siendo bloqueantes.** No se escribe CSS sobre HTML que no valida:
> cada error de marcado que se arregla después obliga a revisar los estilos que dependían
> de esa estructura.

---

### Fase 1 — Cimientos

Es la fase que más condiciona al resto: acá se fija
el vocabulario que van a usar todas las demás.

| ID | Tarea | Archivos | Estado |
|---|---|---|---|
| T-10 | Crear el árbol `assets/css/` completo y `main.css` con los `@import` en orden | `assets/css/**` | ✅ |
| T-11 | Montserrat (OFL) auto-hospedada. **Nunca Google Fonts por `<link>`** | `assets/fonts/` | ✅ |
| T-12 | Escribir `@font-face` con `font-display: swap` y stack de respaldo | `01-settings/fonts.css` | ✅ |
| T-13 | Volcar los design tokens de §4 de lineamientos | `01-settings/tokens.css` | ✅ |
| T-14 | Insertar `<link rel="stylesheet" href="/assets/css/main.css">` en el `<head>` de **las 21 páginas** | `index.html`, `pages/*.html` | ✅ |

**T-11 — se usa la fuente VARIABLE, no cinco estáticas.** Google Fonts ya no distribuye
Montserrat en pesos separados: el repositorio OFL oficial solo publica el archivo
variable. No es una concesión, es mejor: **un único `.woff2` de 212 KB** cubre todo el
rango 100–900 (los cinco pesos corporativos incluidos) en **una sola petición HTTP**,
contra las cinco que harían falta con archivos estáticos.

La licencia SIL OFL 1.1 obliga a redistribuir su texto: está en `assets/fonts/OFL.txt`.

**Detalle de T-12:**

```css
@font-face {
  font-family: "Montserrat";
  src: url("../../fonts/montserrat-variable.woff2") format("woff2-variations"),
       url("../../fonts/montserrat-variable.woff2") format("woff2");
  font-weight: 100 900;   /* rango completo, no un peso fijo */
  font-style: normal;
  font-display: swap;
}
```

**Criterio de salida:** abrir cualquier página y ver que el texto ya renderiza en
Montserrat. Nada más cambió todavía. ✅ **Fase cerrada.**

---

### Fase 2 — Base

Todo por selector de elemento, **sin una sola clase**.

| ID | Tarea | Archivos |
|---|---|---|
| T-20 | Reset propio escrito a mano: `box-sizing: border-box`, márgenes en cero, `img/svg` en bloque con `max-width: 100%`, `font: inherit` en controles de formulario | `02-base/reset.css` |
| T-21 | Tipografía base: escala `h1`–`h6` con los pesos del manual, `p`, listas, `small`, `address`, `time`, `blockquote`. Ancho de lectura `--prose-max` | `02-base/typography.css` |
| T-22 | Elementos: `a` (violeta, subrayado en hover), `hr`, `table`, `figure`, `fieldset`, `legend`, `input`/`select`/`textarea` base | `02-base/elements.css` |
| T-23 | **Foco global visible** con `:focus-visible` + `prefers-reduced-motion` | `02-base/elements.css` |
| T-24 | Utilidades mínimas: `.u-visually-hidden`, `.u-flow`, `.u-container` | `05-utilities/utilities.css` |

**Criterio de salida:** las 21 páginas se ven consistentes y legibles en tipografía y
color, aunque todavía sin layout. Navegables enteras solo con `Tab`, con foco visible
en cada parada.

---

### Fase 3 — Chrome del sitio (header y footer)

Primera fase que toca HTML.

El header y el footer aparecen en las 21 páginas. Resolverlos una vez resuelve el 40%
de la percepción visual del sitio. Y son la prueba de fuego del responsive, porque el
header tiene 3 `nav` + un buscador apilados.

| ID | Tarea |
|---|---|
| T-30 | Agregar clases a `components/header.html`: `.l-header`, `.l-header__brand`, `.l-header__nav`, `.l-header__search`, `.l-header__user` |
| T-31 | **Propagar** el header a las 21 páginas y verificar con el script de §7 (única divergencia admitida: `aria-current`) |
| T-32 | Estilar `.l-header` mobile-first: apilado en mobile, fila en `≥48rem`, fila completa con buscador expandido en `≥64rem` |
| T-33 | Área de reserva del logotipo: padding mínimo, sin `transform`, sin `text-shadow`, sin cambio de color. Prohibiciones del manual §2.3 |
| T-34 | Estado activo de navegación vía `[aria-current="page"]` — **sin clase nueva** |
| T-35 | Lo mismo para `components/footer.html`: `.l-footer` + propagación |
| T-36 | Footer en negativo (fondo `--surface-invert`, texto `--on-surface-invert`), grilla de 1 → 3 columnas |
| T-37 | `.l-container` y `.l-page` (§3.1) aplicados al `<main>` de todas las páginas |

**Sobre el menú en mobile:** sin JavaScript no hay menú hamburguesa funcional.
La navegación se resuelve **apilada y visible**, o con scroll horizontal en una fila.
No se simula un toggle con `:target` ni con checkbox oculto: es un hack que rompe
accesibilidad y no está en el espíritu del TP2.

**Criterio de salida:** header y footer correctos a 320px, 768px, 1024px y 1440px,
idénticos en las 21 páginas.

---

### Fase 4 — Componentes

Se construyen contra el Figma, no contra una página puntual.

| ID | Componente | Clase | Aparece en |
|---|---|---|---|
| T-40 | Botones (primario violeta, secundario outline, terciario link) | `.c-button` | Todas |
| T-41 | Breadcrumb | `.c-breadcrumb` | Todas menos inicio |
| T-42 | Tarjeta de libro (portada, título, autor, precio, acción) | `.c-card-book` | catálogo, inicio, promociones, favoritos, recomendaciones |
| T-43 | Formularios: campo, label, ayuda, error, fieldset | `.c-form`, `.c-field` | form, reserva, contacto, login, registro ×3, mi-cuenta |
| T-44 | Panel de filtros | `.c-filters` | catálogo, categorías |
| T-45 | Paginación | `.c-pagination` | catálogo, categorías |
| T-46 | Badge / etiqueta de promoción | `.c-badge` | promociones, catálogo, detalle |
| T-47 | Valoración por estrellas | `.c-rating` | catálogo, detalle |
| T-48 | Tabla de resumen / carrito | `.c-summary` | carrito, resumen, reserva |

**Regla de construcción:** cada componente se escribe **una sola vez** y se aplica por
clase donde haga falta. Si aparece la tentación de escribir
`.c-card-book--en-catalogo`, es que el componente está mal cortado. Se revisa, no se parcha.

**T-43 en detalle** — los formularios son el corazón evaluable del TP (el TP1 los pidió
explícitamente). Estados a cubrir:
`:focus-visible`, `:invalid:not(:placeholder-shown)`, `:disabled`, `:checked`,
`[required]` con marca visual **más** texto (§6: el color nunca es el único portador).

**Criterio de salida:** los 9 componentes existen, documentados, y se ven bien
aislados y dentro de una página real.

---

### Fase 5 — Layout por página

Acá se puede **paralelizar entre integrantes** dentro de `feature/estilados`:
las fases anteriores ya dieron el vocabulario común, así que dos personas no chocan
mientras cada una tome grupos de páginas distintos y commitee seguido.

| ID | Páginas | Layout principal |
|---|---|---|
| T-50 | `index.html`, `pages/inicio.html` | Hero en negativo violeta + grillas de destacados |
| T-51 | `catalogo.html`, `categorias.html` | Sidebar de filtros + grilla de resultados (1 col mobile → sidebar + 3/4 col en `≥64rem`) |
| T-52 | `detalle-libro*.html` (3 archivos) | 2 columnas: portada + ficha; descripción a todo el ancho |
| T-53 | `form.html`, `reserva.html`, `resumen.html` | Formulario + resumen lateral pegajoso en desktop |
| T-54 | `carrito.html`, `favoritos.html`, `recomendaciones.html` | Lista/grilla + panel de totales |
| T-55 | `login.html`, `registro*.html` (3 pasos) | Tarjeta centrada, ancho acotado, indicador de paso |
| T-56 | `mi-cuenta.html` | Navegación lateral de secciones + panel |
| T-57 | `nosotros.html`, `contacto.html`, `promociones.html` | Contenido editorial + franja destacada en negativo |

**Regla:** si una página necesita una regla que no existe, primero se pregunta si es un
componente nuevo (va a F4) o un caso real de una sola página (va a su archivo).
Ante la duda, componente.

**Criterio de salida:** cada página pasa el checklist de §9 de los lineamientos.

---

### Fase 6 — Impresión

Fase corta pero **obligatoria por consigna** y la que todos los
equipos se olvidan. Es puntaje regalado.

| ID | Tarea |
|---|---|
| T-60 | Ocultar en `@media print`: navegación del header, buscador, navegación del footer, breadcrumb, filtros, paginación, botones de acción |
| T-61 | Forzar fondo blanco y texto negro. Sin fondos violetas: gasta tinta y el manual prioriza legibilidad |
| T-62 | Expandir URLs: `a[href^="http"]::after { content: " (" attr(href) ")"; }` |
| T-63 | `@page { margin: 2cm; }` y control de cortes (`break-after: avoid` en títulos, `break-inside: avoid` en tarjetas) |
| T-64 | Verificar en vista previa de impresión las páginas con más sentido en papel: `detalle-libro`, `resumen`, `reserva`, `nosotros` |

**Criterio de salida:** `Ctrl+P` en las 21 páginas da un documento legible y sin
elementos de interfaz.

---

### Fase 7 — QA y entrega

Cierre del TP2. Tras el PR a `dev`, sigue `dev → test → main`.

| ID | Tarea |
|---|---|
| T-70 | Checklist completo (§9 lineamientos) en las 21 páginas |
| T-71 | Validación W3C: HTML **y** CSS, cero errores |
| T-72 | Auditoría de contraste en todas las combinaciones texto/fondo usadas |
| T-73 | Recorrido completo solo con teclado, foco visible en cada parada |
| T-74 | Los 3 comandos de verificación de "CSS vanilla" (§0 lineamientos) devuelven vacío |
| T-75 | Verificar que ningún valor quedó hardcodeado fuera de `tokens.css` |
| T-76 | Actualizar `README.md`: stack, estructura de `assets/`, cómo levantar el sitio |
| T-77 | Abrir el **PR de `feature/estilados` a `dev`** y esperar validación del equipo |
| T-78 | Una vez mergeado: `dev → test → main` y crear el tag anotado `tp2` |

**T-75, comando:**

```bash
# hex fuera de tokens.css  → debe devolver vacío
rg -n '#[0-9a-fA-F]{3,8}\b' assets/css --glob '!**/tokens.css'

# !important fuera de print → debe devolver vacío
rg -n '!important\s*;' assets/css --glob '!**/print.css'

# estilos por id → debe devolver vacío
rg -n '^\s*#[a-zA-Z][\w-]*\s*[,{]' assets/css
```

---

## Reparto sugerido

Dos integrantes, con las fases 0–4 como trabajo conjunto (definen el vocabulario común)
y la fase 5 paralelizada:

| Fase | Quién |
|---|---|
| F0 | **Ambos** — T-00 es decisión conjunta obligatoria |
| F1, F2 | Uno solo. Son cimientos: dos personas tocando `tokens.css` se pisan |
| F3 | El otro, mientras el primero cierra F2 |
| F4 | Repartido por componente (T-40..T-44 / T-45..T-48) |
| F5 | Paralelo: T-50..T-53 / T-54..T-57 |
| F6, F7 | **Ambos** — el QA cruzado es el punto |

---

## Inventario de componentes *(F4 cerrada)*

Criterio aplicado: **la clase va solo en la raíz** del componente y los hijos se estilan
por elemento dentro de su alcance (§3.3 de lineamientos). El marcado del TP1 varía entre
páginas (títulos h2/h3/h4, acciones como link o como formulario) y así no hubo que
reescribirlo. Las clases se agregaron con un script sobre el `<main>` de cada página;
header y footer no se tocaron.

| Componente | Clase | Dónde va | Instancias | Estado |
|---|---|---|---|---|
| Botón | `.c-button`, `.c-button--secondary` | `<a>` de acción principal; `<button>` de quitar/limpiar/cancelar | 31 | ✅ |
| Breadcrumb | `.c-breadcrumb` | `<nav aria-label="Migas de pan">` | 19 | ✅ |
| Tarjeta de libro | `.c-card-book` | `<article>` con portada o link a detalle | 33 | ✅ |
| Tarjeta genérica | `.c-card` | promociones y sucursales | 13 | ✅ |
| Grilla | `.l-grid`, `.l-grid--books` | la `<ul>` que agrupa tarjetas | 12 | ✅ |
| Formulario | `.c-form` | `<form>` con campos (no los de solo botones) | 14 | ✅ |
| Filtros | `.c-filters` | `<aside>` de filtros del catálogo | 1 | ✅ |
| Paginación | `.c-pagination` | `<nav>` de paginación | 1 | ✅ |
| Badge | `.c-badge` | `<mark>` de etiqueta en recomendaciones | 4 | ✅ |
| Rating | `.c-rating` | `<data value="N">N de 5 estrellas</data>` | 7 | ✅ |
| Tabla | `.c-table` | `<div role="region" tabindex="0">` que envuelve cada `<table>` | 7 | ✅ |

Cambios respecto del plan original:

- **`.c-summary` pasó a ser `.c-table`**: el mismo contenedor con scroll sirve para
  carrito, resumen, historial de pedidos y ficha técnica.
- **`.c-field` no hizo falta**: los campos ya salen de la marca desde `02-base`, y
  `.c-form` resuelve el ritmo y los estados.
- **Campos obligatorios**: la marca "(obligatorio)" sale del atributo `required` por CSS.
  Se quitaron los `*` escritos a mano en `form.html`.

---

## Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Se estila sobre HTML que no valida (T-03 sin cerrar) | Alto — retrabajo de estilos al corregir el marcado | T-02/T-03 bloquean F1 |
| `feature/estilados` acumula demasiado y el PR se vuelve irrevisable | Alto — nadie revisa 3000 líneas de CSS | Commits por tarea `T-xx`; si el PR supera ~400 líneas, se parte por fase |
| Header/footer divergen entre las 21 páginas | Alto — el sitio se ve inconsistente | Script de verificación en cada PR que toque `components/` |
| Alguien "resuelve rápido" con Bootstrap o Google Fonts | **Crítico — incumple la consigna** | Los 3 comandos de §0 corren en F7 y en cada revisión |
| Valores hardcodeados que se multiplican | Medio — imposible ajustar después | T-75 + revisión cruzada de PR |
| La impresión queda para el final y no se hace | Medio — se pierde 1/3 de la consigna | F6 es fase propia con criterio de salida, no un "si llegamos" |
| Menú mobile sin JS termina en un hack `:target` | Medio — rompe accesibilidad | Decidido: navegación apilada visible (F3) |

---

## Orden de ejecución, resumido

```
✅ T-00  Decisión: gana main
✅ T-01  dev recreada desde origin/main + feature/estilados
🔨 F0    T-02 ✅ · T-03 ✅ · pendiente: T-04/T-05 inventario Figma
✅ F1    Tokens + tipografía auto-hospedada + link en 21 páginas
✅ F2    Reset, tipografía, elementos, foco
✅ F3    Header y footer (clases + propagación + responsive)
✅ F4    Los 9 componentes
⬜ F5    Layout por página (paralelizable)
⬜ F6    Impresión
⬜ F7    QA, validación W3C, PR a dev, merge a main, tag tp2
```

Todo se implementa en `feature/estilados` y entra a `dev` por **Pull Request**,
una vez validado por el equipo.
