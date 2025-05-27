//
//  PowerUpTimer.swift
//  Bauble2d
//
//  Created by Nick on 5/26/25.
//

import SpriteKit

class PowerUpTimer: SKNode {
    var overlay = SKSpriteNode(imageNamed: "powerup-timer")
    var timerBar = SKSpriteNode(color: UIColor(.baublePurple), size: CGSize(width: 150, height: 30))
    var background = SKSpriteNode(color: .darkGray, size: CGSize(width: 150, height: 30))
    var gameScene: GameScene
    
    enum PowerUpColor {
        case red, green, purple
    }
    
    init(in gameScene: GameScene, position: CGPoint) {
        self.gameScene = gameScene
        super.init()
        self.position = position
        
        overlay.texture?.filteringMode = .nearest
        overlay.zPosition = 5
        addChild(overlay)
        
        timerBar.zPosition = 4
        timerBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        timerBar.position = CGPoint(x: -72, y: 0)
        addChild(timerBar)
        
        background.zPosition = 3
        background.anchorPoint = CGPoint(x: 0, y: 0.5)
        background.position = CGPoint(x: -72, y: 0)
        addChild(background)
        
        startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColor(_ color: PowerUpColor) {
        timerBar.color = getColor(color)
    }
    
    func getColor(_ color: PowerUpColor) -> UIColor {
        switch color {
        case .green:
            return UIColor(.baubleGreen)
        case .red:
            return UIColor(.baubleRed)
        case .purple:
            return UIColor(.baublePurple)
        }
    }
    
    func startTimer() {
        let powerUpTimer = SKAction.wait(forDuration: 5)
        let powerUpTimerAction = SKAction.run(spawnPowerUp)
        let powerUpTimerSequence = SKAction.sequence([powerUpTimer, powerUpTimerAction])
        spawnPowerUp()
        self.run(SKAction.repeatForever(powerUpTimerSequence))
    }
    
    func spawnPowerUp() {
        let powerUp = Int.random(in: 0..<3)
        let type: GameScene.PowerUpType
        
        timerBar.run(SKAction.resize(toWidth: 150, duration: 0))
        
        switch powerUp {
        case 0:
            timerBar.color = .baublePurple
            type = .baubiteSpawner
        case 1:
            timerBar.color = .baubleRed
            type = .enemyClearer
        default:
            timerBar.color = .baubleGreen
            type = .nestHealer
        }
        
        timerBar.run(SKAction.resize(toWidth: 0, duration: 5), completion: {
            self.gameScene.spawnPowerUp(type)
            self.run(SKAction.playSoundFileNamed("powerupspawn.wav", waitForCompletion: false))
        })
    }
}
