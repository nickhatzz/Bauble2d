//
//  TitleScene.swift
//  Bauble2d
//
//  Created by Nick on 5/4/25.
//

import SpriteKit
import GameplayKit

class TitleScene: SKScene {

    private var title: SKSpriteNode!
    private var playButton: SKSpriteNode!
    private var crashButton: SKSpriteNode!
    private var baubite: Baubite = Baubite()
    private var lavaLurker: LavaLurker = LavaLurker(x: 0, y: -100)
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        
        // add border
        let border = SKSpriteNode(color: .clear, size: CGSize(width: 0, height: 0))
        border.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.physicsBody!.restitution = 1
        border.physicsBody!.affectedByGravity = false
        addChild(border)
        
        // add nest
        addChild(Nest())
        
        // add baubite and lavalurker
        addChild(baubite)
        addChild(lavaLurker)
        
        // ui
        title = SKSpriteNode(texture: SKTexture(imageNamed: "logo"), size: CGSize(width: 683 / 2, height: 384 / 2))
        title.position = CGPoint(x: 0, y: 180)
        title.zPosition = 3
        addChild(title)
        
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playbutton"), size: CGSize(width: 409 / 2, height: 144 / 2))
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.zPosition = 3
        addChild(playButton)
        
        crashButton = SKSpriteNode(texture: SKTexture(imageNamed: "crashbutton"), size: CGSize(width: 409 / 2, height: 143 / 2))
        crashButton.position = CGPoint(x: 0, y: -100)
        crashButton.zPosition = 3
        addChild(crashButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(playButton) {
                let newScene = SKScene(fileNamed: "GameScene")
                newScene!.scaleMode = .aspectFit
                self.view!.presentScene(newScene!, transition: SKTransition.doorsCloseHorizontal(withDuration: 2))
                return
            } else if objects.contains(crashButton) {
                let emptyArray: [String] = []
                let crash = emptyArray[0]
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // randomly move baubite
        if Int.random(in: 0...60) == 0 {
            baubite.move(towards: CGPoint(x: Int.random(in: Int(0 - self.scene!.frame.width)..<Int(self.scene!.frame.width)), y: Int.random(in: Int(0 - self.scene!.frame.height)..<Int(self.scene!.frame.height))))
        }
        
        // make lavalurker follow baubite
        lavaLurker.move(towards: baubite.position)
    }
    
}
