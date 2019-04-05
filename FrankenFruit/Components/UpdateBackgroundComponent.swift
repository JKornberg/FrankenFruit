//
//  UpdateBackgroundComponent.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/28/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class UpdateBackgroundComponent : GKComponent{
    
    unowned var bg : BackgroundEntity
    let frame : CGRect
    init(bg: BackgroundEntity, frame: CGRect){
        self.bg = bg
        self.frame = frame
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBackground(score : CGFloat, overshoot : CGFloat){
        bg.backgroundNodeArray[bg.index%3].position.x = frame.width * CGFloat(bg.backgroundNodeArray.count - 1) + overshoot
        bg.backgroundNodeArray[bg.index%3].texture = SKTexture(imageNamed: "CrossedDemoBg")
        bg.index += 1
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if bg.backgroundNodeArray[bg.index%3].position.x + frame.width <= 0{
            updateBackground(score: 0, overshoot: bg.backgroundNodeArray[bg.index%3].position.x + frame.width)
        }
    }
}
