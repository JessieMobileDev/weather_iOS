//
//  MapViewController.swift
//  weather_app
//
//  Created by Jessica on 3/29/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // Variables
    var cityName = ""
    var estateName = ""
    var countryName = ""
    let locationManager = CLLocationManager()
    var cityWeatherUrl1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    var cityWeatherUrl2: String = "&appid=07d507ff7042b77082e11242514fb182&units=imperial"
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }
    
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            setUpLocationManager()
            checkLocationAuthorization()
            
        } else {
            
            // Alert the user that the location services are disabled and it needs to enable it
            showAlert(title: "Permissions", message: "Please, enable the location services in your phone", positiveBtn: "OK")
        }
    }
    
    func setUpLocationManager() {
        
        // Set up the location manager delegate to allow delegate functions to trigger
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func zoomInUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            zoomInUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert explaining how to turn on the permissions again
            showAlert(title: "Permissions", message: "You can enable locations for the app in your phone settings later on", positiveBtn: "OK")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert explaining that the phone has restrictions from parent level
            showAlert(title: "Permissions", message: "Your phone has location restriction", positiveBtn: "OK")
        case .authorizedAlways:
            break
        }
    }
    
    func showAlert(title: String, message: String, positiveBtn: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: positiveBtn, style: UIAlertAction.Style.default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func tapOnMap(_ sender: UITapGestureRecognizer) {
        
        if ConnectionHandler.Connection() {
            
            // Retrieve the location where the user tapped on the map
            let location = sender.location(in: self.mapView)
            let locationCoordinates = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            
            // Convert location to address to retrieve the city name
            let geoCoder = CLGeocoder()
            let latAndLon = CLLocation(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude)
            
            geoCoder.reverseGeocodeLocation(latAndLon) { [weak self](placemarks, error)  in
                
                guard let self = self else { return }
                
                if let _ = error {
                    
                    // Show alert informing the user
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    
                    // Show alert informing the user
                    return
                }
                
                self.cityName = placemark.locality ?? ""
                self.estateName = placemark.subAdministrativeArea ?? ""
                self.countryName = placemark.country ?? ""
                
                DispatchQueue.main.async {
                    
                    // Assign values to the annotation
                    annotation.coordinate = locationCoordinates
                    annotation.title = self.cityName
                    annotation.subtitle = "Bookmark"
                    
                    // Apply the annotation to the map
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotation(annotation)
                }
                
                // Display an alert to double check if the user would like to bookmark the selected city
                let message = "Would you like to bookmark " + self.cityName + "?"
                let alert = UIAlertController(title: "Bookmark", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
                    
                    // Perform the unwind segue to pass the weather data back to Home Screen
                    self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            
            showAlert(title: "No connection", message: "Turn on the connection on your phone to proceed", positiveBtn: "OK")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Update location when changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    // When permission authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}
