//
//  Endpoint.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
enum Endpoint {
    case products(limit: Int)

    var url: URL {
        switch self {
        case .products(let limit):
            return URL(string: "https://fakestoreapi.com/products?limit=\(limit)")!
        }
    }
}
