//
//  ProductsListWorker.swift
//  Shopping
//
//  Created by Mai on 23/01/2026.
//

import Foundation
final class ProductsListWorker {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchProducts(limit: Int) async throws -> [Product] {
        return try await apiClient.request(.products(limit: limit))
    }
}
