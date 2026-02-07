package com.example.frontend

import android.app.*
import android.app.usage.*
import android.content.Context
import android.content.Intent   // ✅ THIS WAS MISSING
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject

class UsageMonitorService : Service() {

    private lateinit var usm: UsageStatsManager
    private var lastPkg: String? = null

    override fun onCreate() {
        super.onCreate()

        usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        createNotificationChannel()

        val notification = NotificationCompat.Builder(this, "intentra")
            .setContentTitle("Intentra Active")
            .setContentText("Tracking app usage")
            .setSmallIcon(android.R.drawable.ic_menu_info_details)
            .setOngoing(true)
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                1,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            )
        } else {
            startForeground(1, notification)
        }

        monitor()
    }

    private fun monitor() {
        Thread {
            while (true) {
                detect()
                Thread.sleep(2000)
            }
        }.start()
    }

    private fun detect() {
        val end = System.currentTimeMillis()
        val start = end - 5000

        val events = usm.queryEvents(start, end)
        val event = UsageEvents.Event()
        var current: String? = null

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                current = event.packageName
            }
        }

        if (current != null && current != lastPkg && current != packageName) {
            lastPkg = current
            val intentType = classify(current)
            saveLog(current, intentType, end)

            Log.d("INTENTRA", "$current | $intentType | $end")
        }
    }

    private fun classify(pkg: String): String =
        when (pkg) {
            "com.whatsapp",
            "com.instagram.android",
            "com.google.android.youtube" -> "DISTRACTION"

            "com.google.android.apps.docs",
            "com.microsoft.office.word" -> "FOCUS"

            else -> "NEUTRAL"
        }

    private fun saveLog(pkg: String, intent: String, time: Long) {
        val prefs = getSharedPreferences("intentra_logs", MODE_PRIVATE)
        val arr = JSONArray(prefs.getString("logs", "[]"))

        val obj = JSONObject()
        obj.put("package", pkg)
        obj.put("intent", intent)
        obj.put("timestamp", time)

        arr.put(obj)
        prefs.edit().putString("logs", arr.toString()).apply()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "intentra",
                "Intentra Tracking",
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    // ✅ REQUIRED for Service
    override fun onBind(intent: Intent?): IBinder? = null
}
