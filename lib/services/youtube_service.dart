import 'package:logger/logger.dart';
import '../models/video_model.dart';

class YouTubeService {
  final Logger _logger = Logger();

  YouTubeService();

  /// Valida si una URL es de YouTube
  bool isValidYouTubeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      return host.contains('youtube.com') ||
          host.contains('youtu.be') ||
          host.contains('youtube-nocookie.com');
    } catch (e) {
      return false;
    }
  }

  /// Obtiene información del video de YouTube
  /// Usa una aproximación simulada basada en la metadata disponible
  Future<Video> getVideoInfo(String url) async {
    try {
      _logger.i('Obteniendo información del video: $url');

      final videoId = extractVideoId(url);
      if (videoId.isEmpty) {
        throw Exception('URL de YouTube inválida');
      }

      // Simulamos la obtención de información del video
      // En una app real, usarías YouTube API o yt-dlp-web
      final video = Video(
        id: videoId,
        title: 'Video de YouTube',
        url: url,
        thumbnailUrl: 'https://img.youtube.com/vi/$videoId/0.jpg',
        duration: 600,
        uploader: 'Autor',
        uploadDate: DateTime.now(),
        viewCount: 0,
        availableFormats: _getMockFormats(),
      );

      _logger.i('Video obtenido: ${video.title}');
      return video;
    } catch (e) {
      _logger.e('Error obteniendo información del video', error: e);
      rethrow;
    }
  }

  /// Obtiene solo los formatos disponibles sin descargar metadata completa
  Future<List<Format>> getAvailableFormats(String url) async {
    try {
      final video = await getVideoInfo(url);
      return _filterRecommendedFormats(video.availableFormats);
    } catch (e) {
      _logger.e('Error obteniendo formatos', error: e);
      rethrow;
    }
  }

  /// Simula formatos disponibles para demostración
  List<Format> _getMockFormats() {
    return [
      Format(
        id: '18',
        formatName: 'MP4 360p',
        extension: 'mp4',
        resolution: '360p',
        filesize: 50000000,
        fps: '30',
        hasAudio: true,
        hasVideo: true,
      ),
      Format(
        id: '22',
        formatName: 'MP4 720p',
        extension: 'mp4',
        resolution: '720p',
        filesize: 150000000,
        fps: '30',
        hasAudio: true,
        hasVideo: true,
      ),
      Format(
        id: '137',
        formatName: 'MP4 1080p',
        extension: 'mp4',
        resolution: '1080p',
        filesize: 300000000,
        fps: '30',
        hasAudio: false,
        hasVideo: true,
      ),
      Format(
        id: '140',
        formatName: 'MP3 Audio',
        extension: 'mp3',
        resolution: 'audio',
        filesize: 8000000,
        fps: 'N/A',
        hasAudio: true,
        hasVideo: false,
      ),
      Format(
        id: '251',
        formatName: 'WEBM Audio',
        extension: 'webm',
        resolution: 'audio',
        filesize: 10000000,
        fps: 'N/A',
        hasAudio: true,
        hasVideo: false,
      ),
    ];
  }

  /// Filtra los formatos recomendados (similar a la app en Zig)
  /// Devuelve: Mejores MP4/MKV y opciones capped 1080p/720p/480p/360p + audio solo
  List<Format> _filterRecommendedFormats(List<Format> formats) {
    final recommended = <Format>[];
    final seen = <String>{};

    // 1. Mejor formato con video + audio
    final best = formats.where((f) => f.hasVideo && f.hasAudio).toList();
    if (best.isNotEmpty) {
      best.sort((a, b) => b.filesize.compareTo(a.filesize));
      if (best.first.filesize > 0) {
        recommended.add(best.first);
        seen.add('${best.first.resolution}-${best.first.extension}');
      }
    }

    // 2. Formatos capped por resolución
    for (final resolution in ['1080p', '720p', '480p', '360p']) {
      final filtered = formats
          .where(
            (f) =>
                f.hasVideo && f.hasAudio && f.resolution.contains(resolution),
          )
          .toList();

      if (filtered.isNotEmpty) {
        filtered.sort((a, b) => b.filesize.compareTo(a.filesize));
        final key = '$resolution-${filtered.first.extension}';
        if (!seen.contains(key)) {
          recommended.add(filtered.first);
          seen.add(key);
        }
      }
    }

    // 3. Audio solo
    final audioOnly = formats.where((f) => f.hasAudio && !f.hasVideo).toList();
    if (audioOnly.isNotEmpty) {
      audioOnly.sort((a, b) => b.filesize.compareTo(a.filesize));
      recommended.add(audioOnly.first);
    }

    return recommended;
  }

  /// Extrae el ID del video de una URL de YouTube
  String extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);

      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.last;
      } else if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'] ?? '';
      }

      return '';
    } catch (e) {
      _logger.e('Error extrayendo video ID', error: e);
      return '';
    }
  }
}
