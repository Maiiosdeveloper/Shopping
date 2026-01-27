//
//  APIClient.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
final class APIClient: APIClientProtocol {

    static let shared = APIClient()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {

        let request = URLRequest(url: endpoint.url)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case noInternet
}
