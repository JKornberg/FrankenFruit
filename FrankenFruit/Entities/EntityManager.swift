//
//  EntityManager.swift
//  Mockingbird
//
//  Created by Jonah Kornberg on 12/12/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class EntityManager {
    var scene : SKScene
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    lazy var componentSystems : [GKComponentSystem] = {
        let stateMachineSystem = GKComponentSystem(componentClass: StateMachineComponent.self)
        return [stateMachineSystem]
    }()
    
    init(scene: SKScene){
        self.scene = scene
    }
    
    func add(_ entity: GKEntity){
        entities.insert(entity)
        if let spriteNode = entity.component(ofType: RenderComponent.self){
            scene.addChild(spriteNode.node)
        }
        if let shapeNode = entity.component(ofType: ShapeRenderComponent.self){
            scene.addChild(shapeNode.node)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity){
        if let spriteComponent = entity.component(ofType: RenderComponent.self)?.node{
            spriteComponent.removeFromParent()
        }
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func getMelon()-> GKEntity?{
        for entity in entities{
            if let _ = entity.component(ofType: TapFlyComponent.self){
                return entity
            }
        }
        return nil
    }
    
    func update(_ deltaTime: CFTimeInterval){
        for componentSystem in componentSystems{
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for entity in toRemove{
            
            for componentSystem in componentSystems{
                componentSystem.removeComponent(foundIn: entity)
            }
        }
        toRemove.removeAll()
    }
    
    
}
