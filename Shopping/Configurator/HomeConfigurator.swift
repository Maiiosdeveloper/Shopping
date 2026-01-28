//
//  HomeConfigurator.swift
//  Shopping
//
//  Created by Mai on 25/01/2026.
//

import UIKit
enum HomeConfigurator {
    static func productsViewController() -> ProductsListViewController {
        let viewCotroller = ProductsListViewController()
        let presenter = ProductsListPresenter(view: viewCotroller)
        let interactor = ProductsListInteractor(presenter: presenter)
        let router = ProductsListRouter(viewController: viewCotroller)
        router.dataStore = interactor
        viewCotroller.interactor = interactor
        viewCotroller.router = router
        return viewCotroller
    }
    static func productDetailsViewController(product: ProductItemViewModel) -> ProductDetailsViewController {
        let viewCotroller = ProductDetailsViewController(product: product)
        return viewCotroller
    }
}
