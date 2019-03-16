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
class SlantedEntity : GKEntity
{
    let node : SKSpriteNode
    let size : CGSize = CGSize(width: 140, height: 100)
    
    init(angle : CGFloat){
        node = SKSpriteNode()
        let baseNode = SKSpriteNode(color: .flatPlum, size: size)
        let bufferedNode = baseNode.copy() as! SKSpriteNode
        let bufferSize = CGFloat(30)
        bufferedNode.scale(to: CGSize(width: bufferedNode.size.width + bufferSize, height: bufferedNode.size.height + bufferSize))
        bufferedNode.color = .flatYellowDark
        node.size = size
        node.zRotation = angle
        super.init()
        node.addChild(bufferedNode)
        node.addChild(baseNode)
        let renderComponent = RenderComponent(node: node)
        addComponent(renderComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
