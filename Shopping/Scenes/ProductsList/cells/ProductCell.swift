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
    var imageTask: Task<Void, Never>?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        productImageView.image = nil
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
        //loadImage(from: model.imageURL)
        self.productImageView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.productImageView.alpha = 1
        }
        switch layout {
        case .list:
            titleLabel.numberOfLines = 2
        case .grid:
            titleLabel.numberOfLines = 3
        }
        
        layoutIfNeeded()
    }
    
//    private func loadImage(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        imageTask?.cancel()
//        imageTask = Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                if Task.isCancelled { return }
//                await MainActor.run {
//                    self.productImageView.image = UIImage(data: data)
//                }
//            } catch {
//                print("Image Error:", error)
//            }
//        }
//    }
}
extension ProductCell: ProductCellProtocol {
    func displayCell(product: ProductItemViewModel, layout: LayoutMode) {
        configure(with: product, layout: layout)
    }
}
