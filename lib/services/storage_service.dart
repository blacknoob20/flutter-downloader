import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../models/download_model.dart';

class StorageService {
  static const String _downloadsKey = 'downloads_list';
  static const String _settingsPrefix = 'settings_';
  final Logger _logger = Logger();
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _logger.i('StorageService inicializado');
  }

  /// Guarda un historial de descarga
  Future<void> saveDownload(Download download) async {
    try {
      final downloads = await getDownloads();
      downloads[download.id] = download;

      final jsonList = downloads.entries.map((e) => e.value.toJson()).toList();

      await _prefs.setString(_downloadsKey, _jsonEncode(jsonList));
      _logger.i('Descarga guardada: ${download.id}');
    } catch (e) {
      _logger.e('Error guardando descarga', error: e);
    }
  }

  /// Obtiene todas las descargas guardadas
  Future<Map<String, Download>> getDownloads() async {
    try {
      final jsonString = _prefs.getString(_downloadsKey);
      if (jsonString == null) return {};

      final jsonList = _jsonDecode(jsonString) as List<dynamic>;
      final downloads = <String, Download>{};

      for (final json in jsonList) {
        final download = Download.fromJson(json as Map<String, dynamic>);
        downloads[download.id] = download;
      }

      return downloads;
    } catch (e) {
      _logger.e('Error cargando descargas', error: e);
      return {};
    }
  }

  /// Obtiene una descarga específica
  Future<Download?> getDownload(String id) async {
    final downloads = await getDownloads();
    return downloads[id];
  }

  /// Elimina una descarga del historial
  Future<void> deleteDownload(String id) async {
    try {
      final downloads = await getDownloads();
      downloads.remove(id);

      final jsonList = downloads.values.map((d) => d.toJson()).toList();

      if (jsonList.isEmpty) {
        await _prefs.remove(_downloadsKey);
      } else {
        await _prefs.setString(_downloadsKey, _jsonEncode(jsonList));
      }

      _logger.i('Descarga eliminada: $id');
    } catch (e) {
      _logger.e('Error eliminando descarga', error: e);
    }
  }

  /// Borra todo el historial
  Future<void> clearAllDownloads() async {
    try {
      await _prefs.remove(_downloadsKey);
      _logger.i('Historial de descargas borrado');
    } catch (e) {
      _logger.e('Error borrando historial', error: e);
    }
  }

  /// Obtiene un ajuste de configuración
  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async {
    return _prefs.get('$_settingsPrefix$key') ?? defaultValue;
  }

  /// Guarda un ajuste de configuración
  Future<void> setSetting(String key, dynamic value) async {
    try {
      if (value is String) {
        await _prefs.setString('$_settingsPrefix$key', value);
      } else if (value is int) {
        await _prefs.setInt('$_settingsPrefix$key', value);
      } else if (value is bool) {
        await _prefs.setBool('$_settingsPrefix$key', value);
      } else if (value is double) {
        await _prefs.setDouble('$_settingsPrefix$key', value);
      }
      _logger.i('Ajuste guardado: $key = $value');
    } catch (e) {
      _logger.e('Error guardando ajuste', error: e);
    }
  }

  // Helpers para JSON
  String _jsonEncode(List<dynamic> data) {
    return jsonEncode(data);
  }

  dynamic _jsonDecode(String data) {
    return jsonDecode(data);
  }
}
