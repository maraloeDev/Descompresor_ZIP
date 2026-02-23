#!/bin/bash

# --- Configuración de Seguridad ---
set -u
set -o pipefail

# --- Variables Globales ---
declare TMP_DIR=""
declare FILE_PATH=""
declare DEST_FINAL=""
declare SISTEMA_OP=""

# ==========================================
# 1. DETECCIÓN DE SISTEMA Y LIMPIEZA
# ==========================================
fun_detectar_sistema() {
    case "$(uname -s)" in
        Linux*)     SISTEMA_OP="Linux" ;;
        Darwin*)    SISTEMA_OP="Mac" ;;
        MINGW*|MSYS*|CYGWIN*) SISTEMA_OP="Windows" ;;
        *)          SISTEMA_OP="Desconocido" ;;
    esac
}

fun_cleanup() {
    local exit_code=$?
    [[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
    exit "$exit_code"
}
trap fun_cleanup EXIT SIGINT SIGTERM

# ==========================================
# 2. GESTIÓN DE CONFLICTOS (Smart Move)
# ==========================================
fun_smart_move() {
    local src_dir="$1"
    local dst_dir="$2"
    local item=""
    local base_item=""

    # Habilitar dotglob para incluir archivos ocultos
    shopt -s dotglob
    for item in "$src_dir"/*; do
        [[ -e "$item" ]] || continue
        base_item=$(basename "$item")

        # COMPROBACIÓN: ¿Ya existe en el destino?
        if [[ -e "$dst_dir/$base_item" ]]; then
            # Ventana de decisión
            if zenity --question --title="Conflicto de archivos" \
                --text="El archivo <b>$base_item</b> ya existe en el destino.\n\n¿Deseas sobreescribirlo?" \
                --ok-label="Sí, sobreescribir" --cancel-label="No, saltar" --width=400; then
                cp -rf "$item" "$dst_dir/"
            fi
            # Si el usuario cancela, no hace nada y pasa al siguiente archivo
        else
            # Si no existe, se mueve directamente
            cp -rf "$item" "$dst_dir/"
        fi
    done
    shopt -u dotglob
}

# ==========================================
# 3. SELECTOR Y VALIDACIÓN (Bucle UX)
# ==========================================
fun_dialogo_archivo() {
    if [[ "$SISTEMA_OP" == "Windows" ]]; then
        powershell -NoProfile -Command "& {
            $f = New-Object System.Windows.Forms.OpenFileDialog
            $f.Filter = 'Compresiones soportadas|*.zip;*.rar;*.7z;*.tar;*.gz;*.tgz;*.xz;*.bz2'
            if($f.ShowDialog() -eq 'OK') { $f.FileName }
        }"
    elif [[ "$SISTEMA_OP" == "Mac" ]] && ! command -v zenity &> /dev/null; then
        osascript -e 'POSIX path of (choose file with prompt "Selecciona un archivo comprimido")' 2>/dev/null
    else
        zenity --file-selection --title="📦 Selecciona un archivo comprimido" \
            --file-filter="Comprimidos | *.zip *.rar *.7z *.tar *.gz *.tar.gz *.tgz *.tar.xz *.xz *.tar.bz2 *.bz2"
    fi
}

fun_lanzar_error_continuar() {
    local mensaje="$1"
    zenity --error --title="Formato Inválido" --text="$mensaje" --width=350
}

# ==========================================
# 4. MOTOR RECURSIVO
# ==========================================
fun_extraer_recursivo() {
    local folder="$1"
    local found_any=false
    local f=""
    local cmd=""

    for f in "$folder"/*; do
        [[ -f "$f" ]] || continue
        cmd=""
        case "${f,,}" in
            *.zip)          cmd="unzip -q -o" ;;
            *.tar.gz|*.tgz) cmd="tar -xzf" ;;
            *.tar.xz|*.xz)  cmd="tar -xJf" ;;
            *.tar.bz2|*.bz2) cmd="tar -xjf" ;;
            *.tar)          cmd="tar -xf" ;;
            *.rar)          cmd="unrar x -o+ -inul" ;;
            *.7z)           cmd="7z x -y" ;;
        esac

        if [[ -n "$cmd" ]]; then
            (cd "$folder" && eval "$cmd \"$f\"" > /dev/null 2>&1)
            rm -f "$f"
            found_any=true
        fi
    done
    [[ "$found_any" == true ]] && fun_extraer_recursivo "$folder"
}

# ==========================================
# 5. FLUJO PRINCIPAL (MAIN)
# ==========================================
main() {
    fun_detectar_sistema

    # BUCLE DE SELECCIÓN
    while true; do
        FILE_PATH=$(fun_dialogo_archivo)
        [[ -z "$FILE_PATH" || "$FILE_PATH" == "null" ]] && exit 0
        FILE_PATH=$(echo "$FILE_PATH" | tr -d '\r\n')

        if [[ "$FILE_PATH" =~ \.(zip|rar|7z|tar|gz|tgz|xz|bz2)$ ]]; then
            break
        else
            fun_lanzar_error_continuar "El archivo no es válido.\nInténtalo de nuevo."
        fi
    done

    # PROCESAMIENTO
    DEST_FINAL=$(dirname "$FILE_PATH")
    TMP_DIR=$(mktemp -d)

    (
        echo "20" ; echo "# Copiando archivo..."
        cp "$FILE_PATH" "$TMP_DIR/"
        echo "50" ; echo "# Extrayendo niveles recursivos..."
        fun_extraer_recursivo "$TMP_DIR"
        echo "100" ; echo "# Analizando conflictos de destino..."
    ) | zenity --progress --title="UnpackMaster Pro" --auto-close --pulsate

    # GESTIÓN DE SOBREESCRITURA
    fun_smart_move "$TMP_DIR" "$DEST_FINAL"

    zenity --info --text="¡Proceso terminado!\nArchivos gestionados en: $DEST_FINAL" --title="Éxito"
}

main