//
//  ProductsListModels.swift
//  Shopping
//
//  Created by Mai on 23/01/2026.
//

import UIKit
struct ProductItemViewModel {
    let title: String
    let price: String
    let image: UIImage?
    init(product: Product, image: UIImage?) {
        self.title = product.title
        self.price = "$\(product.price)"
        self.image = image
    }
}
