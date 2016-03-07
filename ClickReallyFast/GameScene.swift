//
//  GameScene.swift
//  ClickReallyFast
//
//  Created by Greg Willis on 3/6/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var mainLabel = SKLabelNode?()
    var scoreLabel = SKLabelNode?()
    var square = SKSpriteNode?()
    var score = 0
    
    var customBackgroundColorBlue = UIColor(red: (59/255), green: (89/255), blue: (152/255), alpha: 1.0)
    var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    var touchLocation = CGPoint?()
    
    let introMessage = ["Ready", "Set", "GO!!!"]
    var timerCounter = -1

    var isAlive = true
    
    override func didMoveToView(view: SKView) {
        backgroundColor = customBackgroundColorBlue
        spawnMainLabel()
        spawnScoreLabel()
        startGameTimer()
        stopGameTimer()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            touchLocation  = touch.locationInNode(self)
            if let touchedNode = nodeAtPoint(touchLocation!) as? SKSpriteNode {
                if touchedNode == square  && isAlive {
                    addToScore()
                }
                
                
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    
    }
}

// MARK: - Spawning Functions

extension GameScene {
    
    func spawnMainLabel() {
        let labelLocation : CGPoint = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetHeight(self.frame) * 0.8)
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel?.fontSize = (view?.frame.width)! * 0.3
        mainLabel?.fontColor = offWhiteColor
        mainLabel?.position = labelLocation
        mainLabel?.text = ""
        addChild(mainLabel!)
    }
    
    func spawnScoreLabel() {
        let labelLocation : CGPoint = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetHeight(self.frame) * 0.1)
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel?.fontSize = (view?.frame.width)! * 0.2
        scoreLabel?.fontColor = offBlackColor
        scoreLabel?.position = labelLocation
        scoreLabel?.text = "Score: \(score)"
        addChild(scoreLabel!)
    }
    
    func spawnSquare() {
        square = SKSpriteNode(color: offWhiteColor, size: CGSize(width: 300, height: 300))
        square?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        addChild(square!)
        
    }
}

// MARK: - Timer Functions

extension GameScene {
    
    func startGameTimer() {
        

        let wait = SKAction.waitForDuration(1.0)
        let countDownTimer = SKAction.runBlock {
            self.timerCounter++
            if self.timerCounter == 0 {
                self.mainLabel?.text = "\(self.introMessage[self.timerCounter])"
            }
            if self.timerCounter == 1 {
                self.mainLabel?.text = "\(self.introMessage[self.timerCounter])"
            }
            if self.timerCounter == 2 {
                self.mainLabel?.text = "\(self.introMessage[self.timerCounter])"
                self.spawnSquare()
            }
            
        }
        let sequence = SKAction.sequence([wait, countDownTimer])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    func stopGameTimer() {
        let wait = SKAction.waitForDuration(10.0)
        let stopThenPresentScene = SKAction.runBlock {
            self.square?.removeFromParent()
            self.isAlive = false
            self.mainLabel?.text = "Try Again"
            self.mainLabel?.fontSize = (self.view?.frame.width)! * 0.2
            self.resetGame()
            
        }
        runAction(SKAction.sequence([wait, stopThenPresentScene]))
    }
}

// MARK: - Score Functions

extension GameScene {
    
    func addToScore() {
        score++
        self.scoreLabel?.text = "Score: \(self.score)"
    }
}

// MARK: - Helper Functions

extension GameScene {
    
    func resetGame() {
        let wait = SKAction.waitForDuration(4)
        let transition = SKAction.runBlock {
            if let gameScene = GameScene(fileNamed: "GameScene"), view = self.view {
                gameScene.scaleMode = .ResizeFill
                view.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        runAction(SKAction.sequence([wait, transition]))
    }
}