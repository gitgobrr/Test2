//
//  PinAnnotation.swift
//  BinomTechTest
//
//  Created by sergey on 24.08.2023.
//

import UIKit
import MapKit


class PinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = .init()
    var image: UIImage?
    var title: String?
    var subtitle: String?
}

class PinAnnotationView: MKAnnotationView {
    static let id = "mypin"

    private let container = Capsule()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: C.pinAnnotationHeight, height: C.pinAnnotationHeight)
        canShowCallout = true
        setupUI()
    }
    
    private func setupUI() {
        let view = UIImageView(image: .init(named: "track"))
        let avatar = UIImageView(image: .init(named: "avatar"))
        
        addSubview(view)
        addSubview(avatar)
        
        avatar.frame = frame.insetBy(dx: 7, dy: 7)
        avatar.frame = avatar.frame.offsetBy(dx: 0, dy: -3.5)
        view.frame = bounds
        
        addCalloutOverlay()
    }
    
    private func addCalloutOverlay() {
        let nameLabel = UILabel()
        nameLabel.text = "Илья"
        let subLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .headline).withSize(14)
        subLabel.font = .preferredFont(forTextStyle: .callout).withSize(12)
        subLabel.textColor = .lightGray
        subLabel.text = "GPS, 14:00"
        let stack = UIStackView(arrangedSubviews: [nameLabel,subLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        container.addSubview(stack)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(container)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: C.Spacing.small),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: C.Spacing.small),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -C.Spacing.medium),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -C.Spacing.small),
            
            container.centerXAnchor.constraint(equalTo: centerXAnchor, constant: frame.width),
            container.topAnchor.constraint(equalTo: bottomAnchor),
        ])
        container.backgroundColor = .systemBackground
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Capsule: UIView {
    override func layoutSubviews() {
        roundCorners()
    }
}
