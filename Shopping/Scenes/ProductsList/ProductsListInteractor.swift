//
//  ProductsListInteractor.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import Foundation
import UIKit
import SwiftData
protocol ProductsListBusinessLogic {
    var count: Int { get }
    func viewDidLoad()
    func configureCell(cell: ProductCellProtocol,at index: Int, layoutMode: LayoutMode)
    func loadMore()
    func didSelectItem(at index: Int)
}
protocol ProductsListDataStore {
    var productViewModel: ProductItemViewModel? { get }
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
    var productViewModel: ProductItemViewModel?
    
    var context: ModelContext?
    init(presenter: ProductsListPresentationLogic) {
        self.presenter = presenter
        currentLimit = limit
    }
    private func fetchProducts() async {
        guard !isLoading else { return }
        isLoading = true
//        Task {
            do {
                comingProducts = try await worker.fetchProducts(limit: currentLimit)
                if comingProducts.count == allProducts.count {
                    isLastPage = true
                }else {
                    // This workaround approach because the api doesn't contain offset or page for pagination
                    let ids = Set(allProducts.map { $0.id })
                    let missing = comingProducts.filter { !ids.contains($0.id) }
                    allProducts.append(contentsOf: missing)
                    // Load images in parallel using TaskGroup
                    await loadImagesForProducts(missing)
                    // save to cache
                    saveToCache()
                }
                presenter?.reloadData()
            } catch {
                print("❌ No network. Loading from cache...")
                if allProducts.isEmpty {
                    await loadFromCache()
                }
                
            }
            isLoading = false
//        }
        
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
            Task {
                await fetchProducts()
            }
        }
        
    }
}
extension ProductsListInteractor {
    private func saveToCache() {
        guard let context else { return }

        for p in allProducts {
            let imgData = imageCache[p.id]?.pngData()

            let cached = CachedProduct(
                id: p.id,
                title: p.title,
                price: p.price,
                desc: p.description, category: p.category,
                imageData: imgData
            )

            context.insert(cached)
        }

        try? context.save()
    }
    private func loadFromCache() async {
        guard let context else { return }

        let cached = try? context.fetch(FetchDescriptor<CachedProduct>())

        allProducts = cached?.map {
            Product(
                id: $0.id,
                title: $0.title,
                price: $0.price,
                description: $0.desc, category: $0.category,
                image: ""
            )
        } ?? []

        // imageCache from SwiftData
        cached?.forEach {
            if let data = $0.imageData {
                imageCache[$0.id] = UIImage(data: data)
            }
        }

        presenter?.reloadData()

    }


}
extension ProductsListInteractor: ProductsListBusinessLogic {
    func didSelectItem(at index: Int) {
        let selectedProduct = allProducts[index]
        productViewModel = .init(product: selectedProduct, image: imageCache[selectedProduct.id])
    }
    
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
        Task {
            await fetchProducts()
        }
    }
    
    var count: Int {
        allProducts.count
    }
    
    
}
extension ProductsListInteractor: ProductsListDataStore {

}
