import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/youtube_service.dart';
import 'services/download_service.dart';
import 'services/storage_service.dart';
import 'services/logging_service.dart';
import 'viewmodels/download_viewmodel.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar LoggingService
  final loggingService = LoggingService();
  await loggingService.initialize();

  // Inicializar StorageService
  final storageService = StorageService();
  await storageService.initialize();

  runApp(MyApp(
    loggingService: loggingService,
    storageService: storageService,
  ));
}

class MyApp extends StatelessWidget {
  final LoggingService loggingService;
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.loggingService,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoggingService>(create: (_) => loggingService),
        Provider<YouTubeService>(create: (_) => YouTubeService()),
        Provider<DownloadService>(create: (_) => DownloadService()),
        Provider<StorageService>(create: (_) => storageService),
        ChangeNotifierProvider(
          create: (context) => DownloadViewModel(
            youtubeService: context.read<YouTubeService>(),
            downloadService: context.read<DownloadService>(),
            storageService: context.read<StorageService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'YouTube Downloader',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
