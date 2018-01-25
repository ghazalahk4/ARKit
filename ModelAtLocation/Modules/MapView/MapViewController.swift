//
//  MapViewController.swift
//  ModelAtLocation
//
//  Created by Ghazalah on 24/01/18.
//  Copyright © 2018 Ghazalah. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var currentLatLongLabel: UILabel!
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 100
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        indicatorView.startAnimating()
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleTap(gestureReconizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        for annotation in mapView.annotations {
            if annotation.title ?? "" != "Current location" {
                mapView.removeAnnotation(annotation)
            }
        }
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = "View in AR"
        
        mapView.addAnnotation(pointAnnotation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.K_MOVE_TO_AR_VIEW {
            if let controller = segue.destination as? ARViewController{
                controller.location = sender as? CLLocation
                controller.currentLocation = currentLocation
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print("Accuracy ->\(location!.horizontalAccuracy)")
        if location!.horizontalAccuracy >= 100.0{
            return
        }

        if let currentLocation = currentLocation {
            if location!.horizontalAccuracy < currentLocation.horizontalAccuracy{
                self.currentLocation = location
            }else{
                return
            }
        }
        currentLocation = location
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        currentLatLongLabel.text = String(describing: location!.coordinate)
        centerMapOnLocation(location: currentLocation!)
        indicatorView.stopAnimating()
        
        for annotation in mapView.annotations {
            if annotation.title ?? "" == "Current location" {
                mapView.removeAnnotation(annotation)
            }
        }
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error -> \(error.localizedDescription)")
    }
    
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let location = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        self.performSegue(withIdentifier: SegueIdentifier.K_MOVE_TO_AR_VIEW, sender: location)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        let customPointAnnotation = annotation
//        annotationView?.image = #imageLiteral(resourceName: "pin")
//
//        return annotationView
//    }
    
}
