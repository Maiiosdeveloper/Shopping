//
//  ProductsListModels.swift
//  Shopping
//
//  Created by Mai on 23/01/2026.
//

import Foundation
struct ProductItemViewModel {
    let title: String
    let price: String
    let imageURL: String
    init(product: Product) {
        self.title = product.title
        self.price = "$\(product.price)"
        self.imageURL = product.image
    }
}
