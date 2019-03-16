//
//  SlideState.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class SlideState : GKState{
    unowned var entity : GKEntity
    init(entity : GKEntity){
        self.entity = entity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if let physicsComponent = entity.component(ofType: PhysicsComponent.self){
            physicsComponent.physicsBody.isDynamic = true
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let renderComponent = entity.component(ofType: RenderComponent.self) else {fatalError("attempting to slide non-rendered object")}
        renderComponent.node.position.x -= 2
    }
    
}
