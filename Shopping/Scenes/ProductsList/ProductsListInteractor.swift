//
//  ProductsListInteractor.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
import UIKit
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
    private var comingProducts: [Product] = []
    private var imageCache: [Int: UIImage] = [:]
    private var isLastPage:Bool = false
    init(presenter: ProductsListPresentationLogic) {
        self.presenter = presenter
        currentLimit = limit
    }
    private func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                comingProducts = try await worker.fetchProducts(limit: currentLimit)
                // This workaround approach because the api doesn't contain offset or page for pagination
                if comingProducts.count == allProducts.count {
                    isLastPage = true
                }else {
                    if comingProducts.count <= currentLimit {
                        allProducts = comingProducts
                        // Load images in parallel using TaskGroup
                        await loadImagesForProducts(allProducts)
                    }else {
                        allProducts.append(contentsOf: [comingProducts.last!])
                        // Load images in parallel using TaskGroup
                        await loadImagesForProducts([comingProducts.last!])
                    }
                    
                }
                
                //allProducts = comingProducts
                
                presenter?.reloadData()
                
            } catch {
                presenter?.presentError(error)
            }
            isLoading = false
        }
        
    }
    private func loadImagesForProducts(_ products: [Product]) async {

        await withTaskGroup(of: (Int, UIImage?).self) { group in
            
            for product in products {
                let id = product.id
                let urlString = product.image
                
                group.addTask {
                    guard let url = URL(string: urlString) else {
                        return (id, nil)
                    }

                    let result = try? await URLSession.shared.data(from: url)
                    let data = result?.0
                    let image = data.flatMap { UIImage(data: $0) }

                    return (id, image)
                }
            }

            for await (id, image) in group {
                if let img = image {
                    self.imageCache[id] = img
                }
            }
        }
    }

    // MARK: - Pagination
    private func fetchMoreProductsIfNeeded() {
        if !isLastPage {
            currentLimit += limit
            fetchProducts()
        }
        
    }
}
extension ProductsListInteractor: ProductsListBusinessLogic {
    func loadMore() {
        fetchMoreProductsIfNeeded()
    }
    
    func configureCell(cell: ProductCellProtocol, at index: Int,layoutMode: LayoutMode) {
        let product = allProducts[index]
        DispatchQueue.main.async { [weak self] in
            cell.displayCell(product: .init(product: product,image: self?.imageCache[product.id]), layout: layoutMode)
        }
        
    }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    var count: Int {
        allProducts.count
    }
    
    
}

