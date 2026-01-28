//
//  ProductsListRouter.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import UIKit
protocol ProductsListRoutingLogic {
    func routeToProductDetails()
}
protocol ProductsListProductsListDataPassing {
    var dataStore: ProductsListDataStore? { get }
}

final class ProductsListRouter {
    weak var viewController: ProductsListViewController?
    var dataStore: ProductsListDataStore?
    init(viewController: ProductsListViewController?) {
        self.viewController = viewController
    }
}
extension ProductsListRouter: ProductsListRoutingLogic {
    func routeToProductDetails() {
        guard let product = dataStore?.productViewModel else { return }
        viewController?.navigationController?.pushViewController(HomeConfigurator.productDetailsViewController(product: product), animated: true)
    }
}
extension ProductsListRouter: ProductsListProductsListDataPassing {
    
}

