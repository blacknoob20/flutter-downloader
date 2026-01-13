import 'package:flutter/material.dart';
import '../models/video_model.dart';

class VideoInfoCard extends StatelessWidget {
  final Video video;

  const VideoInfoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              video.thumbnailUrl,
              width: 80,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 60,
                  color: colorScheme.surface,
                  child: Icon(
                    Icons.video_library,
                    color: colorScheme.onSurface,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (textTheme.titleSmall ?? const TextStyle()).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  video.uploader,
                  style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
