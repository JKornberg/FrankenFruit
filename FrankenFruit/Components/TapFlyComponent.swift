//
//  flyComponent.swift
//  Mockingbird
//
//  Created by Jonah Kornberg on 12/12/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit

class TapFlyComponent : GKComponent {
    let node : SKSpriteNode
    init(node : SKSpriteNode){
        self.node = node
        super.init()
    }
    func didPress(){
        node.physicsBody!.velocity.dy = 0
        node.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 55))
    }
    
    func didLetGo(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
