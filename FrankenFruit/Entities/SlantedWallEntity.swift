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
class SlantedWallEntity : GKEntity
{
    let node : SKSpriteNode
    let path : CGPath
    let bufferPath : CGPath
    let size : CGSize = CGSize(width: 140, height: 100)
    
    init(angle : CGFloat){
        let renderComponent = RenderComponent(color: .flatPlum, size: size)
        node = renderComponent.node
        var transform = CGAffineTransform(rotationAngle: angle)
        path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: &transform)
        bufferPath = path.copy(strokingWithWidth: 200, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        node.zRotation = angle
        super.init()
        addComponent(renderComponent)
        let shapeComponent = ShapeRenderComponent(shapeNode: SKShapeNode(path: path))
        addComponent(shapeComponent)

    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
