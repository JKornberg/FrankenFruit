//
//  BackgroundEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class BackgroundEntity : GKEntity{
    var backgroundNodeArray = [SKSpriteNode]()
    var combinedNode : SKSpriteNode
    unowned var scene : SKScene
    unowned var obstacleManager : ObstacleManager
    
    init(bgImage : UIImage, scene : SKScene, obstacleManager : ObstacleManager){
        self.scene = scene
        self.combinedNode = SKSpriteNode()
        self.obstacleManager = obstacleManager
        super.init()
        setupInitialBackground(image: bgImage)
        let renderComponent = RenderComponent(node: combinedNode)
        self.addComponent(renderComponent)
        combinedNode.anchorPoint = .zero
        combinedNode.position = .zero
        combinedNode.zPosition = -10
        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager),StationaryState(entity: self)])
        self.addComponent(stateMachineComponent)
        stateMachineComponent.enterInitialState()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitialBackground(image: UIImage){
        for i in 0..<3{
            let spriteNode = SKSpriteNode(texture: SKTexture(image: image))
            spriteNode.anchorPoint = .zero
            spriteNode.position.x = scene.frame.width * CGFloat(i)
            backgroundNodeArray.append(spriteNode)
            combinedNode.addChild(spriteNode)
        }
    }
}
