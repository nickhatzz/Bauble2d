//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class EnemyClearer: PowerUpBase, PowerUp {
    
    init(x: Double, y: Double) {
        super.init(textureAtlas: SKTextureAtlas(named: "enemy-clearer"), position: CGPoint(x: x, y: y))
        self.name = "enemyclearer"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collected(in scene: GameScene) {
        scene.spawnParticle(name: "LavaLurkerParticle", position: position)
        scene.score += 200
        scene.removeAllEnemies()
        scene.run(SKAction.playSoundFileNamed("powerupcollected.wav", waitForCompletion: false))
        removeFromParent()
    }
    
}
