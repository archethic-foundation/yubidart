//
//  Error.swift
//  yubikit_ios
//
//  Created by charly on 19/12/2022.
//

import Foundation

enum YubikitError: String {
    case other = "OTHER"
    case dataError = "INVALID_DATA"
    case alreadyConnectedFailure = "ALREADY_CONNECTED"
    case notConnectedFailure = "NOT_CONNECTED"
    case unsupportedOperation = "UNSUPPORTED_OPERATION"
    case invalidPin = "INVALID_PIN"
    case invalidMangementKey = "INVALID_MANAGEMENT_KEY"
}
