//
//  SATPathEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/27/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class SATPathEntity : GKEntity{
    var satPath = [SATRect]()
    let obstacleManager : ObstacleManager
    let frame : CGRect
    let genX : CGFloat
    var endOfPathY : CGFloat
    var position : CGPoint = .zero
    init(obstacleManager : ObstacleManager){
        self.obstacleManager = obstacleManager
        self.frame = obstacleManager.scene.frame
        self.genX = frame.width * 1.25
        endOfPathY = frame.midY
        super.init()
        
        let firstPath = SATRect(start: CGPoint(x: genX, y: frame.midY), end: CGPoint(x: genX * 2, y: frame.midY), thickness: 50, rotation: 0)
        satPath.append(firstPath)
    }
    
    func updatePath(){
        var newPath = [SATRect]()
        if satPath.count > 1 {
            let oldPath = satPath[satPath.count - 2]
            newPath.append(oldPath.shiftBy(xAmount: -genX))

        }
        let oldPath = satPath[satPath.count - 1]
        newPath.append(oldPath.shiftBy(xAmount: -genX))
        
        var endOfPathX = genX
        let randomComponent = obstacleManager.randomComponent
        while endOfPathX < genX * 2{
            //var newX = CGFloat.random(in: obstacleManager.gameplayConfiguration.segmentWidth.lower...obstacleManager.gameplayConfiguration.segmentWidth.upper)
            var newX = randomComponent.randomIn(Int(obstacleManager.gameplayConfiguration.segmentWidth.lower), Int(obstacleManager.gameplayConfiguration.segmentWidth.upper)) + endOfPathX

            if newX > genX * 2{
                newX = genX * 2
            }

            var pathAngle = CGFloat.random(in:-obstacleManager.gameplayConfiguration.pathAngle...obstacleManager.gameplayConfiguration.pathAngle)
            var newY = endOfPathY + (newX-endOfPathX) * tan(pathAngle)
            if newY < 0{
                newY = 0
                pathAngle = atan((newY-endOfPathY)/(newX-endOfPathX))
            }
           

            if newY > frame.height
            {
                newY = frame.height
                pathAngle = atan((newY-endOfPathY)/(newX-endOfPathX))
            }

            newPath.append(SATRect(start: CGPoint(x: endOfPathX, y: endOfPathY), end: CGPoint(x: newX, y: newY), thickness: 50, rotation: pathAngle))
            endOfPathX = newX
            endOfPathY = newY

        }
        satPath = newPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
