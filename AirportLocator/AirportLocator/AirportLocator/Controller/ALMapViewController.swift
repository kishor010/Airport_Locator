//
//  ALMapViewController.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ALMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    var presenter: ALMapPresenter?
    var currentLatitude : String?
    var currentLongitude : String?
    
    //MARK: APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        presenter = ALMapPresenter(alMapService: ALMapService())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Locator"
        locationManagerSetup()
        dertermineCurrentLocation()
    }
    
    //MARK: INITIAL SETUP
    private func locationManagerSetup() {
        self.locationManager?.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
        //dertermineLocation()
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        presenter?.attachView(view: self)
    }
    
    //MARK: ALLOW ACCESS FOR CURRENT LOCATION
    private func dertermineCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.currentLatitude = "0.0"
                self.currentLongitude = "0.0"
            case .authorizedAlways, .authorizedWhenInUse:
                guard let currentLocation = locationManager?.location else {
                    return
                }
                self.currentLatitude = String(currentLocation.coordinate.latitude)
                self.currentLongitude = String(currentLocation.coordinate.longitude)
                presenter?.airportListAPI(latitude:currentLatitude ?? "0.0",longitude:currentLongitude ?? "0.0")
                
            @unknown default:
                print("Location services are not enabled")
            }
        } else {
            print("Location services are not enabled")
        }
    }
}
    
 //MARK: CLLocationManagerDelegate
extension ALMapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
        mapView.setRegion(region, animated: true)
       
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
    
//MARK: - Protocols Implementation
extension ALMapViewController: MapControllerView {
    func onSuccess(list: AirportListModel) {
        if list.isSuccess == true{
            let annotations = list.results.map { location -> MKAnnotation in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                if let currentLocation = locationManager?.location {
                    let currentLocationCoordinate = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                   let coordinateDistance = CLLocation(latitude: location.latitude, longitude: location.longitude)
                   let distanceInMeters = coordinateDistance.distance(from: currentLocationCoordinate)
                    if distanceInMeters < 1000 {
                        let strDistance = String(format: "%.2f", distanceInMeters)
                                          annotation.subtitle = "Distance: " + strDistance + "M"
                    }
                    else {
                        let strDistance = String(format: "%.2f", (distanceInMeters/1000))
                        annotation.subtitle = "Distance: " + strDistance + "KM"
                    }
                }
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                return annotation
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func startLoading() {
        // Show your loader
        showProgressIndicator(view: self.view)
    }
    
    func finishLoading() {
        // Dismiss your loader
        hideProgressIndicator(view: self.view)
    }
    
    func showError(errorMessage: String) {
        // show error loader
        Utils.showAlert(AlertTitle: errorMessage, AlertMessage: "", controller: self)
    }
}
