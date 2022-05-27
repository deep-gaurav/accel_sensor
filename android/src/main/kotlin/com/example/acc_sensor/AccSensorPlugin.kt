package com.example.acc_sensor

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AccSensorPlugin */
class AccSensorPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var senseroImpl: SensorImpl
  private lateinit var accelerometerChannel: EventChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.acc_sensor/acc_sensor")
    val sensorsManager = flutterPluginBinding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    senseroImpl = SensorImpl(
            sensorsManager,
            Sensor.TYPE_ACCELEROMETER
    )

    accelerometerChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.example.acc_sensor/acc_messenger")
    accelerometerChannel.setStreamHandler( senseroImpl )
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    print(call.method)
    if (call.method == "enable") {
      senseroImpl.isEnabled = true
      result.success(null)
    } else if (call.method == "disable"){
      senseroImpl.isEnabled = false
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    senseroImpl.isEnabled = false
    channel.setMethodCallHandler(null)
  }
}
