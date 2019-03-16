//
//  InputComponent.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class InputComponent : GKComponent{
    
    unowned var node : SKSpriteNode
    
    init(node : SKSpriteNode){
        self.node = node
        super.init()
    }
    
    func didPress(){
        node.physicsBody!.velocity.dy = 0
        node.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 55))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
