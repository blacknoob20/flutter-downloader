# Configuración Rápida del Proyecto Flutter

## Pasos Iniciales

### 1. Verificar que Flutter está instalado

```bash
flutter --version
dart --version
```

### 2. Crear el proyecto desde este directorio

Si ya tienes la estructura creada:

```bash
cd youtube_downloader
flutter pub get
flutter pub upgrade
```

### 3. Configurar Android

#### Android Studio (Recomendado)

```bash
flutter config --android-studio-dir=/Applications/Android\ Studio.app
flutter config --android-sdk-path=$HOME/Library/Android/sdk
```

#### O manualmente

1. Descarga Android Studio desde https://developer.android.com/studio
2. Abre un emulador o conecta un dispositivo Android
3. Ejecuta `flutter devices` para verificar

### 4. Configurar iOS

```bash
# Para macOS/iOS
cd ios
pod repo update  # Actualizar CocoaPods
cd ..
flutter pub get
```

### 5. Ejecutar la aplicación

```bash
# En dispositivo/emulador conectado
flutter run

# O especificar dispositivo
flutter devices
flutter run -d <device_id>
```

## Verificación de Dependencias

### Verificar que yt-dlp está disponible

En tu dispositivo móvil (si es posible):
```bash
yt-dlp --version
```

O instalar en tu máquina de desarrollo para testing:
```bash
# macOS
brew install yt-dlp ffmpeg

# Linux
sudo apt-get install yt-dlp ffmpeg python3-pip
pip3 install yt-dlp

# Windows
choco install yt-dlp ffmpeg
```

## Troubleshooting

### Error: "Could not resolve all files for configuration ':app:debugRuntimeClasspath'"

Solución:
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Error: "XCouldn't communicate with a native service"

Para iOS, ejecuta:
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod repo update
cd ..
flutter clean
flutter pub get
```

### Error: "yt-dlp: command not found"

La app necesita que yt-dlp esté instalado en el dispositivo. En emuladores Android:
```bash
flutter install  # Instala la app
# Luego dentro de la app, seguirá las instrucciones para instalar yt-dlp
```

## Próximos Pasos

1. Personaliza el paquete de la app en `pubspec.yaml`
2. Actualiza los identificadores de bundle:
   - Android: Edita `android/app/build.gradle`
   - iOS: Edita `ios/Runner.xcodeproj` en Xcode

3. Prueba la aplicación:
   ```bash
   flutter test
   ```

4. Construye para release:
   ```bash
   # Android APK
   flutter build apk --release

   # iOS IPA
   flutter build ios --release

   # Web
   flutter build web --release
   ```

## Recursos Útiles

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp)
