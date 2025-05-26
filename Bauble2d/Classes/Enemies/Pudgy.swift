//
//  Pudgy.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//

import SpriteKit

class Pudgy: Enemy {
    
    init(spawnPoint: CGPoint) {
        super.init(health: 100, attackDamage: 20, moveSpeed: Double.random(in: 30...50), size: CGSize(width: 32, height: 32), position: spawnPoint, textureAtlas: SKTextureAtlas(named: "pudgy"))
        self.name = "pudgy"
        self.texture = SKTexture(imageNamed: "pudgy-walk1")
        self.texture?.filteringMode = .nearest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
