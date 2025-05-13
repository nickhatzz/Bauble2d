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
    // health bar
    private let healthBar = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 20))
    let healthBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 210, height: 25))
    let damageBackground = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 20))
    // timer
    private let timeLabel = SKLabelNode(text: "Time: 00:00")
    var time = 0
    // score
    private let scoreLabel = SKLabelNode(text: "Score: 0")
    
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
        
        // final score label
        scoreLabel.position = CGPoint(x: 0, y: 100)
        scoreLabel.fontSize = 60
        scoreLabel.fontName = "KiwiSoda"
        scoreLabel.zPosition = 10
        
        // timer label
        timeLabel.position = CGPoint(x: -350, y: 190)
        timeLabel.fontSize = 45
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.fontName = "KiwiSoda"
        timeLabel.zPosition = 10
        addChild(timeLabel)
        
        // timer timer
        let oneSecondTimer = SKAction.wait(forDuration: 1)
        let timerAction = SKAction.run(updateTime)
        let timerSequence = SKAction.sequence([oneSecondTimer, timerAction])
        self.run(SKAction.repeatForever(timerSequence))
        
        // lavalurker attack timer
        let halfSecondTimer = SKAction.wait(forDuration: 0.5)
        let attackTimerAction = SKAction.run(lavaLurkerAttack)
        let attackTimerSequence = SKAction.sequence([halfSecondTimer, attackTimerAction])
        self.run(SKAction.repeatForever(attackTimerSequence))
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
            if object?.name == "baubite" {
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
        // stop timers
        removeAllActions()
        
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
        
        // show final score
        scoreLabel.text = "Score: \(time * 17)"
        addChild(scoreLabel)
        
        // add play again button
        // add return to menu button
        
        print("game over")
    }
    
    func updateTime() {
        time += 1
        let minutes: Int = time / 60
        let seconds: Int = time - (minutes * 60)
        timeLabel.text = "Time: \(String(format: "%2.2d", minutes)):\(String(format: "%2.2d", seconds))"
    }
    
    func lavaLurkerAttack() {
        guard nest.health > 0 else { return }
        
        for lavaLurker in lavaLurkers {
            if hypotf(Float(lavaLurker.position.x - nest.position.x), Float(lavaLurker.position.y - nest.position.y)) < 100 {
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
