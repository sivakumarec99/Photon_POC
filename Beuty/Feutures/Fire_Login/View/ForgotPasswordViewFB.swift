//
//  ForgotPasswordView.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//
import SwiftUI
import FirebaseAuth

struct ForgotPasswordViewFirebase: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = AuthViewModel_FiireBase()
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var isSuccess = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .bold()

                Text("Enter your email to receive a password reset link.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                Button(action: resetPassword) {
                    Text("Send Reset Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(isSuccess ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func resetPassword() {
        message = ""
        guard !email.isEmpty else {
            message = "Please enter your email."
            isSuccess = false
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                message = "Error: \(error.localizedDescription)"
                isSuccess = false
            } else {
                message = "Reset link sent! Check your email."
                isSuccess = true
            }
        }
    }
}
