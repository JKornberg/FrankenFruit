//
//  ObstacleManager.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/16/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//
import SpriteKit
import GameplayKit
import CGPathIntersection
class ObstacleManager : GKEntity, SKPhysicsContactDelegate{
    
    
    
    /*Obstacle Generation Process Explained
     Path entity is created at ObstacleManager.init
     Path Entity will create a random path starting at scenewidth * 1.25 and ending at scenewidth * 1.25 * 3
     We make each path screenwidth * 1.25 so that obstacles placed at the beginning will not magically appear on screen
     Path Entity uses GeneratePath to make a section of the path which creates a section of the path equal to scenewidth * 1.25 and returns it as a SkShapeNode
     The path is stored in an array PathEntity.shapeArray which stores 2 segments of the path at a time
     PathEntity calls ObstacleManager.LayoutObstacles with Buffer = True, this means that it needs to layout the first 2 path segments of obstacle
     LayoutObstacles creates a maximum amount of obstacles per path section, it picks a randomX and randomY and sees if the obstacle overlaps with the path or with a buffer around the other obstacles. If the obstacle is close to the beginning of the path segment, it also checks if it overlaps with the previous path segment AND the previous group of obstacle buffers. The currentObstacles are then stored in previousObstacles and their buffer positions are shifted by the sceneWidth as they do not slide with the sprites
     
     There is a max retries for each obstacle
     The update function checks if the path has slid the scenewidth * 1.25 (or in the case of buffer = true if it has slid scenewidth * 1.25 * 2)
     This is done by using the progress variable which is reset each new path (and after the first two paths).
     When true, progress = progress - scene.width, firstTime is set to false so buffered will be false, PathEntity.createNewPathSegment() is called
     CreateNewPathSegment generates a new path segment, places it at scenewidth * 1.25, and updates shapeArray to remove the irrelevant path and add the new one
     LayoutObstacles is then called again with buffer = false
     
     */
    
    var gameplayConfiguration : GameplayConfiguration
    unowned var scene : SKScene
    unowned var entityManager : EntityManager
    var satPathEntity : SATPathEntity?
    let randomComponent : RandomComponent
    var previousSATObstacles = [SATRect]()
    
    var score : CGFloat
    var progress : CGFloat
    var difficultyProgress : CGFloat
    
    init(entityManager : EntityManager){
        self.score = 0
        self.progress = 0
        self.difficultyProgress = 0
        self.entityManager = entityManager
        gameplayConfiguration = GameplayConfiguration(frame: entityManager.scene.frame, difficulty: 20)
        randomComponent = RandomComponent()
        self.scene = entityManager.scene
        super.init()
        //pathEntity = PathEntity(obstacleManager: self)
        addComponent(randomComponent)
        //cgPathEntity = CGPathEntity(obstacleManager: self)
        //layoutObstaclesCg()
        satPathEntity = SATPathEntity(obstacleManager: self)
        let stateComponent = StateMachineComponent(states: [SpawnObstacleState(entity: self)])
        //stateComponent.enterInitialState()
        //addComponent(stateComponent)
        layoutSATPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //gameplayConfiguration.difficulty += amount
        score += gameplayConfiguration.speed
        progress += gameplayConfiguration.speed
        difficultyProgress += 1
        if progress > scene.frame.width * 1.25{
            progress -= scene.frame.width * 1.25
            layoutSATPath()
            satPathEntity?.updatePath()
        }
        if difficultyProgress >= 30 && gameplayConfiguration.difficulty <= 20{
            gameplayConfiguration = GameplayConfiguration(frame: scene.frame, difficulty: gameplayConfiguration.difficulty + 1)
            difficultyProgress = 0
        }
    }
    
    func layoutSATPath(){
        //holds buffer rects of obstacles
        var obstacles = [SATRect]()
        //number of attempted placements of obstacles
        var totalRetries = 0
        //number of retries for a specific obstacle
        var obstacleRetries = 0
        
        let genX = scene.frame.width * 1.25
        guard let pathEntity = satPathEntity else {fatalError("NEED A PATH YO")}
        print("maxRetries:  \(gameplayConfiguration.maxRetries)")
        print("maxObstacles: \(gameplayConfiguration.maxObstacles)")
        while (totalRetries < gameplayConfiguration.maxRetries && obstacles.count < gameplayConfiguration.maxObstacles){
            let obstacle = pickObstacle()
            let newX = randomComponent.randomIn(Int(genX), Int(genX * 2))
            var newObstacleArray = obstacles
            if newX < genX + 140{
                newObstacleArray.append(contentsOf: previousSATObstacles)
            }
            newObstacleArray.append(contentsOf: obstacles)
            while obstacleRetries < gameplayConfiguration.maxObstacleRetries{
                let newY = randomComponent.randomIn(0, Int(scene.frame.height))
                var isValid = true
                let obstacleSAT = SATRect(size: obstacle.size!, position: CGPoint(x: newX, y: newY), rotation: obstacle.rotation)
                
                for ob in newObstacleArray{
                    if obstacleSAT.doesIntersect(ob){
                        isValid = false
                        break
                    }
                }
                
                if !isValid{
                    obstacleRetries += 1
                    totalRetries += 1
                    continue
                }
                
                for path in pathEntity.satPath{
                    if path.doesIntersect(obstacleSAT){
                        isValid = false
                        obstacleRetries += 1
                        totalRetries += 1
                        continue
                    }
                }
                
                if isValid{
                    obstacle.node.position = CGPoint(x: newX, y: newY)
                    entityManager.add(obstacle)
                    totalRetries += 1
                    obstacles.append(obstacleSAT)
                    break
                }
                obstacleRetries += 1
                totalRetries += 1
            }
            obstacleRetries = 0
        }
        print("totalRetries: \(totalRetries)")
        print("totalObstacles: \(obstacles.count)")
        previousSATObstacles = [SATRect]()
        for ob in obstacles{
            previousSATObstacles.append(ob.shiftBy(xAmount: -genX))
            
        }
    }
    
