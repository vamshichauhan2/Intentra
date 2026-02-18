package com.example.frontend

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class MainActivity : FlutterActivity() {

    private val CHANNEL = "intentra/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "startTracking" -> {
                    startActivity(
                        Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    )
                    startForegroundService(
                        Intent(this, UsageMonitorService::class.java)
                    )
                    result.success(true)
                }

                // ✅ THIS WAS MISSING
                "getLogs" -> {
                    val prefs = getSharedPreferences("usage_queue", MODE_PRIVATE)
                    val logs = prefs.getString("logs", "[]")
                    result.success(logs)
                }

                else -> result.notImplemented()
            }
        }
    }
}
