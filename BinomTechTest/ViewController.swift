//
//  ViewController.swift
//  BinomTechTest
//
//  Created by sergey on 22.08.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var current = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func zoomIn() {
        var region = mapView.region
        guard region.span.latitudeDelta / 2 > 1/60 && region.span.longitudeDelta > 1/60 else {
            return
        }
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: false)
    }
    
    @objc func zoomOut() {
        var region = mapView.region
        guard region.span.latitudeDelta * 2 <= 180 && region.span.longitudeDelta * 2 <= 180 else {
            return
        }
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapView.setRegion(region, animated: false)
    }
    
    @objc func nextTracker() {
        if current >= mapView.annotations.count {
            current = 0
        }
        guard !mapView.annotations.isEmpty else { return }
        mapView.setCenter(mapView.annotations[current].coordinate, animated: true)
        current += 1
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
            sheet.detents = [.custom(identifier: .medium,resolver: { context in
                context.maximumDetentValue * 0.2
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
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: PinAnnotationView.id)
        let urlTeplate = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: urlTeplate)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
        mapView.delegate = self
        view.addSubview(mapView)
        let ant = PinAnnotation()
        ant.coordinate = .init(latitude: 41.6929, longitude: 44.8082)
        ant.title = "Илья"
        ant.image = .init(named: "avatar")
        mapView.addAnnotation(ant)
        let ant2 = PinAnnotation()
        let ant3 = PinAnnotation()
        ant2.coordinate = .init(latitude: 40, longitude: 40)
        ant3.coordinate = .init(latitude: 45, longitude: 40)
        mapView.addAnnotations([
            ant2,ant3
        ])
        mapView.frame = view.frame
        mapView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        mapView.showsUserLocation = true
    }
    private func setupButtons() {
        [
            (zoomInButton,UIImage(named: "zin")),
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



