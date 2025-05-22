//
//  LoginView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var showRegister = false

    @State private var logoBounce = false
    @State private var loginButtonTapped = false
    @State private var registerButtonTapped = false

    var body: some View {
        ZStack {
            // 🌈 Background Gradient
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // 🔰 Logo + Title
                VStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                        .offset(y: logoBounce ? -5 : 5)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: logoBounce)
                    Text("Login")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                }
                .onAppear { logoBounce = true }

                // 📦 Login Card
                VStack(spacing: 16) {
                    // 📨 Email
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Enter your email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    // 🔐 Password
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        SecureField("Enter your password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 🔘 Login Button
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Button("Login") {
                            loginButtonTapped = true
                            Task {
                                await viewModel.login()
                                loginButtonTapped = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .scaleEffect(loginButtonTapped ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: loginButtonTapped)
                    }

                    // 🛑 Error Message
                    if let error = viewModel.errorMessage {
                        
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                }
                .fullScreenCover(isPresented: $viewModel.navigateToHome) {
                    // TODO: Replace with your real HomeView
//                    Text("✅ Welcome! Login successful.")
//                        .font(.title)
//                        .bold()
                    
                    HomeView()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 5)
                .padding(.horizontal)

                // 🧭 Navigate to Register
                Button("Don't have an account? Register") {
                    registerButtonTapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        registerButtonTapped = false
                        showRegister = true
                    }
                }
                .font(.footnote)
                .foregroundColor(.blue)
                .scaleEffect(registerButtonTapped ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.2), value: registerButtonTapped)
                .sheet(isPresented: $showRegister) {
                    RegisterView()
                }
            }
            .padding(.top, 40)
        }
    }

    // 🌙 Dynamic Gradient
    private var gradientColors: [Color] {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return [Color.black, Color.gray]
        } else {
            return [Color.blue.opacity(0.3), Color.white]
        }
    }
}




