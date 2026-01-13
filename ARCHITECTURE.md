# YouTube Downloader - Documentación de Arquitectura

## Estructura General

El proyecto sigue el patrón **MVVM (Model-View-ViewModel)** con **State Management mediante Provider**.

```
youtube_downloader/
├── lib/
│   ├── main.dart                      # Punto de entrada
│   ├── models/                        # Modelos de datos
│   │   ├── video_model.dart           # Video y Format
│   │   └── download_model.dart        # Download y DownloadStatus
│   ├── services/                      # Servicios de lógica de negocio
│   │   ├── youtube_service.dart       # YouTube/yt-dlp
│   │   ├── download_service.dart      # Gestión de descargas
│   │   └── storage_service.dart       # Almacenamiento local
│   ├── viewmodels/                    # ViewModels (estado)
│   │   └── download_viewmodel.dart    # Lógica de descargas
│   ├── screens/                       # Pantallas principales
│   │   ├── home_screen.dart           # Ingreso de URL
│   │   ├── format_selection_screen.dart # Selección de formato
│   │   └── download_screen.dart       # Historial de descargas
│   └── widgets/                       # Widgets reutilizables
│       ├── dialogs.dart               # Diálogos (Error, Loading, Confirm)
│       ├── download_card.dart         # Tarjeta de descarga
│       └── format_selection_card.dart # Tarjeta de formato
├── test/                              # Tests
├── testing/                           # Guías y scripts de testing
└── pubspec.yaml                       # Dependencias
```

## Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                      UI Layer (Screens & Widgets)                │
├─────────────────────────────────────────────────────────────────┤
│    HomeScreen → FormatSelectionScreen → DownloadScreen          │
│         ↓                   ↓                   ↓                 │
│  Input URL          Select Format         Show Progress          │
└──────┬──────────────────┬──────────────────┬──────────────────────┘
       │                  │                  │
       ↓                  ↓                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                  ViewModel (Provider)                            │
├─────────────────────────────────────────────────────────────────┤
│              DownloadViewModel                                   │
│  - Gestiona estado de descargas                                  │
│  - Comunicación entre servicios y UI                             │
│  - Notifica cambios a widgets                                    │
└──────┬──────────────────┬──────────────────┬──────────────────────┘
       │                  │                  │
       ↓                  ↓                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                  Services Layer                                  │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │YouTubeService    │  │DownloadServ. │  │StorageService    │   │
│  │- Validar URL     │  │- Descargar   │  │- Guardar histor. │   │
│  │- Obtener info    │  │- Pausar      │  │- Cargar histor.  │   │
│  │- Listar formatos │  │- Reanudar    │  │- Guardar ajustes │   │
│  │- Usar yt-dlp     │  │- Cancelar    │  │- SharedPrefs     │   │
│  └──────────────────┘  └──────────────┘  └──────────────────┘   │
└──────┬──────────────────┬──────────────────┬──────────────────────┘
       │                  │                  │
       ↓                  ↓                  ↓
┌─────────────────────────────────────────────────────────────────┐
│              Data & External Services Layer                      │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌─────────┐  ┌──────────┐  ┌────────────┐         │
│  │ YouTube  │  │ Local   │  │ yt-dlp   │  │  ffmpeg   │         │
│  │ (API)    │  │FileSystem│  │(Process) │  │ (Process) │         │
│  └──────────┘  └─────────┘  └──────────┘  └────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

## Patrones de Diseño

### 1. **MVVM Pattern**

- **Model**: `Video`, `Download`, `Format`
- **View**: Screens y Widgets
- **ViewModel**: `DownloadViewModel`

### 2. **Service Locator**

Mediante Provider, se inyectan los servicios:

```dart
Provider<YouTubeService>(create: (_) => YouTubeService()),
Provider<DownloadService>(create: (_) => DownloadService()),
Provider<StorageService>(create: (_) => storageService),
```

### 3. **Repository Pattern**

`StorageService` actúa como repositorio de datos locales.

### 4. **Observable Pattern**

`ChangeNotifier` en `DownloadViewModel` notifica cambios a la UI.

## Dependencias Clave

| Paquete | Uso |
|---------|-----|
| `provider` | State management y inyección de dependencias |
| `dio` | HTTP client para descargas |
| `shared_preferences` | Almacenamiento local de datos |
| `path_provider` | Acceso a directorios del dispositivo |
| `uuid` | Generación de IDs únicos |
| `process` | Ejecución de procesos del sistema (yt-dlp) |
| `logger` | Sistema de logging |
| `intl` | Internacionalización y formateo |

