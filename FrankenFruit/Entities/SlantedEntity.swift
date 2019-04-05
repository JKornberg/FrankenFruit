//
//  SlantedWallEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
import ChameleonFramework
class SlantedEntity : ObstacleEntity
{
    init(angle : CGFloat, obstacleManager : ObstacleManager){
        super.init(obstacleManager: obstacleManager)
        size = CGSize(width: 80, height: 21)
        bufferSize = CGSize(width: 90, height: 31)
        rotation = angle
        node = SKSpriteNode(imageNamed: "SpikeObstacle")
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bufferNode = node.copy() as! SKSpriteNode
        let bufferSize = CGFloat(10)
        bufferNode.scale(to: CGSize(width: bufferNode.size.width + bufferSize, height: bufferNode.size.height + bufferSize))
        bufferNode.color = .orange
        let renderComponent = RenderComponent(node: node)
        addComponent(renderComponent)
        
        
        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager), StationaryState(entity: self)])

//        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager),StationaryState(entity: self)])
        self.addComponent(stateMachineComponent)
        stateMachineComponent.enterInitialState()
        addComponent(RemoveEntity(node: node, obstacleManager: obstacleManager))
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = ColliderType.SlantedObstacle.rawValue
        physicsBody.contactTestBitMask = ColliderType.SlantedObstacle.rawValue
        node.physicsBody = physicsBody
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
