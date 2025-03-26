//
//  File.swift
//  yubidart
//
//  Created by charly on 01/02/2023.
//

import Flutter
import UIKit
import YubiKit

class PivCalculateSecretHandler: Handler {
    func canHandle(_ call: FlutterMethodCall) -> Bool {
        call.method == "pivCalculateSecret"
    }
    
    func handle(_ context: SwiftYubikitIosPlugin, call: FlutterMethodCall, result: @escaping FlutterResult) {
        var secKeyCreateError : Unmanaged<CFError>?
        
        guard
            let args = call.arguments as? Dictionary<String, Any>,
            let pin = args["pin"] as? String,
            let rawSlot = args["slot"] as? NSNumber,
            let slot = YKFPIVSlot(rawValue: rawSlot.uintValue),
            let rawPeerPublicKey = args["peerPublicKey"] as? FlutterStandardTypedData,
            let peerPublicKey = DerDecoder().decodePublicKey(rawPeerPublicKey.data as Data, &secKeyCreateError)
        else {
            if (secKeyCreateError != nil) {
                result(FlutterError.init(
                    code: YubikitError.dataError.rawValue,
                    message: "Invalid Public Key",
                    details: secKeyCreateError?.takeRetainedValue().localizedDescription
                ))
                return
                
            }
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
                        
                        pivSession.calculateSecretKey(
                            in: slot,
                            peerPublicKey: peerPublicKey
                        ) { secretKey, error in
                            guard secretKey != nil else {
                                context.failure(
                                    result: result,
                                    code: YubikitError.other.rawValue,
                                    message: "Failed to calculate PIV secret key",
                                    details: error?.localizedDescription
                                )
                                return
                            }
                            
                            result(secretKey)
                            context.connection.disconnect(successMessage: nil, errorMessage: nil)
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
