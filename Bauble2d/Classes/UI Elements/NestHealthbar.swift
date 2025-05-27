//
//  NestHealthbar.swift
//  Bauble2d
//
//  Created by Nick on 5/23/25.
//

import SpriteKit

class NestHealthbar: SKNode {
    let shrinkSpeed = 30.0
    var healthbar = SKSpriteNode(imageNamed: "nesthealthbar")
    var greenBar = SKSpriteNode(color: UIColor(.baubleGreen), size: CGSize(width: 209, height: 30))
    var redBar = SKSpriteNode(color: UIColor(.baubleRed), size: CGSize(width: 209, height: 30))
    
    init(position: CGPoint) {
        super.init()
        self.position = position
        
        healthbar.texture?.filteringMode = .nearest
        healthbar.zPosition = 5
        addChild(healthbar)
        
        greenBar.zPosition = 4
        greenBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        greenBar.position = CGPoint(x: -209/2, y: 0)
        redBar.zPosition = 3
        addChild(greenBar)
        addChild(redBar)
    }
    
    func update(health: Int) {
        let newWidth = 209.0 * (CGFloat(health)/1000)
        let difference = abs(greenBar.frame.width - newWidth)
        
        let shrinkAction = SKAction.resize(toWidth: newWidth, duration: difference / shrinkSpeed)
        greenBar.run(shrinkAction)
//        greenBar.size.width = 209.0 * (CGFloat(health)/1000)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
