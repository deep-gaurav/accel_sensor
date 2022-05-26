import Flutter
import UIKit
import CoreMotion

public class SwiftAccSensorPlugin: NSObject, FlutterPlugin {
    
    private var streamHandler:SwiftStreamHandler;
    
    private init(sth:SwiftStreamHandler) {
        streamHandler = sth;
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "acc_sensor", binaryMessenger: registrar.messenger())
      let handler = SwiftStreamHandler();
      let evc = FlutterEventChannel(name: "acc_messenger", binaryMessenger: registrar.messenger());
      evc.setStreamHandler(handler)
      let instance = SwiftAccSensorPlugin(sth:handler)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method == "enable"){
          streamHandler.isEnabled = true;
          result(nil)
      }else if(call.method == "disable"){
          streamHandler.isEnabled = false;
          result(nil)
      }
  }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        streamHandler.isEnabled = false
    }
}

class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    public var isEnabled = true;
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let manager = CMMotionManager.init()
        let GRAVITY = 9.8;

        manager.startAccelerometerUpdates(to: OperationQueue.init()) { (data, error) in
                if let myData = data{
                    if(self.isEnabled){
                        events(
                            [
                                -myData.acceleration.x * GRAVITY,
                                 -myData.acceleration.y * GRAVITY,
                                 -myData.acceleration.z * GRAVITY
                            ]
                        )
                    }
                }
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
