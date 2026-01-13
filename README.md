# YouTube Downloader - Flutter App

Una aplicación móvil elegante y ligera para descargar videos de YouTube directamente en tu teléfono.

## 🎯 Características

- 📱 **Interfaz moderna y amigable** - Diseño intuitivo con Material 3
- 🎬 **Múltiples formatos** - MP4, MKV, WebM, audio solo y más
- ⚡ **Descarga rápida** - Integración con `youtube_explode_dart` para extraer URLs directas
- 📊 **Seguimiento de progreso** - Visualiza el progreso, velocidad y tiempo estimado
- 💾 **Almacenamiento inteligente** - Guarda automáticamente en tu dispositivo
- ⏸️ **Control de descargas** - Pausa, reanuda y cancela descargas
- 📜 **Historial completo** - Mantén un registro de todas tus descargas
- 🌙 **Tema oscuro/claro** - Soporta ambos modos de tema
- 📲 **Compatible con Android e iOS** - Funciona nativamente sin dependencias externas

## 📋 Requisitos

- Flutter 3.0 o superior
- Dart 3.0 o superior

**✅ No requiere yt-dlp ni ffmpeg** - La aplicación funciona directamente en dispositivos móviles usando `youtube_explode_dart` para extraer información y URLs de descarga de YouTube.

## 🚀 Inicio rápido

### 1. Clonar/Descargar el proyecto

```bash
cd /path/to/youtube_downloader
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

```bash
# En dispositivo o emulador
flutter run

# O especificar el dispositivo
flutter run -d <device_id>

# Modo release
flutter run --release
```

## 📁 Estructura del proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── models/
│   ├── video_model.dart              # Modelo de Video y Format
│   └── download_model.dart           # Modelo de Download
├── services/
│   ├── youtube_service.dart          # Servicio de YouTube (youtube_explode_dart)
│   ├── download_service.dart         # Servicio de descargas (Dio HTTP)
│   └── storage_service.dart          # Servicio de almacenamiento local
├── viewmodels/
│   └── download_viewmodel.dart       # ViewModel con lógica de negocio
├── screens/
│   ├── home_screen.dart              # Pantalla principal
│   ├── format_selection_screen.dart  # Selección de formato
│   └── download_screen.dart          # Pantalla de descargas
└── widgets/
    ├── dialogs.dart                  # Diálogos reutilizables
    ├── download_card.dart            # Tarjeta de descarga
    └── format_selection_card.dart    # Tarjeta de selección de formato
```

## 🔧 Arquitectura

La aplicación **NO requiere yt-dlp ni ffmpeg**. En su lugar, utiliza:

- **`youtube_explode_dart`**: Extrae información del video y URLs de descarga directa de YouTube sin dependencias externas
- **`Dio`**: Descarga los archivos directamente usando HTTP con seguimiento de progreso en tiempo real

Esto permite que la aplicación funcione **nativamente en Android e iOS** sin necesidad de herramientas de línea de comandos.

## 🎮 Uso

### Paso 1: Ingresa una URL
- Abre la app y pega la URL de un video de YouTube
- La URL debe ser válida

### Paso 2: Selecciona un formato
- La app mostrará los formatos disponibles con información real
- Puedes ver el tamaño, resolución y características de cada uno
- Selecciona el que prefieras

### Paso 3: Descarga
- Presiona "Descargar"
- Monitorea el progreso en la pantalla de descargas
- La descarga se guarda automáticamente en tu dispositivo

## ⚙️ Configuración

### Añadir nuevos formatos recomendados

Edita el método `_filterRecommendedFormats` en [lib/services/youtube_service.dart](lib/services/youtube_service.dart) para personalizar los formatos mostrados.

### Cambiar carpeta de descargas

Modifica el método `_getOutputDirectory` en [lib/services/download_service.dart](lib/services/download_service.dart).

## 🧪 Testing

```bash
# Ejecutar tests
flutter test

# Con cobertura
flutter test --coverage

# Generar reporte HTML de cobertura
genhtml coverage/lcov.info -o coverage/html
```

## 🐛 Solución de problemas

### "yt-dlp: command not found"
- Asegúrate de haber instalado `yt-dlp` correctamente
- En macOS: `brew install yt-dlp`
- En Linux: `pip3 install yt-dlp` o `apt-get install yt-dlp`

### "La descarga no inicia"
- Verifica que tengas conexión a internet
- Comprueba que la URL es válida
- Asegúrate de que `yt-dlp` está actualizado: `yt-dlp -U`

### "Permiso denegado al guardar"
- La app necesita permisos de almacenamiento
- En Android: Verifica los permisos en Configuración
- En iOS: Verifica los permisos en Configuración > Privacidad

## 📱 Soporte de plataformas

- ✅ Android 7.0+
- ✅ iOS 12.0+
- ✅ Linux (con Flutter)
- ✅ macOS (con Flutter)
- ✅ Windows (con Flutter)

## 🔄 Sincronización con proyecto Zig

Este proyecto Flutter es una adaptación móvil del descargador de YouTube original en Zig. Ambos comparten la misma lógica central usando `yt-dlp`:

- **Zig**: Terminal CLI, `zig-code/`
- **Flutter**: App móvil, `youtube_downloader/`

## 📦 Dependencias principales

- **provider**: State management
- **dio**: HTTP client para descargas
- **yt-dlp**: Backend para obtener videos de YouTube
- **shared_preferences**: Almacenamiento local de preferencias
- **path_provider**: Acceso a directorios del dispositivo
- **logger**: Sistema de logging
- **uuid**: Generación de IDs únicos

## 📄 Licencia

Este proyecto está bajo licencia MIT.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📧 Soporte

Para reportar bugs o solicitar features, abre un issue en el repositorio.

---

**Disfruta descargando tus videos favoritos de YouTube directamente en tu teléfono** 🎉