## Flujo de Descarga Detallado

```
1. User Input (URL)
   ↓
2. YouTubeService.isValidYouTubeUrl()
   ├─ Válida: Continúa
   └─ Inválida: Muestra error
   ↓
3. YouTubeService.getVideoInfo()
   ├─ Ejecuta: yt-dlp --dump-json <url>
   ├─ Parsea resultado JSON
   └─ Retorna Video con formatos disponibles
   ↓
4. FormatSelectionScreen muestra formatos
   ↓
5. User selecciona formato
   ↓
6. DownloadViewModel.downloadVideo()
   ├─ Crea Download object
   ├─ Llama DownloadService.downloadVideo()
   │  ├─ Ejecuta: yt-dlp -f <format_id> <url>
   │  ├─ Monitorea progreso
   │  └─ Guarda archivo
   ├─ Actualiza Download status
   ├─ Notifica a UI (via Provider)
   └─ Guarda en StorageService
   ↓
7. DownloadScreen muestra progreso
   ↓
8. Descarga completa o error
   ├─ Éxito: Guarda historial
   └─ Error: Muestra mensaje
```

## Manejo de Errores

### Niveles de Error

1. **Validación**: URLs inválidas, datos malformados
2. **Ejecución**: yt-dlp falla, red no disponible
3. **Persistencia**: No se puede guardar en almacenamiento

### Estrategia

- Cada servicio lanza excepciones con contexto
- ViewModel captura y convierte en mensajes UI
- Usuario ve dialogs de error claros

## State Management

### DownloadViewModel

```dart
// Estado
List<Download> _downloads
Download? _currentDownload
bool _isLoading
String? _errorMessage

// Métodos públicos
initialize()         // Carga historial
downloadVideo()      // Inicia descarga
pauseDownload()      // Pausa
resumeDownload()     // Reanuda
cancelDownload()     // Cancela
deleteDownload()     // Elimina del historial
clearHistory()       // Borra todo
```

## Consideraciones de Performance

### Optimizaciones Implementadas

1. **Lazy Loading**: Formatos se cargan bajo demanda
2. **List Caching**: Historial se cachea en memoria
3. **Progress Updates**: Solo se redibuja cuando cambia el progreso
4. **Process Management**: yt-dlp se ejecuta en background

### Límites

- Máximo de descargas simultáneas: 1 (actual)
- Timeout de yt-dlp: Configurable
- Tamaño máximo de caché: Ilimitado

## Seguridad

### Consideraciones

1. **URLs**: Se valida contra patrones de YouTube
2. **Procesos**: Se ejecuta yt-dlp con argumentos seguros
3. **Almacenamiento**: SharedPreferences encriptado en iOS
4. **Archivos**: Se guardan en directorio privado de la app

## Extensibilidad

### Para agregar nueva funcionalidad

1. **Nuevo servicio**: Crear en `lib/services/`
2. **Actualizar ViewModel**: Agregar método en `DownloadViewModel`
3. **Nueva pantalla**: Crear en `lib/screens/`
4. **Nuevos widgets**: Crear en `lib/widgets/`
5. **Tests**: Agregar en `test/`

### Ejemplo: Agregar descarga de playlists

```dart
// 1. En YouTubeService
Future<List<Video>> getPlaylistVideos(String url) async { ... }

// 2. En DownloadViewModel
Future<void> downloadPlaylist(String url) async { ... }

// 3. Crear PlaylistScreen

// 4. Actualizar navegación en main.dart
```

## Testing Strategy

### Tipos de Tests

1. **Unit Tests**: Modelos, servicios
2. **Widget Tests**: Screens, widgets
3. **Integration Tests**: Flujos completos

### Cobertura Objetivo

- Servicios: 100%
- Modelos: 100%
- ViewModels: 80%+
- UI: 60%+

## Deployment

### Pre-release Checklist

- [ ] Todos los tests en verde
- [ ] `flutter analyze` sin warnings
- [ ] Performance acceptable
- [ ] Sin errores conocidos
- [ ] Versión actualizada en pubspec.yaml

### Build Process

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Referencias

- [Flutter Architecture Documentation](https://flutter.dev/docs/testing/best-practices)
- [Provider Documentation](https://pub.dev/packages/provider)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp)
