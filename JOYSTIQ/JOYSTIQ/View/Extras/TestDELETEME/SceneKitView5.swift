//
//  SwiftUIView5.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/17/23.
//

import SwiftUI
import SceneKit


struct MySceneKitView: UIViewRepresentable {
    
    private var snapshotButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Take Snapshot", for: .normal)
        button.backgroundColor = .blue
        return button
        
    }()
    
    func makeUIView(context: Context) -> SCNView {
        
        let scnView = SCNView()
        // Set up SCNView properties and configuration here
        
        let scene = SCNScene()
        
        // Set the scene in the SCNView
        scnView.scene = scene
        scnView.backgroundColor = UIColor.clear //lets snapshot be transparent background
        scnView.allowsCameraControl = false
        
        // Load the Hair model
        let nodeURL = Bundle.main.url(forResource: "CamTest5", withExtension: "usdc")!
        let nodeScene = try! SCNScene(url: nodeURL, options: nil)
        let newNode = nodeScene.rootNode
        
        //add shorts as scene node
        scene.rootNode.addChildNode(newNode)
        
        // Add the snapshot button and action
        snapshotButton.addTarget(context.coordinator, action: #selector(Coordinator.takeSnapshot), for: .touchUpInside)
        // Set the frame for the button
        snapshotButton.frame = CGRect(x: 16, y: 16, width: 120, height: 40) // Adjust the frame as needed
        scnView.addSubview(snapshotButton)
        
        
        return scnView
        
    }
    
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
        // Update SCNView as needed when the SwiftUI environment changes
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        
        var parent: MySceneKitView
        
        init(_ parent: MySceneKitView) {
            self.parent = parent
        }
        
        @objc func takeSnapshot() {
            
            guard let sceneView = parent.snapshotButton.superview as? SCNView else { return }
            
            // Capture the snapshot of the current scene
            let image = sceneView.snapshot()
            print("Screenshot captured?")
        }
        
    } //end coordinator class
    
    
}

struct ContentView5: View {
    
    //@State private var scnView = MySceneKitView()
    
    var body: some View {
        
        VStack {
            
            //scnView
                //.frame(width: 300, height: 600) // Adjust the frame size as needed
            
            MySceneKitView()
                .frame(width: 300, height: 600)
                
            
           
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.gray)
    }
}




struct SwiftUIView5_Previews: PreviewProvider {
    static var previews: some View {
        ContentView5()
    }
}
