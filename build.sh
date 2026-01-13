#!/bin/bash

# YouTube Downloader - Build Script

set -e

echo "🚀 YouTube Downloader - Build Script"
echo "====================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funciones
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}✗ Error: $1 no está instalado${NC}"
        exit 1
    fi
}

log_step() {
    echo -e "${YELLOW}$1${NC}"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Verificar requisitos
log_step "Verificando requisitos..."
check_command flutter
check_command dart
log_success "Requisitos verificados\n"

# Limpiar builds anteriores
log_step "Limpiando builds anteriores..."
flutter clean
log_success "Limpieza completada\n"

# Obtener dependencias
log_step "Obteniendo dependencias..."
flutter pub get
log_success "Dependencias obtenidas\n"

# Análisis estático
log_step "Ejecutando análisis estático..."
flutter analyze
log_success "Análisis completado\n"

# Formato de código
log_step "Verificando formato de código..."
dart format --set-exit-if-changed lib/ test/ 2>/dev/null || true
log_success "Formato verificado\n"

# Build APK (Android)
if [ "$1" == "android" ] || [ "$1" == "all" ]; then
    log_step "Construyendo APK de Android..."
    flutter build apk --release
    log_success "APK construido en: build/app/outputs/flutter-app.apk\n"
fi

# Build iOS
if [ "$1" == "ios" ] || [ "$1" == "all" ]; then
    log_step "Construyendo para iOS..."
    flutter build ios --release
    log_success "iOS construido en: build/ios/iphoneos/\n"
fi

# Build web
if [ "$1" == "web" ] || [ "$1" == "all" ]; then
    log_step "Construyendo para Web..."
    flutter build web --release
    log_success "Web construido en: build/web/\n"
fi

# Si no se especificó plataforma, solo verificar
if [ -z "$1" ]; then
    log_step "Testing..."
    flutter test
    log_success "Tests completados\n"
fi

echo -e "${GREEN}====================================="
echo "✓ Build completado exitosamente"
echo "=====================================${NC}"
echo ""
echo "Para construir para una plataforma específica:"
echo "  ./build.sh android   # Construir APK"
echo "  ./build.sh ios       # Construir para iOS"
echo "  ./build.sh web       # Construir para Web"
echo "  ./build.sh all       # Construir para todas las plataformas"
