//
//  GameScene.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // gameplay vars
    private var baubites: [Baubite] = []
    private var lavaLurkers: [LavaLurker] = []
    private var nest: Nest = Nest()
    private var numberOfBaubites: Int = 100
    private var touchLocations: [CGPoint] = []
    
    // ui vars
    private let healthBar = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 20))
    let healthBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 210, height: 25))
    let damageBackground = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 20))
    let gameOverLabel = SKSpriteNode(texture: SKTexture(imageNamed: "logo"), size: CGSize(width: 683 / 2, height: 384 / 2))
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        physicsWorld.contactDelegate = self
        
        // add border
        let border = SKSpriteNode(color: .clear, size: CGSize(width: 0, height: 0))
        border.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.physicsBody!.restitution = 1
        border.physicsBody!.affectedByGravity = false
        addChild(border)
        
        // add nest
        addChild(nest)
        
        // add baubites
        for i in 0..<numberOfBaubites {
            baubites.append(Baubite())
            addChild(baubites[i])
        }
        
        // nest healthbar
        healthBarBackground.position = CGPoint(x: 0, y: 200)
        healthBarBackground.zPosition = 5
        damageBackground.position = CGPoint(x: 0, y: 200)
        damageBackground.zPosition = 6
        healthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthBar.position = CGPoint(x: -100, y: 200)
        healthBar.zPosition = 7
        addChild(healthBarBackground)
        addChild(damageBackground)
        addChild(healthBar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // add touched points to touchLocations
        touchLocations = []
        for touch in touches {
            touchLocations.append(touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // add touched points to touchLocations
        touchLocations = []
        for touch in touches {
            touchLocations.append(touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // empty touchLocations
        touchLocations = []
        for baubite in baubites {
            baubite.physicsBody!.velocity = .zero
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard nest.health > 0 else { return }
        
        // baubite movement
        if !touchLocations.isEmpty {
            let baubitesPerGroup = numberOfBaubites / touchLocations.count
            
            for touchesIndex in 0..<touchLocations.count {
                for baubitesIndex in (touchesIndex * baubitesPerGroup)..<((touchesIndex + 1) * baubitesPerGroup) {
                    baubites[baubitesIndex].move(towards: touchLocations[touchesIndex])
                }
            }
        } else {
            for baubite in baubites {
                baubite.physicsBody!.velocity = .zero
            }
        }
        
        // spawning lavalurkers
        if Int.random(in: 0..<60) == 0 {
            let lavaLurker = LavaLurker(x: Double.random(in: 0-self.frame.width...self.frame.width), y: Double.random(in: 0-self.frame.height...self.frame.height))
            lavaLurkers.append(lavaLurker)
            addChild(lavaLurkers.last!)
            lavaLurkers.last!.move(towards: nest.position)
        }
        
        // lavalurker attacks
        if Int(currentTime) % 3 == 0 {
            for lavaLurker in lavaLurkers {
                print(hypotf(Float(lavaLurker.position.x - nest.position.x), Float(lavaLurker.position.y - nest.position.y)))
                if hypotf(Float(lavaLurker.position.x - nest.position.x), Float(lavaLurker.position.y - nest.position.y)) < 80 {
                    if let particles = SKEmitterNode(fileNamed: "LavaLurkerParticle") {
                        particles.position = nest.position
                        particles.zPosition = 4
                        addChild(particles)
                    }
                    nest.health -= 10
                    if nest.health <= 0 {
                        // game over
                        gameOver()
                    } else {
                        healthBar.size.width = CGFloat(nest.health / 5)
                    }
                    print(nest.health)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "lavalurker" {
            collisionBetween(creature: contact.bodyA.node!, object: contact.bodyB.node)
        } else if contact.bodyB.node?.name == "lavalurker" {
            collisionBetween(creature: contact.bodyB.node!, object: contact.bodyA.node)
        }
    }
    
    func collisionBetween(creature: SKNode, object: SKNode?) {
        if creature.name == "lavalurker" {
            if object?.name == "nest" {
//                if let particles = SKEmitterNode(fileNamed: "LavaLurkerParticle") {
//                    particles.position = nest.position
//                    particles.zPosition = 4
//                    addChild(particles)
//                }
//                nest.health -= 100
//                if nest.health <= 0 {
//                    // game over
//                    gameOver()
//                } else {
//                    healthBar.size.width = CGFloat(nest.health / 5)
//                }
//                print(nest.health)
            } else if object?.name == "baubite" {
                if let particles = SKEmitterNode(fileNamed: "BaubiteParticle") {
                    particles.position = creature.position
                    particles.zPosition = 4
                    addChild(particles)
                }
                lavaLurkers.remove(at: lavaLurkers.firstIndex(of: creature as! LavaLurker)!)
                creature.removeFromParent()
                print("rip")
            }
        } else if creature.name == "baubite" {
            if object?.name == "lavalurker" {
                object?.removeFromParent()
                print("rip")
            }
        }
    }
    
    func gameOver() {
        // remove healthbar
        healthBar.removeFromParent()
        healthBarBackground.removeFromParent()
        damageBackground.removeFromParent()
        
        // remove baubites
        for baubite in baubites {
            baubite.removeFromParent()
        }
        baubites = []
        
        // destroy nest
        if let particles = SKEmitterNode(fileNamed: "NestParticle") {
            particles.position = nest.position
            particles.zPosition = 4
            addChild(particles)
        }
        nest.removeFromParent()
        
        // game over ui
        gameOverLabel.position = CGPoint(x: 0, y: 180)
        gameOverLabel.zPosition = 3
        addChild(gameOverLabel)
        
        print("game over")
    }
}
