//
//  PathEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
import CGPathIntersection
class PathEntity : GKEntity{
    
    unowned var scene : SKScene
    unowned var obstacleManager : ObstacleManager
    unowned var entityManager : EntityManager
    var shapeArray = [SKShapeNode]()
    var endOfPath : CGPoint
    let pathSegment : ClosedRange<CGFloat>
    var currentIndex = 0
    var firstTime : Bool = true
    
    init(obstacleManager : ObstacleManager){
        self.obstacleManager = obstacleManager
        self.entityManager = obstacleManager.entityManager
        self.scene = obstacleManager.scene
        
        //Extend path to 1.25x screen
        endOfPath = CGPoint(x: scene.frame.width * 1.25, y: scene.frame.midY)
        print("End of path: \(endOfPath)")
        pathSegment = scene.frame.width/8...scene.frame.width/3
        super.init()
        for _ in 0..<2{
            let newPath = generatePath()
            newPath.zPosition = 10
            shapeArray.append(newPath)
        }
        shapeArray[currentIndex].position.x = scene.frame.width * 1.25
        scene.addChild(shapeArray[currentIndex])
        shapeArray[currentIndex + 1].position.x = (scene.frame.width * 1.25) * 2
        scene.addChild(shapeArray[currentIndex+1])
        obstacleManager.layoutObstacles(pathEntity: self, buffered: true)
        let stateMachine = StateMachineComponent(states: [SlideState(entity: self, obstacleManager: obstacleManager)])
        addComponent(stateMachine)
        stateMachine.enterInitialState()
    }
    
    
    
    func createNewPathSegment(progress : CGFloat) -> SKShapeNode{
        let newPath : SKShapeNode = generatePath()
        newPath.position.x = scene.frame.width * 1.25
        shapeArray[currentIndex%2].removeFromParent()
        shapeArray[currentIndex%2] = newPath
        scene.addChild(newPath)
        currentIndex += 1
        return newPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generatePath() -> SKShapeNode{
        let newPath = UIBezierPath()
        let fullPathWidth = scene.frame.width * 1.25
        newPath.move(to: CGPoint(x: 0, y: endOfPath.y))
        var pathLength : CGFloat = 0
        while (pathLength < fullPathWidth){
            var newPointX = CGFloat.random(in: pathSegment) + pathLength
            if newPointX > fullPathWidth{
                newPointX = fullPathWidth
            }
            
            let maxAngle = obstacleManager.gameplayConfiguration.pathAngle
            let newAngle = CGFloat.random(in: -maxAngle...maxAngle)
            var newPointY = endOfPath.y + (newPointX-pathLength) * tan(newAngle)

            if newPointY > scene.frame.height - 40{
                newPointY = scene.frame.height - 40
            } else if newPointY < 40{
                newPointY = 40
            }
            let newPoint = CGPoint(x: newPointX, y: newPointY)
            newPath.addLine(to: newPoint)
            endOfPath = CGPoint(x: newPointX, y: newPointY)
            pathLength = newPointX
        }
        
        let newCGPath = newPath.cgPath.copy(strokingWithWidth: 40, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        let shapeNode = SKShapeNode(path: newCGPath)
        shapeNode.fillColor = .black
        print(shapeNode.frame)
        
        return shapeNode
    }

        
        
        
        
        /*if CGFloat(progress) >= obstacleManager.scene.frame.width{
            let newEndPath = generatePath()
            shapeNodes.dequeue()
            let newNode = shapeArray[currentPath + 1 % 2]
            shapeArray[currentPath % 2] = newEndPath
            print("Generating at: \(scene.frame.width + progress - scene.frame.width)")
            newNode.position.x = scene.frame.width + progress - scene.frame.width
            obstacleManager.scene.addChild(newNode)
            shapeNodes.enqueue(newEndPath)
            obstacleManager.gameplayConfiguration.progress = 0
        } */
    
    
}
