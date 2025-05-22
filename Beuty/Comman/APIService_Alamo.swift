//
//  APIService 2.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation
import Alamofire

actor APIService {
    private let domainURL: URL
    private let session: Session

    init(domainURL: URL) {
        self.domainURL = domainURL

        // Configure Alamofire session with SSL trust disabled (dev only)
        self.session = Session(
            serverTrustManager: ServerTrustManager(evaluators: [
                "fakestoreapi.com": DisabledTrustEvaluator()
            ])
        )
    }

    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case unknown(Error)
    }

    // Generic GET
    func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }

        return try await session.request(url)
            .validate()
            .serializingDecodable(T.self).value
    }

    // Generic POST
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }

        return try await session.request(
            url,
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(T.self).value
    }

    // Generic PUT (Update)
    func update<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }

        return try await session.request(
            url,
            method: .put,
            parameters: body,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingDecodable(T.self).value
    }

    // DELETE
    func delete(endpoint: String) async throws {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }

        _ = try await session.request(
            url,
            method: .delete
        )
        .validate()
        .serializingData().value
    }
}



