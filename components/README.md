# Componentes compartidos — PAWPrints

Los archivos `header.html` y `footer.html` contienen el **markup canónico** del encabezado y
pie de página que **todas** las páginas del sitio deben incluir.

## Cómo usar

Dado que el TP1 es HTML puro (sin includes ni server-side templating), el procedimiento es:

1. Abrir `components/header.html` y **copiar** el bloque completo.
2. Pegarlo en tu página entre los marcadores:

```html
<!-- #region components/header.html — NO editar aquí, editar el componente y re-copiar -->
  ... (markup del header) ...
<!-- #endregion components/header.html -->
```

3. Hacer lo mismo con `footer.html`.

## Cómo actualizar el componente

1. Editar `components/header.html` (o `footer.html`).
2. Propagar el cambio a **todas** las páginas que lo usan:

```bash
# verificar divergencias (todas las páginas deben devolver diff vacío)
for f in pages/*.html index.html; do
  diff <(sed -n '/#region components\/header.html/,/#endregion components\/header.html/p' "$f") \
       components/header.html && echo "$f OK" || echo "$f DIVERGE"
done
```

## Páginas que usan estos componentes

- `index.html`
- `pages/categorias.html`
- `pages/catalogo.html`
- `pages/detalle-libro.html`
- `pages/nosotros.html`
- (todas las que agreguen los demás integrantes del equipo)
