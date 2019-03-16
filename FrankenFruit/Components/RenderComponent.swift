//
//  SpriteComponent.swift
//  Mockingbird
//
//  Created by Jonah Kornberg on 12/12/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit

class RenderComponent : GKComponent {
    
    var node : SKSpriteNode
    
    init(texture : SKTexture){
        node = SKSpriteNode(texture: texture)
        super.init()
    }
    
    init(node : SKSpriteNode){
        self.node = node
        super.init()
    }
    
    init(color: UIColor, size: CGSize){
        node = SKSpriteNode(color: color, size: size)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
