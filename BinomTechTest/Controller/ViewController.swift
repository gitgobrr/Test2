//
//  ViewController.swift
//  BinomTechTest
//
//  Created by sergey on 22.08.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let locatoinManager = LocationDataManager()
    let mapView = MKMapView()
    let zoomInButton = UIButton()
    let zoomOutButton = UIButton()
    let myLocationButton = UIButton()
    let nextTrackerButton = UIButton()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        return stack
    }()
    
    var currentAnnotationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func zoomIn() {
        mapView.camera.centerCoordinateDistance /= 1.5
    }
    
    @objc func zoomOut() {
        mapView.camera.centerCoordinateDistance *= 1.5
    }
    
    @objc func nextTracker() {
        if currentAnnotationIndex >= mapView.annotations.count {
            currentAnnotationIndex = 0
        }
        guard !mapView.annotations.isEmpty else { return }
        mapView.setCenter(mapView.annotations[currentAnnotationIndex].coordinate, animated: true)
        currentAnnotationIndex += 1
    }
    
    @objc func snapToMyLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    deinit {
        mapView.delegate = nil
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else {
            return MKTileOverlayRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        let vc = SheetViewController(annotationView: view)
        if view.annotation is PinAnnotation {
            vc.imageView.image = UIImage(named: "avatar")
        }
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(identifier: .medium,resolver: { _ in
                C.bottomSheetImageHeight+vc.storiesButton.intrinsicContentSize.height+C.Spacing.medium
            })]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        present(vc, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation:
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.image = UIImage(named: "myloc")
            return view
        case is PinAnnotation:
            return mapView.dequeueReusableAnnotationView(withIdentifier: PinAnnotationView.id, for: annotation)
        default:
            return nil
        }
    }
}
extension ViewController {
    private func setup() {
        setupMap()
        setupStackView()
        setupButtons()
    }
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubviews([
            zoomInButton,
            zoomOutButton,
            myLocationButton,
            nextTrackerButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    private func setupMap() {
        let urlTeplate = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: urlTeplate)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        mapView.showsUserLocation = true
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: PinAnnotationView.id)
        
        for i in 0..<3 {
            let annotation = PinAnnotation()
            let coordinates: (Double, Double) = (.random(in: -45...45), .random(in: -45...45))
            annotation.coordinate = .init(latitude: CLLocationDegrees(coordinates.0), longitude: CLLocationDegrees(coordinates.1))
            annotation.title = "annotation \(i)"
            annotation.image = .init(named: "avatar")
            mapView.addAnnotation(annotation)
        }
        mapView.cameraZoomRange = .init(
            minCenterCoordinateDistance: C.Map.minCenterCoordinateDistance,
            maxCenterCoordinateDistance: mapView.cameraZoomRange.maxCenterCoordinateDistance
        )
    }
    
    private func setupButtons() {
        [(zoomInButton,UIImage(named: "zin")),
         (zoomOutButton,UIImage(named: "zout")),
         (myLocationButton,UIImage(named: "myloc")),
         (nextTrackerButton,UIImage(named: "nxttrack"))
        ].forEach { (btn, img) in
            print(btn)
            btn.setImage(img, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
        }
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        myLocationButton.addTarget(self, action: #selector(snapToMyLocation), for: .touchUpInside)
        nextTrackerButton.addTarget(self, action: #selector(nextTracker), for: .touchUpInside)
    }
}



