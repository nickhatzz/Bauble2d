//
//  Enemy.swift
//  Bauble2d
//
//  Created by Nick on 5/26/25.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    var health: Int
    private let attackDamage: Int
    private let moveSpeed: Double
    private let textureAtlas: SKTextureAtlas
    private var walkTextures: [SKTexture] {
        var array: [SKTexture] = []
        for textureName in textureAtlas.textureNames.sorted(by: <) {
            if textureName.contains("walk") {
                array.append(textureAtlas.textureNamed(textureName))
            }
        }
        return array
    }
    
    init(health: Int, attackDamage: Int, moveSpeed: Double, size: CGSize, position: CGPoint, textureAtlas: SKTextureAtlas) {
        self.health = health
        self.moveSpeed = moveSpeed
        self.textureAtlas = textureAtlas
        self.attackDamage = attackDamage
        super.init(texture: .none, color: .white, size: size)
        
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.restitution = 1
        self.physicsBody?.mass = 1000
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        self.physicsBody!.affectedByGravity = false
        self.zPosition = 1
    }
    
    func move(towards newLocation: CGPoint) {
        let distance: Double = Double(hypotf(Float(newLocation.x - self.position.x), Float(newLocation.y - self.position.y)))
        self.physicsBody!.velocity.dx = (newLocation.x - self.position.x) / (distance / moveSpeed)
        self.physicsBody!.velocity.dy = (newLocation.y - self.position.y) / (distance / moveSpeed)
        startWalkAnimation()
    }
    
    func startWalkAnimation() {
        let animation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        self.run(SKAction.repeatForever(animation))
    }
    
    func attack(target: SKSpriteNode) {
        if let baubite = target as? Baubite {
            baubite.health -= attackDamage
        } else if let nest = target as? Nest {
            nest.health -= attackDamage
        }
        self.run(SKAction.playSoundFileNamed("attack.wav", waitForCompletion: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
