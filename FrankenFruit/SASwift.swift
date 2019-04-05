//
//  SASwift.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/27/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import UIKit
struct SARect{
    var corners = [CGPoint]()
    var axes = [CGVector]()
    var midPoint : CGPoint
    
    init(x1: CGFloat, x2: CGFloat, y1: CGFloat, y2: CGFloat, rotation: CGFloat){
        midPoint = CGPoint(x: (x2-x1)/2 + x1, y: (y2-y1)/2 + y1)
        corners.append(getRotatedPoint(point: CGPoint(x: x1, y: y1), rotation: rotation))
        corners.append(getRotatedPoint(point: CGPoint(x: x1, y: y2), rotation: rotation))
        corners.append(getRotatedPoint(point: CGPoint(x: x2, y: y2), rotation: rotation))
        corners.append(getRotatedPoint(point: CGPoint(x: x2, y: y1), rotation: rotation))
        axes = getNormals()
    }
    
    func getRotatedPoint(point : CGPoint, rotation: CGFloat) -> CGPoint{
        let tempX = point.x - midPoint.x
        let tempY = point.y - midPoint.y
        let rotatedX = tempX * cos(rotation) - tempY * sin(rotation)
        let rotatedY = tempX * sin(rotation) + tempY * cos(rotation)
        return CGPoint(x: rotatedX + midPoint.x, y: rotatedY + midPoint.y)
    }
    
    func getNormals() -> [CGVector]{
        var normals = [CGVector]()
        for i in 0..<corners.count/2{
            normals.append(CGVector(dx: corners[i].y, dy: -corners[i].x))
        }
        return normals
    }
    
}

func dotProduct(corner : CGPoint, axis: CGVector) -> CGFloat{
    return corner.x * axis.dx + corner.y * axis.dy
}

func intersects(rect1 : SARect, rect2 : SARect)->Bool{
    var axes = rect1.axes
    axes.append(contentsOf: rect2.axes)
    for axis in axes{
        var rect1Min = dotProduct(corner: rect1.corners[0], axis: axis)
        var rect1Max = dotProduct(corner: rect1.corners[0], axis: axis)
        var rect2Min = dotProduct(corner: rect2.corners[0], axis: axis)
        var rect2Max = dotProduct(corner: rect2.corners[0], axis: axis)
        for i in 1..<rect1.corners.count{
            let dot1 = dotProduct(corner: rect1.corners[i], axis: axis)
            if dot1 < rect1Min{
                rect1Min = dot1
            }
            if dot1 > rect1Max{
                rect1Max = dot1
            }
            
            let dot2 = dotProduct(corner: rect2.corners[i], axis: axis)
            if dot2 < rect2Min{
                rect2Min = dot2
            }
            if dot2 > rect2Max{
                rect2Max = dot2
            }
        }
        
        if rect1Min > rect2Max || rect2Min > rect1Max{
            return false
        }
    }
    return true
}
