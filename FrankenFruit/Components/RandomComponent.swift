//
//  RandomComponent.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/20/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit
class RandomComponent : GKComponent{
    let randomSource : GKLinearCongruentialRandomSource
    
    override init(){
        randomSource = GKLinearCongruentialRandomSource()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomFloat() -> CGFloat{
        return CGFloat(randomSource.nextUniform())
    }
    
    func randomIn(_ lower : Int, _ higher : Int) -> CGFloat{
        let dist = GKRandomDistribution(lowestValue: lower, highestValue: higher)
        return CGFloat(dist.nextInt())
    }
    
    func randomTo(to num: Int)->Int{
        return randomSource.nextInt(upperBound: num)
    }
    
}
