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
    unowned var obstacleManager : ObstacleManager
    var nodes : [SKSpriteNode]?
    
    init(entity : GKEntity, obstacleManager : ObstacleManager){
        self.entity = entity
        self.obstacleManager = obstacleManager
        super.init()
    }
    
    init(entity : GKEntity, obstacleManager : ObstacleManager, nodes : [SKSpriteNode]){
        self.entity = entity
        self.obstacleManager = obstacleManager
        self.nodes = nodes
        super.init()
    }

    
    override func didEnter(from previousState: GKState?) {
        if let physicsComponent = entity.component(ofType: PhysicsComponent.self){
            physicsComponent.physicsBody.isDynamic = true
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let renderComponent = entity.component(ofType: RenderComponent.self){
            renderComponent.node.position.x -= obstacleManager.gameplayConfiguration.speed
        }
        else if let shapeRenderComponent = entity.component(ofType: ShapeRenderComponent.self){
            shapeRenderComponent.node.position.x -= obstacleManager.gameplayConfiguration.speed
        } else if let nodes = self.nodes{
            for node in nodes{
                node.position.x -= obstacleManager.gameplayConfiguration.speed
            }
        }
    }
    
}
