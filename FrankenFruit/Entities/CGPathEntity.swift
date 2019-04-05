//
//  CGPathEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/24/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import CGPathIntersection
import GameplayKit
import SpriteKit
class CGPathEntity : GKEntity{
    
    unowned var obstacleManager : ObstacleManager
    let genX : CGFloat
    var currentPath : CGMutablePath?
    var previousPath : CGMutablePath?
    var endOfPathY : CGFloat
    var startOfPathY : CGFloat
    
    init(obstacleManager : ObstacleManager){
        self.obstacleManager = obstacleManager
        genX = obstacleManager.scene.frame.width * 1.25
        endOfPathY = obstacleManager.scene.frame.midY
        startOfPathY = obstacleManager.scene.frame.midY
        super.init()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: genX, y: obstacleManager.scene.frame.midY))
        path.addLine(to: CGPoint(x: genX * 2, y: obstacleManager.scene.frame.midY))
        let strokedPath = path.copy(strokingWithWidth: 40, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        let strokedMutable = strokedPath.mutableCopy()
        currentPath = strokedMutable
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
        
    }
    
    func updateCg(buffered : Bool? = false){
        print("started")
        currentPath!.move(to: CGPoint(x: 0, y: startOfPathY))
        startOfPathY = endOfPathY
        previousPath = currentPath!
        currentPath = CGMutablePath()
        let randomComponent = obstacleManager.randomComponent
        let genX = obstacleManager.scene.frame.width * 1.25
        currentPath!.move(to: CGPoint(x: genX, y: endOfPathY))
        var pathLength : CGFloat = 0
        while(pathLength < genX){
            var newPointX = randomComponent.randomIn(Int(obstacleManager.gameplayConfiguration.segmentWidth.lower), Int(obstacleManager.gameplayConfiguration.segmentWidth.upper)) + pathLength
            if newPointX > genX{
                newPointX = genX
            }
            let maxAngle = obstacleManager.gameplayConfiguration.pathAngle
            let newAngle = CGFloat.random(in: -maxAngle...maxAngle)
            var newPointY = endOfPathY + (newPointX-pathLength) * tan(newAngle)
            
            if newPointY > obstacleManager.scene.frame.height - 40{
                newPointY = obstacleManager.scene.frame.height - 40
            } else if newPointY < 40{
                newPointY = 40
            }
            let newPoint = CGPoint(x: newPointX, y: newPointY)
            currentPath!.addLine(to: newPoint)
            endOfPathY = newPointY
            pathLength = newPointX
        }
        let strokedPath = currentPath!.copy(strokingWithWidth: 80, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        let strokedMutable = strokedPath.mutableCopy()
        currentPath = strokedMutable
    }
}
