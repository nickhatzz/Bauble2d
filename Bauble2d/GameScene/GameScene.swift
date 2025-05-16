//
//  GameScene.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*
     TO-DO:
     -more powerups (clear enemies, heal nest, etc)
     -play again button
     -improve nest healthbar
     -make enemies spawn only on outter edges
     -prevent last baubite from dying
     -second enemy type
     -make powerups spawn on a timer, add timer to ui
     -return to menu button
     -save top scores to menu
     -improve the way that more enemies spawn when the time is greater
     */
    
    // gameplay vars
    private var baubites: [Baubite] = []
    private var lavaLurkers: [LavaLurker] = []
    private var nest: Nest = Nest()
    private var numberOfBaubites: Int = 5
    private var touchLocations: [CGPoint] = []
    private var score = 0
    
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
        let secondTimerAction = SKAction.run(secondFunction)
        let secondTimerSequence = SKAction.sequence([oneSecondTimer, secondTimerAction])
        self.run(SKAction.repeatForever(secondTimerSequence))
        
        // lavalurker attack timer
        let halfSecondTimer = SKAction.wait(forDuration: 0.5)
        let halfSecondTimerAction = SKAction.run(halfSecondFunction)
        let halfSecondTimerSequence = SKAction.sequence([halfSecondTimer, halfSecondTimerAction])
        self.run(SKAction.repeatForever(halfSecondTimerSequence))
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
        if Int.random(in: 0..<30/((time/15)+1)) == 0 {
            let lavaLurker = LavaLurker(x: Double.random(in: 0-self.frame.width...self.frame.width), y: Double.random(in: 0-self.frame.height...self.frame.height))
            lavaLurkers.append(lavaLurker)
            addChild(lavaLurkers.last!)
            lavaLurkers.last!.move(towards: nest.position)
            if lavaLurker.position.x < 0 {
                lavaLurker.xScale = -1
            }
        }
        
        // spawning powerups
        if Int.random(in: 0..<200) == 0 {
            spawnPowerUp()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "baubite" {
            collisionBetween(creature: contact.bodyA.node!, object: contact.bodyB.node)
        } else if contact.bodyB.node?.name == "baubite" {
            collisionBetween(creature: contact.bodyB.node!, object: contact.bodyA.node)
        }
    }
    
    func collisionBetween(creature: SKNode, object: SKNode?) {
        if creature.name == "baubite" {
            if object?.name == "lavalurker" {
                let baubite = creature as! Baubite
                baubite.health -= 10
                if baubite.health <= 0 && numberOfBaubites > 1 {
                    baubite.removeFromParent()
                    numberOfBaubites -= 1
                    baubites.remove(at: baubites.firstIndex(of: baubite)!)
                    (object as! LavaLurker).move(towards: CGPoint(x: 0, y: 0))
                    score -= 40
                } else {
                    if let particles = SKEmitterNode(fileNamed: "BaubiteParticle") {
                        particles.position = object!.position
                        particles.zPosition = 4
                        addChild(particles)
                    }
                    lavaLurkers.remove(at: lavaLurkers.firstIndex(of: object as! LavaLurker)!)
                    object!.removeFromParent()
                    score += 20
                }
            } else if object?.name == "baubitespawn" {
                score += 200
                object!.removeFromParent()
                print("colission")
                for _ in 0..<10 {
                    baubites.append(Baubite())
                    if let particles = SKEmitterNode(fileNamed: "BaubiteParticle") {
                        particles.position = baubites.last!.position
                        particles.zPosition = 4
                        addChild(particles)
                    }
                    addChild(baubites.last!)
                    numberOfBaubites += 1
                }
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
        score += time * 17
        scoreLabel.text = "Score: \(score)"
        scoreLabel.removeFromParent()
        addChild(scoreLabel)
        
        // add play again button
        // add return to menu button
        
        print("game over")
    }
    
    func secondFunction() {
        // update time
        time += 1
        let minutes: Int = time / 60
        let seconds: Int = time - (minutes * 60)
        timeLabel.text = "Time: \(String(format: "%2.2d", minutes)):\(String(format: "%2.2d", seconds))"
        
        // heal baubites
        for baubite in baubites {
            baubite.heal()
        }
    }
    
    func halfSecondFunction() {
        guard nest.health > 0 else { return }
        
        // lavalurker attacks
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
        
        // heal nest
        if nest.health < 1000 {
            nest.health += 1
            healthBar.size.width = CGFloat(nest.health / 5)
        }
    }
    
    func spawnPowerUp() {
        let powerUp = Int.random(in: 0...0)
        let x = Double.random(in: 0-self.frame.width...self.frame.width)
        let y = Double.random(in: 0-self.frame.height...self.frame.height)
        switch powerUp {
        case 0:
            if let particles = SKEmitterNode(fileNamed: "BaubiteParticle") {
                particles.position = CGPoint(x: x, y: y)
                particles.zPosition = 4
                addChild(particles)
            }
            addChild(BaubiteSpawn(x: x, y: y))
        default:
            break
        }
    }
}
