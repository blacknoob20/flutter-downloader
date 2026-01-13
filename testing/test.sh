#!/bin/bash

# YouTube Downloader - Script de Testing Básico

echo "🧪 YouTube Downloader - Testing Script"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funciones
run_test() {
    echo -e "${YELLOW}Running: $1${NC}"
    eval $1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Passed${NC}\n"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}\n"
        return 1
    fi
}

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml no encontrado${NC}"
    echo "Por favor ejecuta este script desde la raíz del proyecto Flutter"
    exit 1
fi

# Tests
echo -e "${YELLOW}1. Verificando análisis estático...${NC}"
run_test "flutter analyze"

echo -e "${YELLOW}2. Verificando formato del código...${NC}"
run_test "dart format --set-exit-if-changed lib/ test/ 2>/dev/null"

echo -e "${YELLOW}3. Obteniendo dependencias...${NC}"
run_test "flutter pub get"

echo -e "${YELLOW}4. Ejecutando tests unitarios...${NC}"
run_test "flutter test"

echo ""
echo -e "${GREEN}======================================"
echo "✓ Todos los tests completados"
echo "=====================================${NC}"
