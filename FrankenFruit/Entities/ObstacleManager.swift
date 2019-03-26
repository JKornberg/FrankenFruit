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
    var pathEntity : PathEntity?
    var cgPathEntity : CGPathEntity?
    var shapePathEntity : ShapePathEntity?
    let randomComponent : RandomComponent
    var previousObstacles = [SKNode]()
    var contactGlobal = false
    
    init(entityManager : EntityManager){
        self.entityManager = entityManager
        gameplayConfiguration = GameplayConfiguration(frame: entityManager.scene.frame)
        randomComponent = RandomComponent()
        self.scene = entityManager.scene
        super.init()
        //pathEntity = PathEntity(obstacleManager: self)
        addComponent(randomComponent)
        //cgPathEntity = CGPathEntity(obstacleManager: self)
        shapePathEntity = ShapePathEntity(obstacleManager: self)
        layoutShapes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //gameplayConfiguration.difficulty += amount
        gameplayConfiguration.score += gameplayConfiguration.speed
        //gameplayConfiguration.progress += gameplayConfiguration.speed
        //print(gameplayConfiguration.progress)
        if gameplayConfiguration.progress >= (scene.frame.width * 1.25){
            guard let pathEntity = shapePathEntity else {fatalError("Path not initiated")}
            gameplayConfiguration.progress -= scene.frame.width * 1.25
            pathEntity.updatePath()
            layoutShapes()
        }
    }

    func layoutShapes()
    {
        var obstacles = [SKNode]()
        var totalRetries = 0
        var obstacleRetries = 0
        let genX = scene.frame.width * 1.25
        guard let pathEntity = shapePathEntity else {fatalError("NEED A PATH YO")}
        var newPathArray = [SKShapeNode]()
        newPathArray.append(contentsOf: pathEntity.previousPathNodes)
        newPathArray.append(contentsOf: pathEntity.currentPathNodes)
        for path in newPathArray{
            scene.addChild(path)
        }
        while (totalRetries < gameplayConfiguration.maxRetires && obstacles.count < gameplayConfiguration.maxObstacles){
            var obstacle = pickObstacle()
            let newX = randomComponent.randomIn(0, Int(genX))
            obstacle.node.position.x = newX
            obstacle.bufferNode.position.x = newX
            var newObstacleArray = obstacles
            if obstacle.node.position.x < genX + 140{
                newObstacleArray.append(contentsOf: previousObstacles)
            }
            var currentRetries = 0
            
            while(currentRetries < gameplayConfiguration.maxObstacleRetries)
            {
                let newY = randomComponent.randomIn(0, Int(scene.frame.height))
                obstacle.node.position.y = newY
                obstacle.bufferNode.position.y = newY
                
                var isValid = true
                for ob in newObstacleArray{
                    if ob.intersects(obstacle.bufferNode){
                        isValid = false
                        break
                    }
                }
                scene.addChild(obstacle.node)
                obstacle.node.removeFromParent()
                if contactGlobal == false && isValid{
                    entityManager.add(obstacle)
                    obstacles.append(obstacle.bufferNode)
                    break
                }
                contactGlobal = false
                currentRetries += 1
                totalRetries += 1
            }
            obstacle = pickObstacle()
            obstacleRetries = 0
        }
        for ob in obstacles{
            ob.position.x -= genX
        }
       /* for path in newPathArray{
            path.removeFromParent()
        } */
        previousObstacles = obstacles
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 0b0001 || contact.bodyB.categoryBitMask == 0b0001{
            print("contact")
            contactGlobal = true
        }
    }
    
    func layoutObstaclesCg()
    {
        var obstacles = [SKNode]()
        var totalRetries = 0
        var obstacleRetries = 0
        let genX = scene.frame.width * 1.25
        guard let pathEntity = cgPathEntity else {fatalError("NEED A PATH YO")}
        var buffer = 2
        if let previousPath = pathEntity.previousPath{
            buffer = 1
        }
        while (totalRetries < gameplayConfiguration.maxRetires * buffer && obstacles.count < gameplayConfiguration.maxObstacles * buffer){
            let currentPath = CGPathImage(from: pathEntity.currentPath!)
            var previousPath : CGPathImage?
            if let prevPath = pathEntity.previousPath{
                previousPath = CGPathImage(from: prevPath)
            }
            var obstacle = pickObstacle()
            for i in 1...buffer{
                var buffered = 0
                if i == 1{
                    buffered = Int(genX)
                }
                let newX = randomComponent.randomIn(Int(genX) * i, Int(genX * CGFloat(buffer + 1)))
                obstacle.node.position.x = newX
                obstacle.bufferNode.position.x = newX
                
                var newObstacleArray = obstacles
                if obstacle.node.position.x < genX * CGFloat(i) + 140{
                    newObstacleArray.append(contentsOf: previousObstacles)
                }
                
                while(obstacleRetries < gameplayConfiguration.maxObstacleRetries){
                    let newY = randomComponent.randomIn(0,Int(scene.frame.height))
                    obstacle.node.position.y = newY
                    obstacle.bufferNode.position.y = newY
                    var isValid = true
                    for k in newObstacleArray{
                        if k.intersects(obstacle.bufferNode)
                        {
                            isValid = false
                            break
                        }
                    }
                    
                    
                    let obstaclePath = CGPath(rect: obstacle.node.frame, transform: nil)
                    let obstaclePathImage = CGPathImage(from: obstaclePath)

                    if obstacle.node.position.x < genX + 40{
                        if previousPath != nil{
                            print(obstacle.node.position.x)
                            print(obstaclePathImage)
                            if previousPath!.intersects(path: obstaclePathImage){
                                isValid = false
                            }
                        }
                    } else if (currentPath.intersects(path: obstaclePathImage)){
                        print("intersectsPath")
                        isValid = false
                    }
                    if isValid {
                        entityManager.add(obstacle)
                        obstacles.append(obstacle.bufferNode)
                        break
                    }
                    obstacleRetries += 1
                    totalRetries += 1
                }
                obstacle = pickObstacle()
                obstacleRetries = 0
            }

        }
        for w in obstacles{
            w.position.x -= genX * CGFloat(buffer)
        }
        previousObstacles = obstacles

    }
    
    func layoutObstacles(pathEntity : PathEntity, buffered : Bool? = false){
        var currentObstacles = [SKNode]()
        let buffer = buffered! ? scene.frame.width * 1.25 : 0
        var obstacleRetries = 0
        var totalRetries = 0
//        while (currentObstacles.count < gameplayConfiguration.maxObstacles * (buffered! ? 2 : 1) && previousX < scene.frame.width * 1.25 * (buffered! ? 3 : 2)){
        while (currentObstacles.count < gameplayConfiguration.maxObstacles * (buffered! ? 2 : 1) && totalRetries < gameplayConfiguration.maxRetires * (buffered! ? 2 : 1)){
            for i in 0...(buffered! ? 1 : 0){
                var obstacle : ObstacleEntity = pickObstacle()
                let newX = randomComponent.randomIn(Int(scene.frame.width * 1.25), Int(scene.frame.width * 1.25) * 2 ) + (CGFloat(i) * buffer)
                obstacle.node.position.x = newX
                obstacle.bufferNode.position.x = newX
                
                var newObstacleArray = currentObstacles
                if obstacle.node.position.x < scene.frame.width * 1.25 + buffer + 140{
                    newObstacleArray.append(contentsOf: previousObstacles)
                }
                while obstacleRetries < gameplayConfiguration.maxObstacleRetries{

                    let randomY = CGFloat.random(in: 0...scene.frame.height)
                    obstacle.node.position.y = randomY
                    obstacle.bufferNode.position.y = randomY
                    var isValid = true
                    

                    
                    for j in newObstacleArray{
                        if obstacle.bufferNode.intersects(j){
                            isValid = false
                            break
                        }
                    }
                    
                    if obstacle.node.position.x < scene.frame.width * 1.25 + buffer + 40{
                        if obstacle.node.intersects(pathEntity.shapeArray[0]) && !obstacle.node.intersects(pathEntity.shapeArray[1])  && isValid{
                            entityManager.add(obstacle)
                            currentObstacles.append(obstacle.bufferNode)
                            break
                        }
                    } else if obstacle.node.intersects(pathEntity.shapeArray[(pathEntity.currentIndex + 1) % 2])  && isValid{
                        entityManager.add(obstacle)
                        currentObstacles.append(obstacle.bufferNode)
                        break
                    }
                    obstacleRetries += 1
                    totalRetries += 1
                }
//                while objectRetries < gameplayConfiguration.maxObstacleRetries{
//                    randomY = randomComponent.randomIn(0, Int(scene.frame.height))
//                    objectRetries += 1
//                    obstacle.node.position.y = randomY
//                    obstacle.bufferNode.position.y = randomY
//                }
                obstacle = pickObstacle()
                obstacleRetries = 0
                //print("retries: \(totalRetries), positionX: \(newX), positionY: \(randomY)")
            }

        }
        for k in currentObstacles{
            k.position.x -= scene.frame.width * 1.25
        }
        print("count: \(currentObstacles.count)")
        previousObstacles = currentObstacles
        
    }
    
    func pickObstacle() -> ObstacleEntity{
        let num = randomComponent.randomTo(to: 2)
        switch num {
        case 0:
            return BlockEntity(obstacleManager: self)
        case 1:
            let ang = CGFloat.random(in: -gameplayConfiguration.slantAngle...gameplayConfiguration.slantAngle)
            let entity = SlantedEntity(angle: ang, obstacleManager: self)
            entity.node.zRotation = ang
            entity.bufferNode.zRotation = ang
            return entity
            
        default:
            return BlockEntity(obstacleManager: self)
        }
    }
    
    
    
    struct GameplayConfiguration{
        var score : CGFloat = 0
        var progress : CGFloat = 0
        var difficulty : Int = 0
        var maxObstacles : Int = 20
        var maxObstacleRetries : Int = 5
        var maxRetires : Int = 200
        var xRange = CGFloat(0)...CGFloat(30)
        let frame : CGRect
        var slantAngle : CGFloat = 60
        
        
        init(frame: CGRect){
            self.frame = frame
        }
        
        var segmentWidth : (lower: Int, upper: Int){
            var lower = frame.width/12
            var upper = frame.width/6
            return (Int(lower),Int(upper))
        }
        
        var speed : CGFloat {
                switch difficulty{
                case 0..<6:
                    return 5
                case 0..<12:
                    return 2
                case 0..<18:
                    return 3
                case 0..<24:
                    return 4
                default:
                    return 5
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
        var pathWidth : CGFloat {
            switch difficulty{
            case 0..<5:
                return 250
            case 0..<11:
                return 225
            case 0..<21:
                return 200
            case 0..<29:
                return 150
            default:
                return 120
            }
        }
        var pathAngle : CGFloat{
            //return 20
            return 75 * CGFloat.pi / 180
            return ((CGFloat(difficulty - difficulty % 5) / 5 * 7) + 30) * CGFloat.pi / 180
        }
    
    }
}