    func pickObstacle() -> ObstacleEntity{
        let num = randomComponent.randomTo(to: 2)
        switch num {
        case 0:
            return BlockEntity(obstacleManager: self)
        case 1:
            let ang = CGFloat.random(in: -70 * CGFloat.pi/180...70 * CGFloat.pi/180)
            let entity = SlantedEntity(angle: ang, obstacleManager: self)
            entity.node.zRotation = ang
            entity.bufferNode.zRotation = ang
            return entity
            
        default:
            return BlockEntity(obstacleManager: self)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == ColliderType.SlantedObstacle.rawValue || contact.bodyB.categoryBitMask == ColliderType.SlantedObstacle.rawValue{
            scene.view?.isPaused = true
            print("contact")

        }
        if contact.bodyA.categoryBitMask == ColliderType.SquareObstacle.rawValue || contact.bodyB.categoryBitMask == ColliderType.SquareObstacle.rawValue{
            if contact.contactNormal.dx != 0{
                scene.view?.isPaused = true

                print("contact")
            }
        }
    }
    
    func createGameplayConfiguration(frame: CGRect, difficulty: Int) -> GameplayConfiguration{
        return GameplayConfiguration(frame: frame, difficulty: difficulty)
    }
    
    struct GameplayConfiguration{
        
        let frame : CGRect
        
        
        var difficulty : Int
        
        
        var speed : CGFloat
        
        var maxObstacles : Int
        var maxObstacleRetries : Int
        var maxRetries : Int
        var pathAngle : CGFloat
        var segmentWidth : SegmentWidth
        
        init(frame: CGRect, difficulty: Int){
            self.frame = frame
            self.difficulty = difficulty
            speed = 1
            segmentWidth = SegmentWidth(lower: frame.width/8, upper: frame.width/4)
            maxObstacles = 5
            maxRetries = 20
            maxObstacleRetries = 3
            pathAngle = 35 * CGFloat.pi/180
            setProperties()
            
        }
        var backgroundSpeed : CGFloat{
            return speed * 0.7
        }
        mutating func setProperties(){
            switch difficulty{
            case let x where x > 1:
                speed = 1
                segmentWidth = SegmentWidth(lower: frame.width/8, upper: frame.width/4)
                maxObstacles = 5
                maxRetries = 20
                maxObstacleRetries = 3
                pathAngle = 35 * CGFloat.pi/180
                fallthrough
            case let x where x > 2:
                maxObstacleRetries = 5
                fallthrough
            case let x where x > 3:
                speed = 1.5
                pathAngle = 45 * CGFloat.pi/180
                fallthrough
            case let x where x > 4:
                maxObstacles = 8
                fallthrough
            case let x where x > 5:
                maxRetries = 50
                fallthrough
            case let x where x > 6:
                pathAngle = 55 * CGFloat.pi/180
                fallthrough
            case let x where x > 7:
                speed = 2
                fallthrough
            case let x where x > 8:
                segmentWidth = SegmentWidth(lower: frame.width/8, upper: frame.width/5)
                fallthrough
            case let x where x > 9:
                maxRetries = 75
                fallthrough
            case let x where x > 10:
                maxObstacles = 20
                fallthrough
            case let x where x > 11:
                speed = 5
                fallthrough
            case let x where x > 12:
                fallthrough
            case let x where x > 13:
                fallthrough
            case let x where x > 14:
                fallthrough
            case let x where x > 15:
                fallthrough
            case let x where x > 16:
                fallthrough
            case let x where x > 17:
                fallthrough
            case let x where x > 18:
                fallthrough
            case let x where x > 19:
                break
            default:
                fatalError("Invalid difficulty")
            }
            
        }
        
        struct SegmentWidth {
            var lower : CGFloat
            var upper : CGFloat
            init(lower : CGFloat, upper: CGFloat){
                self.lower = lower
                self.upper = upper
            }
            
            mutating func update(lower: CGFloat, upper: CGFloat){
                self.lower = lower
                self.upper = upper
            }
        }
        
        //        var maxObstacles : CGFloat {
        //            if difficulty < 28{
        //                return 3 + CGFloat(difficulty) - CGFloat(difficulty % 2)
        //            } else {
        //                return 17
        //            }
        //        }
        //
        
    }
}

