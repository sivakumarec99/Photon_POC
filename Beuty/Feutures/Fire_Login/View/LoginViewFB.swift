//
//  LoginView.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//


import SwiftUI

struct LoginViewFirebase: View {
    @StateObject private var vm = AuthViewModel_FiireBase()
    @State private var showPassword = false
    @State private var navigateToRegister = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .bold()

                        // Email Field
                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)

                        // Password Field with Show/Hide
                        ZStack(alignment: .trailing) {
                            Group {
                                if showPassword {
                                    TextField("Password", text: $vm.password)
                                } else {
                                    SecureField("Password", text: $vm.password)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)

                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }

                        // Login Button
                        Button(action: vm.login) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        // Forgot Password
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .underline()
                        }

                        // Navigate to Register
                        HStack {
                            Text("Don’t have an account?")
                            Button(action: {
                                navigateToRegister = true
                            }) {
                                Text("Register")
                                    .foregroundColor(.blue)
                                    .bold()
                            }
                        }
                        .font(.subheadline)

                        // Success Message
                        if vm.isLoginSuccessful {
                            Text("Login Successful 🎉")
                                .foregroundColor(.green)
                                .font(.headline)
                        }

                        // Error Message
                        if !vm.errorMessage.isEmpty {
                            Text(vm.errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordViewFirebase()
            }
        }
    }
}

