//
//  GameScene.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var baubites: [Baubite] = []
    private var nest: Nest = Nest()
    private var numberOfBaubites: Int = 100
    private var touchLocations: [CGPoint] = []
    
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
        
        // check nest health
        if nest.health <= 0 {
            gameOver()
        }
        
        // spawning lavalurkers
        if Int.random(in: 0..<60) == 0 {
            let lavaLurker = LavaLurker(x: Double.random(in: 0-self.frame.width...self.frame.width), y: Double.random(in: 0-self.frame.height...self.frame.height))
            let action = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 5)
            lavaLurker.run(action)
            addChild(lavaLurker)
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
                nest.health -= 100
                print(nest.health)
            } else if object?.name == "baubite" {
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
        print("game over")
    }
}
