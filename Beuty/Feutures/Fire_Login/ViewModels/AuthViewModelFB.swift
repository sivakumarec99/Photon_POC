//
//  AuthViewModel.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//


import Foundation

class AuthViewModel_FiireBase: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var phone = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    @Published var isLoginSuccessful: Bool = false


    func register() {
        guard Validators.isValidEmail(email),
              Validators.isValidPassword(password),
              !fullName.isEmpty else {
            errorMessage = "Please fill all fields correctly"
            return
        }

        FirebaseService.shared.registerUser(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone.isEmpty ? nil : phone
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isAuthenticated = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func login() {
        guard Validators.isValidEmail(email),
              Validators.isValidPassword(password) else {
            errorMessage = "Email or password is invalid"
            return
        }

        FirebaseService.shared.loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isAuthenticated = true
                    self.isLoginSuccessful = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
