//
//  +UIView.swift
//  Shopping
//
//  Created by Mai on 27/01/2026.
//
import UIKit

extension UIView {

    func startShimmer() {
        let light = UIColor.white.withAlphaComponent(0.6).cgColor
        let dark = UIColor.lightGray.withAlphaComponent(0.3).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [dark, light, dark]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        gradientLayer.name = "shimmerLayer"

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "shimmerAnimation")
        self.layer.addSublayer(gradientLayer)
    }

    func stopShimmer() {
        self.layer.sublayers?
            .filter { $0.name == "shimmerLayer" }
            .forEach { $0.removeFromSuperlayer() }
    }
}
