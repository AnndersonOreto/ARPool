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
    var configured = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(_:)))
        sceneView.addGestureRecognizer(panGesture)
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
    
    @objc func panGesture( _ gesture: UIPanGestureRecognizer){
        gesture.minimumNumberOfTouches = 1
        
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        
        guard let result : ARHitTestResult = results.first else {return}
        
        let hits = self.sceneView.hitTest(gesture.location(in: gesture.view), options: nil)
        
        if let tappedNode = hits.first?.node{
            if tappedNode.geometry is SCNSphere {
                let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                tappedNode.position = position
            }
        }
        
    }
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if configured{
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults2 = sceneView.hitTest(tapLocation, options: nil)

            guard let planeNode = hitTestResults2.first?.node.geometry as? SCNPlane else { return }
            
            let tube = SCNTube(innerRadius: planeNode.height/2, outerRadius: planeNode.height/2 + 0.05, height: 0.6)
            let tubeMaterial = SCNMaterial()
            tubeMaterial.diffuse.contents = UIImage(named: "tubeWall")
            tube.materials = [tubeMaterial]
            let tubeNode = SCNNode(geometry: tube)
            let shape = SCNPhysicsShape(geometry: tube, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
            
            tubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            tubeNode.position = SCNVector3(Float((hitTestResults2.first?.node.position.x)!), Float((hitTestResults2.first?.node.position.y)!+0.05), Float((hitTestResults2.first?.node.position.z)!))
            currentNode.parent?.addChildNode(tubeNode)
            
            let circle = SCNCylinder(radius: planeNode.height/2 , height: 0.0)
            let circleMaterial = SCNMaterial()
            circleMaterial.diffuse.contents = UIImage(named: "poolFloor")
            circle.materials = [circleMaterial]
            let circleNode = SCNNode(geometry: circle)
            circleNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            circleNode.position = SCNVector3(Float((hitTestResults2.first?.node.position.x)!), Float((hitTestResults2.first?.node.position.y)!+0.05), Float((hitTestResults2.first?.node.position.z)!))
            currentNode.parent?.addChildNode(circleNode)
            
            currentNode.geometry?.materials.first?.transparency = 0
            configured = false
            
            createBall(node: hitTestResults2.first!.node, plane: planeNode)
        }else{return}
    }
    func createBall(node: SCNNode, plane: SCNPlane) {
        for _ in 0..<2000{
            let ball = SCNSphere(radius: 0.05)
            let ballMaterial = SCNMaterial()
            let number = Int.random(in: 0...3)
            
            switch number{
            case 0:
                ballMaterial.diffuse.contents = UIColor.red
            case 1:
                ballMaterial.diffuse.contents = UIColor.blue
            case 2:
                ballMaterial.diffuse.contents = UIColor.yellow
            case 3:
                ballMaterial.diffuse.contents = UIColor.green
            default:
                break
            }
            
            ball.materials = [ballMaterial]
            let ballNode = SCNNode(geometry: ball)
            ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            ballNode.position = SCNVector3(x: Float.random(in: (node.position.x - 0.75)...(node.position.x + 0.75)), y: Float.random(in: (node.position.y + 2.5)...(node.position.y + 3.0)), z: Float.random(in: (node.position.z - 0.75)...(node.position.z + 0.75)))
            currentNode.parent?.addChildNode(ballNode)
        }
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
        if plane.height > 1.5 && plane.width > 1.5{
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
