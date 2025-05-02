//
//  Baubite.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit

class Baubite {
    
    var sprite = SKSpriteNode(color: .blue, size: CGSize(width: 20, height: 20))
    
    init() {
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
//        sprite.physicsBody?.collisionBitMask = 
        sprite.physicsBody!.restitution = 1
        sprite.physicsBody!.affectedByGravity = false
        sprite.zPosition = 1
        sprite.name = "baubite"
    }
    
}
