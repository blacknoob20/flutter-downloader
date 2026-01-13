import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  late File _logFile;
  late IOSink _logSink;
  bool _initialized = false;

  factory LoggingService() {
    return _instance;
  }

  LoggingService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');

      // Crear directorio de logs si no existe
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      // Crear archivo de log con timestamp
      final timestamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now());
      _logFile = File('${logsDir.path}/app_$timestamp.log');

      // Crear el archivo si no existe
      if (!await _logFile.exists()) {
        await _logFile.create(recursive: true);
      }

      _logSink = _logFile.openWrite(mode: FileMode.append);
      _initialized = true;

      // Imprimir información de inicialización de forma síncrona
      print('═══════════════════════════════════════════════════════════');
      print('✅ LOGGING SERVICE INITIALIZED');
      print('═══════════════════════════════════════════════════════════');
      print('📂 Log Directory: ${logsDir.path}');
      print('📄 Log File: ${_logFile.path}');
      print('⏰ Timestamp: ${DateTime.now()}');
      print('═══════════════════════════════════════════════════════════');

      log('=== Aplicación iniciada ===');
      log('Timestamp: ${DateTime.now()}');
      log('Directorio de logs: ${logsDir.path}');
    } catch (e) {
      print('❌ Error inicializando LoggingService: $e');
    }
  }

  // Métodos públicos para logging
  void logInfo(String message) => log(message);

  void logDebug(String message) => log('🔧 DEBUG: $message');

  void logSuccess(String message) => log('✅ SUCCESS: $message');

  void logWarning(String message) => log('⚠️  WARNING: $message');

  Future<void> log(String message) async {
    if (!_initialized) return;

    try {
      final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
      final formattedMessage = '[$timestamp] $message';

      // Escribir en el archivo
      _logSink.writeln(formattedMessage);

      // También mostrar en consola
      print(formattedMessage);
    } catch (e) {
      print('Error escribiendo log: $e');
    }
  }

  Future<void> logError(
      String title, dynamic error, StackTrace? stackTrace) async {
    if (!_initialized) return;

    try {
      final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
      final errorMessage = '''
[$timestamp] ❌ ERROR: $title
Error: $error
${stackTrace != null ? 'StackTrace:\n$stackTrace' : ''}
''';

      _logSink.writeln(errorMessage);
      print(errorMessage);
    } catch (e) {
      print('Error escribiendo log de error: $e');
    }
  }

  Future<String> getLogFilePath() async {
    if (!_initialized) {
      await initialize();
    }
    return _logFile.path;
  }

  Future<List<File>> getAllLogFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');

      if (!await logsDir.exists()) {
        return [];
      }

      final files = logsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.log'))
          .toList();

      files.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      return files;
    } catch (e) {
      print('Error obteniendo archivos de log: $e');
      return [];
    }
  }

  Future<String> getLatestLogContent() async {
    try {
      if (!_initialized) {
        await initialize();
      }
      return await _logFile.readAsString();
    } catch (e) {
      return 'Error leyendo log: $e';
    }
  }

  Future<void> flush() async {
    if (_initialized) {
      await _logSink.flush();
    }
  }

  Future<void> close() async {
    if (_initialized) {
      await _logSink.close();
      _initialized = false;
    }
  }

  void clearOldLogs({int daysToKeep = 7}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');

      if (!await logsDir.exists()) return;

      final files = logsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.log'))
          .toList();
      final now = DateTime.now();

      for (var file in files) {
        final stat = file.statSync();
        final age = now.difference(stat.modified).inDays;

        if (age > daysToKeep) {
          await file.delete();
          log('Log antiguo eliminado: ${file.path}');
        }
      }
    } catch (e) {
      print('Error limpiando logs antiguos: $e');
    }
  }
}
