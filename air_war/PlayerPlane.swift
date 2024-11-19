//
//  PlayerPlane.swift
//  air_war
//
//  Created by Thanh Dat Nguyen on 19/11/24.
//


//help to create PlayPlane
import SpriteKit

class PlayerPlane: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "ship_0000")
        let size = CGSize(width: 100, height: 100)
        super.init(texture: texture, color: .clear, size: size)
        //add PhysicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.None

        shoot()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(to location: CGPoint) {
        guard let parent = self.parent else {
            return // Ensure the node has a parent before trying to constrain its movement
        }
        
        let halfWidth = self.size.width / 2
        let halfHeight = self.size.height / 2
        
        let xPosition = max(parent.frame.minX + halfWidth, min(parent.frame.maxX - halfWidth, location.x))
        let yPosition = max(parent.frame.minY + halfHeight, min(parent.frame.maxY - halfHeight, location.y))
        
        // Update the player's position
        self.position = CGPoint(x: xPosition, y: yPosition)
    }
    
    func shoot() {
        // shoot every 500ms
        let spawnAction = SKAction.run { [weak self] in
            self?.genBullet()
        }
        let waitAction = SKAction.wait(forDuration: 0.3)
        let sequenceAction = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        self.run(repeatAction)
    }
    
    func genBullet() {
        // Create the bullet
        let bulletNode = SKSpriteNode(imageNamed: "tile_0001")
        bulletNode.scale(to: CGSize(width: 20, height: 20))
        bulletNode.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height / 2) // Start slightly above the plane
        self.parent?.addChild(bulletNode) // Add bullet to the parent scene, not the player node
        
        // Add physics body to the bullet
        bulletNode.physicsBody = SKPhysicsBody(rectangleOf: bulletNode.size)
        bulletNode.physicsBody?.isDynamic = true
        bulletNode.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bulletNode.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        bulletNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Fly the bullet to the top of the scene
        let endPos = CGPoint(x: self.position.x, y: self.parent?.frame.height ?? 0)
        let bulletAction = SKAction.move(to: endPos, duration: 1)
        let removeAction = SKAction.removeFromParent()
        
        bulletNode.run(SKAction.sequence([bulletAction, removeAction]))
    }
    
    
}
