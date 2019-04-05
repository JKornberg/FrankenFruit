//
//  ColliderTypes.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit

enum ColliderType : UInt32{
    case Nothing = 0b00000000
    case Bird = 0b00001111
    case Projectile = 0b00000010
    case SlantedObstacle = 0b00000100
    case SquareObstacle = 0b00001000
    case Coin = 0b00010000
    case Boundary = 0b00100000
    case BirdContact = 0b00011100
    //case BirdCollide = 0b00100000
    
}
