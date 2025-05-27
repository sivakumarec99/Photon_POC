//
//  APIService 2.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation
import Alamofire
import UIKit

actor APIService {
    private let domainURL: URL
    private let session: Session

    init(domainURL: URL) {
        self.domainURL = domainURL

        // Allow insecure domains (dev only)
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
        case imageConversionFailed
        case unknown(Error)
    }

    // MARK: - Generic GET
    func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }

        return try await session.request(url)
            .validate()
            .serializingDecodable(T.self).value
    }

    // MARK: - Generic POST
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

    // MARK: - PUT (Update)
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

    // MARK: - DELETE
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

    // MARK: ✅ - DOWNLOAD IMAGE USING ALAMOFIRE
    func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }

        let data = try await session.request(url).serializingData().value
        return UIImage(data: data)
    }

    // MARK: ✅ - UPLOAD IMAGE
    func uploadImage(
        to endpoint: String,
        image: UIImage,
        imageKey: String = "file",  // key used by server (e.g., "file" or "image")
        additionalParameters: [String: String] = [:]
    ) async throws -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.8),
              let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.imageConversionFailed
        }

        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: { formData in
                    formData.append(imageData, withName: imageKey, fileName: "upload.jpg", mimeType: "image/jpeg")
                    for (key, value) in additionalParameters {
                        formData.append(Data(value.utf8), withName: key)
                    }
                },
                to: url,
                method: .post
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}



