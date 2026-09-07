# Componentes compartidos — PAWPrints

Los archivos `header.html` y `footer.html` contienen el **markup canónico** del encabezado y
pie de página que **todas** las páginas del sitio deben incluir.

Estos archivos **no se cargan solos**: HTML puro no tiene forma de incluir un archivo dentro
de otro. Son la **copia maestra** desde la cual se copia y pega el markup en cada página.

## Cómo usar

1. Abrir `components/header.html` y **copiar** el bloque completo.
2. Pegarlo en tu página entre los marcadores:

```html
<!-- #region components/header.html — NO editar aquí, editar el componente y re-copiar -->
  ... (markup del header) ...
<!-- #endregion components/header.html -->
```

3. Hacer lo mismo con `footer.html`.

Los marcadores de apertura y cierre son comentarios HTML: no se ven en el navegador y sirven
para ubicar rápido dónde está pegada cada copia.

## Cómo actualizar el componente

1. Editar `components/header.html` (o `footer.html`).
2. Copiar el bloque nuevo y pegarlo, a mano, en **todas** las páginas de la lista de abajo,
   reemplazando lo que haya entre los dos marcadores.

No hay automatización: en el TP1 la sincronización es manual y a propósito. A partir del TP
siguiente, cuando entre el lenguaje de servidor, esto pasa a ser un `include` real y la
duplicación desaparece.

## Páginas que usan estos componentes

- `index.html`
- `pages/inicio.html`
- `pages/catalogo.html`
- `pages/categorias.html`
- `pages/detalle-libro.html`
- `pages/detalle-libro-cien-anios-de-soledad.html`
- `pages/detalle-libro-la-odisea.html`
- `pages/promociones.html`
- `pages/nosotros.html`
- `pages/reserva.html`
- `pages/contacto.html`
- `pages/recomendaciones.html`
- `pages/carrito.html`
- `pages/resumen.html`
- `pages/favoritos.html`
- `pages/mi-cuenta.html`
- `pages/login.html`
- `pages/registro.html`
- `pages/registro-paso-2.html`
- `pages/registro-paso-3.html`
