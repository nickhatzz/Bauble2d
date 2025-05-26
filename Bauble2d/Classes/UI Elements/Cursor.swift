//
//  Cursor.swift
//  Bauble2d
//
//  Created by Nick on 5/25/25.
//

import SpriteKit

class Cursor: SKSpriteNode {
    init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "cursor"), color: .white, size: CGSize(width: 96, height: 96))
        self.position = position
        self.texture?.filteringMode = .nearest
        self.zPosition = 10
    }
    
    func move(to position: CGPoint) {
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
