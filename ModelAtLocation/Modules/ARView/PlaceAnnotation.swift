//
//  PlaceAnnotation.swift
//  ARTool
//
//  Created by Ghazalah on 14/12/17.
//  Copyright © 2017 Ghazalah. All rights reserved.
//

import Foundation
import ARCL
import CoreLocation
import SceneKit
import SpriteKit

class PlaceAnnotation: LocationNode {
    var title: String!
    var annotationNode: SCNNode
    var distance: String = "Model is placed here"
    
    init(location: CLLocation?, title: String) {
        let poiScene = SCNScene(named:
            "art.scnassets/ship.scn")!
        let poiNode =  poiScene.rootNode.childNode(
            withName: "ship", recursively: true)

        self.annotationNode = (poiNode?.clone())!
//        self.annotationNode = SCNNode()
        self.title = title

        super.init(location: location)

        initialize2DUI()
        
//        let poiScene = SCNScene(named:
//            "POI.scnassets/POIAnnotationNew.scn")!

//        self.annotationNode = SCNNode()
//        self.title = title
//
//        super.init(location: location)
//        initializeUI()

    }
    
    private func center(node: SCNNode) {
        let (min,max) = node.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
    }
    
    private func initializeUI() {
        
        let plane = SCNPlane(width: 4, height: 3)
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 4, height: 1)
        text.isWrapped = true
        text.font = UIFont(name: "Futura", size: 0.4)
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0, 0.2)
        center(node: textNode)
        
        let imagePlane = SCNPlane(width: 1, height: 1)
        imagePlane.cornerRadius = 0.1
        imagePlane.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "car")
        
        let imageNode = SCNNode(geometry: imagePlane)
        imageNode.position = SCNVector3(0, -1, 0.2)
        
        let textDistance = SCNText(string: self.distance, extrusionDepth: 0)
        textDistance.containerFrame = CGRect(x: 0, y: 0, width: 5, height: 1)
        textDistance.isWrapped = true
        textDistance.font = UIFont(name: "Futura", size: 0.4)
        textDistance.alignmentMode = kCAAlignmentCenter
        textDistance.truncationMode = kCATruncationMiddle
        textDistance.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNodeDistance = SCNNode(geometry: textDistance)
        textNodeDistance.position = SCNVector3(0, -2, 0.2)
        center(node: textNodeDistance)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.addChildNode(textNode)
        planeNode.addChildNode(imageNode)
        planeNode.addChildNode(textNodeDistance)
        
        self.annotationNode.scale = SCNVector3(10,10,10)
        self.annotationNode.addChildNode(planeNode)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        self.addChildNode(self.annotationNode)
    }
    
    private func initialize2DUI(){
        self.addChildNode(self.annotationNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
