//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class BaubiteSpawn: SKSpriteNode {
    
    init(x: Double, y: Double) {
        super.init(texture: SKTexture(imageNamed: "nest"), color: .clear, size: CGSize(width: 25, height: 25))
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        self.physicsBody!.mass = 10000000000
        self.zPosition = 2
        self.name = "baubitespawn"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
