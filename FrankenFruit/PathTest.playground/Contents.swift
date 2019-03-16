import UIKit
import SpriteKit
import CoreGraphics
import CGPathIntersection

class DrawPath : UIView{
    
    override func draw(_ rect : CGRect){
        print("drawn")
        //setup horizontal bezier path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 600, y: 200))
        path.lineWidth = 80
        
        //setup rectangle bezier
        let obstacle = UIBezierPath(rect: CGRect(x: 50, y: 0, width: 100, height: 300))
        
        //make rectangular cgpath from horizontal bezier
        let tmp = path.cgPath
        let strokedPath = tmp.copy(strokingWithWidth: 80, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: 0)
        
        //make rectangle vertical rectangle
        let obs = obstacle.cgPath
        let buffer = obs.copy(strokingWithWidth: 50, lineCap: .butt, lineJoin: .miter, miterLimit: 100/70)

        //make slanted shape
        var transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        let slantedPath = CGPath(rect: CGRect(x: 300, y: -80, width: 200, height: 30), transform: &transform)
        let slantedBuffer = slantedPath.copy(strokingWithWidth: 100, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
        
        
        
        //get context and fill path
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.blue.cgColor)
        context.addPath(strokedPath)
        context.fillPath()
        
        
        context.addPath(buffer)
        context.setFillColor(UIColor.purple.cgColor)
        context.closePath()
        context.fillPath()
        
        context.setFillColor(UIColor.green.cgColor)
        context.addPath(obs)
        context.closePath()
        context.fillPath()
        
        context.setFillColor(UIColor.orange.cgColor)
        context.addPath(slantedBuffer)
        context.closePath()
        context.fillPath()
        
        context.setFillColor(UIColor.white.cgColor)
        context.addPath(slantedPath)
        context.closePath()
        context.fillPath()
    


        print(strokedPath.intersects(path: obs))


    }
}

let view = DrawPath(frame: CGRect(x: 0, y: 0, width: 812, height: 375))


