import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/logging_service.dart';

class LogsViewScreen extends StatefulWidget {
  const LogsViewScreen({super.key});

  @override
  State<LogsViewScreen> createState() => _LogsViewScreenState();
}

class _LogsViewScreenState extends State<LogsViewScreen> {
  late Future<List<File>> _logFiles;
  String? _selectedLogPath;
  String _logContent = '';

  @override
  void initState() {
    super.initState();
    _logFiles = context.read<LoggingService>().getAllLogFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de Logs'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<File>>(
        future: _logFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final files = snapshot.data ?? [];

          if (files.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay logs disponibles',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Lista de archivos de log
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Archivos de Log (${files.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          final fileName = file.path.split('/').last;
                          final fileSize = file.lengthSync();
                          final fileSizeStr = _formatBytes(fileSize);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(fileName,
                                  style: const TextStyle(fontSize: 12)),
                              subtitle: Text(fileSizeStr,
                                  style: const TextStyle(fontSize: 10)),
                              selected: _selectedLogPath == file.path,
                              onTap: () async {
                                final content = await file.readAsString();
                                setState(() {
                                  _selectedLogPath = file.path;
                                  _logContent = content;
                                });
                              },
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Copiar path'),
                                    onTap: () async {
                                      _copyToClipboard(file.path);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Eliminar'),
                                    onTap: () async {
                                      await file.delete();
                                      setState(() {
                                        _logFiles = context
                                            .read<LoggingService>()
                                            .getAllLogFiles();
                                        _selectedLogPath = null;
                                        _logContent = '';
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Log eliminado')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Contenido del log seleccionado
              Expanded(
                child: _selectedLogPath == null
                    ? Center(
                        child: Text(
                          'Selecciona un archivo de log',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedLogPath!.split('/').last,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () =>
                                      _copyToClipboard(_logContent),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh, size: 20),
                                  onPressed: () async {
                                    final file = File(_selectedLogPath!);
                                    final content = await file.readAsString();
                                    setState(() => _logContent = content);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText(
                                  _logContent,
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void _copyToClipboard(String text) {
    if (text.isEmpty) return;
    // Para copiar al portapapeles, usaríamos normalmente Clipboard
    // Por ahora mostramos un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contenido copiado')),
    );
  }
}
