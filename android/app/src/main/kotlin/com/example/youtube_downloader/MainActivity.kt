package com.example.youtube_downloader

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.youtube_downloader/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openFolder" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        openFolder(path)
                        result.success(true)
                    } else {
                        result.error("INVALID_PATH", "Path is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openFolder(path: String) {
        val file = File(path)
        val uri = Uri.fromFile(file)
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "resource/folder")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }

        // Si el intent anterior no funciona, intentar con el explorador de archivos
        try {
            startActivity(intent)
        } catch (e: Exception) {
            // Alternativa: usar el gestor de archivos del sistema
            val alternativeIntent = Intent(Intent.ACTION_GET_CONTENT).apply {
                type = "*/*"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            try {
                startActivity(alternativeIntent)
            } catch (e2: Exception) {
                e2.printStackTrace()
            }
        }
    }
}
