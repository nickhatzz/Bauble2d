//
//  NestHealthbar.swift
//  Bauble2d
//
//  Created by Nick on 5/23/25.
//

import SpriteKit

class NestHealthbar: SKNode {
    var background = SKSpriteNode(imageNamed: "nesthealthbar")
    var healthbar = SKSpriteNode(imageNamed: "healthbargreen")
    var healthbarCropNode = SKCropNode()
    
    init(position: CGPoint) {
        super.init()
        self.position = position
        
        background.texture?.filteringMode = .nearest
        background.zPosition = 5
        addChild(background)
        
        healthbar.texture?.filteringMode = .nearest
        healthbar.zPosition = 6
        healthbar.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthbar.position = CGPoint(x: -209/2, y: -2)
        addChild(healthbar)
    }
    
    func update(health: Int) {
        healthbar.size.width = 209.0 * (CGFloat(health)/1000)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
