import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/main.dart';

void main() {
  testWidgets('App debería mostrar la pantalla principal', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(storageService: MockStorageService()));

    // Verify que la app se construyó correctamente
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Descargador de YouTube'), findsOneWidget);
  });
}

// Mock para StorageService
class MockStorageService {
  Future<void> initialize() async {}
  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async =>
      defaultValue;
  Future<void> setSetting(String key, dynamic value) async {}
}
