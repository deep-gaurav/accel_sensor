import 'dart:async';

import 'package:flutter/services.dart';

class AccSensor {
  final MethodChannel _channel =
      const MethodChannel('com.example.acc_sensor/acc_sensor');
  final EventChannel _eventChannel =
      const EventChannel('com.example.acc_sensor/acc_messenger');
  Stream<AccelerometerEvent>? _accelerometerEvents;

  AccSensor() {
    _eventChannel.receiveBroadcastStream();
  }
  start() {
    _channel.invokeMethod('enable');
  }

  stop() {
    _channel.invokeMethod('disable');
  }

  /// A broadcast stream of events from the device accelerometer.
  Stream<AccelerometerEvent> get accelerometerEvents {
    try {
      start();
      _accelerometerEvents ??=
          _eventChannel.receiveBroadcastStream("start").map((dynamic event) {
        final list = event.cast<num>();
        return AccelerometerEvent(
            list[0]?.toDouble()!, list[1]?.toDouble()!, list[2]?.toDouble()!);
      });
      return _accelerometerEvents!;
    } catch (e) {
      throw e;
    }
  }
}

// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Discrete reading from an accelerometer. Accelerometers measure the velocity
/// of the device. Note that these readings include the effects of gravity. Put
/// simply, you can use accelerometer readings to tell if the device is moving in
/// a particular direction.
class AccelerometerEvent {
  /// Constructs an instance with the given [x], [y], and [z] values.
  AccelerometerEvent(this.x, this.y, this.z);

  /// Acceleration force along the x axis (including gravity) measured in m/s^2.
  ///
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving to the right and negative mean it is moving to the left.
  final double x;

  /// Acceleration force along the y axis (including gravity) measured in m/s^2.
  ///
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving towards the sky and negative mean it is moving towards
  /// the ground.
  final double y;

  /// Acceleration force along the z axis (including gravity) measured in m/s^2.
  ///
  /// This uses a right-handed coordinate system. So when the device is held
  /// upright and facing the user, positive values mean the device is moving
  /// towards the user and negative mean it is moving away from them.
  final double z;

  @override
  String toString() => '[AccelerometerEvent (x: $x, y: $y, z: $z)]';
}
