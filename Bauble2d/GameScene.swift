//
//  GameScene.swift
//  Bauble2d
//
//  Created by Nick on 5/2/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var baubites: [Baubite] = []
    private var numberOfBaubites: Int = 50
    private var touchLocations: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        for i in 0..<numberOfBaubites {
            baubites.append(Baubite())
            addChild(baubites[i].sprite)
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
            baubite.sprite.removeAllActions()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // move baubites towards touchLocations in equal groups
        guard !touchLocations.isEmpty else { return }
        let baubitesPerGroup = numberOfBaubites / touchLocations.count
        let speed: Double = 250
        
        for touchesIndex in 0..<touchLocations.count {
            for baubitesIndex in (touchesIndex * baubitesPerGroup)..<((touchesIndex + 1) * baubitesPerGroup) {
                let distance: Double = Double(hypotf(Float(touchLocations[touchesIndex].x - baubites[baubitesIndex].sprite.position.x), Float(touchLocations[touchesIndex].y - baubites[baubitesIndex].sprite.position.y)))
                let action = SKAction.move(to: touchLocations[touchesIndex], duration: distance / speed)
                action.timingMode = .linear
//                baubites[baubitesIndex].sprite.removeAllActions()
                baubites[baubitesIndex].sprite.run(action)
            }
        }
    }
}
