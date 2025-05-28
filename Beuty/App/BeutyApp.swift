//
//  BeutyApp.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//

import SwiftUI
@main
struct BeutyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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

