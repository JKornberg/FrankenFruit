//
//  RemoveOffScreen.swift
//  Mockingbird
//
//  Created by Jonah Kornberg on 12/27/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//
import GameplayKit
import SpriteKit
class RemoveEntity : GKComponent {
    
    let node : SKNode
    let obstacleManager : ObstacleManager
    
    init(node : SKSpriteNode, obstacleManager : ObstacleManager){
        self.node = node
        self.obstacleManager = obstacleManager
        
        super.init()
        node.size.width = node.calculateAccumulatedFrame().width
    }
    
    init(node : SKShapeNode, obstacleManager : ObstacleManager){
        self.node = node
        self.obstacleManager = obstacleManager
        
        super.init()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = self.entity else {
            print("No entity for Slide Component")
            return
        }
        if node.position.x + node.calculateAccumulatedFrame().width < 0{
            
            obstacleManager.entityManager.remove(entity)
        }
    }
}

