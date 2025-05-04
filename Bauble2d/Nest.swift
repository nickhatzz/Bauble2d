//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class Nest: SKSpriteNode {
    
    var health = 1000
    
    init() {
        super.init(texture: SKTexture(imageNamed: "nest"), color: .clear, size: CGSize(width: 164, height: 109))
        self.position = CGPoint(x: 0, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.mass = 10000000000
        self.zPosition = 1
        self.name = "nest"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
