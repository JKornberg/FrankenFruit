//
//  PlayerEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class PlayerEntity : GKEntity {
    
    override init(){
        super.init()
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: "PlayerSprite"))
        let tapFlyComponent = TapFlyComponent(node: renderComponent.node)
        let physicsBody = SKPhysicsBody(rectangleOf: renderComponent.node.frame.size)
        physicsBody.affectedByGravity = true
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, categoryBitMask: .Bird, contactTestBitMask: .BirdContact, collisionBitMask: .Boundary)
        renderComponent.node.physicsBody = physicsComponent.physicsBody
        self.addComponent(renderComponent)
        self.addComponent(tapFlyComponent)
        self.addComponent(physicsComponent)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
