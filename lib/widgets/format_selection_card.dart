import 'package:flutter/material.dart';
import '../models/video_model.dart';

class FormatSelectionCard extends StatelessWidget {
  final Format format;
  final bool isSelected;
  final VoidCallback onTap;

  const FormatSelectionCard({
    super.key,
    required this.format,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                activeColor: colorScheme.primary,
                onChanged: (_) => onTap(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (format.hasVideo)
                          Chip(
                            label: const Text('Video'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                                color: colorScheme.onPrimaryContainer),
                          ),
                        if (format.hasVideo && format.hasAudio)
                          const SizedBox(width: 8),
                        if (format.hasAudio)
                          Chip(
                            label: const Text('Audio'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: colorScheme.secondaryContainer,
                            labelStyle: TextStyle(
                                color: colorScheme.onSecondaryContainer),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      format.displayName,
                      style:
                          (textTheme.titleMedium ?? const TextStyle()).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tamaño: ${format.fileSizeDisplay}',
                          style: (textTheme.bodySmall ?? const TextStyle())
                              .copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'FPS: ${format.fps}',
                          style: (textTheme.bodySmall ?? const TextStyle())
                              .copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
