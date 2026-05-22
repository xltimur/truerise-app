package com.rectify.rectify

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "rectify/share")
      .setMethodCallHandler { call, result ->
        if (call.method == "share") {
          val text = call.arguments as? String ?: ""
          val sendIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
          }
          startActivity(Intent.createChooser(sendIntent, null))
          result.success(null)
        } else {
          result.notImplemented()
        }
      }
  }
}
