import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/info_card.dart';
import '../widgets/banner_card.dart';
import 'format_selection_screen.dart';
import 'logs_view_screen.dart';
import 'download_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  late YouTubeService _youtubeService;

  @override
  void initState() {
    super.initState();
    _youtubeService = YouTubeService();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _handleDownload() {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa una URL de YouTube')),
      );
      return;
    }

    if (!_youtubeService.isValidYouTubeUrl(url)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL de YouTube inválida')));
      return;
    }

    _showLoadingAndFetchVideo(url);
  }

  void _showLoadingAndFetchVideo(String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(
        message: 'Obteniendo información del video...',
      ),
    );

    _youtubeService.getVideoInfo(url).then((video) {
      if (!mounted) return;
      Navigator.pop(context); // Cierra el loading dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormatSelectionScreen(video: video),
        ),
      ).then((_) {
        if (!mounted) return;
        _urlController.clear();
      });
    }).catchError((error) {
      if (!mounted) return;
      Navigator.pop(context); // Cierra el loading dialog

      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Error',
          message: 'No se pudo obtener la información del video: $error',
          onDismiss: () {},
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargador de YouTube'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DownloadScreen()),
              );
            },
            tooltip: 'Ver descargas',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LogsViewScreen()),
              );
            },
            tooltip: 'Ver logs',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner
              const BannerCard(),
              const SizedBox(height: 24),

              // URL Input
              const Text(
                'Pega la URL del video',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=...',
                  hintStyle: TextStyle(
                    color:
                        colorScheme.onSurface.withAlpha((0.35 * 255).round()),
                  ),
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _urlController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _urlController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // Download Button
              ElevatedButton.icon(
                onPressed: _handleDownload,
                icon: const Icon(Icons.download),
                label: const Text('Descargar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Info Cards
              const InfoCard(
                icon: Icons.video_library,
                title: 'Múltiples formatos',
                description: 'MP4, MKV, WebM y más',
              ),
              const SizedBox(height: 12),
              const InfoCard(
                icon: Icons.speed,
                title: 'Descarga rápida',
                description: 'Con seguimiento de progreso',
              ),
              const SizedBox(height: 12),
              const InfoCard(
                icon: Icons.storage,
                title: 'Almacenamiento inteligente',
                description: 'Guarda en tu dispositivo automáticamente',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
