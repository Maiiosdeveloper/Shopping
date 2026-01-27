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
    func loadMore()
}

final class ProductsListInteractor {
    private let limit = 7
    private var presenter: ProductsListPresentationLogic?
    private var worker = ProductsListWorker()
    private var isLoading = false {
        didSet {
            presenter?.presentLoading(isLoading)
        }
    }
    private var currentLimit:Int
    private var allProducts: [Product] = []
    init(presenter: ProductsListPresentationLogic) {
        self.presenter = presenter
        currentLimit = limit
    }
    private func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let comingProducts = try await worker.fetchProducts(limit: currentLimit)
                // This workaround approach because the api doesn't contain offset or page for pagination
                allProducts = comingProducts
                presenter?.reloadData()
            } catch {
                presenter?.presentError(error)
            }
            isLoading = false
        }
        
    }
    // MARK: - Pagination
    private func fetchMoreProductsIfNeeded() {
        currentLimit += limit
        fetchProducts()
    }
}
extension ProductsListInteractor: ProductsListBusinessLogic {
    func loadMore() {
        fetchMoreProductsIfNeeded()
    }
    
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

