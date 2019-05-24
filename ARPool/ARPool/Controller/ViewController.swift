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
    var touched = false
    var teste1: SCNNode = SCNNode()
    var timer: Timer = Timer()
    var goal: SCNNode = SCNNode()
    
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
        let a = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        sceneView.addGestureRecognizer(a)
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
        //        gesture.minimumNumberOfTouches = 1
        //
        //        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        //
        //        guard let result : ARHitTestResult = results.first else {return}
        //
        //        let hits = self.sceneView.hitTest(gesture.location(in: gesture.view), options: nil)
        //
        //        if let tappedNode = hits.first?.node{
        //            if tappedNode.geometry is SCNSphere {
        //                let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        //                tappedNode.position = position
        //            }
        //        }
        
    }
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if configured{
            
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults2 = sceneView.hitTest(tapLocation, options: nil)
            
            if let planeNode = currentNode.geometry as? SCNPlane {
                
                let tube = SCNTube(innerRadius: planeNode.height/2, outerRadius: planeNode.height/2 + 0.05, height: 0.6)
                let tubeMaterial = SCNMaterial()
                tubeMaterial.diffuse.contents = UIImage(named: "tubeWall")
                tube.materials = [tubeMaterial]
                let tubeNode = SCNNode(geometry: tube)
                let shape = SCNPhysicsShape(geometry: tube, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
                
                tubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
                tubeNode.position = SCNVector3(Float((currentNode.position.x)), Float((currentNode.position.y)+0.25), Float((currentNode.position.z)))
                currentNode.parent?.addChildNode(tubeNode)
                
                let circle = SCNCylinder(radius: planeNode.height/2 , height: 0.0)
                let circleMaterial = SCNMaterial()
                circleMaterial.diffuse.contents = UIImage(named: "poolFloor")
                circle.materials = [circleMaterial]
                let circleNode = SCNNode(geometry: circle)
                circleNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                circleNode.position = SCNVector3(Float((currentNode.position.x)), Float(tubeNode.position.y-0.3), Float((currentNode.position.z)))
                currentNode.parent?.addChildNode(circleNode)
                
                let tube2 = SCNTube(innerRadius: planeNode.height*3, outerRadius: planeNode.height*3.1 + 0.05, height: 4.0)
                let tubeNode2 = SCNNode(geometry: tube2)
                let shape2 = SCNPhysicsShape(geometry: tube2, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
                
                let tube2Material = SCNMaterial()
                tube2Material.diffuse.contents = UIImage(named: "panorama")
                tube2.materials = [tube2Material]
                
                tubeNode2.physicsBody = SCNPhysicsBody(type: .static, shape: shape2)
                tubeNode2.geometry?.materials.first?.transparency = 0
                tubeNode2.position = SCNVector3(Float((currentNode.position.x)), Float((currentNode.position.y)+0.26), Float((currentNode.position.z)))
                currentNode.parent?.addChildNode(tubeNode2)
                
                let tube3 = SCNTube(innerRadius: 0.5, outerRadius: 0.5, height: 1.0)
                let tubeNode3 = SCNNode(geometry: tube3)
                let shape3 = SCNPhysicsShape(geometry: tube3, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
                
                tube3.materials.first?.diffuse.contents = UIColor.blue
                
                tubeNode3.physicsBody = SCNPhysicsBody(type: .static, shape: shape3)
                tubeNode3.runAction(SCNAction.sequence([SCNAction.fadeOpacity(to: 0.4, duration: 1.0), SCNAction.fadeOpacity(to: 0.8, duration: 1.0)]))
                tubeNode3.geometry?.materials.first?.transparency = 0.5
                tubeNode3.position = SCNVector3(Float((currentNode.position.x)+2.0), Float((currentNode.position.y)+0.26), Float((currentNode.position.z)))
                currentNode.parent?.addChildNode(tubeNode3)
                goal = tubeNode3
                
                let circle2 = SCNCylinder(radius: planeNode.height*3 , height: 0.0)
                let circleNode2 = SCNNode(geometry: circle2)
                circleNode2.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                circleNode2.geometry?.materials.first?.transparency = 0
                circleNode2.position = SCNVector3(Float((currentNode.position.x)), Float(tubeNode2.position.y-0.3), Float((currentNode.position.z)))
                currentNode.parent?.addChildNode(circleNode2)
                
                currentNode.geometry?.materials.first?.transparency = 0
                configured = false
                
                createBall(node: currentNode, plane: planeNode)
            }
        }else{
        }
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        var node = SCNNode()
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            if !touched {
                if let camera = sceneView.session.currentFrame?.camera {
                    var cameraTransform = camera.transform
                    let cameraDirection = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y,cameraTransform.columns.3.z)
                    
//                    let powX = pow(cameraDirection.x,2)
//                    let powY = pow(cameraDirection.y,2)
//                    let powZ = pow(cameraDirection.z,2)
//
//
//                    let v = sqrt(powX+powY+powZ)
//                    let ux = cameraDirection.x / v
//                    let uy = cameraDirection.y / v
//                    let uz = cameraDirection.z / v
//
//                    cameraTransform.columns.3.x = ux
//                    cameraTransform.columns.3.y = uy
//                    cameraTransform.columns.3.z = uz
                    let tapLocation = gestureReconizer.location(in: sceneView)
                    let hitTestResults2 = sceneView.hitTest(tapLocation, options: nil)
                    
                    if let sphereNode = hitTestResults2.first?.node{
                        // A GENTE NEM USA ESSE 'a'
                        if (sphereNode.geometry as? SCNBox) != nil {
                            //                    sphereNode.runAction(SCNAction.sequence([SCNAction.move(to: SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z), duration: 1.0)]))
                            //                    sphereNode.simdWorldTransform = cameraTransform//position = SCNVector3(Float(ux), Float(uy), Float(uz))
                            teste1 = sphereNode
                            teste1.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                            //node = sphereNode
                            touched = true
                            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(movement), userInfo: nil, repeats: true)
                        }
                    }
                }
            }
        }
        else {
            if let camera = sceneView.session.currentFrame?.camera {
                var cameraTransform = SCNMatrix4(camera.transform)
                let cameraDirection = SCNVector3(-1 * cameraTransform.m31, -1 * cameraTransform.m32,-1 * cameraTransform.m33)
                let powX = pow(cameraDirection.x,2)
                let powY = pow(cameraDirection.y,2)
                let powZ = pow(cameraDirection.z,2)
                
                
                let v = sqrt(powX+powY+powZ)
                let ux = cameraDirection.x / v
                let uy = cameraDirection.y / v
                let uz = cameraDirection.z / v
                
                cameraTransform.m31 = ux
                cameraTransform.m32 = uy
                cameraTransform.m33 = uz

                teste1.simdWorldTransform = simd_float4x4(cameraTransform)
                teste1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                if let a = goal.geometry as? SCNTube {
                    if (teste1.position.x < (goal.position.x + Float(a.height/2))) && (teste1.position.x > (goal.position.x - Float(a.height/2))) && (teste1.position.z < (goal.position.z + Float(a.height/2))) && (teste1.position.z > (goal.position.z - Float(a.height/2))) {
                        teste1.removeFromParentNode()
                    }
                }
                teste1 = SCNNode()
                //node.simdWorldTransform = cameraTransform
                touched = false
                timer.invalidate()
                timer = Timer()
            }
        }
    }
    
    @objc func movement() {
        if let camera = sceneView.session.currentFrame?.camera {
            var cameraTransform = SCNMatrix4(camera.transform)
            let cameraDirection = SCNVector3(-1 * cameraTransform.m31, -1 * cameraTransform.m32,-1 * cameraTransform.m33)
            let powX = pow(cameraDirection.x,2)
            let powY = pow(cameraDirection.y,2)
            let powZ = pow(cameraDirection.z,2)
            
            
            let v = sqrt(powX+powY+powZ)
            let ux = cameraDirection.x / v
            let uy = cameraDirection.y / v
            let uz = cameraDirection.z / v
            
            cameraTransform.m31 = ux
            cameraTransform.m32 = uy
            cameraTransform.m33 = uz
            
            teste1.simdWorldTransform = simd_float4x4(cameraTransform)
            
        }
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
        
        for _ in 0...9{
            let ball = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
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

extension ViewController: UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIImage(named: "grid")
            plane.materials = [planeMaterial]
            
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
            sceneView.debugOptions = []
            return
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
