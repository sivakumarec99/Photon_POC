//
//  IntroFlowView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 23/05/25.
//


import SwiftUI

struct IntroFlowView: View {
    @Binding var hasSeenIntro: Bool // To update AppStorage when done

    // For Matched Geometry Animation
    @Namespace var animationNamespace

    // States for controlling the flow
    @State private var showLaunchImageOnly = true // Start with just the launch image
    @State private var showDemoScreens = false    // Transition to demo screens
    @State private var currentDemoPage = 0

    let totalDemoPages = 5 // You mentioned 5 scrollable screens

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // White background for everything in this flow

            if showLaunchImageOnly {
                // --- Launch Image Phase ---
                VStack {
                    Spacer()
                    Image("app_logo") // Make sure you have this image in Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .matchedGeometryEffect(id: "logo", in: animationNamespace)
                    Spacer()
                }
                .transition(.opacity) // Optional: fade transition
                .onAppear {
                    // Wait 3 seconds then transition to demo screens
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 0.7)) { // Animation for the logo move
                            showLaunchImageOnly = false
                            showDemoScreens = true
                        }
                    }
                }
            } else if showDemoScreens {
                // --- Demo Screens Phase ---
                VStack {
                    // Image at the top of the demo screen (where it "moved" to)
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Potentially smaller
                        .matchedGeometryEffect(id: "logo", in: animationNamespace)
                        .padding(.top, 50)


                    TabView(selection: $currentDemoPage) {
                        ForEach(0..<totalDemoPages, id: \.self) { index in
                            DemoPageView(pageNumber: index + 1)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .animation(.default, value: currentDemoPage) // Animate tab changes

                    // "Next" or "Get Started" Button
                    Button(action: {
                        if currentDemoPage < totalDemoPages - 1 {
                            withAnimation {
                                currentDemoPage += 1
                            }
                        } else {
                            // Last page, dismiss intro
                            withAnimation {
                                hasSeenIntro = true
                            }
                        }
                    }) {
                        Text(currentDemoPage < totalDemoPages - 1 ? "Next" : "Get Started")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95))) // Optional: nice transition
            }
        }
        .preferredColorScheme(.light) // Enforce light mode for this view if desired
    }
}

// Preview Helper for IntroFlowView
struct IntroFlowView_Previews: PreviewProvider {
    static var previews: some View {
        IntroFlowView(hasSeenIntro: .constant(false))
    }
}