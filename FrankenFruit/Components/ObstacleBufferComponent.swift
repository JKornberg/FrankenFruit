//
//  ObstacleBufferComponent.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/18/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class ObstacleBufferComponent : GKComponent{
    let node : SKSpriteNode
    
    init(node : SKSpriteNode){
        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
