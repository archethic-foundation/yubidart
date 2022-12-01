//
//  Connection.swift
//  yubikit_ios
//
//  Created by charly on 19/12/2022.
//

import Foundation
import Flutter
import UIKit
import YubiKit


enum YubikeyConnectionType: UInt8 {
    case NFC = 0b00000001
    case Accessory = 0b0000010
}

extension UInt8 {
    func isEnabled(_ connectionType: YubikeyConnectionType) -> Bool {
        return self & connectionType.rawValue != 0
    }
}

class YubiKeyConnection: NSObject {
    var connectionType: UInt8
    var activeConnection: YKFConnectionProtocol?
    var connectionCallback: ((_ connection: YKFConnectionProtocol) -> Void)?
    var connectionErrorCallback: ((_ error: Error) -> Void)?
    
    init(withType type: UInt8) {
        connectionType = type
        
        super.init()
        NSLog("Init yubikey connection")
        
        
        YubiKitManager.shared.delegate = self
    }
    
    deinit {
        NSLog("Deinit yubikey connection")
    }
    
    
    func connect(
        completion: @escaping (_ connection: YKFConnectionProtocol) -> Void,
        error: @escaping (_ error: Error) -> Void
    ) {
        self.connectionCallback = completion
        self.connectionErrorCallback = error

        if (connectionType.isEnabled(YubikeyConnectionType.Accessory)) {
            NSLog("Attempting Accessory connection !")
            YubiKitManager.shared.startAccessoryConnection()
        }
        
        if #available(iOS 13.0, *) {
            if (connectionType.isEnabled(YubikeyConnectionType.NFC)) {
                NSLog("Attempting NFC connection !")
                YubiKitManager.shared.startNFCConnection()
            }
        }
    }
    
    func disconnect(successMessage successMessage: String?, errorMessage errorMessage: String?) {
        if #available(iOS 13.0, *) {
            if let message = errorMessage {
                YubiKitManager.shared.stopNFCConnection(withErrorMessage: message)
            } else if let message = successMessage {
                YubiKitManager.shared.stopNFCConnection(withMessage: message)
            } else {
                YubiKitManager.shared.stopNFCConnection()
            }
        }
        YubiKitManager.shared.stopAccessoryConnection()
    }
}

extension YubiKeyConnection: YKFManagerDelegate {
    func didConnectNFC(_ connection: YKFNFCConnection) {
        NSLog("Did connect NFC")
        activeConnection = connection
        if let callback = connectionCallback {
            NSLog("Calling callback")
            callback(connection)
        }
    }
    
    func didDisconnectNFC(_ connection: YKFNFCConnection, error: Error?) {
        NSLog("Did disconnect NFC")
        if #available(iOS 13.0, *) {
            YubiKitManager.shared.stopNFCConnection(withErrorMessage: "Connection lost")
        }
        activeConnection = nil
    }
    
    func didFailConnectingNFC(_ error: Error) {
        NSLog("Did fail to connect NFC")
        if #available(iOS 13.0, *) {
            YubiKitManager.shared.stopNFCConnection(withErrorMessage: error.localizedDescription)
        }
        activeConnection = nil

        if let callback = connectionErrorCallback {
            callback(error)
        }
    }
    
    func didConnectAccessory(_ connection: YKFAccessoryConnection) {
        NSLog("Did connect accessory")
        activeConnection = connection
    }
    
    func didDisconnectAccessory(_ connection: YKFAccessoryConnection, error: Error?) {
        NSLog("Did disconnect accessory")
        YubiKitManager.shared.stopAccessoryConnection()
        activeConnection = nil
    }
}
