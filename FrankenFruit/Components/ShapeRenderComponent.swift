//
//  SpriteComponent.swift
//  Mockingbird
//
//  Created by Jonah Kornberg on 12/12/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit

class ShapeRenderComponent : GKComponent {
    
    var node : SKShapeNode
    
    init(shapeNode : SKShapeNode, color : UIColor? = UIColor.white){
        node = shapeNode
        super.init()
        if let color = color{
            node.fillColor = color
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
