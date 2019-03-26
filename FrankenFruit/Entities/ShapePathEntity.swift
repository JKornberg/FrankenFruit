//
//  ShapePathEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/25/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class ShapePathEntity : GKEntity{
    
    let genX : CGFloat
    let frame : CGRect
    let obstacleManager : ObstacleManager
    var currentPathNodes = [SKShapeNode]()
    var previousPathNodes = [SKShapeNode]()
    var lastX : CGFloat
    var lastY : CGFloat = 0
    
    init(obstacleManager: ObstacleManager){
        self.obstacleManager = obstacleManager
        genX = obstacleManager.scene.frame.width * 1.25
        frame = obstacleManager.scene.frame
        lastY = obstacleManager.scene.frame.midY
        lastX = genX
        super.init()
        
        //Make iniitial straight path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.midY))
        path.addLine(to: CGPoint(x: genX, y: frame.midY))
        let strokedPath = path.cgPath.copy(strokingWithWidth: 40, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        let shapeNode = SKShapeNode(path: strokedPath)
        shapeNode.name = "firstPath"
        shapeNode.fillColor = .black
        shapeNode.zPosition = 10
        shapeNode.physicsBody = createPathPhysicsBody(path: strokedPath)
        
        currentPathNodes.append(shapeNode)
        
        //currentPathNodes[0].physicsBody = createPathPhysicsBody(path: strokedPath)
    }
    
    func updatePath(){
        if currentPathNodes.count > 1{
            previousPathNodes.append(currentPathNodes[currentPathNodes.count-2])
        }
        previousPathNodes.append(currentPathNodes[currentPathNodes.count-1])
        currentPathNodes = [SKShapeNode]()
        while lastX < genX * 2{
            var newX = obstacleManager.randomComponent.randomIn(obstacleManager.gameplayConfiguration.segmentWidth.lower, obstacleManager.gameplayConfiguration.segmentWidth.upper) + lastX
            if newX > genX * 2{
                newX = genX * 2
            }
            
            let maxAngle = obstacleManager.gameplayConfiguration.pathAngle
            let newAngle = CGFloat.random(in: -maxAngle...maxAngle)
            var newPointY = lastY + (newX - lastX) * tan(newAngle)
            if newPointY > frame.height{
                newPointY = frame.height
            } else if newPointY < 0{
                newPointY = 0
            }
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: lastX, y: lastY))
            path.addLine(to: CGPoint(x: newX, y: newPointY))
            let strokedPath = path.cgPath.copy(strokingWithWidth: 80, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
            let shapeNode = SKShapeNode(path: strokedPath)
            shapeNode.physicsBody = createPathPhysicsBody(path: strokedPath)
            currentPathNodes.append(shapeNode)
            lastX = newX
        }
        lastX = genX

    }
    
    
    func createPathPhysicsBody(path: CGPath) -> SKPhysicsBody{
        let physicsBody = SKPhysicsBody(polygonFrom: path)
        physicsBody.affectedByGravity = false
        physicsBody.collisionBitMask = 0b0100
        physicsBody.categoryBitMask = 0b0001
        physicsBody.contactTestBitMask = 0b0010

//        physicsBody.collisionBitMask = ColliderType.pathCollide.rawValue
//        physicsBody.categoryBitMask = ColliderType.Path.rawValue
//        physicsBody.contactTestBitMask = ColliderType.Object.rawValue
        return physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
