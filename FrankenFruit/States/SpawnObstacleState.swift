//
//  PauseState.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 4/4/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import GameplayKit
import SpriteKit
class SpawnObstacleState : GKState{
    let obstacleManager : ObstacleManager
    init(entity : ObstacleManager){
        self.obstacleManager = entity
        super.init()
        obstacleManager.gameplayConfiguration.setProperties()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Spawning Obstacles")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let gameplayConfiguration = obstacleManager.gameplayConfiguration
        obstacleManager.score += gameplayConfiguration.speed
        obstacleManager.progress += gameplayConfiguration.speed
        obstacleManager.difficultyProgress += 1
        if obstacleManager.progress > obstacleManager.scene.frame.width * 1.25{
            obstacleManager.progress -= obstacleManager.scene.frame.width * 1.25
            obstacleManager.layoutSATPath()
            obstacleManager.satPathEntity?.updatePath()
        }
        if obstacleManager.difficultyProgress >= 30 && gameplayConfiguration.difficulty <= 20{
            obstacleManager.gameplayConfiguration = obstacleManager.createGameplayConfiguration(frame: obstacleManager.scene.frame, difficulty: gameplayConfiguration.difficulty + 1)
            obstacleManager.difficultyProgress = 0
        }

    }
    
}
