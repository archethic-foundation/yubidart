//
//  File.swift
//  yubidart
//
//  Created by charly on 01/02/2023.
//

import Flutter
import UIKit
import YubiKit

class CapabilitiesHandler: Handler {
    private  var kGetPlatformVersion = "getPlatformVersion"
    private  var kSupportsNFCScanning = "supportsNFCScanning"
    private  var kSupportsISO7816NFCTags = "supportsISO7816NFCTags"
    private  var kSupportsMFIAccessoryKey = "supportsMFIAccessoryKey"
    
    
    func canHandle(_ call: FlutterMethodCall) -> Bool {
        switch (call.method) {
        case kGetPlatformVersion, kSupportsNFCScanning, kSupportsISO7816NFCTags, kSupportsMFIAccessoryKey:
            return true
        default:
            return false
        }
    }
    
    func handle(_ context: SwiftYubikitIosPlugin, call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case kGetPlatformVersion:
            result("iOS " + UIDevice.current.systemVersion)
            return
        case kSupportsNFCScanning:
            result(YubiKitDeviceCapabilities.supportsNFCScanning)
            return
        case kSupportsISO7816NFCTags:
            result(YubiKitDeviceCapabilities.supportsISO7816NFCTags)
            return
        case kSupportsMFIAccessoryKey:
            result(YubiKitDeviceCapabilities.supportsMFIAccessoryKey)
            return
        default:
            return
        }
    }
}
