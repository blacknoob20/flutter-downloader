# YouTube Downloader - Guía de Testing

## Tests Unitarios

### Correr todos los tests

```bash
flutter test
```

### Correr un test específico

```bash
flutter test test/services/youtube_service_test.dart
```

### Tests con cobertura

```bash
flutter test --coverage
```

## Tests de Integración

```bash
flutter drive --target=test_driver/app.dart
```

## Pruebas Manuales

### Casos de prueba básicos

1. **Validación de URL**
   - URL válida: `https://www.youtube.com/watch?v=...`
   - URL inválida: texto aleatorio
   - Esperar feedback visual

2. **Selección de formato**
   - Verificar que aparezcan al menos 3 formatos recomendados
   - Seleccionar diferentes formatos
   - Botón de descarga debe estar habilitado

3. **Descarga**
   - Iniciar descarga
   - Verificar que aparezca barra de progreso
   - Esperar a que se complete
   - Verificar que el archivo se guardó

4. **Historial**
   - Descargar múltiples videos
   - Verificar que aparezcan en historial
   - Pausar/reanudar descargas
   - Eliminar del historial

## Performance

Monitoreo de performance:

```bash
flutter run --profile

# En otra terminal
dart devtools
```

Temas a verificar:
- Tiempo de inicio (< 2s)
- FPS durante descarga (> 50 FPS)
- Uso de memoria (< 200 MB)

## Debugging

### Habilitar debug logs

```dart
// En main.dart
Logger.level = Level.debug;
```

### Usar el debugger

```bash
flutter run
# Presiona 'd' para abrir DevTools
```

## Checklist de testing antes de release

- [ ] Tests unitarios: 100% de paso
- [ ] Tests de integración: 100% de paso
- [ ] Sin errores de lint: `flutter analyze`
- [ ] App se construye sin warnings
- [ ] Formato de código: `dart format lib/ test/`
- [ ] URLs de YouTube válidas funcionan
- [ ] Selección de formatos funciona
- [ ] Descargas se completan correctamente
- [ ] Historial persiste después de reiniciar
- [ ] Tema oscuro/claro funciona
- [ ] Performance es aceptable
