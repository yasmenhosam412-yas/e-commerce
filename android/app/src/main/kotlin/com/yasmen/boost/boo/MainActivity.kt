package com.yasmen.boost.boo

import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yasmen.boost.boo/keyhash"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getKeyHash") {
                try {
                    val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
                    } else {
                        packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                    }

                    val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        packageInfo.signingInfo?.apkContentsSigners
                    } else {
                        packageInfo.signatures
                    }

                    if (signatures != null) {
                        // Take the first signature only
                        val signature = signatures[0]
                        val md = MessageDigest.getInstance("SHA")
                        md.update(signature.toByteArray())
                        val keyHash = Base64.encodeToString(md.digest(), Base64.NO_WRAP)
                        Log.d("KeyHash", keyHash)
                        result.success(keyHash)
                    } else {
                        result.error("ERROR", "No signatures found", null)
                    }

                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
