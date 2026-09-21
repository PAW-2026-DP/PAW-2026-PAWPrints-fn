# PAWPrints — TP1 Maquetado HTML5

Sitio web estático de la librería **PAWPrints**, desarrollado como TP1 de PAW (Programación de Aplicaciones Web).

## Tecnología

HTML5 puro — sin CSS, sin JavaScript (requisito del TP1).  
Las páginas demuestran el uso correcto de las etiquetas semánticas de HTML5 y formularios con tipos y atributos adecuados.

## Estructura

```
/
├── index.html               # Redirige a pages/inicio.html (inicio del wireframe)
├── components/
│   ├── README.md            # Guía de uso de componentes compartidos
│   ├── header.html          # Fragmento canónico del <header>
│   └── footer.html          # Fragmento canónico del <footer>
├── img/
│   └── portada-placeholder.svg  # Portada de relleno para las fichas de libro
├── pages/
│   ├── inicio.html          # Página de inicio
│   ├── catalogo.html        # Catálogo de libros
│   ├── categorias.html      # Listado de categorías y subcategorías
│   ├── detalle-libro.html   # Detalle de un libro
│   ├── detalle-libro-cien-anios-de-soledad.html
│   ├── detalle-libro-la-odisea.html
│   ├── promociones.html     # Promociones, novedades y eventos
│   ├── nosotros.html        # Sobre nosotros
│   ├── reserva.html         # Formulario de reserva de libro
│   ├── contacto.html        # Sucursales, redes y atención al cliente
│   ├── recomendaciones.html # Recomendaciones por categoría
│   ├── carrito.html         # Carrito de compras
│   ├── resumen.html         # Resumen del pedido (checkout)
│   ├── favoritos.html       # Lista de deseados
│   ├── mi-cuenta.html       # Datos de la cuenta y pedidos
│   ├── login.html           # Iniciar sesión
│   ├── registro.html        # Crear cuenta (paso 1)
│   ├── registro-paso-2.html # Datos de envío (paso 2)
│   └── registro-paso-3.html # Confirmación (paso 3)
└── docs/
    └── sitemap.md           # Mapa del sitio con todas las páginas
```

## Ramas

```
main              → base estable del proyecto
dev               → integración continua del equipo
test              → rama de validación previa a main
feature/<tarea>   → una rama por tarea, se integra a dev
```

## Diseño de referencia

Figma: https://www.figma.com/design/OVQUC7OFmjIB2e0KPmntXe/PAWPrints

## Enunciado

TP Nº1 — PAW 2026. Maquetado Web con HTML5 semántico.
