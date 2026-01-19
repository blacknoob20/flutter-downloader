import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/video_model.dart';
import '../viewmodels/download_viewmodel.dart';
import '../widgets/format_selection_card.dart';
import '../widgets/video_info_card.dart';
import '../widgets/download_progress_button.dart';
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
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DownloadScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar formato'), elevation: 0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Info
            VideoInfoCard(video: widget.video),

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
              child: DownloadProgressButton(
                label: 'Descargar en ${_selectedFormat.displayName}',
                onPressed: _handleDownload,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
