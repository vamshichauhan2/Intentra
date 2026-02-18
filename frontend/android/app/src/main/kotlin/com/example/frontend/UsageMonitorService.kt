package com.example.frontend

import android.app.*
import android.app.usage.*
import android.content.Context
import android.content.Intent
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

        Log.d("INTENTRA", "🚀 Service CREATED")

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

        Log.d("INTENTRA", "📡 Foreground service started")

        monitor()
    }

    /**
     * STEP 1
     * Background loop runs every 2 seconds
     */
    private fun monitor() {
        Log.d("INTENTRA", "🧠 Monitor loop started")

        Thread {
            while (true) {
                detect()
                Thread.sleep(2000)
            }
        }.start()
    }

    /**
     * STEP 2
     * Detect which app moved to foreground
     */
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

        // STEP 3: New app detected
        if (current != null && current != lastPkg && current != packageName) {
            lastPkg = current

            Log.d("INTENTRA", "📱 DETECTED APP → $current")

            val intentType = classify(current)

            Log.d(
                "INTENTRA",
                "🧠 CLASSIFIED → $current as $intentType"
            )

            saveLog(current, intentType, end)
        }
    }

    /**
     * STEP 4
     * Decide intent type
     */
    private fun classify(pkg: String): String =
        when (pkg) {
            "com.whatsapp",
            "com.instagram.android",
            "com.google.android.youtube" -> "DISTRACTION"

            "com.google.android.apps.docs",
            "com.microsoft.office.word" -> "FOCUS"

            else -> "NEUTRAL"
        }

    /**
     * STEP 5
     * Store locally for Flutter to sync later
     */
    private fun saveLog(pkg: String, intent: String, time: Long) {
        val isoTime = java.time.Instant
            .ofEpochMilli(time)
            .toString()

        val prefs = getSharedPreferences("usage_queue", MODE_PRIVATE)
        val arr = JSONArray(prefs.getString("logs", "[]"))

        val obj = JSONObject()
        obj.put("package", pkg)
        obj.put("intent", intent)
        obj.put("timestamp", isoTime)

        arr.put(obj)
        prefs.edit().putString("logs", arr.toString()).apply()

        Log.d(
            "INTENTRA",
            "💾 STORED LOCALLY → $pkg | $intent | $isoTime"
        )
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

    override fun onBind(intent: Intent?): IBinder? = null
}
