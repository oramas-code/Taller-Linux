#!/bin/bash

AGENDA="agenda.txt"

mostrar_menu() {
    echo "----------------------------------"
    echo "        AGENDA TELEFÓNICA         "
    echo "----------------------------------"
    echo "1. Agregar contacto"
    echo "2. Consultar contacto"
    echo "3. Borrar contacto"
    echo "4. Listar contactos"
    echo "5. Ordenar por nombre"
    echo "6. Ordenar por teléfono"
    echo "7. Generar reporte"
    echo "0. Salir"
    echo "----------------------------------"
    echo -n "Selecciona una opción: "
}

agregar_contacto() {
    echo -n "Ingrese el nombre del contacto: "
    read nombre
    echo -n "Ingrese el número de teléfono: "
    read telefono

    if [ ! -f "$AGENDA" ]; then
        touch "$AGENDA"
        echo "Archivo de agenda creado."
    fi

    if grep -q "^$nombre:" "$AGENDA"; then
        echo "El contacto ya existe."
    else
        echo "$nombre:$telefono" >> "$AGENDA"
        echo "Contacto agregado con éxito."
    fi
}

consultar_contacto() {
    echo -n "Ingrese el nombre del contacto: "
    read nombre
    telefono=$(grep "^$nombre:" "$AGENDA" | cut -d ':' -f2)
    if [ -z "$telefono" ]; then
        echo "Contacto no encontrado."
    else
        echo "El número de $nombre es: $telefono"
    fi
}

borrar_contacto() {
    echo -n "Ingrese el nombre del contacto a borrar: "
    read nombre
    sed -i "/^$nombre:/d" "$AGENDA"
    echo "Contacto borrado (si existía)."
}

listar_contactos() {
    echo "Lista de contactos:"
    echo "╔══════════════════╦══════════════╗"
    echo "║ Nombre           ║ Teléfono     ║"
    echo "╠══════════════════╬══════════════╣"
    awk -F: '{printf "║ %-16s ║ %-12s ║\n", $1, $2}' "$AGENDA"
    echo "╚══════════════════╩══════════════╝"
}

ordenar_por_nombre() {
    sort -t ':' -k1,1 "$AGENDA" -o "$AGENDA"
    echo "Agenda ordenada por nombre."
}

ordenar_por_telefono() {
    sort -t ':' -k2,2n "$AGENDA" -o "$AGENDA"
    echo "Agenda ordenada por teléfono."
}

generar_reporte() {
    sort -t ':' -k1,1 "$AGENDA" > reporte_agenda.txt
    echo "Reporte generado en 'reporte_agenda.txt'"
}

while true; do
    mostrar_menu
    read opcion
    case $opcion in
        1) agregar_contacto ;;
        2) consultar_contacto ;;
        3) borrar_contacto ;;
        4) listar_contactos ;;
        5) ordenar_por_nombre ;;
        6) ordenar_por_telefono ;;
        7) generar_reporte ;;
        0) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción no válida. Intenta de nuevo." ;;
    esac
done
