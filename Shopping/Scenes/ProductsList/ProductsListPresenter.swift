//
//  ProductsListPresenter.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
protocol ProductsListPresentationLogic {
    func reloadData()
    func presentError(_ error: Error)
    func presentLoading(_ isLoading: Bool)
}
final class ProductsListPresenter {
    
    weak var viewController: ProductsListDisplayLogic?
    init(view: ProductsListDisplayLogic) {
        self.viewController = view
    }
    
}
extension ProductsListPresenter: ProductsListPresentationLogic {
    func reloadData() {
        viewController?.reloadData()
    }
    func presentError(_ error: Error) {
            viewController?.displayError("Something went wrong")
        }
        func presentLoading(_ isLoading: Bool) {
            viewController?.displayLoading(isLoading)
        }
}
