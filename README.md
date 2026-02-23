# 📦 DescompresorZIP
> Herramienta de automatización en Bash para la gestión simplificada de archivos comprimidos.

[![Bash Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Descripción
**DescompresorZIP** elimina la fricción de recordar parámetros específicos para cada tipo de archivo (`tar`, `zip`, `rar`, etc.). El script detecta automáticamente el formato, verifica si tienes las herramientas necesarias instaladas y te permite elegir el destino final de los datos.

## ✨ Características
- **Smart Detection:** Identificación de extensiones mediante manipulación nativa de strings.
- **Dependency Check:** Valida si el sistema tiene instalados los binarios necesarios antes de actuar.
- **Sandboxing:** Utiliza directorios temporales (`mktemp`) para asegurar una extracción limpia.
- **Universal:** Soporta `.zip`, `.tar`, `.tar.gz`, `.rar` y `.7z`.

## 🛠️ Instalación
```bash
# Clonar repositorio
git clone [https://github.com/maraloeDev/DescompresorZIP.git](https://github.com/maraloeDev/DescompresorZIP.git)

# Entrar al directorio
cd DescompresorZIP

# Dar permisos de ejecución
chmod +x descompresor.sh

