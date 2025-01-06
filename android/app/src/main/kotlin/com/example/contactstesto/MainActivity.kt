package com.contactio.app

import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.contactio.app/launcher"

    override fun configureFlutterEngine() {
        super.configureFlutterEngine()
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchUrl") {
                val url = call.argument<String>("url")
                Log.d("MainActivity", "Launching URL: $url")  // Debug log
                launchUrl(url)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchUrl(url: String?) {
        if (url != null) {
            try {
                val intent: Intent = when {
                    url.startsWith("tel:") -> Intent(Intent.ACTION_DIAL, Uri.parse(url))
                    url.startsWith("sms:") -> Intent(Intent.ACTION_SENDTO, Uri.parse(url))
                    url.startsWith("mailto:") -> Intent(Intent.ACTION_SENDTO, Uri.parse(url))
                    else -> Intent(Intent.ACTION_VIEW, Uri.parse(url))
                }
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

                // Ensure there is an activity to handle the intent
                val resolveInfo = packageManager.resolveActivity(intent, 0)
                if (resolveInfo != null) {
                    startActivity(intent)
                } else {
                    throw Exception("No app can handle this URL")
                }
            } catch (e: Exception) {
                e.printStackTrace()
                // Optionally show a toast or other fallback mechanism
            }
        }
    }
}
