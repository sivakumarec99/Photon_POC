//
//  AuthService.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 21/05/25.
//

import Foundation
import Alamofire

protocol AuthServicing {
    func registerUser(request: RegisterRequest) async throws -> RegisterResponse
    func loginUser(request: LoginRequest) async throws -> LoginResponse
}

final class AuthService: AuthServicing {
    static let shared = AuthService()
    private init() {}

    private enum Endpoint: String {
        case register = "/api/register"
        case login = "/api/login"

        var url: String {
            return "https://reqres.in" + rawValue
        }
    }

    func registerUser(request: RegisterRequest) async throws -> RegisterResponse {
        try await sendRequest(
            to: Endpoint.register.url,
            method: .post,
            parameters: request,
            responseType: RegisterResponse.self
        )
    }

    func loginUser(request: LoginRequest) async throws -> LoginResponse {
        try await sendRequest(
            to: Endpoint.login.url,
            method: .post,
            parameters: request,
            responseType: LoginResponse.self
        )
    }

    /// ✅ Generic reusable method
    private func sendRequest<T: Decodable, U: Encodable>(
        to url: String,
        method: HTTPMethod,
        parameters: U,
        responseType: T.Type
    ) async throws -> T {
        do {
            return try await AF.request(
                url,
                method: method,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .serializingDecodable(T.self)
            .value
        } catch {
            throw mapAFError(error)
        }
    }

    /// 🔍 Custom error mapping for better control
    private func mapAFError(_ error: Error) -> Error {
        if let afError = error.asAFError {
            switch afError {
            case .sessionTaskFailed(let urlError as URLError):
                return NetworkError.noConnection(urlError)
            case .responseValidationFailed:
                return NetworkError.invalidResponse
            default:
                return NetworkError.unknown(error)
            }
        }
        return error
    }
}

enum NetworkError: Error, LocalizedError {
    case noConnection(URLError)
    case invalidResponse
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .noConnection(let urlError):
            return "No internet connection: \(urlError.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server."
        case .decodingError:
            return "Failed to decode the response."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}


func handleNetworkError(_ error: Error) -> String {
    if let networkError = error as? NetworkError {
        return networkError.localizedDescription
    } else {
        return "An unknown error occurred."
    }
}
