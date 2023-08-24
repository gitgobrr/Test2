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
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        canShowCallout = true
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        let view = UIImageView(image: .init(named: "track"))
        let avatar = UIImageView(image: .init(named: "avatar"))
        
        addSubview(view)
        addSubview(avatar)
        
        avatar.frame = frame.insetBy(dx: 7, dy: 7)
        avatar.frame = avatar.frame.offsetBy(dx: 0, dy: -3.5)
        view.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
