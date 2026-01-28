//
//  ProductsCacheManager.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import SwiftData
import UIKit

@Model
class CachedProduct {
    @Attribute(.unique) var id: Int
    var title: String
    var price: Double
    var desc: String
    let category: String
    var imageData: Data?   // store image as Data

    init(id: Int, title: String, price: Double, desc: String, category: String,  imageData: Data?) {
        self.id = id
        self.title = title
        self.price = price
        self.desc = desc
        self.category = category
        self.imageData = imageData
    }
}
