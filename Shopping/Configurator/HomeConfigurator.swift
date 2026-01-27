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
        viewCotroller.interactor = interactor
        viewCotroller.router = router
        return viewCotroller
    }
}
