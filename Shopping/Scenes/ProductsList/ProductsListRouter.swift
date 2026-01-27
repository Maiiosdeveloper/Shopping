//
//  ProductsListRouter.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import UIKit
protocol ProductsListRoutingLogic {
    func routeToProductDetails(product: Product)
}
final class ProductsListRouter {
    weak var viewController: ProductsListViewController?
    init(viewController: ProductsListViewController?) {
        self.viewController = viewController
    }
}
extension ProductsListRouter: ProductsListRoutingLogic {
    func routeToProductDetails(product: Product) {
        
    }
}

