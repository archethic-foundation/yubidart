//
//  Handler.swift
//  yubidart
//
//  Created by charly on 01/02/2023.
//

import Foundation

protocol Handler {
    func canHandle(_ call: FlutterMethodCall) -> Bool
    func handle(_ context: SwiftYubikitIosPlugin,  call: FlutterMethodCall, result: @escaping FlutterResult)
}
