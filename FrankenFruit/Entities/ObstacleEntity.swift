//
//  ObstacleEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/23/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
import ChameleonFramework
class ObstacleEntity : GKEntity
{
    var node : SKSpriteNode
    var bufferNode : SKSpriteNode
    var rotation : CGFloat = 0
    var size : CGSize?
    var bufferSize : CGSize?
    var position : CGPoint?
    init(obstacleManager : ObstacleManager){
        node = SKSpriteNode()
        bufferNode = SKSpriteNode()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
