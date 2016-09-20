//
//  AppDelegate.swift
//  CallExtension
//
//  Created by rongyan.zry on 16/9/15.
//  Copyright © 2016年 rongyan.zry. All rights reserved.
//

import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    var window: UIWindow?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    var providerDelegate:ProviderDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        providerDelegate = ProviderDelegate()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        /*
         Store push credentials on server for the active user.
         For sample app purposes, do nothing since everything is being done locally.
         */
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        guard type == .voIP else { return }
        
        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
            let handle = payload.dictionaryPayload["handle"] as? String,
            let uuid = UUID(uuidString: uuidString)
        {
            displayIncomingCall(uuid: uuid, handle: handle)
        }
    }
    
    /// Display the incoming call to the user
    func displayIncomingCall(uuid: UUID, handle: String) {
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle)
    }

}

