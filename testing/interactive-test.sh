#!/bin/bash

# YouTube Downloader - Interactive Test Script

set -e

echo "🎬 YouTube Downloader - Interactive Testing"
echo "==========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones
test_url_validation() {
    echo -e "${BLUE}Testing URL Validation${NC}"
    echo "Prueba estos casos:"
    echo "  ✓ https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    echo "  ✓ https://youtu.be/dQw4w9WgXcQ"
    echo "  ✗ https://example.com"
    echo "  ✗ texto aleatorio"
    echo ""
}

test_format_selection() {
    echo -e "${BLUE}Testing Format Selection${NC}"
    echo "Verifica que:"
    echo "  ✓ Aparezcan formatos recomendados"
    echo "  ✓ Se muestre resolución y tamaño"
    echo "  ✓ Se pueda seleccionar cada formato"
    echo "  ✓ El botón de descarga se actualice"
    echo ""
}

test_download_flow() {
    echo -e "${BLUE}Testing Download Flow${NC}"
    echo "Verifica que:"
    echo "  ✓ Se muestre barra de progreso"
    echo "  ✓ Se actualice el porcentaje"
    echo "  ✓ Se muestre velocidad de descarga"
    echo "  ✓ La descarga se complete exitosamente"
    echo ""
}

test_history() {
    echo -e "${BLUE}Testing Download History${NC}"
    echo "Verifica que:"
    echo "  ✓ Se muestren todas las descargas"
    echo "  ✓ Se pueda pausar/reanudar"
    echo "  ✓ Se pueda cancelar"
    echo "  ✓ Se pueda eliminar del historial"
    echo ""
}

test_persistence() {
    echo -e "${BLUE}Testing Data Persistence${NC}"
    echo "Verifica que:"
    echo "  ✓ El historial persista después de reiniciar"
    echo "  ✓ Los ajustes se guarden"
    echo "  ✓ Los archivos estén en el directorio de descargas"
    echo ""
}

test_theme() {
    echo -e "${BLUE}Testing Theme Support${NC}"
    echo "Verifica que:"
    echo "  ✓ La app responda a cambios de tema del sistema"
    echo "  ✓ Se vea bien en tema claro"
    echo "  ✓ Se vea bien en tema oscuro"
    echo ""
}

run_tests() {
    echo ""
    echo -e "${YELLOW}Selecciona qué tests ejecutar:${NC}"
    echo ""
    echo "1) Todos los tests"
    echo "2) Unit Tests"
    echo "3) Widget Tests"
    echo "4) Manual Tests"
    echo "5) Ver checklist"
    echo "0) Salir"
    echo ""
    read -p "Opción: " option

    case $option in
        1)
            echo ""
            echo -e "${YELLOW}Ejecutando todos los tests...${NC}"
            flutter test
            ;;
        2)
            echo ""
            echo -e "${YELLOW}Ejecutando unit tests...${NC}"
            flutter test test/models_test.dart -v
            ;;
        3)
            echo ""
            echo -e "${YELLOW}Ejecutando widget tests...${NC}"
            flutter test test/widget_test.dart -v
            ;;
        4)
            echo ""
            echo -e "${YELLOW}Guía de Testing Manual${NC}"
            echo ""
            test_url_validation
            test_format_selection
            test_download_flow
            test_history
            test_persistence
            test_theme
            echo -e "${GREEN}Sigue la guía anterior para probar manualmente${NC}"
            ;;
        5)
            echo ""
            echo -e "${YELLOW}Checklist Pre-Release${NC}"
            echo ""
            echo "Antes de lanzar a producción, verifica:"
            echo ""
            echo -e "${BLUE}Code Quality${NC}"
            echo "  [ ] flutter analyze sin errores"
            echo "  [ ] dart format correcto"
            echo "  [ ] Tests en 100% de paso"
            echo ""
            echo -e "${BLUE}Funcionalidades${NC}"
            echo "  [ ] URLs de YouTube válidas funcionan"
            echo "  [ ] Selección de formatos funciona"
            echo "  [ ] Descargas se completan correctamente"
            echo "  [ ] Historial persiste"
            echo "  [ ] Pausa/Reanuda/Cancela funcionan"
            echo ""
            echo -e "${BLUE}UI/UX${NC}"
            echo "  [ ] Tema oscuro/claro funciona"
            echo "  [ ] Responsive en diferentes tamaños"
            echo "  [ ] Mensajes de error claros"
            echo "  [ ] Loading states visibles"
            echo ""
            echo -e "${BLUE}Performance${NC}"
            echo "  [ ] App inicia rápido (< 2s)"
            echo "  [ ] FPS alto durante descarga (> 50)"
            echo "  [ ] Memoria < 200MB"
            echo ""
            echo -e "${BLUE}Permisos${NC}"
            echo "  [ ] Permisos de almacenamiento funcionan"
            echo "  [ ] Permisos de internet funcionan"
            echo ""
            ;;
        0)
            echo -e "${GREEN}¡Adiós!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            ;;
    esac

    echo ""
    read -p "Presiona Enter para continuar..."
    clear
    run_tests
}

# Main
clear
run_tests
