#!/usr/bin/env bash
cfg="${1:-.projects.yml}"
[ -f "$cfg" ] || { echo "Archivo no encontrado: $cfg" >&2; exit 2; }

# Extrae líneas con "path:" y quita el prefijo. Maneja espacios y ~.
mapfile -t raw_paths < <(sed -n 's/^[[:space:]]*path:[[:space:]]*//p' "$cfg")

paths=()
for p in "${raw_paths[@]}"; do
  # expandir ~ y variables si existen
  expanded=$(eval echo "$p")
  paths+=("$expanded")
done

if [ "${#paths[@]}" -eq 0 ]; then
  echo "No se extrajeron paths." >&2
  exit 2
fi

# Construir cadena separada por comas
joined=$(IFS=,; echo "${paths[*]}")

echo "Ejecutando: gemini --include-directories $joined"
gemini --include-directories "$joined"
exit $?

# Construir comando; cada path es argumento separado
# echo "Ejecutando: gemini --include-directories ${paths[*]}"
# gemini --include-directories "${paths[@]}"
# exit $?
