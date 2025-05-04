//
//  LavaLurker.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//

import SpriteKit

class LavaLurker: SKSpriteNode {
    
    let moveSpeed: Double
    
    init(x: Double, y: Double) {
        self.moveSpeed = Double.random(in: 50...100)
        super.init(texture: SKTexture(imageNamed: "lavalurker"), color: .clear, size: CGSize(width: 40, height: 30))
        self.position = CGPoint(x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.restitution = 1
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        self.physicsBody!.affectedByGravity = false
        self.zPosition = 1
        self.name = "lavalurker"
    }
    
    func move(towards newLocation: CGPoint) {
        let distance: Double = Double(hypotf(Float(newLocation.x - self.position.x), Float(newLocation.y - self.position.y)))
        self.physicsBody!.velocity.dx = (newLocation.x - self.position.x) / (distance / moveSpeed)
        self.physicsBody!.velocity.dy = (newLocation.y - self.position.y) / (distance / moveSpeed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
