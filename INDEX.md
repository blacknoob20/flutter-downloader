# 📑 Índice de Documentación

## 🚀 Empezar Aquí

Comienza por leer estos archivos en orden:

1. **[QUICKSTART.md](QUICKSTART.md)** ⚡ 5 minutos
   - Requisitos previos
   - Pasos iniciales
   - Primeros comandos
   - Solución de problemas básicos

2. **[README.md](README.md)** 📖 15 minutos
   - Descripción completa
   - Características
   - Requisitos detallados
   - Estructura del proyecto
   - Uso básico

## 📚 Documentación Principal

### Desarrollo
- **[ARCHITECTURE.md](ARCHITECTURE.md)** 🏗️
  - Estructura general
  - Flujo de datos
  - Patrones de diseño
  - Dependencias clave
  - Consideraciones de performance
  - Estrategia de extensibilidad

- **[SETUP.md](SETUP.md)** ⚙️
  - Pasos iniciales
  - Configuración de plataformas
  - Verificación de dependencias
  - Troubleshooting
  - Próximos pasos

### Testing
- **[testing/GUIDE.md](testing/GUIDE.md)** 🧪
  - Tests unitarios
  - Tests de integración
  - Pruebas manuales
  - Performance testing
  - Checklist pre-release

### Historial
- **[CHANGELOG.md](CHANGELOG.md)** 📝
  - Versión 1.0.0
  - Features implementadas
  - Roadmap futuro

### Configuración
- **[android_manifest_config.md](android_manifest_config.md)** 🤖
  - Permisos Android
  - Configuración de manifest
  - Características del dispositivo

- **[ios_setup.md](ios_setup.md)** 🍎
  - Configuración Info.plist
  - Deployment target
  - Configuraciones específicas de iOS

## 📋 Resúmenes
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** 📊
  - Estadísticas del proyecto
  - Features implementadas
  - Tecnologías utilizadas
  - Estructura final
  - Pasos siguientes

## 🛠️ Scripts y Utilidades

### Scripts Disponibles
```bash
# Desarrollo
./build.sh                    # Compilar proyecto
./commands.sh                 # Menú interactivo de comandos

# Testing
bash testing/test.sh          # Tests automatizados
bash testing/interactive-test.sh  # Testing interactivo
```

### Makefile
```bash
make help                 # Ver todos los comandos
make run                  # Ejecutar app
make test                 # Tests
make build               # Compilar APK
make clean               # Limpiar
make analyze             # Análisis estático
make format              # Formatear código
```

## 📂 Estructura de Archivos

```
youtube_downloader/
│
├── 📚 DOCUMENTACIÓN
│   ├── README.md                    # Documentación principal
│   ├── QUICKSTART.md               # Guía rápida (5 min)
│   ├── ARCHITECTURE.md             # Arquitectura del proyecto
│   ├── SETUP.md                    # Configuración detallada
│   ├── PROJECT_SUMMARY.md          # Resumen del proyecto
│   ├── CHANGELOG.md                # Historial de cambios
│   ├── android_manifest_config.md  # Config Android
│   ├── ios_setup.md                # Config iOS
│   └── INDEX.md                    # Este archivo
│
├── 🔧 SCRIPTS
│   ├── build.sh                    # Script de compilación
│   ├── commands.sh                 # Menú de comandos
│   ├── Makefile                    # Comandos útiles
│   └── flutter_config.yaml         # Config Flutter
│
├── 📱 CÓDIGO FUENTE (lib/)
│   ├── main.dart                   # Punto de entrada
│   ├── models/                     # Modelos de datos
│   │   ├── video_model.dart
│   │   └── download_model.dart
│   ├── services/                   # Lógica de negocio
│   │   ├── youtube_service.dart
│   │   ├── download_service.dart
│   │   └── storage_service.dart
│   ├── viewmodels/                 # State management
│   │   └── download_viewmodel.dart
│   ├── screens/                    # Pantallas
│   │   ├── home_screen.dart
│   │   ├── format_selection_screen.dart
│   │   └── download_screen.dart
│   └── widgets/                    # Componentes UI
│       ├── dialogs.dart
│       ├── download_card.dart
│       └── format_selection_card.dart
│
├── 🧪 TESTING (test/ & testing/)
│   ├── models_test.dart            # Unit tests
│   ├── widget_test.dart            # Widget tests
│   ├── testing/GUIDE.md            # Guía de testing
│   ├── testing/test.sh             # Script de tests
│   └── testing/interactive-test.sh # Testing interactivo
│
├── ⚙️ CONFIGURACIÓN
│   ├── pubspec.yaml                # Dependencias
│   ├── pubspec.lock                # Lock file
│   └── .gitignore                  # Git ignores
│
└── 📦 PLATAFORMAS
    ├── android/                    # Código Android
    └── ios/                        # Código iOS
```

