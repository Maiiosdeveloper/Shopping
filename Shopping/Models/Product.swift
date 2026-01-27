//
//  Product.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}


