//
//  BaubleButton.swift
//  Bauble2d
//
//  Created by Nick on 5/22/25.
//

import SpriteKit

class BaubleButton: SKNode {
    
    var background = SKSpriteNode(imageNamed: "baublebutton")
    var label: SKLabelNode = SKLabelNode()
    
    init(position: CGPoint, text: String) {
        super.init()
        self.position = position
        
        background.texture?.filteringMode = .nearest
        background.zPosition = 5
        background.setScale(1.5)
        addChild(background)
        
        label = SKLabelNode(text: text)
        label.verticalAlignmentMode = .center
        label.fontName = "Stardew Valley Regular"
        label.zPosition = 6
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
