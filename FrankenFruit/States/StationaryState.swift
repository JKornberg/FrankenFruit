//
//  SlideState.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class StationaryState : GKState{
    unowned var entity : GKEntity
    init(entity : GKEntity){
        self.entity = entity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        //
        if let physicsComponent = entity.component(ofType: PhysicsComponent.self){
            physicsComponent.physicsBody.isDynamic = false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //DO NOTHING
    }
    
}
