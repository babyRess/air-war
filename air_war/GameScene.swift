//
//  GameScene.swift
//  air_war
//
//  Created by Thanh Dat Nguyen on 15/11/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
   
    var player: PlayerPlane!
    

    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        createLoopingBackground()
        
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // Disable gravity entirely

        player = PlayerPlane()
        player.position = CGPoint(x: 0, y: -(self.size.height/2)+player.self .size.height)
        addChild(player)
        
        // add enemy plane every 1s
        let spawnAction = SKAction.run {
            let enemyP = EnemyPlane()
            self.addChild(enemyP)
            enemyP.Setup()
        }
        let waitAction = SKAction.wait(forDuration: 3)
        let sequenceAction = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        run(repeatAction)
    }
    
    
    func createLoopingBackground() {
        // First background
        let background1 = SKSpriteNode(imageNamed: "Background")
        background1.size = self.size
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x:-self.size.width/2, y: -self.size.height/2)
        background1.zPosition = -1
        self.addChild(background1)

        // Second background
        let background2 = SKSpriteNode(imageNamed: "Background")
        background2.size = self.size
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x:-self.size.width/2, y: self.size.height/2)
        background2.zPosition = -1
        self.addChild(background2)

        // Move both backgrounds downward
        let moveDown = SKAction.moveBy(x: 0, y: -self.size.height, duration: 5)
        let resetPosition = SKAction.moveBy(x: 0, y: self.size.height, duration: 0)
        let loopAction = SKAction.sequence([moveDown, resetPosition])

        // Repeat the action on both backgrounds
        background1.run(SKAction.repeatForever(loopAction))
        background2.run(SKAction.repeatForever(loopAction))
    }
    
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            // Move the player to the touch location
            player.move(to: touchLocation)
        }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if (bodyA.categoryBitMask == PhysicsCategory.Bullet && bodyB.categoryBitMask == PhysicsCategory.Enemy||bodyB.categoryBitMask == PhysicsCategory.Bullet && bodyA.categoryBitMask == PhysicsCategory.Enemy) {
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
        }
        
        if (bodyA.categoryBitMask == PhysicsCategory.EnemyBullet && bodyB.categoryBitMask == PhysicsCategory.Player||bodyB.categoryBitMask == PhysicsCategory.EnemyBullet && bodyA.categoryBitMask == PhysicsCategory.Player) {
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
        }
        
        if (bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Enemy) {
            bodyA.node?.removeFromParent()
        }
        
        if (bodyA.categoryBitMask == PhysicsCategory.Enemy && bodyB.categoryBitMask == PhysicsCategory.Player) {
            bodyA.node?.removeFromParent()
        }
        
  
    }
}
