//
//  PowerUp.swift
//  Bauble2d
//
//  Created by Nick on 5/26/25.
//
import SpriteKit

class PowerUpBase: SKSpriteNode {
    
    private let textureAtlas: SKTextureAtlas
    private var textures: [SKTexture] {
        var array: [SKTexture] = []
        for textureName in textureAtlas.textureNames.sorted(by: <) {
            array.append(textureAtlas.textureNamed(textureName))
        }
        return array
    }
    
    init(textureAtlas: SKTextureAtlas, position: CGPoint) {
        self.textureAtlas = textureAtlas
        super.init(texture: textureAtlas.textureNamed(textureAtlas.textureNames.first!), color: .white, size: CGSize(width: 48, height: 48))
        
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.contactTestBitMask = self.physicsBody!.collisionBitMask
        self.zPosition = 2
        self.texture?.filteringMode = .nearest
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.3)
        self.run(SKAction.repeatForever(animation))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PowerUp {
    func collected(in scene: GameScene)
}
