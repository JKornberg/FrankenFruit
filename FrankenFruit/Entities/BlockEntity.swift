//
//  BlockEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/23/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
import ChameleonFramework
class BlockEntity : ObstacleEntity
{

    override init(obstacleManager : ObstacleManager){
        super.init(obstacleManager: obstacleManager)
        size = CGSize(width: 67, height: 35)
        bufferSize = CGSize(width: 77, height: 45)
        node = SKSpriteNode(texture: SKTexture(imageNamed: "BlockObstacle"))
        bufferNode = node.copy() as! SKSpriteNode
        let bufferSize = CGFloat(10)
        bufferNode.scale(to: CGSize(width: bufferNode.size.width + bufferSize, height: bufferNode.size.height + bufferSize))
        let renderComponent = RenderComponent(node: node)
        addComponent(renderComponent)
        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager),StationaryState(entity: self)])

//        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager),StationaryState(entity: self)])
        self.addComponent(stateMachineComponent)
        stateMachineComponent.enterInitialState()
        addComponent(RemoveEntity(node: node, obstacleManager: obstacleManager))
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = ColliderType.SquareObstacle.rawValue
        physicsBody.contactTestBitMask = ColliderType.Bird.rawValue
        node.physicsBody = physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
