class Video {
  final String id;
  final String title;
  final String url;
  final String thumbnailUrl;
  final int duration; // en segundos
  final String uploader;
  final DateTime uploadDate;
  final int viewCount;
  final List<Format> availableFormats;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    required this.uploader,
    required this.uploadDate,
    required this.viewCount,
    required this.availableFormats,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Sin título',
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnail'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      uploader: json['uploader'] as String? ?? 'Desconocido',
      uploadDate: DateTime.parse(
          json['upload_date'] as String? ?? DateTime.now().toIso8601String()),
      viewCount: json['view_count'] as int? ?? 0,
      availableFormats: (json['formats'] as List<dynamic>?)
              ?.map((f) => Format.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnail': thumbnailUrl,
      'duration': duration,
      'uploader': uploader,
      'upload_date': uploadDate.toIso8601String(),
      'view_count': viewCount,
      'formats': availableFormats.map((f) => f.toJson()).toList(),
    };
  }
}

class Format {
  final String id;
  final String formatName;
  final String extension;
  final String resolution; // ej: "1080p", "720p", "audio only"
  final int filesize; // en bytes
  final String fps; // frames per second
  final bool hasAudio;
  final bool hasVideo;
  final String? downloadUrl; // URL directa para descargar

  Format({
    required this.id,
    required this.formatName,
    required this.extension,
    required this.resolution,
    required this.filesize,
    required this.fps,
    required this.hasAudio,
    required this.hasVideo,
    this.downloadUrl,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      id: json['format_id'] as String? ?? '',
      formatName: json['format'] as String? ?? 'Formato desconocido',
      extension: json['ext'] as String? ?? 'unknown',
      resolution: json['resolution'] as String? ?? 'N/A',
      filesize: json['filesize'] as int? ?? 0,
      fps: (json['fps'] as num?)?.toString() ?? 'N/A',
      hasAudio: (json['acodec'] as String? ?? '') != 'none',
      hasVideo: (json['vcodec'] as String? ?? '') != 'none',
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'format_id': id,
      'format': formatName,
      'ext': extension,
      'resolution': resolution,
      'filesize': filesize,
      'fps': fps,
      'acodec': hasAudio ? 'aac' : 'none',
      'vcodec': hasVideo ? 'h264' : 'none',
      'download_url': downloadUrl,
    };
  }

  String get displayName {
    if (hasVideo && hasAudio) {
      return '$resolution ($extension)';
    } else if (hasAudio) {
      return 'Audio solo ($extension)';
    }
    return '$resolution ($extension)';
  }

  String get fileSizeDisplay {
    if (filesize == 0) return 'Tamaño desconocido';
    if (filesize < 1024 * 1024) {
      return '${(filesize / 1024).toStringAsFixed(2)} KB';
    } else if (filesize < 1024 * 1024 * 1024) {
      return '${(filesize / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(filesize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}
