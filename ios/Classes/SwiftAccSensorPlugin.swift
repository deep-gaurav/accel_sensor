import Flutter
import UIKit
import CoreMotion

public class SwiftAccSensorPlugin: NSObject, FlutterPlugin {
    
    private var streamHandler:SwiftStreamHandler;
    
    private init(sth:SwiftStreamHandler) {
        streamHandler = sth;
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.example.acc_sensor/acc_sensor", binaryMessenger: registrar.messenger())
      let handler = SwiftStreamHandler(mmanager:CMMotionManager.init());
      let evc = FlutterEventChannel(name: "com.example.acc_sensor/acc_messenger", binaryMessenger: registrar.messenger());
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
    public var motionManager:CMMotionManager;
    
    public init(mmanager:CMMotionManager) {
        motionManager = mmanager
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let GRAVITY = 9.8;
//        if #available(iOS 10.0, *) {
//            let timer = Timer(timeInterval: 0.4, repeats: true) { _ in
//                if (self.isEnabled){
//                    events([-1,-1,-1])
//                }else{
//                    
//                }
//             }
//            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
//        } else {
//            // Fallback on earlier versions
//        }
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
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
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}
