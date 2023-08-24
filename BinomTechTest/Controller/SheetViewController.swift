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
    let storiesButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "Посмотреть историю"
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: C.Spacing.small, leading: C.Spacing.large, bottom: C.Spacing.small, trailing: C.Spacing.large)
        $0.configuration = config
        return $0
    }(UIButton())
    
    init(annotationView: MKAnnotationView) {
        imageView.image = annotationView.image
        if let title = annotationView.annotation?.title {
            nameLabel.text = title
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
private extension SheetViewController {
    func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(storiesButton)
        setupImageView()
        setupDetailsStack()
        setupLabelStack()
        setupStackView()
        makeConstraints()
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.roundCorners()
    }
    
    func setupDetailsStack() {
        detailsStack.addArrangedSubviews([
            makeIconedLabel(image: .init(systemName: "wifi"), title: "GPS"),
            makeIconedLabel(image: .init(systemName: "calendar"), title: "02.07.17"),
            makeIconedLabel(image: .init(systemName: "clock"), title: "14:00")
        ])
        detailsStack.axis = .horizontal
        detailsStack.distribution = .equalSpacing
        detailsStack.alignment = .bottom
    }
    
    func setupLabelStack() {
        labelStack.addArrangedSubviews([nameLabel,detailsStack])
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing
        nameLabel.font = .boldSystemFont(ofSize: C.Spacing.medium)
    }
    
    func setupStackView() {
        stackView.addArrangedSubviews([imageView, labelStack])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = C.Spacing.small
    }
    
    func makeIconedLabel(image: UIImage?, title: String) -> UIStackView {
        let image = UIImageView(image: image)
        let label = UILabel()
        label.text = title
        let stack = UIStackView(arrangedSubviews: [image,label])
        stack.axis = .horizontal
        stack.alignment = .bottom
        return stack
    }
    
    func makeConstraints() {
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        storiesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.Spacing.medium),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: C.Spacing.medium),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.Spacing.medium),
            stackView.bottomAnchor.constraint(equalTo: storiesButton.topAnchor),
            storiesButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: C.bottomSheetImageHeight),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
