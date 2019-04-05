//
//  GameScene.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityManager : EntityManager!
    var obstacleManager : ObstacleManager!
    let playerEntity = PlayerEntity()

    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        entityManager = EntityManager(scene : self )
        obstacleManager = ObstacleManager(entityManager: entityManager)

        self.lastUpdateTime = 0

    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = obstacleManager
        let cameraEntity = CameraEntity(scene: self)
        entityManager.add(cameraEntity)
        self.camera=cameraEntity.camera
        let background = BackgroundEntity(bgImage: UIImage(named: "FarBg")!, scene: self, obstacleManager: obstacleManager)
        entityManager.add(background)
        let playerNode = playerEntity.component(ofType: RenderComponent.self)
        playerNode!.node.position = CGPoint(x: self.frame.width-500, y: self.frame.midY)
        entityManager.add(playerEntity)

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = currentTime - lastUpdateTime
        entityManager.update(deltaTime)
        obstacleManager.update(deltaTime: deltaTime)
        lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let flyComponent = playerEntity.component(ofType: TapFlyComponent.self) else {fatalError("Could not retrieve mocking bird body")}
        flyComponent.didPress()
    }
    
    
}
