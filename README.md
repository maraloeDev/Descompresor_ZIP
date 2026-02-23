# 📦 UnpackMaster Pro (v3.5 - Multi-OS Edition)
> La herramienta definitiva de descompresión recursiva e inteligente. Ahora compatible con Windows, Mac y Linux. 🕺✨

[![Bash Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Mac%20%7C%20Linux-lightgrey)](https://github.com/maraloeDev/DescompresorZIP)
[![Architecture](https://img.shields.io/badge/Architecture-Modular-blueviolet)](https://es.wikipedia.org/wiki/Programaci%C3%B3n_modular)

## 💎 Ingeniería de Software Aplicada
Esta versión no es solo un script, es una aplicación robusta diseñada bajo principios de **tolerancia a fallos** y **modularidad funcional**.

### 🛠️ Blindaje Técnico:
* **Validación Persistente:** Si eliges un archivo no válido, el programa te avisa y te permite reintentar sin cerrarse. 🔄
* **Arquitectura de Funciones:** Código 100% modular con variables locales y lógica encapsulada.
* **Control de Conflictos (Smart Move):** Sistema inteligente que detecta archivos duplicados en el destino y te permite decidir (Sobreescribir/Saltar) caso por caso.
* **Higiene de Datos (Auto-Cleanup):** Uso de `trap` para garantizar que la carpeta temporal se borre SIEMPRE, incluso si el script falla o se interrumpe.

---

## 🚀 Funcionalidades Estrella

### 1. Descompresión "Matrioshka" (Recursiva)
Abre archivos dentro de archivos (ZIP -> RAR -> 7Z) de forma automática hasta llegar al fondo.


### 2. Multi-OS Engine (Linux, Mac, Windows)
Detecta tu sistema operativo y usa la mejor herramienta disponible:
* **Linux:** Zenity nativo y gestores de paquetes automáticos.
* **Windows (Git Bash):** Integración con **PowerShell** para diálogos nativos.
* **macOS:** Uso de **AppleScript** y Homebrew.

### 3. Gestión Inteligente de Conflictos
Si al extraer un archivo este ya existe en la carpeta final, UnpackMaster te preguntará qué hacer, dándote el control total para no perder datos importantes.


---

## Funciones

1. Función,Responsabilidad
2. fun_detectar_sistema,Identifica el Kernel para adaptar los comandos de UI.
3. fun_cleanup,Garantiza que no queden residuos en /tmp.
4. fun_smart_move,Lógica de decisión para archivos duplicados.

---

## 💻 Instalación y Uso

```bash
# 1. Clonar el proyecto
git clone https://github.com/maraloeDev/DescompresorZIP.git
cd DescompresorZIP

# 2. Dar permisos de ejecución
chmod +x descompresor_pro.sh

# 3. ¡Lanzar la magia!
./descompresor.sh
