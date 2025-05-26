//
//  Baubite.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit

class Baubite: SKSpriteNode {
    
    private let attackDamage = 10
    private let moveSpeed: Double
    public var health: Int = 100
    public var moving = false
    
    private let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "baubite")
    private var idleTextures: [SKTexture] {
        var array: [SKTexture] = []
        for i in 0..<5 {
            let texture = textureAtlas.textureNamed("baubite-idle\(i+1)")
            texture.filteringMode = .nearest
            array.append(texture)
        }
        return array
    }
    private var walkTextures: [SKTexture] {
        var array: [SKTexture] = []
        for i in 0..<6 {
            let texture = textureAtlas.textureNamed("baubite-walk\(i+1)")
            texture.filteringMode = .nearest
            array.append(texture)
        }
        return array
    }
    
    init() {
        self.moveSpeed = Double.random(in: 200...250)
        super.init(texture: nil, color: .clear, size: CGSize(width: 32/1.333, height: 40/1.333))
        self.position = CGPoint(x: Int.random(in: -50...50), y: Int.random(in: 75...100))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody!.restitution = 1
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.affectedByGravity = false
        self.zPosition = 1
        self.name = "baubite"
        self.texture?.filteringMode = .nearest
        startIdleAnimation()
    }
    
    func move(towards newLocation: CGPoint) {
        let distance: Double = Double(hypotf(Float(newLocation.x - self.position.x), Float(newLocation.y - self.position.y)))
        self.physicsBody!.velocity.dx = (newLocation.x - self.position.x) / (distance / moveSpeed)
        self.physicsBody!.velocity.dy = (newLocation.y - self.position.y) / (distance / moveSpeed)
        if !moving {
            startWalkAnimation()
            self.moving = true
        }
    }
    
    func stopMoving() {
        self.physicsBody?.velocity = .zero
        if moving {
            self.moving = false
            startIdleAnimation()
        }
    }
    
    func heal() {
        if health < 100 {
            health += 5
        }
    }
    
    func attack(enemy: Enemy) {
        enemy.health -= attackDamage
    }
    
    // animate
    func startWalkAnimation() {
        let animation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        self.run(SKAction.repeatForever(animation))
    }
    
    func startIdleAnimation() {
        let animation = SKAction.animate(with: idleTextures, timePerFrame: 0.1)
        self.run(SKAction.repeatForever(animation))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
