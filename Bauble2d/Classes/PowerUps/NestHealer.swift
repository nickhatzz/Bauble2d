//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class NestHealer: PowerUpBase, PowerUp {
    
    init(x: Double, y: Double) {
        super.init(textureAtlas: SKTextureAtlas(named: "nest-healer"), position: CGPoint(x: x, y: y))
        self.name = "nesthealer"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collected(in scene: GameScene) {
        scene.spawnParticle(name: "PudgyParticle", position: position)
        scene.score += 200
        let nestDifference = 1000 - scene.nest.health
        if nestDifference <= 200 {
            scene.nest.health = 1000
        } else {
            scene.nest.health += 200
        }
        scene.healthBar.update(health: scene.nest.health)
        for baubite in scene.baubites {
            baubite.health = 100
        }
        scene.run(SKAction.playSoundFileNamed("powerupcollected.wav", waitForCompletion: false))
        removeFromParent()
    }
    
}
