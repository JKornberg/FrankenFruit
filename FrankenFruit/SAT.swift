import UIKit

struct SATRect {
    
    var corners = [CGVector]()
    var midPoint : CGPoint?
    var axes = [CGVector]()
    
    var size : CGSize?
    var rotation : CGFloat?
    
    init(corners : [CGVector])
    {
        midPoint = nil
        self.corners = corners
        axes.append(contentsOf: getNormals())
    }
    
    //Intended for Obstacles
    init(size: CGSize, position midPoint: CGPoint, rotation r: CGFloat){
        self.midPoint = midPoint
        self.size = size
        self.rotation = r
        corners.append(getRotatedPoint(x: midPoint.x-size.width/2, y: midPoint.y-size.height/2, rotation: r))
        corners.append(getRotatedPoint(x: midPoint.x-size.width/2, y: midPoint.y+size.height/2, rotation: r))
        corners.append(getRotatedPoint(x: midPoint.x+size.width/2, y: midPoint.y+size.height/2, rotation: r))
        corners.append(getRotatedPoint(x: midPoint.x+size.width/2, y: midPoint.y-size.height/2, rotation: r))
        axes.append(contentsOf: getNormals())
    }

    //Intended for Path
    init(start: CGPoint, end : CGPoint, thickness t: CGFloat){
        midPoint = nil
        let r = atan((end.y - start.y)/(end.x-start.x))
        corners.append(CGVector(dx: t * sin(r) + start.x, dy: -t * cos(r) + start.y))
        corners.append(CGVector(dx: -t * sin(r) + start.x, dy: t * cos(r) + start.y))
        corners.append(CGVector(dx: -t * sin(r) + end.x , dy: t * cos(r) + end.y))
        corners.append(CGVector(dx: t * sin(r) + end.x, dy: -t * cos(r) + end.y))
        axes.append(contentsOf: self.getNormals())
    }
    
    init(start: CGPoint, end : CGPoint, thickness t: CGFloat, rotation r : CGFloat){
        midPoint = nil
        corners.append(CGVector(dx: t * sin(r) + start.x, dy: -t * cos(r) + start.y))
        corners.append(CGVector(dx: -t * sin(r) + start.x, dy: t * cos(r) + start.y))
        corners.append(CGVector(dx: -t * sin(r) + end.x , dy: t * cos(r) + end.y))
        corners.append(CGVector(dx: t * sin(r) + end.x, dy: -t * cos(r) + end.y))
        axes.append(contentsOf: self.getNormals())
    }
    
    
    init(x1: CGFloat, x2: CGFloat, y1: CGFloat, y2: CGFloat, rotation: CGFloat)
    {
        midPoint = CGPoint(x: (x2-x1)/2 + x1, y: (y2-y1)/2 + y1)
        corners.append(getRotatedPoint(x: x1, y: y1, rotation: rotation))
        corners.append(getRotatedPoint(x: x1, y: y2, rotation: rotation))
        corners.append(getRotatedPoint(x: x2, y: y2, rotation: rotation))
        corners.append(getRotatedPoint(x: x2, y: y1, rotation: rotation))
        axes.append(contentsOf: self.getNormals())
        
    }
    
    func getRotatedPoint(x : CGFloat, y: CGFloat, rotation : CGFloat) -> CGVector{
        guard let midPoint = midPoint else {fatalError("midpoint not set")}
        let tempX = x-midPoint.x
        let tempY = y-midPoint.y
        let rotatedX = tempX * cos(rotation) - tempY * sin(rotation)
        let rotatedY = tempX * sin(rotation) + tempY * cos(rotation)
        return CGVector(dx: rotatedX + midPoint.x, dy: rotatedY + midPoint.y)
    }
    
    func getNormals() -> [CGVector]{
        var normals = [CGVector]()
        for i in 0..<corners.count/2{
            let v1 = corners[i]
            let v2 = corners[i+1 == corners.count ? 0 : i+1]
            let edge = CGVector(dx: v1.dx - v2.dx, dy: v1.dy-v2.dy)
            let normal = CGVector(dx: -edge.dy, dy: edge.dx)
            normals.append(normal)
        }
        return normals
    }
    
    func doesIntersect(_ rect1 : SATRect)->Bool{
        var allAxes = self.axes
        allAxes.append(contentsOf: rect1.axes)
        var intersects = true
        for axis in allAxes{
            var minSelf = dotProduct(v1: corners[0], v2: axis)
            var maxSelf = dotProduct(v1: corners[0], v2: axis)
            for corner in self.corners{
                let dp = dotProduct(v1: corner, v2: axis)
                if  dp < minSelf{
                    minSelf = dp
                } else if dp > maxSelf{
                    maxSelf = dp
                }
            }
            
            var minRect1 = dotProduct(v1: rect1.corners[0], v2: axis)
            var maxRect1 = dotProduct(v1: rect1.corners[0], v2: axis)
            for corner in rect1.corners{
                let dp = dotProduct(v1: corner, v2: axis)
                if  dp < minRect1{
                    minRect1 = dp
                } else if dp > maxRect1{
                    maxRect1 = dp
                }
            }
            if minSelf > maxRect1 || maxSelf < minRect1{
                intersects = false
                return intersects
            }
        }
        return intersects
    }
    
    func shiftBy(xAmount : CGFloat)->SATRect{
        let newRect = SATRect(corners: [CGVector(dx: corners[0].dx + xAmount, dy: corners[0].dy),CGVector(dx: corners[1].dx + xAmount, dy: corners[1].dy),CGVector(dx: corners[2].dx + xAmount, dy: corners[2].dy),CGVector(dx: corners[3].dx + xAmount, dy: corners[3].dy)])
        return newRect
    }
    
    func printCorners()->String{
        return "SATRect(corners: [CGVector(dx: \(corners[0].dx), dy: \(corners[0].dy)),CGVector(dx: \(corners[1].dx), dy: \(corners[1].dy)),CGVector(dx: \(corners[2].dx), dy: \(corners[2].dy)),CGVector(dx: \(corners[3].dx), dy: \(corners[3].dy))])"
    }
    
}

func dotProduct(v1 : CGVector, v2: CGVector) -> CGFloat{
    return v1.dx * v2.dx + v1.dy * v2.dy
}




