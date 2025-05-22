//
//  RegisterView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()

    @State private var confirmPassword = ""
    @State private var logoBounce = false
    @State private var registerButtonTapped = false
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 🌈 Background
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🔰 Logo + Title
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.accentColor)
                            .offset(y: logoBounce ? -5 : 5)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: logoBounce)

                        Text("Create Account")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                    }
                    .onAppear { logoBounce = true }

                    // 📦 Form Card
                    VStack(spacing: 16) {
                        // 📧 Email
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email").font(.caption).foregroundColor(.secondary)
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }

                        // 🔒 Password
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password").font(.caption).foregroundColor(.secondary)
                            SecureField("Enter password", text: $viewModel.password)
                                .textFieldStyle(.roundedBorder)

                            Text("Confirm Password").font(.caption).foregroundColor(.secondary)
                            SecureField("Re-enter password", text: $confirmPassword)
                                .textFieldStyle(.roundedBorder)
                        }

                        // 🔄 Loading / Button
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Button("Register") {
                                registerButtonTapped = true
                                Task {
                                    await handleRegistration()
                                    registerButtonTapped = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!isFormValid)
                            .scaleEffect(registerButtonTapped ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: registerButtonTapped)
                        }

                        // 🛑 Error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                .padding(.top, 40)
            }
            .navigationDestination(isPresented: $viewModel.navigateToLogin) {
                LoginView()
            }
        }
    }

    // 🎨 Dynamic theme-based gradient
    private var gradientColors: [Color] {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return [Color.black, Color.gray]
        } else {
            return [Color.purple.opacity(0.3), Color.white]
        }
    }

    // 🧠 Register Handler
    private func handleRegistration() async {
        guard viewModel.password == confirmPassword else {
            viewModel.errorMessage = "Passwords do not match"
            return
        }

        await viewModel.register()
    }

    // ✅ Field Validations
    private var isFormValid: Bool {
        viewModel.email.contains("@") &&
        viewModel.password.count >= 6 &&
        viewModel.password == confirmPassword
    }
}



