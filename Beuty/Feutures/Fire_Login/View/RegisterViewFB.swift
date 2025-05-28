//
//  RegisterView.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//


import SwiftUI

struct RegisterViewFirebase: View {
    
    @StateObject private var vm = AuthViewModel_FiireBase()

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("Create Account")
                        .font(.largeTitle).bold()

                    Group {
                        TextField("Full Name", text: $vm.fullName)
                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $vm.password)
                        TextField("Phone (optional)", text: $vm.phone)
                            .keyboardType(.phonePad)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    Button(action: vm.register) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

