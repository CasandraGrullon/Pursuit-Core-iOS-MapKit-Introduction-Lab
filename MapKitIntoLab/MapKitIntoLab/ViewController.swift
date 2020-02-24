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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return annotations
    }
    private func loadMapView() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    private func convertCoordinateToPlacemark(for school: School) {
        let location = coordinates(lat: school.latitude, long: school.longitude)
        locationSession.convertCoordinateToPlacemark(coordinate: location)
    }
    
    private func convertPlaceNameToCoordinate(for searchQuery: String) {
        locationSession.convertPlaceNameToCoordinate(addressString: searchQuery)
    }
    
    
}

