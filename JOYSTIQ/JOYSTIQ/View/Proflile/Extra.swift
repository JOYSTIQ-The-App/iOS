//
//  Extra.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/14/23.
//

import Foundation


//START TEST
/*

func handleButtonPress() {
    
    // Find the "Walking" node in the scene hierarchy
    guard let walkingNode = scene.rootNode.childNode(withName: "Walking", recursively: true) else {
        return
    }
    
    // Find the "BACKPACK_01" child node within the "Walking" node
    guard let backpackNode = walkingNode.childNode(withName: "BACKPACK_01", recursively: true) else {
        return
    }
    
    // Remove the "BACKPACK_01" node from its parent
    backpackNode.removeFromParentNode()
}


//scene.rootNode.childNode(withName: "Walking", recursively: true)?.childNode(withName: "GRIP_01", recursively: true)?.removeFromParentNode()
 
 
 
 
 //FOR ZACHS2
 //scene.rootNode.childNode(withName: "Shorts", recursively: true)?.removeFromParentNode()
 //scene.rootNode.scale = SCNVector3(1.3, 1.3, 1.3)
 //scene.rootNode.position = SCNVector3(x: 0, y: 1.1, z: 0)
 
 //scene.rootNode.scale = SCNVector3(0.5, 1.3, 1.3)
 
 
 //configureCamera()
 
 
 // Load the Hair model
 let shortsURL = Bundle.main.url(forResource: "HairTest5", withExtension: "usdc")!
 let shortsScene = try! SCNScene(url: shortsURL, options: nil)
 let shortsNode = shortsScene.rootNode
 
 //add shorts as scene node
 scene.rootNode.addChildNode(shortsNode)
 
 
 //move positition of node
 var currentPosition = shortsNode.position
 
 // Update the y-component of the position to move it up
 currentPosition.z += 0.2
 currentPosition.y += 0.03

 // Assign the updated position back to the node
 shortsNode.position = currentPosition
 
*/
//END TEST

/*
private func addShortsToScene() {
   
    // Load the Shorts model
    let shortsURL = Bundle.main.url(forResource: "Shortsd", withExtension: "usdc")!
    let shortsScene = try! SCNScene(url: shortsURL, options: nil)
    let shortsNode = shortsScene.rootNode
    
    //add shorts as scene node
    scene.rootNode.addChildNode(shortsNode)
    
}
*/

/*
private func createAmbientLight(color: UIColor, intensity: CGFloat) -> SCNNode {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .ambient
    lightNode.light?.color = color
    lightNode.light?.intensity = intensity
    
    scene.rootNode.addChildNode(lightNode)
    return lightNode
}
 */


/*
 //-----------------------START COSMETIC ADD ONS--------------------------

 // Load the Hair model
 let shortsURL = Bundle.main.url(forResource: "elenahair", withExtension: "usdc")!
 let shortsScene = try! SCNScene(url: shortsURL, options: nil)
 let shortsNode = shortsScene.rootNode
 
 var currentPosition = shortsNode.position
 
 // Update the y-component of the position to move it up
 currentPosition.z += 0.27

 // Assign the updated position back to the node
 shortsNode.position = currentPosition
 
 //add shorts as scene node
 scene.rootNode.addChildNode(shortsNode)
 
 // Load the flip flops model
 let flopsURL = Bundle.main.url(forResource: "flops", withExtension: "usdc")!
 let flopsScene = try! SCNScene(url: flopsURL, options: nil)
 let flopsNode = flopsScene.rootNode
 
 var currPosition = flopsNode.position
 
 // Update the y-component of the position to move it up
 currPosition.z += 0.27

 // Assign the updated position back to the node
 flopsNode.position = currPosition
 
 //add shorts as scene node
 scene.rootNode.addChildNode(flopsNode)
 
 // Load the sword model
 let backURL = Bundle.main.url(forResource: "sword", withExtension: "usdc")!
 let backScene = try! SCNScene(url: backURL, options: nil)
 let backNode = backScene.rootNode
 
 var curPosition = backNode.position
 
 // Update the y-component of the position to move it up
 curPosition.z += 0.48
 curPosition.y += 0.04
 

 // Assign the updated position back to the node
 backNode.position = curPosition
 
 //add shorts as scene node
 scene.rootNode.addChildNode(backNode)
 
 // Load the glasses model
 let glassesURL = Bundle.main.url(forResource: "glasses", withExtension: "usdc")!
 let glassesScene = try! SCNScene(url: glassesURL, options: nil)
 let glassesNode = glassesScene.rootNode
 
 //rotation
 // Rotate the glasses by 45 degrees around the y-axis
 let rotationAngle = Float(-90.0 * Double.pi / 180.0)
 let rotation = SCNVector4(x: 0, y: 0, z: 1, w: rotationAngle)
 glassesNode.rotation = rotation
 
 //positioning
 var curPos = glassesNode.position
 curPos.z += 0.42
 curPos.x -= 0.04
 curPos.y += 0.02
 glassesNode.position = curPos
 
 // Scale the node down to about 70 percent of its current size
 let scalePercentage: Float = 0.8
 glassesNode.scale = SCNVector3(x: scalePercentage, y: scalePercentage, z: scalePercentage)

 
 //add shorts as scene node
 scene.rootNode.addChildNode(glassesNode)
 
 //-----------------------END COSMETIC ADD ONS--------------------------
 
 
 
 
 */
