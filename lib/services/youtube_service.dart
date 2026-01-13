import 'package:logger/logger.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import '../models/video_model.dart';

class YouTubeService {
  final Logger _logger = Logger();
  final yt.YoutubeExplode _ytClient = yt.YoutubeExplode();

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

  /// Obtiene información del video de YouTube usando youtube_explode_dart
  Future<Video> getVideoInfo(String url) async {
    try {
      _logger.i('Obteniendo información del video: $url');

      final videoId = extractVideoId(url);
      if (videoId.isEmpty) {
        throw Exception('URL de YouTube inválida');
      }

      // Obtener información real del video usando youtube_explode_dart
      final ytVideo = await _ytClient.videos.get(videoId);
      final manifest =
          await _ytClient.videos.streamsClient.getManifest(videoId);

      // Obtener formatos disponibles
      final formats = _extractFormats(manifest);

      final video = Video(
        id: videoId,
        title: ytVideo.title,
        url: url,
        thumbnailUrl: ytVideo.thumbnails.mediumResUrl,
        duration: ytVideo.duration?.inSeconds ?? 0,
        uploader: ytVideo.author,
        uploadDate: ytVideo.uploadDate ?? DateTime.now(),
        viewCount: ytVideo.engagement.viewCount,
        availableFormats: formats,
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

  /// Extrae formatos de los streams de YouTube
  List<Format> _extractFormats(yt.StreamManifest manifest) {
    final formats = <Format>[];

    // Formatos muxed (video + audio)
    for (final stream in manifest.muxed) {
      formats.add(Format(
        id: stream.tag.toString(),
        formatName: '${stream.videoCodec.toUpperCase()} ${stream.qualityLabel}',
        extension: stream.container.name,
        resolution: stream.qualityLabel,
        filesize: stream.size.totalBytes,
        fps: '${stream.framerate.framesPerSecond}',
        hasAudio: true,
        hasVideo: true,
        downloadUrl: stream.url.toString(),
      ));
    }

    // Formatos solo video
    for (final stream in manifest.videoOnly) {
      formats.add(Format(
        id: stream.tag.toString(),
        formatName:
            '${stream.videoCodec.toUpperCase()} ${stream.videoQualityLabel} (video only)',
        extension: stream.container.name,
        resolution: stream.videoQualityLabel,
        filesize: stream.size.totalBytes,
        fps: '${stream.framerate.framesPerSecond}',
        hasAudio: false,
        hasVideo: true,
        downloadUrl: stream.url.toString(),
      ));
    }

    // Formatos solo audio
    for (final stream in manifest.audioOnly) {
      formats.add(Format(
        id: stream.tag.toString(),
        formatName:
            'Audio Solo ${stream.audioCodec.toUpperCase()} ${stream.bitrate}',
        extension: stream.container.name,
        resolution: 'audio',
        filesize: stream.size.totalBytes,
        fps: 'N/A',
        hasAudio: true,
        hasVideo: false,
        downloadUrl: stream.url.toString(),
      ));
    }

    return formats;
  }

  /// Filtra los formatos recomendados
  /// Devuelve SOLO formatos con video + audio, más una opción de solo audio
  List<Format> _filterRecommendedFormats(List<Format> formats) {
    final recommended = <Format>[];
    final seen = <String>{};

    // 1. SOLO formatos muxed (video + audio juntos)
    final muxedFormats =
        formats.where((f) => f.hasVideo && f.hasAudio).toList();

    if (muxedFormats.isEmpty) {
      // Si no hay formatos muxed, devolver todos los que tengan video + audio
      return muxedFormats;
    }

    // Agrupar por resolución
    final resolutions = ['1080p', '720p', '480p', '360p', '240p'];

    for (final resolution in resolutions) {
      final filtered =
          muxedFormats.where((f) => f.resolution.contains(resolution)).toList();

      if (filtered.isNotEmpty) {
        // Ordenar por tamaño descendente y tomar el mejor
        filtered.sort((a, b) => b.filesize.compareTo(a.filesize));
        final best = filtered.first;

        final key = '$resolution-${best.extension}';
        if (!seen.contains(key)) {
          recommended.add(best);
          seen.add(key);
        }
      }
    }

    // 2. Agregar opción de SOLO AUDIO (mejor stream de audio disponible)
    final audioOnly = formats.where((f) => f.hasAudio && !f.hasVideo).toList();
    if (audioOnly.isNotEmpty) {
      audioOnly.sort((a, b) => b.filesize.compareTo(a.filesize));
      final bestAudio = audioOnly.first;
      recommended.add(bestAudio);
    }

    return recommended.isEmpty ? muxedFormats : recommended;
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
