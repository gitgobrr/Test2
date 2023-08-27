//
//  Extensions.swift
//  BinomTechTest
//
//  Created by sergey on 23.08.2023.
//


import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func roundCorners() {
        clipsToBounds = true
        layer.cornerRadius = frame.height/2
    }
}
