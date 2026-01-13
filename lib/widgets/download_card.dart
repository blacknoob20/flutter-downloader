import 'package:flutter/material.dart';
import '../models/download_model.dart';

class DownloadCard extends StatefulWidget {
  final Download download;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onOpenFolder;

  const DownloadCard({
    super.key,
    required this.download,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.onDelete,
    required this.onOpenFolder,
  });

  @override
  State<DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<DownloadCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: widget.download.isDownloading ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.download.videoTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.download.selectedFormatName,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: widget.download.status),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.download.isDownloading) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.download.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.download.downloadedSizeDisplay} / ${widget.download.totalSizeDisplay}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Text(
                    '${(widget.download.progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Velocidad: ${widget.download.downloadSpeedDisplay}',
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.download.timeRemaining != null)
                    Flexible(
                      child: Text(
                        'Resta: ${widget.download.timeRemaining}',
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ] else if (widget.download.isCompleted) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green[200]!, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Completado',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            'Tamaño: ${widget.download.totalSizeDisplay}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.download.isFailed) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error en la descarga',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[700],
                            ),
                          ),
                          Text(
                            widget.download.errorMessage ?? 'Error desconocido',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.download.isPaused) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[200]!, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pause_circle_outline,
                        color: Colors.orange[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pausado: ${widget.download.progressPercentage}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.download.isDownloading) ...[
                  TextButton.icon(
                    onPressed: widget.onPause,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pausar'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                  ),
                ] else if (widget.download.isPaused) ...[
                  TextButton.icon(
                    onPressed: widget.onResume,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Reanudar'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                  ),
                ] else if (widget.download.isCompleted) ...[
                  TextButton.icon(
                    onPressed: widget.onOpenFolder,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Abrir'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                  ),
                ] else ...[
                  TextButton.icon(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DownloadStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color textColor;
    late String text;
    late IconData icon;

    switch (status) {
      case DownloadStatus.pending:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
        text = 'Pendiente';
        icon = Icons.schedule;
      case DownloadStatus.downloading:
        bgColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        text = 'Descargando';
        icon = Icons.downloading;
      case DownloadStatus.paused:
        bgColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        text = 'Pausado';
        icon = Icons.pause;
      case DownloadStatus.completed:
        bgColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        text = 'Completado';
        icon = Icons.check_circle;
      case DownloadStatus.failed:
        bgColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        text = 'Error';
        icon = Icons.error;
      case DownloadStatus.cancelled:
        bgColor = Colors.grey[300]!;
        textColor = Colors.grey[900]!;
        text = 'Cancelado';
        icon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
