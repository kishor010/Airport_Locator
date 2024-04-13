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
        self.title = Utils.localizedString(forKey:Keys.locator, table: nil)
        locationManagerSetup()
        dertermineCurrentLocation()
    }
    
    //MARK: INITIAL SETUP
    private func locationManagerSetup() {
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        presenter?.attachView(view: self)
    }
    
    //MARK: ALLOW ACCESS FOR CURRENT LOCATION
    private func dertermineCurrentLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingLocation()
                let manager = CLLocationManager()
                switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.currentLatitude = "0.0"
                    self.currentLongitude = "0.0"
                case .authorizedAlways, .authorizedWhenInUse:
                    guard let currentLocation = self.locationManager?.location else {
                        return
                    }
                    self.currentLatitude = String(currentLocation.coordinate.latitude)
                    self.currentLongitude = String(currentLocation.coordinate.longitude)
                    self.presenter?.airportListAPI(latitude: self.currentLatitude ?? "0.0",longitude: self.currentLongitude ?? "0.0")
                    
                @unknown default:
                    print("Location services are not enabled")
                }
            } else {
                print("Location services are not enabled")
            }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            dertermineCurrentLocation()
        }
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
        showProgressIndicator(view: self.view)
    }
    
    func finishLoading() {
        hideProgressIndicator(view: self.view)
    }
    
    func showError(errorMessage: String) {
        Utils.showAlert(AlertTitle: errorMessage, AlertMessage: "", controller: self)
    }
}
