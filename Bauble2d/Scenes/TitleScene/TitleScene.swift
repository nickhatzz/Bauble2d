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
    private var playButton = BaubleButton(position: CGPoint(x: 0, y: 0), text: "Play!")
    private var gitHubButton = BaubleButton(position: CGPoint(x: 0, y: -75), text: "GitHub Repo")
    private var baubite: Baubite = Baubite()
    private var lavaLurker: LavaLurker = LavaLurker(spawnPoint: CGPoint(x: 0, y: 100))
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFit
        let musicNode = SKAudioNode(fileNamed: "Apple.mp3")
        musicNode.autoplayLooped = true
        musicNode.isPositional = false
        addChild(musicNode)
        
        // add background
        let background = SKSpriteNode(imageNamed: "grass")
        background.texture?.filteringMode = .nearest
        background.zPosition = 0
        addChild(background)
        
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
        lavaLurker.startWalkAnimation()
        
        // ui
        title = SKSpriteNode(texture: SKTexture(imageNamed: "logo"))
        title.texture?.filteringMode = .nearest
        title.setScale(1.2)
        title.position = CGPoint(x: 0, y: 150)
        title.zPosition = 3
        addChild(title)
        
        addChild(playButton)
        addChild(gitHubButton)
        
        let highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(UserDefaults.standard.integer(forKey: "highscore"))")
        highScoreLabel.fontName = "Stardew Valley Regular"
        highScoreLabel.position = CGPoint(x: 0, y: 85)
        highScoreLabel.zPosition = 4
        addChild(highScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(playButton) {
                let newScene = SKScene(fileNamed: "GameScene")
                newScene!.scaleMode = .aspectFit
                newScene?.run(SKAction.playSoundFileNamed("buttonclick.wav", waitForCompletion: false))
                self.view!.presentScene(newScene!)
                return
            } else if objects.contains(gitHubButton) {
                self.run(SKAction.playSoundFileNamed("buttonclick.wav", waitForCompletion: false))
                UIApplication.shared.open(URL(string: "https://github.com/nickhatzz/Bauble2d")!)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // randomly move baubite
        if Int.random(in: 0...60) == 0 {
            baubite.move(towards: CGPoint(x: Int.random(in: Int(0 - self.scene!.frame.width/2)..<Int(self.scene!.frame.width/2)), y: Int.random(in: Int(0 - self.scene!.frame.height/2)..<Int(self.scene!.frame.height/2))))
        }
        
        // make lavalurker follow baubite
        lavaLurker.move(towards: baubite.position)
    }
    
}
