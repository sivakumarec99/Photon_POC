//
//  BeutyApp.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct BeutyApp: App {
    
    // demo App
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenIntro {
                MainTabView()
            } else {
                IntroFlowView(hasSeenIntro: $hasSeenIntro)
            }
        }
    }
}
