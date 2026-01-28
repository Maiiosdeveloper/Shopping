//
//  ProductDetailsViewController.swift
//  Shopping
//
//  Created by Mai on 22/01/2026.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    private let product: ProductItemViewModel
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    // MARK: - Header Sizing
    let maxHeaderHeight: CGFloat = 300
    let minHeaderHeight: CGFloat = 150
    override func viewDidLoad() {
        super.viewDidLoad()
        displayProduct()
    }
    // MARK: - Object Life Cycle
    init(product: ProductItemViewModel) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    private func displayProduct() {
        titleLabel.text = product.title
        priceLabel.text = product.price
        descriptionLabel.text = product.description
        headerImageView.image = product.image
    }
}
// MARK: - ScrollView Delegate (Stretchy Header)
extension ProductDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y

        if offset < 0 {
            // Pull down → expand header
            headerHeightConstraint.constant = maxHeaderHeight - offset
        } else {
            // Scroll up → shrink header
            let newHeight = max(maxHeaderHeight - offset, minHeaderHeight)
            headerHeightConstraint.constant = newHeight
        }
    }
}
