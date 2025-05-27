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
     -add tank enemy: lots of health, have to use many baubites to tank out
     */
    
    /*
     !!! option key can be used to do multiple touches on simulator !!!
     baubite movement is a bit buggy in simulator but works perfectly on real devices
     */
    
    // MARK: Variables
    // gameplay vars
    public var score = 0
    public var baubites: [Baubite] = []
    public var enemies: [Enemy] = []
    public var nest: Nest = Nest()
    private var touchLocations: [CGPoint] = []
    private var enemySpawnTimerNode = SKNode()
    
    // ui vars
    public let healthBar = NestHealthbar(position: CGPoint(x: -140, y: 200))
    private var time = 0 {
        didSet {
            // change enemy spawn interval
            if time == 10 {
                enemySpawnTimerNode.speed = 3
            } else if time == 20 {
                enemySpawnTimerNode.speed = 4
            } else if time == 30 {
                enemySpawnTimerNode.speed = 5
            } else if time == 60 {
                enemySpawnTimerNode.speed = 6
            } else if time == 120 {
                enemySpawnTimerNode.speed = 7
            } else if time == 360 {
                enemySpawnTimerNode.speed = 8
            }
        }
    }
    private let scoreLabel = SKLabelNode(text: "Score: 0")
    private let playButton = BaubleButton(position: CGPoint(x: 0, y: 0), text: "Play again?")
    private let menuButton = BaubleButton(position: CGPoint(x: 0, y: -75), text: "Main menu")
    private var cursors: [Cursor] = []
    
    enum PowerUpType {
        case baubiteSpawner, enemyClearer, nestHealer
    }
    
    // MARK: Start & Update Functions
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        let musicNode = SKAudioNode(fileNamed: "360.mp3")
        musicNode.autoplayLooped = true
        musicNode.isPositional = false
        addChild(musicNode)
        physicsWorld.contactDelegate = self
        
        // add background
        let background = SKSpriteNode(imageNamed: "grass")
        background.texture?.filteringMode = .nearest
        background.zPosition = 0
        addChild(background)
        
        // add border
        let border = SKSpriteNode(color: .clear, size: CGSize(width: 0, height: 0))
        border.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.physicsBody!.restitution = 1
        border.physicsBody!.affectedByGravity = false
        addChild(border)
        
        // add nest
        addChild(nest)
        
        // add baubites
        for i in 0..<10 {
            baubites.append(Baubite())
            addChild(baubites[i])
        }
        
        // nest healthbar & timer
        addChild(healthBar)
        let powerUpTimer = PowerUpTimer(in: self, position: CGPoint(x: 120, y: 200))
        powerUpTimer.name = "poweruptimer"
        addChild(powerUpTimer)
        
        // final score label
        scoreLabel.position = CGPoint(x: 0, y: 85)
        scoreLabel.fontName = "Stardew Valley Regular"
        scoreLabel.zPosition = 10
        
        // one second timer
        let oneSecondTimer = SKAction.wait(forDuration: 1)
        let secondTimerAction = SKAction.run(secondFunction)
        let secondTimerSequence = SKAction.sequence([oneSecondTimer, secondTimerAction])
        self.run(SKAction.repeatForever(secondTimerSequence))
        
        // half second timer
        let halfSecondTimer = SKAction.wait(forDuration: 0.5)
        let halfSecondTimerAction = SKAction.run(halfSecondFunction)
        let halfSecondTimerSequence = SKAction.sequence([halfSecondTimer, halfSecondTimerAction])
        self.run(SKAction.repeatForever(halfSecondTimerSequence))
        
        // baubite attack timer
        let baubiteAttackTimer = SKAction.wait(forDuration: 0.1)
        let baubiteAttackTimerAction = SKAction.run(baubiteAttackTimerFunction)
        let baubiteAttackTimerSequence = SKAction.sequence([baubiteAttackTimer, baubiteAttackTimerAction])
        self.run(SKAction.repeatForever(baubiteAttackTimerSequence))
        
        // enemy spawn timer
        let enemySpawnTimer = SKAction.wait(forDuration: 3)
        let enemySpawnTimerAction = SKAction.run(spawnEnemy)
        let enemySpawnTimerSequence = SKAction.sequence([enemySpawnTimer, enemySpawnTimerAction])
        enemySpawnTimerNode.run(SKAction.repeatForever(enemySpawnTimerSequence), withKey: "enemySpawnTimer")
        addChild(enemySpawnTimerNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard nest.health > 0 else { return }
        
        // baubite movement
        if !touchLocations.isEmpty {
            let numberOfStragglers = baubites.count % touchLocations.count
            let baubitesPerGroup = baubites.count / touchLocations.count
            
            for touchesIndex in 0..<touchLocations.count {
                for baubitesIndex in (touchesIndex * baubitesPerGroup)..<((touchesIndex + 1) * baubitesPerGroup) {
                    baubites[baubitesIndex].move(towards: touchLocations[touchesIndex])
                }
            }
            
            // add stragglers to last group
            if numberOfStragglers > 0 {
                for i in 1...numberOfStragglers {
                    baubites[baubites.count - i].move(towards: touchLocations.last!)
                }
            }
        } else {
            for baubite in baubites {
                baubite.stopMoving()
            }
        }
    }
    
    // MARK: Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // add touched points to touchLocations
        if nest.health > 0 {
            for touch in touches {
                touchLocations.append(touch.location(in: self))
                cursors.append(Cursor(position: touch.location(in: self)))
                addChild(cursors.last!)
            }
        } else {
            if let touch = touches.first {
                let location = touch.location(in: self)
                let objects = nodes(at: location)
                if objects.contains(playButton) {
                    let newScene = SKScene(fileNamed: "GameScene")
                    newScene!.scaleMode = .aspectFit
                    newScene?.run(SKAction.playSoundFileNamed("buttonclick.wav", waitForCompletion: false))
                    self.view!.presentScene(newScene!)
                    return
                } else if objects.contains(menuButton) {
                    let newScene = SKScene(fileNamed: "TitleScene")
                    newScene!.scaleMode = .aspectFit
                    newScene?.run(SKAction.playSoundFileNamed("buttonclick.wav", waitForCompletion: false))
                    self.view!.presentScene(newScene!)
                    return
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // add touched points to touchLocations
        for touch in touches {
            if let touchIndex = touchLocations.firstIndex(of: touch.previousLocation(in: self)) {
                touchLocations[touchIndex] = touch.location(in: self)
                cursors[touchIndex].move(to: touch.location(in: self))
            } else if let touchIndex = touchLocations.firstIndex(of: touch.location(in: self)) {
                touchLocations[touchIndex] = touch.location(in: self)
                cursors[touchIndex].move(to: touch.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // remove from touchLocations
        for touch in touches {
            touchLocations.removeAll(where: { $0 == touch.previousLocation(in: self) })
            touchLocations.removeAll(where: { $0 == touch.location(in: self) })
            // remove cursors
            cursors.forEach { cursor in
                if cursor.position == touch.previousLocation(in: self) || cursor.position == touch.location(in: self) {
                    cursor.removeFromParent()
                    cursors.removeAll(where: { $0.position == cursor.position })
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // empty touchLocations & cursors
        for cursor in cursors {
            cursor.removeFromParent()
        }
        touchLocations = []
        cursors = []
    }
    
    // MARK: Collision Functions
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "baubite" {
            collisionBetween(creature: contact.bodyA.node!, object: contact.bodyB.node)
        } else if contact.bodyB.node?.name == "baubite" {
            collisionBetween(creature: contact.bodyB.node!, object: contact.bodyA.node)
        }
    }
    
    func collisionBetween(creature: SKNode, object: SKNode?) {
        if creature.name == "baubite" {
            if object?.name == "baubitespawn" {
                (object as! BaubiteSpawn).collected(in: self)
            } else if object?.name == "enemyclearer" {
                (object as! EnemyClearer).collected(in: self)
            } else if object?.name == "nesthealer" {
                (object as! NestHealer).collected(in: self)
            }
        }
    }
    
    // MARK: Timer Functions
    func secondFunction() {
        time += 1
        
        // heal baubites
        for baubite in baubites {
            baubite.heal()
        }
    }
    
    func halfSecondFunction() {
        guard nest.health > 0 else {
            gameOver()
            return
        }
        
        // enemy attacks
        for enemy in enemies {
            if hypotf(Float(enemy.position.x - nest.position.x), Float(enemy.position.y - nest.position.y)) < 100 {
                enemy.attack(target: nest)
                if enemy.name == "lavalurker" {
                    spawnParticle(name: "LavaLurkerParticle", position: nest.position)
                } else {
                    spawnParticle(name: "PudgyParticle", position: nest.position)
                }
            }
        }
        
        // heal nest
        if nest.health < 1000 {
            nest.health += 1
            healthBar.update(health: nest.health)
        }
    }
    
    func baubiteAttackTimerFunction() {
        for baubite in baubites {
            for enemy in enemies.filter({ hypotf(Float($0.position.x - baubite.position.x), Float($0.position.y - baubite.position.y)) < 60 }) {
                spawnParticle(name: "BaubiteParticle", position: enemy.position)
                baubite.attack(enemy: enemy)
                if baubites.count > 5 {
                    enemy.attack(target: baubite)
                }
                // deaths
                if baubite.health <= 0 {
                    baubiteDeath(baubite: baubite)
                }
                if enemy.health <= 0 {
                    enemyDeath(enemy: enemy)
                }
            }
        }
    }
    
    // MARK: Gameplay Functions
    func gameOver() {
        // stop timers
        removeAllActions()
        enemySpawnTimerNode.removeAllActions()
        
        // remove healthbar & power up timer
        healthBar.removeFromParent()
        childNode(withName: "poweruptimer")?.removeFromParent()
        
        // remove baubites
        for baubite in baubites {
            baubite.removeFromParent()
        }
        baubites = []
        
        // destroy nest
        spawnParticle(name: "NestParticle", position: nest.position)
        nest.removeFromParent()
        self.run(SKAction.playSoundFileNamed("nestdeath.wav", waitForCompletion: false))
        
        // show final score
        let title = SKSpriteNode(texture: SKTexture(imageNamed: "logo"))
        title.texture?.filteringMode = .nearest
        title.setScale(1.2)
        title.position = CGPoint(x: 0, y: 150)
        title.zPosition = 3
        addChild(title)
        
        score += time * 17
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.removeFromParent()
        scoreLabel.zPosition = 4
        addChild(scoreLabel)
        
        // add buttons
        playButton.removeFromParent()
        addChild(playButton)
        menuButton.removeFromParent()
        addChild(menuButton)
        
        // high score
        if score > UserDefaults.standard.integer(forKey: "highscore") {
            UserDefaults.standard.set(score, forKey: "highscore")
        }
    }
    
    func spawnEnemy() {
        let enemy: Enemy
        if Int.random(in: 0..<3) == 0 {
            enemy = Pudgy(spawnPoint: getEnemySpawnPoint())
        } else {
            enemy = LavaLurker(spawnPoint: getEnemySpawnPoint())
        }
        enemies.append(enemy)
        addChild(enemy)
        enemy.move(towards: nest.position)
        if enemy.position.x < 0 {
            enemy.xScale = -1
        }
    }
    
    func spawnPowerUp(_ type: PowerUpType) {
        let x = Double.random(in: -self.frame.width/2+30...self.frame.width/2-30)
        let y = Double.random(in: -self.frame.height/2+30...self.frame.height/2-30)
        switch type {
        case .baubiteSpawner:
            spawnParticle(name: "BaubiteParticle", position: CGPoint(x: x, y: y))
            addChild(BaubiteSpawn(x: x, y: y))
        case .nestHealer:
            spawnParticle(name: "PudgyParticle", position: CGPoint(x: x, y: y))
            addChild(NestHealer(x: x, y: y))
        case .enemyClearer:
            spawnParticle(name: "LavaLurkerParticle", position: CGPoint(x: x, y: y))
            addChild(EnemyClearer(x: x, y: y))
        }
    }
    
    func getEnemySpawnPoint() -> CGPoint {
        let x: Double
        let y: Double
        
        x = Double.random(in: -self.frame.width/2+30...self.frame.width/2-30)
        if Int.random(in: 0...1) == 0 {
            y = -self.frame.height/2+30
        } else {
            y = self.frame.height/2-30
        }
        return CGPoint(x: x, y: y)
    }
    
    func removeAllEnemies() {
        for enemy in enemies {
            if enemy.name == "lavalurker" {
                spawnParticle(name: "LavaLurker", position: enemy.position)
            } else {
                spawnParticle(name: "PudgyParticle", position: enemy.position)
            }
            enemies.removeAll(where: { $0 == enemy })
            enemy.removeFromParent()
        }
    }
    
    func spawnParticle(name: String, position:  CGPoint) {
        if let particles = SKEmitterNode(fileNamed: name) {
            particles.position = position
            particles.zPosition = 4
            addChild(particles)
        }
    }
    
    func enemyDeath(enemy: Enemy) {
        if enemy.name == "lavalurker" {
            spawnParticle(name: "LavaLurkerParticle", position: enemy.position)
        } else {
            spawnParticle(name: "PudgyParticle", position: enemy.position)
        }
        enemies.removeAll(where: { $0 == enemy })
        enemy.removeFromParent()
        score += 40
    }
    
    func baubiteDeath(baubite: Baubite) {
        spawnParticle(name: "BaubiteParticle", position: baubite.position)
        baubites.removeAll(where: { $0 == baubite })
        baubite.removeFromParent()
        score -= 40
    }
}
