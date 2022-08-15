//
//  GameScene.swift
//  Lab9_2022
//
//  Created by ICS 224 on 2022-03-22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
     
    var sprite : SKSpriteNode!
    var opponentSprite : SKSpriteNode!
    var hitCounter : SKLabelNode!
    var opponentHasBeenDropped : Bool = false;
    var gameOver = false;
    var opponentMovementX : Int = 0;
    var misses : Int = 0
    var hits : Int = 0;
    var score : Int = 0 {
        didSet {
            hitCounter.text = "Score: \(score)"
        }
    }
    
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10
    
    override func didMove(to view: SKView) {
        hitCounter = SKLabelNode(fontNamed: "Chalkduster");
        hitCounter.text = "Score: 0";
        hitCounter.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(hitCounter);
        
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width, y: 100 )
        sprite.size = CGSize(width: 120, height: 80)
        addChild(sprite)
        
        CreateOponent()
        
        //let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1.5)
        //let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 2)
        //let movement = SKAction.sequence([downMovement, upMovement])
        //opponentSprite.run(SKAction.repeatForever(movement))
        
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        
        
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       print("Hit!")
        hits+=1;
        opponentHasBeenDropped = true;
        DropOponent()
        moveOpponent()
    }
    
    func moveOpponent() {
        print("Position: \(opponentSprite.position.x)")
        let downMovement = SKAction.move(to: CGPoint(x: opponentMovementX, y: 0), duration: TimeInterval(Float.random(in: 1.0...5.0)))
        opponentSprite.run(downMovement)
        opponentHasBeenDropped = false;
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if(!gameOver){
            sprite.run(SKAction.move(to: CGPoint(x: pos.x, y: sprite.position.y), duration: 1))
        }
    }
     
    func touchMoved(toPoint pos : CGPoint) {
    }

    func touchUp(atPoint pos : CGPoint) {
        if(!gameOver){
            sprite.run(SKAction.move(to: CGPoint(x: pos.x, y: sprite.position.y), duration: 1))
        }
    }
         
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
         
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
         
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
         
    override func update(_ currentTime: TimeInterval) {
        if(!gameOver){
            if(score < 0){
                print("GameOver")
                gameOver = true;
                let gameOverMessage = SKLabelNode(fontNamed: "Chalkduster");
                gameOverMessage.text = "Game Over! Catches: \(hits) Misses: \(misses)";
                gameOverMessage.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
                addChild(gameOverMessage);
                scene?.view?.isPaused = true;
            }
        
            if(opponentSprite.position.y == 0 && !opponentHasBeenDropped){
                opponentHasBeenDropped = true;
                DropOponent()
                moveOpponent()
                    misses+=1;
            }
            score = hits - misses;
        }
    }
    
    func CreateOponent(){
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        opponentSprite.size = CGSize(width: 100, height: 100)
        addChild(opponentSprite)
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        misses-=1
        DropOponent();
        moveOpponent();
    }
    
    func DropOponent(){
        let randomX = Int.random(in: 10...Int(size.width - 10))
        let axisY = Int(size.height)
        opponentSprite.run(SKAction.move(to: CGPoint(x: randomX, y: axisY), duration: 0))
        print("RandomX : \(randomX)")
        opponentMovementX = randomX;
    }
}
