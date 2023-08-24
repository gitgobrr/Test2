//
//  SheetViewController.swift
//  BinomTechTest
//
//  Created by sergey on 23.08.2023.
//

import UIKit
import MapKit

class SheetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let labelStack = UIStackView()
    let detailsStack = UIStackView()
    let stackView = UIStackView()
    let gpsLabel = UILabel()
    let timeLabel = UILabel()
    let dateLabel = UILabel()
    let storiesButton = UIButton()
    
    init(annotationView: MKAnnotationView) {
        imageView.image = annotationView.image
        if let title = annotationView.annotation?.title {
            nameLabel.text = title
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    private func makeIconedLabel(image: UIImage?, title: String) -> UIStackView {
        let image = UIImageView(image: image)
        let label = UILabel()
        label.text = title
        let stack = UIStackView(arrangedSubviews: [image,label])
        stack.axis = .horizontal
        stack.alignment = .bottom
        return stack
    }
    
    private func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 56/2
        view.backgroundColor = .systemBackground
        detailsStack.addArrangedSubviews([
            makeIconedLabel(image: .init(systemName: "wifi"), title: "GPS"),
            makeIconedLabel(image: .init(systemName: "calendar"), title: "02.07.17"),
            makeIconedLabel(image: .init(systemName: "clock"), title: "14:00")
        ])
        detailsStack.axis = .horizontal
        detailsStack.distribution = .equalSpacing
        detailsStack.alignment = .bottom
        labelStack.addArrangedSubviews([nameLabel,detailsStack])
        labelStack.axis = .vertical
        
        labelStack.distribution = .equalSpacing
        
        
        stackView.addArrangedSubviews([imageView, labelStack])
        view.addSubview(stackView)
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "Посмотреть историю"
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 8, leading: 32, bottom: 8, trailing: 32)
        
        storiesButton.configuration = config
        
        view.addSubview(storiesButton)
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 8
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        storiesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: storiesButton.topAnchor),
            storiesButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 56),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
