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
        node = SKSpriteNode(imageNamed: "SpikeObstacle")
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bufferNode = node.copy() as! SKSpriteNode
        let bufferSize = CGFloat(10)
        bufferNode.scale(to: CGSize(width: bufferNode.size.width + bufferSize, height: bufferNode.size.height + bufferSize))
        bufferNode.color = .orange
        let renderComponent = RenderComponent(node: node)
        addComponent(renderComponent)
        
        
        let stateMachineComponent = StateMachineComponent(states: [StationaryState(entity: self),SlideState(entity: self, obstacleManager: obstacleManager)])

//        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager),StationaryState(entity: self)])
        self.addComponent(stateMachineComponent)
        stateMachineComponent.enterInitialState()
        addComponent(RemoveEntity(node: node, obstacleManager: obstacleManager))
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = 0b010
        physicsBody.contactTestBitMask = 0b001
        node.physicsBody = physicsBody
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
