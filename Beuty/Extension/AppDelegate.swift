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
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //FireBase Notification
        FirebaseApp.configure()
        // ✅ Register notification support
        registerForPushNotifications(application)
        // Optional: listen for Firebase Messaging token
        Messaging.messaging().delegate = self
        
        GMSServices.provideAPIKey("AIzaSyBy8T7PjTf68s35t_ixlobLlCn0pYiq758")
        GMSPlacesClient.provideAPIKey("AIzaSyBy8T7PjTf68s35t_ixlobLlCn0pYiq758")
        return true
    }
}

