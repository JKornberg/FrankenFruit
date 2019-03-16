//
//  PathEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class PathEntity : GKEntity{
    
    let bufferedPath : CGPath
    unowned var scene : SKScene
    let shapeNode : SKShapeNode
    init(scene : SKScene){
        self.scene = scene
        let initialPath = UIBezierPath()
        initialPath.move(to: CGPoint(x: 0, y: self.scene.frame.midY))
        initialPath.addLine(to: CGPoint(x: self.scene.frame.width-200 , y: self.scene.frame.midY))
        bufferedPath = initialPath.cgPath.copy(strokingWithWidth: 80, lineCap: .butt, lineJoin: .miter, miterLimit: 0)
        let renderComponent = ShapeRenderComponent(shapeNode: SKShapeNode(path: bufferedPath), color: UIColor.black)
        shapeNode = renderComponent.node
        super.init()
        self.addComponent(renderComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
