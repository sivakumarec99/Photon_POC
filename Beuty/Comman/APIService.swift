//
//  APIService.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation

actor APIService_URLSession {
    private let domainURL: URL
    
    init(domainURL: URL) {
        self.domainURL = domainURL
    }
    
    private lazy var session: URLSession = {
          let config = URLSessionConfiguration.default
          config.httpCookieStorage = HTTPCookieStorage.shared
          config.httpShouldSetCookies = true
          config.httpCookieAcceptPolicy = .always
          return URLSession(configuration: config, delegate: UnsafeSSLSessionDelegate(), delegateQueue: nil)
      }()
    //let session = URLSession(configuration: .default, delegate: UnsafeSSLSessionDelegate(), delegateQueue: nil)

    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case unknown(Error)
    }
    
    private func makeRequest(endpoint: String, method: String, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: endpoint, relativeTo: domainURL) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = body
        }
        return request
    }
    
    // GET
    func get<T: Decodable>(endpoint: String) async throws -> T {
        let request = try makeRequest(endpoint: endpoint, method: "GET")
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return try decode(data: data)
    }
    
    // POST
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        let request = try makeRequest(endpoint: endpoint, method: "POST", body: bodyData)
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try decode(data: data)
    }
    
    // DELETE
    func delete(endpoint: String) async throws {
        let request = try makeRequest(endpoint: endpoint, method: "DELETE")
        let (_, response) = try await session.data(for: request)
        try validate(response: response)
    }
    
    // UPDATE (PUT)
    func update<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        let request = try makeRequest(endpoint: endpoint, method: "PUT", body: bodyData)
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return try decode(data: data)
    }
    
    // Helper to validate HTTP response
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
    }
    
    // Helper to decode JSON data
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}


class UnsafeSSLSessionDelegate: NSObject, URLSessionDelegate {
    // Accept any SSL certificate (not safe for production)
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}



