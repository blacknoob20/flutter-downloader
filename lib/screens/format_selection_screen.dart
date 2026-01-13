import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/video_model.dart';
import '../viewmodels/download_viewmodel.dart';
import '../widgets/format_selection_card.dart';
import 'download_screen.dart';

class FormatSelectionScreen extends StatefulWidget {
  final Video video;

  const FormatSelectionScreen({super.key, required this.video});

  @override
  State<FormatSelectionScreen> createState() => _FormatSelectionScreenState();
}

class _FormatSelectionScreenState extends State<FormatSelectionScreen> {
  late Format _selectedFormat;

  @override
  void initState() {
    super.initState();
    // Selecciona el primer formato (mejor opción) por defecto
    _selectedFormat = widget.video.availableFormats.isNotEmpty
        ? widget.video.availableFormats.first
        : Format(
            id: '',
            formatName: '',
            extension: '',
            resolution: '',
            filesize: 0,
            fps: '0',
            hasAudio: false,
            hasVideo: false,
          );
  }

  void _handleDownload() {
    if (_selectedFormat.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un formato')),
      );
      return;
    }

    final viewModel = context.read<DownloadViewModel>();
    viewModel
        .downloadVideo(
      videoUrl: widget.video.url,
      videoTitle: widget.video.title,
      formatId: _selectedFormat.id,
      formatName: _selectedFormat.displayName,
      directUrl: _selectedFormat.downloadUrl,
      extension: _selectedFormat.extension,
    )
        .then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DownloadScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar formato'), elevation: 0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Info
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.video.thumbnailUrl,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.video_library),
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
                          widget.video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.video.uploader,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formats List
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formatos recomendados (${widget.video.availableFormats.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.video.availableFormats.length,
                itemBuilder: (context, index) {
                  final format = widget.video.availableFormats[index];
                  return FormatSelectionCard(
                    format: format,
                    isSelected: _selectedFormat.id == format.id,
                    onTap: () {
                      setState(() {
                        _selectedFormat = format;
                      });
                    },
                  );
                },
              ),
            ),

            // Download Button
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleDownload,
                  icon: const Icon(Icons.download),
                  label: Text('Descargar en ${_selectedFormat.displayName}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
