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
        // Disable animation to avoid flicker
        productImageView.image = nil
        productImageView.backgroundColor = UIColor.systemGray5

        titleLabel.text = ""
        titleLabel.backgroundColor = UIColor.systemGray5
        titleLabel.layer.cornerRadius = 4
        titleLabel.clipsToBounds = true

        priceLabel.text = ""
        priceLabel.backgroundColor = UIColor.systemGray5
        priceLabel.layer.cornerRadius = 4
        priceLabel.clipsToBounds = true
    }
    func hideSkeleton() {
        productImageView.backgroundColor = .clear
        titleLabel.backgroundColor = .clear
        priceLabel.backgroundColor = .clear
    }
}
extension ProductCell: ProductCellProtocol {
    func displayCell(product: ProductItemViewModel, layout: LayoutMode) {
        configure(with: product, layout: layout)
    }
}
