package com.example.acc_sensor


import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

internal class SensorImpl(
        private val sensorManager: SensorManager,
        sensorType: Int
) : EventChannel.StreamHandler {
    private lateinit var sensorEventListener: SensorEventListener
    public var isEnabled = true

    private val sensor: Sensor by lazy {
        sensorManager.getDefaultSensor(sensorType)
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        sensorEventListener = createSensorEventListener(events)
        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorEventListener)
    }

    private fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size)
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                if (isEnabled){
                    events.success(sensorValues)
                }
            }
        }
    }
}
