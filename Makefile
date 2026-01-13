# YouTube Downloader - Makefile

.PHONY: help clean get test build run format analyze

help:
	@echo "YouTube Downloader - Comandos disponibles:"
	@echo ""
	@echo "  make clean       - Limpiar builds anteriores"
	@echo "  make get         - Obtener dependencias"
	@echo "  make test        - Ejecutar tests"
	@echo "  make build       - Construir APK de Android"
	@echo "  make build-ios   - Construir para iOS"
	@echo "  make build-web   - Construir para Web"
	@echo "  make run         - Ejecutar en dispositivo/emulador"
	@echo "  make run-profile - Ejecutar en modo profile (para debugging)"
	@echo "  make format      - Formatear código"
	@echo "  make analyze     - Análisis estático de código"
	@echo "  make all         - clean + get + analyze + test"
	@echo ""

clean:
	@echo "🧹 Limpiando..."
	flutter clean
	@echo "✓ Limpieza completada"

get:
	@echo "📦 Obteniendo dependencias..."
	flutter pub get
	@echo "✓ Dependencias obtenidas"

test:
	@echo "🧪 Ejecutando tests..."
	flutter test
	@echo "✓ Tests completados"

build: clean get
	@echo "🔨 Construyendo APK de Android..."
	flutter build apk --release
	@echo "✓ APK construido: build/app/outputs/flutter-app.apk"

build-ios: clean get
	@echo "🔨 Construyendo para iOS..."
	flutter build ios --release
	@echo "✓ iOS construido"

build-web: clean get
	@echo "🔨 Construyendo para Web..."
	flutter build web --release
	@echo "✓ Web construido en: build/web/"

run:
	@echo "▶️  Ejecutando aplicación..."
	flutter run

run-profile:
	@echo "▶️  Ejecutando en modo profile..."
	flutter run --profile

format:
	@echo "✨ Formateando código..."
	dart format lib/ test/
	@echo "✓ Formato completado"

analyze:
	@echo "🔍 Analizando código..."
	flutter analyze
	@echo "✓ Análisis completado"

all: clean get analyze test
	@echo "✓ Todas las verificaciones completadas"

.DEFAULT_GOAL := help
