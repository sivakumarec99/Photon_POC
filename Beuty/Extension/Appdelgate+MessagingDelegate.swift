//
//  Appdelgate+MessagingDelegate.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//

import Foundation
import FirebaseMessaging


// Optional: Handle FCM Token updates
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM Token: \(fcmToken ?? "")")
        // Save this token to your backend if needed
    }
}
