import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../viewmodels/download_viewmodel.dart';
import '../widgets/dialogs.dart';
import '../widgets/download_card.dart';
import 'home_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar el historial de descargas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Descargas'),
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: 'Limpiar historial',
                      message:
                          '¿Deseas eliminar todo el historial de descargas?',
                      confirmText: 'Eliminar',
                      onConfirm: () {
                        context.read<DownloadViewModel>().clearHistory();
                      },
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 8),
                      Text('Limpiar historial'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Consumer<DownloadViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.downloads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_done,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sin descargas',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza descargando un video',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva descarga'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: viewModel.downloads.length,
              itemBuilder: (context, index) {
                final download = viewModel.downloads[index];
                return DownloadCard(
                  download: download,
                  onPause: () {
                    viewModel.pauseDownload(download.id);
                  },
                  onResume: () {
                    viewModel.resumeDownload(download.id);
                  },
                  onCancel: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'Cancelar descarga',
                        message: '¿Deseas cancelar esta descarga?',
                        confirmText: 'Cancelar',
                        onConfirm: () {
                          viewModel.cancelDownload(download.id);
                        },
                      ),
                    );
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'Eliminar del historial',
                        message:
                            '¿Deseas eliminar esta descarga del historial?',
                        confirmText: 'Eliminar',
                        onConfirm: () {
                          viewModel.deleteDownload(download.id);
                        },
                      ),
                    );
                  },
                  onOpenFolder: () async {
                    if (download.filePath != null &&
                        download.filePath!.isNotEmpty) {
                      try {
                        final file = File(download.filePath!);
                        final dir = file.parent;

                        if (Platform.isAndroid) {
                          // En Android, usamos un intent nativo
                          const platform = MethodChannel(
                              'com.example.youtube_downloader/downloads');
                          await platform
                              .invokeMethod('openFolder', {'path': dir.path});
                        } else if (Platform.isIOS) {
                          // En iOS, mostramos un diálogo indicando la ubicación
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Archivo guardado en: ${dir.path}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al abrir: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva descarga'),
        ),
      ),
    );
  }
}
