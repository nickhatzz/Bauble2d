//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class Nest: SKSpriteNode {
    
    public var health = 1000
    
    init() {
        super.init(texture: SKTexture(imageNamed: "nest"), color: .clear, size: CGSize(width: 128, height: 128))
        self.position = CGPoint(x: 0, y: 0)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.4)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.mass = 10000000000
        self.zPosition = 2
        self.name = "nest"
        self.texture?.filteringMode = .nearest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
