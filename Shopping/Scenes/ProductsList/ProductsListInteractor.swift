//
//  ProductsListInteractor.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
protocol ProductsListBusinessLogic {
    var count: Int { get }
    func viewDidLoad()
    func configureCell(cell: ProductCellProtocol,at index: Int, layoutMode: LayoutMode)
}

final class ProductsListInteractor {
    private var presenter: ProductsListPresentationLogic?
    private var worker = ProductsListWorker()
    private var isLoading = false
    private var currentLimit = 7
    private var allProducts: [Product] = []
    init(presenter: ProductsListPresentationLogic) {
        self.presenter = presenter
    }
    private func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        presenter?.presentLoading(true)
        Task {
            do {
                allProducts = try await worker.fetchProducts(limit: currentLimit)
                presenter?.reloadData()
            } catch {
                presenter?.presentError(error)
            }
            isLoading = false
            presenter?.presentLoading(false)
        }
    }
    
    private func fetchMoreProductsIfNeeded() {
        currentLimit += 7
        fetchProducts()
    }
}
extension ProductsListInteractor: ProductsListBusinessLogic {
    func configureCell(cell: ProductCellProtocol, at index: Int,layoutMode: LayoutMode) {
        cell.displayCell(product: .init(product: allProducts[index]), layout: layoutMode)
    }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    var count: Int {
        allProducts.count
    }
    
    func configureCell(at index: Int) {
        
    }
    
    
    
}

