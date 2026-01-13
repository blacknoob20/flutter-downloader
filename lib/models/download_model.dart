enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

class Download {
  final String id;
  final String videoTitle;
  final String videoUrl;
  final String selectedFormatId;
  final String selectedFormatName;
  final DateTime startedAt;
  late DownloadStatus status;
  late double progress; // 0.0 a 1.0
  late String? errorMessage;
  late DateTime? completedAt;
  late String? filePath;
  late int? downloadedBytes;
  late int? totalBytes;
  late double downloadSpeed; // bytes por segundo
  late int estimatedTimeRemaining; // segundos

  Download({
    required this.id,
    required this.videoTitle,
    required this.videoUrl,
    required this.selectedFormatId,
    required this.selectedFormatName,
    this.status = DownloadStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
    this.completedAt,
    this.filePath,
    this.downloadedBytes,
    this.totalBytes,
    this.downloadSpeed = 0,
    this.estimatedTimeRemaining = 0,
  }) : startedAt = DateTime.now();

  bool get isCompleted => status == DownloadStatus.completed;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isPaused => status == DownloadStatus.paused;

  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';

  String get timeElapsed {
    final now = DateTime.now();
    final elapsed = now.difference(startedAt);
    return _formatDuration(elapsed);
  }

  String? get timeRemaining {
    if (downloadedBytes == null || totalBytes == null || downloadedBytes == 0) {
      return null;
    }

    final bytesPerSecond =
        downloadedBytes! / startedAt.difference(DateTime.now()).inSeconds.abs();
    if (bytesPerSecond == 0) return null;

    final remaining = (totalBytes! - downloadedBytes!) / bytesPerSecond;
    return _formatDuration(Duration(seconds: remaining.toInt()));
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get downloadSpeedDisplay {
    if (downloadedBytes == null) return '--';
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    if (elapsed == 0) return '--';
    final speed = downloadedBytes! / elapsed;
    if (speed < 1024) return '${speed.toStringAsFixed(2)} B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(2)} KB/s';
    return '${(speed / (1024 * 1024)).toStringAsFixed(2)} MB/s';
  }

  String get totalSizeDisplay {
    if (totalBytes == null || totalBytes == 0) return 'Tamaño desconocido';
    if (totalBytes! < 1024 * 1024) {
      return '${(totalBytes! / 1024).toStringAsFixed(2)} KB';
    } else if (totalBytes! < 1024 * 1024 * 1024) {
      return '${(totalBytes! / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(totalBytes! / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  String get downloadedSizeDisplay {
    if (downloadedBytes == null || downloadedBytes == 0) return '0 B';
    if (downloadedBytes! < 1024 * 1024) {
      return '${(downloadedBytes! / 1024).toStringAsFixed(2)} KB';
    } else if (downloadedBytes! < 1024 * 1024 * 1024) {
      return '${(downloadedBytes! / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(downloadedBytes! / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      id: json['id'] as String,
      videoTitle: json['videoTitle'] as String,
      videoUrl: json['videoUrl'] as String,
      selectedFormatId: json['selectedFormatId'] as String,
      selectedFormatName: json['selectedFormatName'] as String,
      status: DownloadStatus.values[json['status'] as int? ?? 0],
      progress: json['progress'] as double? ?? 0.0,
      errorMessage: json['errorMessage'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      filePath: json['filePath'] as String?,
      downloadedBytes: json['downloadedBytes'] as int?,
      totalBytes: json['totalBytes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoTitle': videoTitle,
      'videoUrl': videoUrl,
      'selectedFormatId': selectedFormatId,
      'selectedFormatName': selectedFormatName,
      'status': status.index,
      'progress': progress,
      'errorMessage': errorMessage,
      'completedAt': completedAt?.toIso8601String(),
      'filePath': filePath,
      'downloadedBytes': downloadedBytes,
      'totalBytes': totalBytes,
    };
  }
}
