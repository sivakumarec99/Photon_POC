//
//  AppDelegate.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//


// AppDelegate.swift

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //FireBase Notification
        FirebaseApp.configure()
        // ✅ Register notification support
        registerForPushNotifications(application)
        // Optional: listen for Firebase Messaging token
        Messaging.messaging().delegate = self
        
        return true
    }
}

