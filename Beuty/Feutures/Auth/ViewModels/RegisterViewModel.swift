//
//  RegisterViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//

import Foundation
import Alamofire

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Inputs
    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - Outputs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var token: String?

    // MARK: - Navigation Triggers
    @Published var navigateToLogin: Bool = false
    @Published var navigateToHome: Bool = false

    // MARK: - Register User
    func register() async {
        guard validateInputs() else { return }

        isLoading = true
        errorMessage = nil

        let request = RegisterRequest(email: email, password: password)

        do {
            let response = try await AuthService.shared.registerUser(request: request)
            token = response.token
            navigateToLogin = true // ✅ Trigger login view
        } catch {
            errorMessage = parseError(error)
        }

        isLoading = false
    }

    // MARK: - Login User
    func login() async {
        guard validateInputs() else { return }

        isLoading = true
        errorMessage = nil

        let request = LoginRequest(email: email, password: password)

        do {
            let response = try await AuthService.shared.loginUser(request: request)
            token = response.token
            navigateToHome = true // ✅ Trigger home view
        } catch {
            navigateToHome = true
            errorMessage = parseError(error)
        }

        isLoading = false
    }

    // MARK: - Input Validation
    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and Password are required."
            return false
        }
        return true
    }

    // MARK: - Error Parsing
    private func parseError(_ error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.localizedDescription
        } else if let afError = error as? AFError {
            return afError.errorDescription ?? "Unexpected error occurred."
        } else {
            return error.localizedDescription
        }
    }
}


