# 🚀 Guía Rápida de Inicio

## 1️⃣ Requisitos Previos

### En tu computadora
- **Flutter**: 3.0+ ([instala aquí](https://flutter.dev/docs/get-started/install))
- **Dart**: 3.0+ (incluido con Flutter)
- **Xcode** (para iOS en macOS)
- **Android Studio** (para Android)
- **yt-dlp**: Para testing local

```bash
# Verificar instalación
flutter doctor

# Instalar yt-dlp y ffmpeg
brew install yt-dlp ffmpeg  # macOS
# O en tu plataforma correspondiente
```

## 2️⃣ Configuración Inicial

### Paso 1: Navega al directorio del proyecto

```bash
cd /Users/cristhianreneguerrerosoto/Docker/compose/flutter-downloader/youtube_downloader
```

### Paso 2: Obtén dependencias

```bash
flutter pub get
```

### Paso 3: Ejecuta la app

```bash
# En emulador o dispositivo conectado
flutter run

# O si quieres especificar el dispositivo
flutter devices
flutter run -d <device_id>
```

## 3️⃣ Primeros Pasos en la App

### Flujo Principal

1. **Pantalla Home**: Ingresa una URL de YouTube
   - Ejemplo: `https://www.youtube.com/watch?v=dQw4w9WgXcQ`

2. **Pantalla de Formato**: Selecciona cómo descargar
   - MP4, MKV, audio solo, etc.

3. **Pantalla de Descarga**: Monitorea el progreso
   - Pausar, reanudar, cancelar
   - Ver historial completo

## 4️⃣ Comandos Útiles

### Desarrollo

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo profile (más rápido)
flutter run --profile

# Ejecutar en modo release
flutter run --release

# Hot reload durante desarrollo
# Presiona 'r' en la terminal
```

### Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar con cobertura
flutter test --coverage

# Usar el Makefile (más fácil)
make test      # Tests
make analyze   # Análisis estático
make format    # Formatear código
```

### Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# O usar el Makefile
make build      # APK
make build-ios  # iOS
make build-web  # Web
```

## 5️⃣ Troubleshooting Rápido

### "Device not found"

```bash
# Listar dispositivos disponibles
flutter devices

# Si es Android, abre el emulador
# Si es iOS, ejecuta en Xcode
```

### "Dependencias no encuentran yt-dlp"

La app necesita que `yt-dlp` esté instalado:

```bash
# macOS
brew install yt-dlp

# Linux
sudo apt-get install yt-dlp
pip3 install yt-dlp

# Windows
choco install yt-dlp
```

### "Error de permisos"

En Android:
- Ve a Configuración > Aplicaciones > YouTube Downloader
- Habilita permisos de Almacenamiento
- Habilita permiso de Internet

En iOS:
- Los permisos se piden automáticamente

### "Errores de compilación"

```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## 6️⃣ Configuración Personalizada

### Cambiar el paquete de la app

En `pubspec.yaml`, cambia el nombre:
```yaml
name: tu_nombre_app
```

En Android (`android/app/build.gradle`):
```gradle
applicationId "com.tudominio.youtube_downloader"
```

En iOS (Xcode):
- Bundle Identifier: `com.tudominio.youtube-downloader`

### Cambiar la carpeta de descargas

En [lib/services/download_service.dart](lib/services/download_service.dart):

```dart
Future<String> _getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/TuCarpeta');
    // ...
}
```

## 7️⃣ Documentación Importante

| Archivo | Descripción |
|---------|-------------|
| [README.md](README.md) | Documentación completa |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Arquitectura del proyecto |
| [SETUP.md](SETUP.md) | Configuración detallada |
| [testing/GUIDE.md](testing/GUIDE.md) | Guía de testing |
| [CHANGELOG.md](CHANGELOG.md) | Cambios y versiones |

## 8️⃣ Estructura de Carpetas

```
youtube_downloader/
├── lib/                    ← Código fuente
│   ├── main.dart          ← Punto de entrada
│   ├── models/            ← Modelos de datos
│   ├── services/          ← Lógica de negocio
│   ├── viewmodels/        ← Estado (Provider)
│   ├── screens/           ← Pantallas principales
│   └── widgets/           ← Componentes reutilizables
├── test/                  ← Tests unitarios
├── testing/               ← Scripts de testing
├── android/               ← Código específico de Android
├── ios/                   ← Código específico de iOS
├── pubspec.yaml          ← Dependencias y config
└── README.md             ← Este archivo
```

## 9️⃣ Próximos Pasos

### Para empezar a desarrollar:

1. ✅ Lee [ARCHITECTURE.md](ARCHITECTURE.md)
2. ✅ Explora los servicios en `lib/services/`
3. ✅ Modifica las pantallas en `lib/screens/`
4. ✅ Agrega tests en `test/`

### Para lanzar:

1. ✅ Personaliza el paquete
2. ✅ Ejecuta todos los tests
3. ✅ Construye para tu plataforma
4. ✅ Sube a App Store / Google Play

## 🔟 Recursos Útiles

- 📚 [Flutter Docs](https://flutter.dev/docs)
- 📚 [Dart Docs](https://dart.dev/guides)
- 📦 [pub.dev](https://pub.dev) - Paquetes Flutter
- 🎥 [Flutter YouTube](https://www.youtube.com/flutterdev)
- 🐛 [GitHub Issues](https://github.com/yt-dlp/yt-dlp/issues)

---

**¿Necesitas ayuda?** Revisa la documentación completa o los scripts de testing.

**¡Listo para empezar!** 🎉

```bash
cd youtube_downloader
flutter run
```
