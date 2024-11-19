//
//  EnemyPlane.swift
//  air_war
//
//  Created by Thanh Dat Nguyen on 19/11/24.
//

import SpriteKit

class EnemyPlane: SKSpriteNode {
    var parrent : SKNode?


    init () {
        let texture = SKTexture(imageNamed: "ship_0001")
        let size = CGSize(width: 100, height: 100)
        super.init(texture: texture, color: .clear, size: size )
    }
   
    func Setup() {
        //add PhysicsBody
        self.zRotation = CGFloat(Double.pi)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        // random position
        let randomPosX = CGFloat.random(in: -360+self.size.width...360-self.size.width)
        parrent = self.parent as! SKScene
        self.position = CGPoint(x: randomPosX, y: parrent!.frame.size.height+self.size.height)

        move()
        
        // shoot every 600ms
        shoot()
    }
    
    func shoot() {
        // shoot every 500ms
        let spawnAction = SKAction.run { [weak self] in
            self?.genBullet()
        }
        let waitAction = SKAction.wait(forDuration: 1)
        let sequenceAction = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        self.run(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // move to end of screen
    func move() {
        
        let moveAction = SKAction.moveTo(y: -parrent!.frame.size.height, duration: 4)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        self.run(sequenceAction)
        // destroy enemy when it move out of screen
        if self.position.y < -self.parrent!.frame.size.height {
            self.removeFromParent()
        }
    }
    
    func genBullet() {
        if self.position.y > self.parrent!.frame.size.height{
            return
        }
        let bullet = SKSpriteNode(imageNamed: "tile_0000")
        bullet.size = CGSize(width: 20, height: 20)
        bullet.position = self.position
        bullet.zRotation = CGFloat(Double.pi)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.EnemyBullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        parrent?.addChild(bullet)
        
        let moveAction = SKAction.moveTo(y: -parrent!.frame.size.height, duration: 0.7)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        bullet.run(sequenceAction)
    }
}
