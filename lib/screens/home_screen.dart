import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import '../widgets/dialogs.dart';
import 'format_selection_screen.dart';
import 'logs_view_screen.dart';

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
      Navigator.pop(context); // Cierra el loading dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormatSelectionScreen(video: video),
        ),
      ).then((_) {
        _urlController.clear();
      });
    }).catchError((error) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargador de YouTube'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LogsViewScreen()),
              );
            },
            tooltip: 'Ver logs',
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.play_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Descarga tus videos favoritos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ligero, rápido y fácil de usar',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
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
              _buildInfoCard(
                icon: Icons.video_library,
                title: 'Múltiples formatos',
                description: 'MP4, MKV, WebM y más',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.speed,
                title: 'Descarga rápida',
                description: 'Con seguimiento de progreso',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
