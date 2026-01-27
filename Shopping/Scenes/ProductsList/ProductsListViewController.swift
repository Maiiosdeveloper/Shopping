//
//  ProductsListViewController.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import UIKit
protocol ProductsListDisplayLogic: AnyObject {
    func reloadData()
    func displayLoading(_ isLoading: Bool)
    func displayError(_ message: String)
}
final class ProductsListViewController: UIViewController {
    // MARK: @IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: @Variables
    private var layoutMode: LayoutMode = .list
    var interactor: ProductsListBusinessLogic?
    var router: ProductsListRoutingLogic?

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationButton()
        interactor?.viewDidLoad()
    }
    // MARK: Functions
    private func setupCollectionView() {
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // spacing
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 8
            collectionView.setCollectionViewLayout(layout, animated: false)
    }
    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Grid",
            style: .plain,
            target: self,
            action: #selector(toggleLayout)
        )
    }
    @objc private func toggleLayout() {
        layoutMode = layoutMode == .list ? .grid : .list
        navigationItem.rightBarButtonItem?.title = layoutMode == .list ? "Grid" : "List"
        collectionView.reloadData()
    }
}
extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ProductCell",
                    for: indexPath
                ) as? ProductCell
        guard let cell else {
            return UICollectionViewCell()
        }
        interactor?.configureCell(cell: cell, at: indexPath.row, layoutMode: layoutMode)
        
                return cell
    }
}
extension ProductsListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch layoutMode {
        case .list:
            return CGSize(width: width, height: 200)
        case .grid:
            return CGSize(width: (width / 2) - 4, height: 240)
        }
    }
}
extension ProductsListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        let threshold: CGFloat = 100

        if offsetY > contentHeight - frameHeight - threshold {
            interactor?.loadMore()
        }
    }
}

extension ProductsListViewController: ProductsListDisplayLogic {
    func reloadData()  {
        Task {
            await MainActor.run { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    func displayLoading(_ isLoading: Bool) {
        
    }
    func displayError(_ message: String) {
        
    }
    
    
}
enum LayoutMode {
    case list
    case grid
}
