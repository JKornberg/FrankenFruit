//
//  GameScene.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager : EntityManager!
    let playerEntity = PlayerEntity()

    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        entityManager = EntityManager(scene: self)
        self.lastUpdateTime = 0

    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        let cameraXOffset = abs((self.frame.width - (UIScreen.main.bounds.width * self.frame.height / UIScreen.main.bounds.height) ) / 2) + self.frame.width/2
        createCamera(cameraXOffset : cameraXOffset)
        let background = BackgroundEntity(bgImage: UIImage(named: "CrossedDemoBg")!, scene: self)
        entityManager.add(background)
        let pathEntity = PathEntity(scene: self)
        entityManager.add(pathEntity)
        
        //Slanted obstacle demo
//        let slantedObstacle = SlantedWallEntity(angle: CGFloat.pi/6)
//        slantedObstacle.node.position = CGPoint(x: 400, y: self.frame.midY)
//        entityManager.add(slantedObstacle)
//        print("Frame width: \(self.frame.width)")
        let slantedObstacle = SlantedEntity(angle: CGFloat.pi/6)
        slantedObstacle.node.position = CGPoint(x: 812-100, y: self.frame.midY)
        entityManager.add(slantedObstacle)
        print("Intersects: \(slantedObstacle.node.intersects(pathEntity.shapeNode))")
        print(slantedObstacle.node.frame.size)
        print(slantedObstacle.node.zRotation)
        print("Frame width: \(self.frame.width)")

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = currentTime - lastUpdateTime
        entityManager.update(deltaTime)
        lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let flyComponent = playerEntity.component(ofType: TapFlyComponent.self) else {fatalError("Could not retrieve mocking bird body")}
        flyComponent.didPress()
    }
    
    func createCamera(cameraXOffset : CGFloat){
        let camera = SKCameraNode()
        camera.position.x += cameraXOffset
        camera.position.y += self.frame.height/2
        self.addChild(camera)
        self.camera = camera

    }
    
}
