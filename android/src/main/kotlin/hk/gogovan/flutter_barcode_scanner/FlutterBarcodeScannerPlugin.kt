package hk.gogovan.flutter_barcode_scanner

import android.content.Context
import android.content.res.Configuration
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterBarcodeScannerPlugin */
class FlutterBarcodeScannerPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel

    private lateinit var keyboardConnectedChannel: EventChannel

    private lateinit var context: Context

    private lateinit var contentObserver : ContentObserver

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_barcode_scanner")
        channel.setMethodCallHandler(this)

        keyboardConnectedChannel = EventChannel(flutterPluginBinding.binaryMessenger, "hk.gogovan.flutter_barcode_scanner.keyboardConnected")
        keyboardConnectedChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "isKeyboardConnected") {
            result.success(context.resources.configuration.keyboard != Configuration.KEYBOARD_NOKEYS)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        contentObserver = KeyboardObserver(Handler(Looper.getMainLooper()), context, events)
        context.contentResolver.registerContentObserver(
            android.provider.Settings.System.CONTENT_URI,
            true,
            contentObserver
        );
    }

    override fun onCancel(arguments: Any?) {
        context.contentResolver.unregisterContentObserver(contentObserver)
    }

    private class KeyboardObserver(handler: Handler, val context: Context, val events: EventChannel.EventSink?): ContentObserver(handler) {
        override fun onChange(selfChange: Boolean) {
            super.onChange(selfChange)
            events?.success(context.resources.configuration.keyboard != Configuration.KEYBOARD_NOKEYS)
        }
    }
}
