//
//  Baubite.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit

class Baubite: SKSpriteNode {
    
    let moveSpeed: Double
    var health: Int = 20
    
    init() {
        self.moveSpeed = Double.random(in: 150...250)
        super.init(texture: SKTexture(imageNamed: "baubite"), color: .clear, size: CGSize(width: 20, height: 20))
        self.position = CGPoint(x: Int.random(in: -50...50), y: Int.random(in: 75...100))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody!.restitution = 1
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.affectedByGravity = false
        self.zPosition = 1
        self.name = "baubite"
    }
    
    func move(towards newLocation: CGPoint) {
        let distance: Double = Double(hypotf(Float(newLocation.x - self.position.x), Float(newLocation.y - self.position.y)))
        self.physicsBody!.velocity.dx = (newLocation.x - self.position.x) / (distance / moveSpeed)
        self.physicsBody!.velocity.dy = (newLocation.y - self.position.y) / (distance / moveSpeed)
    }
    
    func heal() {
        if health < 20 {
            health += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
