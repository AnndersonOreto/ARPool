//
//  ViewController.swift
//  ARPool
//
//  Created by Annderson Packeiser Oreto on 21/05/19.
//  Copyright © 2019 Annderson Packeiser Oreto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var currentNode: SCNNode = SCNNode()
    var conf = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.addShipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        let hitTestResults2 = sceneView.hitTest(tapLocation, options: nil)
//        let translation = hitTestResults.worldTransform.translation
//        let x = translation.x
//        let y = translation.y
//        let z = translation.z
        guard let planeNode = hitTestResults2.first?.node.geometry as? SCNPlane else { return }
        
        let tube = SCNTube(innerRadius: planeNode.height/2, outerRadius: planeNode.height/2, height: 0.1)
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.position = SCNVector3(Float((hitTestResults2.first?.node.position.x)!), Float((hitTestResults2.first?.node.position.y)!+0.05), Float((hitTestResults2.first?.node.position.z)!))
        currentNode.parent?.addChildNode(tubeNode)
    }
}

extension ViewController: ARSCNViewDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Safely unwrapping anchor as ARPlaneAnchor
        if conf{
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            
            // Creating a plan based on anchor points in x and z coordinates
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            let plane = SCNPlane(width: width, height: height)
            
            plane.materials.first?.diffuse.contents = UIColor.lightGray
            
            let planeNode = SCNNode(geometry: plane)
            
            // Adding plane in the space with actual coordinates
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x,y,z)
            planeNode.eulerAngles.x = -.pi / 2
            
            // Adding this object as a child of the actual node
            node.addChildNode(planeNode)
            currentNode = planeNode
            conf = false
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    
            guard let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes.first, let plane = planeNode.geometry as? SCNPlane else { return }
        
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            plane.width = width
            plane.height = height
        
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
        if plane.height > 1 && plane.width > 1{
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
        }
        planeNode.position = SCNVector3(x, y, z)
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
