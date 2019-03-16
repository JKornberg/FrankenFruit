//
//  PhysicsComponent.swift
//  
//
//  Created by Jonah Kornberg on 3/15/19.
//

import GameplayKit
import SpriteKit
class PhysicsComponent : GKComponent {
    var physicsBody: SKPhysicsBody
    init(physicsBody : SKPhysicsBody, categoryBitMask: ColliderType? = nil, contactTestBitMask: ColliderType? = nil, collisionBitMask : ColliderType? = nil){
        self.physicsBody = physicsBody
        
        if let categoryBitMask = categoryBitMask{
            self.physicsBody.categoryBitMask = categoryBitMask.rawValue
        }
        if let collisionBitMask = collisionBitMask{
            self.physicsBody.collisionBitMask = collisionBitMask.rawValue
        }
        
        if let contactTestBitMask = contactTestBitMask{
            self.physicsBody.contactTestBitMask = contactTestBitMask.rawValue
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
