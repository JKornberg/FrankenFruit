//
//  CameraEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 4/2/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class CameraEntity : GKEntity{
    let camera : SKCameraNode
    init(scene: SKScene){
        camera = SKCameraNode()
        let cameraXOffset = abs((scene.frame.width - (UIScreen.main.bounds.width * scene.frame.height / UIScreen.main.bounds.height) ) / 2) + scene.frame.width/2
        camera.position.x += cameraXOffset
        camera.position.y += scene.frame.height/2
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
