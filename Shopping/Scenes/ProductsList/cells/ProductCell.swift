//
//  ProductCell.swift
//  Shopping
//
//  Created by Mai on 24/01/2026.
//

import UIKit
protocol ProductCellProtocol {
    func displayCell(product: ProductItemViewModel, layout: LayoutMode)
}
class ProductCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
    }
    private func setupUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.clipsToBounds = true
        
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
    }
    private func configure(with model: ProductItemViewModel, layout: LayoutMode) {
        hideSkeleton()
        titleLabel.text = model.title
        priceLabel.text = model.price
        productImageView.image = model.image
        self.productImageView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.productImageView.alpha = 1
        }
        layoutIfNeeded()
    }
    func showSkeleton() {
        // Clear previous content
            productImageView.image = nil
            titleLabel.text = ""
            priceLabel.text = ""

            // Set background colors
            productImageView.backgroundColor = .systemGray5
            titleLabel.backgroundColor = .systemGray5
            priceLabel.backgroundColor = .systemGray5

            // Start shimmer on each component
            productImageView.startShimmer()
            titleLabel.startShimmer()
            priceLabel.startShimmer()
    }
    private func hideSkeleton() {
        productImageView.backgroundColor = .clear
            titleLabel.backgroundColor = .clear
            priceLabel.backgroundColor = .clear

            productImageView.stopShimmer()
            titleLabel.stopShimmer()
            priceLabel.stopShimmer()
    }
}
extension ProductCell: ProductCellProtocol {
    func displayCell(product: ProductItemViewModel, layout: LayoutMode) {
        configure(with: product, layout: layout)
    }
}
