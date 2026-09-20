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
