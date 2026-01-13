import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/models/video_model.dart';
import 'package:youtube_downloader/models/download_model.dart';

void main() {
  group('Video Model Tests', () {
    test('Video.fromJson debería crear un objeto Video válido', () {
      final json = {
        'id': 'test123',
        'title': 'Test Video',
        'url': 'https://youtube.com/watch?v=test123',
        'thumbnail': 'https://example.com/thumb.jpg',
        'duration': 300,
        'uploader': 'Test User',
        'upload_date': '2024-01-10',
        'view_count': 1000,
        'formats': [],
      };

      final video = Video.fromJson(json);

      expect(video.id, 'test123');
      expect(video.title, 'Test Video');
      expect(video.duration, 300);
      expect(video.uploader, 'Test User');
    });

    test('Format.displayName debería retornar el nombre correcto', () {
      final format = Format(
        id: '22',
        formatName: '720p mp4',
        extension: 'mp4',
        resolution: '720p',
        filesize: 1024 * 1024 * 50,
        fps: '30',
        hasAudio: true,
        hasVideo: true,
      );

      expect(format.displayName, '720p (mp4)');
    });

    test('Format.fileSizeDisplay debería formatear correctamente', () {
      final format1 = Format(
        id: '22',
        formatName: 'test',
        extension: 'mp4',
        resolution: '720p',
        filesize: 1024 * 1024,
        fps: '30',
        hasAudio: true,
        hasVideo: true,
      );

      expect(format1.fileSizeDisplay, contains('MB'));
    });
  });

  group('Download Model Tests', () {
    test('Download debería inicializarse con estado pending', () {
      final download = Download(
        id: 'dl123',
        videoTitle: 'Test',
        videoUrl: 'https://youtube.com/watch?v=test',
        selectedFormatId: '22',
        selectedFormatName: '720p',
      );

      expect(download.status, DownloadStatus.pending);
      expect(download.progress, 0.0);
      expect(download.isDownloading, false);
    });

    test('progressPercentage debería retornar el porcentaje correcto', () {
      final download = Download(
        id: 'dl123',
        videoTitle: 'Test',
        videoUrl: 'https://youtube.com/watch?v=test',
        selectedFormatId: '22',
        selectedFormatName: '720p',
      );

      download.progress = 0.5;
      expect(download.progressPercentage, '50.0%');
    });

    test('isCompleted debería retornar true cuando status es completed', () {
      final download = Download(
        id: 'dl123',
        videoTitle: 'Test',
        videoUrl: 'https://youtube.com/watch?v=test',
        selectedFormatId: '22',
        selectedFormatName: '720p',
        status: DownloadStatus.completed,
      );

      expect(download.isCompleted, true);
      expect(download.isFailed, false);
    });
  });
}
