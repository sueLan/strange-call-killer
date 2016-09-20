//
//  ProviderDelegate.swift
//  CallExtension
//
//  Created by rongyan.zry on 16/9/16.
//  Copyright © 2016年 rongyan.zry. All rights reserved.
//

import UIKit
import CallKit
import AVFoundation

class ProviderDelegate: NSObject,CXProviderDelegate {
    private let provider:CXProvider
    
    private let callController = CXCallController()
    
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = "CallExtension"
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        providerConfiguration.maximumCallsPerCallGroup = 1
        return providerConfiguration
    }
    
    override init() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
        
        //        if CXProvider.authorizationStatus == .notDetermined {
        //            provider.requestAuthorization()
        //        }
    }
    
    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(uuid: UUID, handle: String) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                print("calling")
            }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let update = CXCallUpdate()
        update.remoteHandle = action.handle
        provider.reportOutgoingCall(with: action.uuid, startedConnectingAt: Date())
        action.fulfill(withDateStarted: Date())
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill(withDateConnected: Date())
    }
    
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        action.fulfill()
        print("Timed out \(#function)")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Received \(#function)")
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Received \(#function)")
    }
}
