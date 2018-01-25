//
//  ARViewController.swift
//  ModelAtLocation
//
//  Created by Ghazalah on 24/01/18.
//  Copyright © 2018 Ghazalah. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import MapKit
import ARKit

class ARViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var backButton: UIButton!
    
    var sceneLocationView = SceneLocationView()
    var location: CLLocation?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
//        sceneLocationView.delegate = self
        sceneLocationView.antialiasingMode = .multisampling4X
        
        view.addSubview(sceneLocationView)
        view.bringSubview(toFront: backButton)
        
        
        self.perform(#selector(addNode), with: nil, afterDelay: 3.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        sceneLocationView.run()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    private func removeGestureRecognizers() {
        for recognizer in sceneLocationView.gestureRecognizers! {
            self.sceneLocationView.removeGestureRecognizer(recognizer)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func addNode(){
        
        
        guard let location = location, let currentLocation = currentLocation else {
            return
        }
        
        let newLocation = CLLocation(coordinate: location.coordinate, altitude: currentLocation.altitude) //CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.42853666751499, longitude: 77.308477610421647), altitude: currentLocation.altitude)//
        
        print("AR Location -> \(String(describing: self.location)) and altitude -> \(currentLocation.altitude)")
        
        let placeAnnotationNode = PlaceAnnotation(location: newLocation, title: "AR Node")
        
        DispatchQueue.main.async {
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
            print(self.sceneLocationView.sceneNode ?? "")
        }
    }

    
    @IBAction func onClickUpBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension ARViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
}
