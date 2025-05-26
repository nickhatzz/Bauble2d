//
//  LavaLurker.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//

import SpriteKit

class LavaLurker: Enemy {
    
    init(spawnPoint: CGPoint) {
        super.init(health: 50, attackDamage: 10, moveSpeed: Double.random(in: 50...100), size: CGSize(width: 72, height: 48), position: spawnPoint, textureAtlas: SKTextureAtlas(named: "lavalurker"))
        self.name = "lavalurker"
        self.texture = SKTexture(imageNamed: "lavalurker-walk1")
        self.texture?.filteringMode = .nearest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
