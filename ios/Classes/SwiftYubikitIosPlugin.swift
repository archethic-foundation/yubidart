import Flutter
import UIKit
import YubiKit


public class SwiftYubikitIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "net.archethic/yubidart", binaryMessenger: registrar.messenger())
        let instance = SwiftYubikitIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    let connection : YubiKeyConnection = YubiKeyConnection(withType: YubikeyConnectionType.NFC.rawValue | YubikeyConnectionType.Accessory.rawValue)
    
    func failure(result: @escaping FlutterResult,
                         code:String,
                         message:String,
                         details:Any?)  {
        result(FlutterError.init(
            code: code,
            message: message,
            details: details
        ))
        self.connection.disconnect(successMessage: nil, errorMessage: nil)
    }
    
    let handlers = [Handler].init(arrayLiteral:
        PivGenerateKeyHandler(),
        PivCalculateSecretHandler(),
        PivGetCertificateHandler(),
        CapabilitiesHandler()
    )
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
        guard
            let matchingHandler = handlers.first(where: {(handler) -> Bool in handler.canHandle(call)})
        else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        matchingHandler.handle(self, call: call, result: result)
    }
}



