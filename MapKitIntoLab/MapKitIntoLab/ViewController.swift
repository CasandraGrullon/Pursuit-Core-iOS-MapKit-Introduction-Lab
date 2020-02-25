//
//  ViewController.swift
//  MapKitIntoLab
//
//  Created by casandra grullon on 2/24/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    private var schools = [School]()
    
    private var locationSession = CoreLocationSession()
    
    private var annotations = [MKAnnotation]()
    
    private var isShowingAnnotations = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadMapView()
        loadSchools()
        mapView.showsUserLocation = true
        searchBar.delegate = self
        mapView.delegate = self
    }
    
    private func loadSchools() {
        SchoolAPIClient.getSchools { (result) in
            switch result {
            case .failure(let appError) :
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let schools):
                DispatchQueue.main.async {
                    self.schools = schools
                    self.loadMapView()
                }
            }
        }
    }
    private func coordinates(lat: String, long: String) -> CLLocationCoordinate2D {
        let latitude = Double(lat) ?? 0
        let longitude = Double(long) ?? 0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return location
    }
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        for school in schools {
            let annotation = MKPointAnnotation()
            let location = coordinates(lat: school.latitude, long: school.longitude)
            annotation.coordinate = location
            annotation.title = school.schoolName
            annotations.append(annotation)
        }
        isShowingAnnotations = true
        self.annotations = annotations
        return annotations
    }
    private func loadMapView() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    private func convertPlaceNameToCoordinate(for searchQuery: String) {
        locationSession.convertPlaceNameToCoordinate(addressString: searchQuery) { (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "\(appError)")
                }
            case .success(let coordinates):
                let region =  MKCoordinateRegion(center: coordinates, latitudinalMeters: 1600, longitudinalMeters: 1600)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        convertPlaceNameToCoordinate(for: searchText)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        guard let school = (schools.filter {$0.schoolName == annotation.title}).first else {
            return
        }
        guard let detailVC = storyboard?.instantiateViewController(identifier: "LocationDetailViewController", creator: { (coder) in
            return LocationDetailViewController(coder: coder, school: school)
        }) else {
            fatalError("could not access LocationDetailViewController")
        }
        present(detailVC, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(systemName: "book")
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingAnnotations {
            mapView.showAnnotations(annotations, animated: true)
        }
        isShowingAnnotations = false
    }
}
