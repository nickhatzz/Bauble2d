//
//  Nest.swift
//  Bauble2d
//
//  Created by Nick on 5/3/25.
//
import SpriteKit

class BaubiteSpawn: PowerUpBase, PowerUp {
    
    init(x: Double, y: Double) {
        super.init(textureAtlas: SKTextureAtlas(named: "baubite-spawn"), position: CGPoint(x: x, y: y))
        self.name = "baubitespawn"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collected(in scene: GameScene) {
        scene.spawnParticle(name: "BaubiteParticle", position: position)
        scene.score += 200
        for _ in 0..<10 {
            if scene.baubites.count < 100 {
                scene.spawnParticle(name: "BaubiteParticle", position: scene.baubites.last!.position)
                scene.baubites.append(Baubite())
                scene.addChild(scene.baubites.last!)
            }
        }
        scene.run(SKAction.playSoundFileNamed("powerupcollected.wav", waitForCompletion: false))
        removeFromParent()
    }
}
