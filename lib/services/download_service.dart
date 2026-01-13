import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/download_model.dart';

enum ContentType {
  video,
  audio,
}

class DownloadService {
  final Logger _logger = Logger();
  final Dio _dio;
  final Map<String, CancelToken> _cancelTokens = {};

  DownloadService({Dio? dio}) : _dio = dio ?? Dio();

  /// Descarga un video usando la URL directa del stream
  Future<Download> downloadVideo({
    required String videoUrl,
    required String videoTitle,
    required String formatId,
    required String formatName,
    required String? directUrl,
    required String extension,
    required Function(Download) onProgress,
    required Function(Download) onComplete,
    required Function(Download, String) onError,
  }) async {
    final downloadId = const Uuid().v4();
    final download = Download(
      id: downloadId,
      videoTitle: videoTitle,
      videoUrl: videoUrl,
      selectedFormatId: formatId,
      selectedFormatName: formatName,
    );

    try {
      _logger.i('Iniciando descarga: $videoTitle (Formato: $formatName)');

      if (directUrl == null || directUrl.isEmpty) {
        throw Exception('URL de descarga no disponible');
      }

      // Determinar tipo de contenido
      final contentType = _getContentType(formatId);
      final outputDir = await _getOutputDirectory(contentType);

      download.status = DownloadStatus.downloading;
      final cancelToken = CancelToken();
      _cancelTokens[downloadId] = cancelToken;

      // Descargar directamente usando Dio
      final fileName =
          '${videoTitle.replaceAll(RegExp(r'[^a-zA-Z0-9_\-\s]'), '_')}.$extension';
      final filePath = '$outputDir/$fileName';

      _logger.i('Descargando desde: $directUrl');
      _logger.i('Guardando en: $filePath');

      await _dio.download(
        directUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            download.progress = progress;
            download.downloadedBytes = received;
            download.totalBytes = total;
            download.downloadSpeed =
                _calculateSpeed(received, download.startedAt);
            download.estimatedTimeRemaining =
                _calculateETA(received, total, download.downloadSpeed);
            onProgress(download);
          }
        },
      );

      final file = File(filePath);
      final fileSize = await file.length();

      download.status = DownloadStatus.completed;
      download.progress = 1.0;
      download.completedAt = DateTime.now();
      download.filePath = filePath;
      download.downloadedBytes = fileSize;
      download.totalBytes = fileSize;

      _logger.i('✅ Descarga completada: $videoTitle');
      _logger.i('📁 Ubicación: $filePath');
      _logger.i('📦 Tamaño: ${_formatBytes(fileSize)}');
      onComplete(download);

      return download;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _logger.i('Descarga cancelada: $videoTitle');
        download.status = DownloadStatus.cancelled;
      } else {
        _logger.e('❌ Error en la descarga', error: e);
        download.status = DownloadStatus.failed;
        download.errorMessage = e.message ?? e.toString();
        onError(download, e.message ?? e.toString());
      }
      return download;
    } catch (e) {
      _logger.e('❌ Error en la descarga', error: e);
      download.status = DownloadStatus.failed;
      download.errorMessage = e.toString();
      onError(download, e.toString());
      return download;
    } finally {
      _cancelTokens.remove(downloadId);
    }
  }

  /// Calcula la velocidad de descarga en bytes por segundo
  double _calculateSpeed(int downloaded, DateTime startTime) {
    final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
    if (elapsedSeconds == 0) return 0;
    return downloaded / elapsedSeconds;
  }

  /// Calcula el tiempo estimado restante en segundos
  int _calculateETA(int downloaded, int total, double speed) {
    if (speed == 0) return 0;
    final remaining = total - downloaded;
    return (remaining / speed).ceil();
  }

  /// Formatea bytes a formato legible
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Determina el tipo de contenido basado en el formato
  ContentType _getContentType(String formatId) {
    // Formatos de audio
    const audioFormats = ['140', '251', '250', '249', '139', '255'];
    if (audioFormats.contains(formatId)) {
      return ContentType.audio;
    }
    // El resto son videos
    return ContentType.video;
  }

  /// Obtiene el directorio de salida según el tipo de contenido
  Future<String> _getOutputDirectory(ContentType contentType) async {
    try {
      // Ruta pública del almacenamiento externo en Android
      final baseDir = contentType == ContentType.video
          ? Directory('/storage/emulated/0/Movies/YouTube Downloader')
          : Directory('/storage/emulated/0/Music/YouTube Downloader');

      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }

      _logger.i('Directorio de salida: ${baseDir.path}');
      return baseDir.path;
    } catch (e) {
      _logger.w(
          'Error obteniendo directorio de almacenamiento externo: $e. Usando fallback...');
      return await _getApplicationDownloadsDirectory();
    }
  }

  /// Directorio alternativo en caso de error
  Future<String> _getApplicationDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/YouTube Downloader');

    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    return downloadsDir.path;
  }

  /// Pausa una descarga
  void pauseDownload(String downloadId) {
    _logger.i('Pausando descarga: $downloadId');
    _cancelTokens[downloadId]?.cancel('Descarga pausada por el usuario');
  }

  /// Reanuda una descarga
  Future<void> resumeDownload(String downloadId) async {
    _logger.i('Reanudando descarga: $downloadId');
    _cancelTokens[downloadId] = CancelToken();
  }

  /// Cancela una descarga
  void cancelDownload(String downloadId) {
    _logger.i('Cancelando descarga: $downloadId');
    _cancelTokens[downloadId]?.cancel('Descarga cancelada por el usuario');
    _cancelTokens.remove(downloadId);
  }

  /// Obtiene el directorio de descargas de la aplicación (deprecated, usar _getOutputDirectory)
  Future<String> _getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/YouTube Downloader');

    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    return downloadsDir.path;
  }

  /// Obtiene el tamaño total descargado
  Future<int> getTotalDownloadedSize() async {
    try {
      final directory = await _getDownloadsDirectory();
      final dir = Directory(directory);

      if (!await dir.exists()) return 0;

      int totalSize = 0;
      final files = await dir.list().toList();

      for (final file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      _logger.e('Error calculando tamaño total', error: e);
      return 0;
    }
  }

  /// Elimina un archivo descargado
  Future<bool> deleteDownloadedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        _logger.i('Archivo eliminado: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Error eliminando archivo', error: e);
      return false;
    }
  }
}
