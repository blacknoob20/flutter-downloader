import 'package:flutter/material.dart';
import '../models/download_model.dart';
import '../services/youtube_service.dart';
import '../services/download_service.dart';
import '../services/storage_service.dart';

class DownloadViewModel extends ChangeNotifier {
  final DownloadService _downloadService;
  final StorageService _storageService;

  final List<Download> _downloads = [];
  late Download _currentDownload;
  bool _isLoading = false;
  String? _errorMessage;

  DownloadViewModel({
    required YouTubeService youtubeService,
    required DownloadService downloadService,
    required StorageService storageService,
  })  : _downloadService = downloadService,
        _storageService = storageService;

  // Getters
  List<Download> get downloads => _downloads;
  Download? get currentDownload =>
      _downloads.isNotEmpty ? _currentDownload : null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Inicialización
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final savedDownloads = await _storageService.getDownloads();
      _downloads.clear();
      _downloads.addAll(savedDownloads.values);
      _downloads.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    } catch (e) {
      _errorMessage = 'Error cargando descargas guardadas';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Descarga un video
  Future<void> downloadVideo({
    required String videoUrl,
    required String videoTitle,
    required String formatId,
    required String formatName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final download = await _downloadService.downloadVideo(
        videoUrl: videoUrl,
        videoTitle: videoTitle,
        formatId: formatId,
        formatName: formatName,
        onProgress: (download) {
          _updateDownload(download);
        },
        onComplete: (download) {
          _updateDownload(download);
          _storageService.saveDownload(download);
        },
        onError: (download, error) {
          _updateDownload(download);
          _storageService.saveDownload(download);
        },
      );

      _currentDownload = download;
      _downloads.insert(0, download);
      _storageService.saveDownload(download);
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pausa una descarga
  void pauseDownload(String downloadId) {
    _downloadService.pauseDownload(downloadId);
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _downloads[index].status = DownloadStatus.paused;
      _storageService.saveDownload(_downloads[index]);
      notifyListeners();
    }
  }

  // Reanuda una descarga
  Future<void> resumeDownload(String downloadId) async {
    await _downloadService.resumeDownload(downloadId);
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _downloads[index].status = DownloadStatus.downloading;
      _storageService.saveDownload(_downloads[index]);
      notifyListeners();
    }
  }

  // Cancela una descarga
  void cancelDownload(String downloadId) {
    _downloadService.cancelDownload(downloadId);
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _downloads[index].status = DownloadStatus.cancelled;
      _storageService.saveDownload(_downloads[index]);
      notifyListeners();
    }
  }

  // Elimina una descarga del historial
  Future<void> deleteDownload(String downloadId) async {
    _downloads.removeWhere((d) => d.id == downloadId);
    await _storageService.deleteDownload(downloadId);
    notifyListeners();
  }

  // Limpia el historial
  Future<void> clearHistory() async {
    _downloads.clear();
    await _storageService.clearAllDownloads();
    notifyListeners();
  }

  void _updateDownload(Download updatedDownload) {
    final index = _downloads.indexWhere((d) => d.id == updatedDownload.id);
    if (index != -1) {
      _downloads[index] = updatedDownload;
    }
    _currentDownload = updatedDownload;
    notifyListeners();
  }
}
