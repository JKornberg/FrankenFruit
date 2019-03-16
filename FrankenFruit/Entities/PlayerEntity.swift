//
//  PlayerEntity.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class PlayerEntity : GKEntity {
    
    override init(){
        super.init()
        let renderComponent = RenderComponent(color: .blue, size: CGSize(width: 50, height: 30))
        self.addComponent(renderComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
