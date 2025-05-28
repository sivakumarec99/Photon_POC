//
//  AppDelegate+Notifications.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate {

    func registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("✅ Notifications permission granted: \(granted)")
        }

        application.registerForRemoteNotifications()
    }

    // Called when APNs has assigned a device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("✅ APNs device token registered.")
    }
 
    // Handle foreground message
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Handle tap on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 Notification tapped: \(userInfo)")
        completionHandler()
    }
}
