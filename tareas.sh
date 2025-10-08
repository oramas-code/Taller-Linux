```bash
#!/bin/bash

archivo="tareas.txt"

# Crear archivo si no existe
touch "$archivo"

# Función para agregar tarea
agregar_tarea() {
  read -p "Descripción de la tarea: " descripcion
  read -p "Prioridad (alta/media/baja): " prioridad
  read -p "Fecha de vencimiento (YYYY-MM-DD): " fecha
  echo "$descripcion | $prioridad | $fecha | incompleta" >> "$archivo"
  echo " Tarea agregada correctamente."
}

# Función para listar tareas
listar_tareas() {
  if [[ ! -s "$archivo" ]]; then
    echo " No hay tareas registradas."
  else
    echo " Lista de tareas:"
    nl -w2 -s". " "$archivo"
  fi
}

# Función para eliminar tarea
eliminar_tarea() {
  listar_tareas
  read -p "Número de la tarea a eliminar: " num
  if [[ -z "$num" ]]; then
    echo " Número inválido."
    return
  fi
  sed "${num}d" "$archivo" > temp.txt && mv temp.txt "$archivo"
  echo " Tarea eliminada correctamente."
}

# Función para marcar tarea como completada
marcar_completada() {
  listar_tareas
  read -p "Número de la tarea a marcar como completada: " num
  if [[ -z "$num" ]]; then
    echo " Número inválido."
    return
  fi
  awk -v n="$num" 'BEGIN{FS=OFS="|"} NR==n {$4=" completa"} {print}' "$archivo" > temp.txt && mv temp.txt "$archivo"
  echo " Tarea marcada como completada."
}

# Función para filtrar tareas por estado
filtrar_tareas() {
  read -p "Filtrar por estado (completa/incompleta): " estado
  echo " Tareas con estado '$estado':"
  grep "$estado" "$archivo" || echo " No se encontraron tareas con ese estado."
}

# Función para ordenar tareas por prioridad o fecha
ordenar_tareas() {
  echo "1. Ordenar por prioridad"
  echo "2. Ordenar por fecha"
  read -p "Seleccione una opción: " opcion
  case $opcion in
    1)
      sort -t"|" -k2 "$archivo"
      ;;
    2)
      sort -t"|" -k3 "$archivo"
      ;;
    *)
      echo " Opción no válida."
      ;;
  esac
}

# Menú principal
while true; do
  echo
  echo "=============================="
  echo " Administrador de Tareas"
  echo "=============================="
  echo "1. Agregar tarea"
  echo "2. Listar tareas"
  echo "3. Eliminar tarea"
  echo "4. Marcar como completada"
  echo "5. Filtrar tareas por estado"
  echo "6. Ordenar tareas"
  echo "7. Salir"
  echo "=============================="
  read -p "Seleccione una opción: " opcion

  case $opcion in
    1) agregar_tarea ;;
    2) listar_tareas ;;
    3) eliminar_tarea ;;
    4) marcar_completada ;;
    5) filtrar_tareas ;;
    6) ordenar_tareas ;;
    7) echo " Saliendo..."; break ;;
    *) echo " Opción inválida." ;;
  esac
done
```
