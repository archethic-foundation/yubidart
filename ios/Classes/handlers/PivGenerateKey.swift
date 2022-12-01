//
//  File.swift
//  yubidart
//
//  Created by charly on 01/02/2023.
//

import Flutter
import UIKit
import YubiKit

class PivGenerateKeyHandler: Handler {
    func canHandle(_ call: FlutterMethodCall) -> Bool {
        call.method == "pivGenerateKey"
    }
    
    func handle(_ context: SwiftYubikitIosPlugin, call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any>,
              let pin = args["pin"] as? String,
              let managementKey = args["managementKey"] as? FlutterStandardTypedData,
              let rawKeyType = args["managementKeyType"] as? NSNumber,
              let keyType = YKFPIVManagementKeyType.fromValue(rawKeyType.uint8Value),
              let rawSlot = args["slot"] as? NSNumber,
              let slot = YKFPIVSlot(rawValue: rawSlot.uintValue),
              let rawType = args["type"] as? NSNumber,
              let type = YKFPIVKeyType(rawValue: rawType.uintValue),
              let rawPinPolicy = args["pinPolicy"] as? NSNumber,
              let pinPolicy = YKFPIVPinPolicy(rawValue: rawPinPolicy.uintValue),
              let rawTouchPolicy = args["touchPolicy"] as? NSNumber,
              let touchPolicy = YKFPIVTouchPolicy(rawValue: rawTouchPolicy.uintValue)
        else {
            result(FlutterError.init(
                code: YubikitError.dataError.rawValue,
                message: "Data or format error",
                details: call.arguments
            ))
            return
        }
        
        context.connection.connect(
            completion: {(connection) -> Void in
                connection.pivSession { session, error in
                    guard let pivSession = session else {
                        context.failure(
                            result: result,
                            code: YubikitError.other.rawValue,
                            message: "Failed to create PIV session",
                            details: error?.localizedDescription
                        )
                        
                        return
                    }
                    
                    pivSession.authenticate(
                        withManagementKey: managementKey.data,
                        type: keyType
                    ) { error in
                        guard error == nil else {
                            context.failure(
                                result: result,
                                code: YubikitError.invalidMangementKey.rawValue,
                                message: "Failed to verify management key",
                                details: error?.localizedDescription
                            )
                            return
                        }
                        
                        pivSession.verifyPin(pin) { retries, verifyPinError in
                            guard verifyPinError == nil else {
                                context.failure(
                                    result: result,
                                    code: YubikitError.invalidPin.rawValue,
                                    message: "Failed to verify pin",
                                    details: retries
                                )
                                return
                            }
                            
                            pivSession.generateKey(
                                in: slot,
                                type: type,
                                pinPolicy: pinPolicy,
                                touchPolicy: touchPolicy
                            ) { publicKeyRef, error in
                                guard publicKeyRef != nil else {
                                    context.failure(
                                        result: result,
                                        code: YubikitError.other.rawValue,
                                        message: "Failed to generate PIV key",
                                        details: error?.localizedDescription
                                    )
                                    return
                                }
                                
                                
                                
                                guard let data = SecKeyCopyExternalRepresentation(publicKeyRef!, nil)  else {
                                    context.failure(
                                        result: result,
                                        code: YubikitError.other.rawValue,
                                        message: "Failed to read generated public key",
                                        details: error?.localizedDescription
                                    )
                                    return
                                }
                                
                                result(data)
                                context.connection.disconnect(successMessage: nil, errorMessage: nil)
                            }
                        }
                    }
                }
            },
            error: {(error) -> Void in
                context.failure(
                    result: result,
                    code: YubikitError.other.rawValue,
                    message: "Connection failed",
                    details: error.localizedDescription
                )
            }
        )
    }
}
