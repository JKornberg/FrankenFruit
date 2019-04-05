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
    unowned var scene : SKScene
    unowned var obstacleManager : ObstacleManager
    var index = 0
    
    init(bgImage : UIImage, scene : SKScene, obstacleManager : ObstacleManager){
        self.scene = scene
        self.obstacleManager = obstacleManager
        super.init()
        setupInitialBackground(image: bgImage)
        for node in backgroundNodeArray{
            scene.addChild(node)
            node.zPosition = -1
        }
        let stateMachineComponent = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager, nodes : backgroundNodeArray),StationaryState(entity: self)])
        self.addComponent(stateMachineComponent)
        stateMachineComponent.enterInitialState()
        let updateComponent = UpdateBackgroundComponent(bg: self, frame : scene.frame)
        addComponent(updateComponent)
        
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
        }
    }
}
