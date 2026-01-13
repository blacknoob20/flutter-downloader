#!/bin/bash

# YouTube Downloader - Flutter Project
# Referencia rápida de comandos

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     YouTube Downloader - Referencia Rápida de Comandos        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

show_menu() {
    echo "🎯 Selecciona una opción:"
    echo ""
    echo "  DESARROLLO"
    echo "  1) flutter run          - Ejecutar la app"
    echo "  2) flutter pub get      - Instalar dependencias"
    echo "  3) flutter clean        - Limpiar proyecto"
    echo ""
    echo "  TESTING"
    echo "  4) flutter test         - Ejecutar tests"
    echo "  5) flutter analyze      - Análisis estático"
    echo "  6) dart format lib/     - Formatear código"
    echo ""
    echo "  BUILD"
    echo "  7) flutter build apk    - Compilar APK Android"
    echo "  8) flutter build ios    - Compilar iOS"
    echo "  9) flutter build web    - Compilar Web"
    echo ""
    echo "  SCRIPTS"
    echo "  10) make help           - Ver comandos Makefile"
    echo "  11) bash testing/interactive-test.sh - Testing interactivo"
    echo ""
    echo "  DOCUMENTACIÓN"
    echo "  12) cat QUICKSTART.md   - Guía rápida (5 min)"
    echo "  13) cat ARCHITECTURE.md - Arquitectura del proyecto"
    echo "  14) cat README.md       - Documentación completa"
    echo ""
    echo "  OTROS"
    echo "  0) Salir"
    echo ""
}

execute_command() {
    case $1 in
        1)
            echo "▶️  Ejecutando flutter run..."
            flutter run
            ;;
        2)
            echo "📦 Instalando dependencias..."
            flutter pub get
            ;;
        3)
            echo "🧹 Limpiando proyecto..."
            flutter clean
            echo "✅ Limpieza completada"
            ;;
        4)
            echo "🧪 Ejecutando tests..."
            flutter test
            ;;
        5)
            echo "🔍 Análisis estático..."
            flutter analyze
            ;;
        6)
            echo "✨ Formateando código..."
            dart format lib/ test/
            echo "✅ Formato aplicado"
            ;;
        7)
            echo "🔨 Compilando APK..."
            flutter build apk --release
            echo "✅ APK compilado en: build/app/outputs/flutter-app.apk"
            ;;
        8)
            echo "🔨 Compilando para iOS..."
            flutter build ios --release
            echo "✅ iOS compilado"
            ;;
        9)
            echo "🔨 Compilando para Web..."
            flutter build web --release
            echo "✅ Web compilado en: build/web/"
            ;;
        10)
            echo "📋 Comandos Makefile disponibles:"
            echo ""
            make help
            ;;
        11)
            echo "🧪 Iniciando testing interactivo..."
            bash testing/interactive-test.sh
            ;;
        12)
            less QUICKSTART.md
            ;;
        13)
            less ARCHITECTURE.md
            ;;
        14)
            less README.md
            ;;
        0)
            echo "👋 ¡Adiós!"
            exit 0
            ;;
        *)
            echo "❌ Opción inválida"
            ;;
    esac
}

# Main loop
while true; do
    clear
    show_menu
    read -p "Opción: " choice
    if [ ! -z "$choice" ]; then
        execute_command $choice
        echo ""
        read -p "Presiona Enter para continuar..."
    fi
done