## 🎯 Guía de Lectura por Tipo de Usuario

### Para Comenzar a Usar (Cualquiera)
1. QUICKSTART.md
2. Ejecutar `flutter run`
3. Probar la aplicación

### Para Desarrollar
1. QUICKSTART.md
2. ARCHITECTURE.md
3. Explorar `lib/` directory
4. Leer comentarios en el código
5. Ejecutar tests: `flutter test`

### Para Hacer Deploy
1. SETUP.md
2. android_manifest_config.md (si es Android)
3. ios_setup.md (si es iOS)
4. testing/GUIDE.md (checklist)
5. Ejecutar: `flutter build`

### Para Entender la Arquitectura
1. ARCHITECTURE.md
2. Explorar `lib/services/`
3. Explorar `lib/viewmodels/`
4. Leer `lib/main.dart`

### Para Agregar Funcionalidades
1. ARCHITECTURE.md (sección "Extensibilidad")
2. Estudiar servicios existentes
3. Crear nuevo servicio
4. Actualizar ViewModel
5. Crear pantalla/widget
6. Agregar tests

## 📖 Lecturas Recomendadas

### Según tu rol

**Desarrollador Flutter**
- ARCHITECTURE.md
- lib/services/ (leer código)
- lib/screens/ (leer código)

**Product Manager**
- README.md
- PROJECT_SUMMARY.md
- CHANGELOG.md

**DevOps / Release**
- SETUP.md
- android_manifest_config.md
- ios_setup.md
- testing/GUIDE.md

**QA / Tester**
- testing/GUIDE.md
- testing/interactive-test.sh
- README.md (Features)

## 🔍 Índice Rápido por Tema

### Ingreso de URL
- Código: [lib/screens/home_screen.dart](lib/screens/home_screen.dart)
- Validación: [lib/services/youtube_service.dart](lib/services/youtube_service.dart#L25)
- Doc: [README.md](README.md#usage)

### Selección de Formato
- Código: [lib/screens/format_selection_screen.dart](lib/screens/format_selection_screen.dart)
- Modelos: [lib/models/video_model.dart](lib/models/video_model.dart)
- Filtrado: [lib/services/youtube_service.dart](lib/services/youtube_service.dart#L80)

### Descarga de Videos
- Código: [lib/services/download_service.dart](lib/services/download_service.dart)
- Modelo: [lib/models/download_model.dart](lib/models/download_model.dart)
- ViewModel: [lib/viewmodels/download_viewmodel.dart](lib/viewmodels/download_viewmodel.dart)

### Almacenamiento Local
- Código: [lib/services/storage_service.dart](lib/services/storage_service.dart)
- Persistencia: SharedPreferences

### Tests
- Unit Tests: [test/models_test.dart](test/models_test.dart)
- Widget Tests: [test/widget_test.dart](test/widget_test.dart)
- Guía: [testing/GUIDE.md](testing/GUIDE.md)

## 💡 Tips Útiles

### Para ejecutar rápido
```bash
# Opción 1: Usar script interactivo
./commands.sh

# Opción 2: Usar Makefile
make run

# Opción 3: Comando directo
flutter run
```

### Para entender el código
```bash
# Leer la arquitectura primero
cat ARCHITECTURE.md

# Luego explorar el código fuente
ls -la lib/

# Luego leer comentarios
grep -r "\/\/" lib/ | head -20
```

### Para hacer testing
```bash
# Ejecutar todos los tests
flutter test

# O usar el script
bash testing/interactive-test.sh

# Con cobertura
flutter test --coverage
```

## 📞 Soporte

- **Documentación oficial**: https://flutter.dev/docs
- **Paquetes**: https://pub.dev
- **yt-dlp**: https://github.com/yt-dlp/yt-dlp
- **Flutter Community**: https://flutter.dev/community

## ✅ Checklist de Lectura

Marca lo que ya has leído:

- [ ] QUICKSTART.md (inicio)
- [ ] README.md (general)
- [ ] ARCHITECTURE.md (técnico)
- [ ] SETUP.md (configuración)
- [ ] testing/GUIDE.md (testing)
- [ ] PROJECT_SUMMARY.md (resumen)
- [ ] Código fuente (desarrollo)
- [ ] Scripts y Makefile (utilities)

---

**Última actualización**: 10 de enero de 2026
**Versión**: 1.0.0

¡Happy coding! 🚀
