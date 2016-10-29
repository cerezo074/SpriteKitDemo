//
//  PlayScene.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {

    private(set) var contentCreated = false
    var isSpaceshipTouched = false
    var spaceship: Spaceship?
    var asteroidTexture: SKTexture?

    var maxWaves: Int = 5
    var currentWave: Int = 0
    var maxNumberItemsPerWave: Int = 15
    var remainingAsteroidsOnWave: Int = 15

    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }

}

// MARK: Contact Methods

extension PlayScene: SKPhysicsContactDelegate {

    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let All: UInt32 = UInt32.max
        static let Asteroid: UInt32 = 0b1
        static let Spaceship: UInt32 = 0b10
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if (firstBody.categoryBitMask & PhysicsCategory.Asteroid != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Spaceship != 0) {
            guard var spaceShip = secondBody.node as? DamageBody else {
                return
            }
            spaceShip.increaseDamage()
        }
    }

}

// MARK: User Input Methods

extension PlayScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let spaceshipNode = childNode(withName: NodeNames.spacehip) as? Spaceship else {
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            guard let nodeTouched = nodes(at: location).first, spaceshipNode == nodeTouched else {
                return
            }
            isSpaceshipTouched = true
            spaceshipNode.position = location
            spaceship = spaceshipNode
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSpaceshipTouched {
            for touch in touches {
                let location = touch.location(in: self)
                spaceship?.position = location
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSpaceshipTouched {
            for touch in touches {
                let location = touch.location(in: self)
                spaceship?.position = location
            }
            isSpaceshipTouched = false
            spaceship = nil
        }
    }

}

extension PlayScene: DamageDelegate {

    func bodyWillReciveDamage(on: DamageBody) {
        guard let node = on as? SKSpriteNode else {
            return
        }
        print("body will recive damage \(node.name)")
    }

    func bodyWillExplote(on: DamageBody) {
        guard let node = on as? SKSpriteNode else {
            return
        }
        print("body will explote \(node.name)")
    }

}

private extension PlayScene {

    struct ImageNames {
        static let spaceship = "spaceship"
        static let asteroid = "asteroid"
    }

    struct NodeNames {
        static let spacehip = "spaceship"
        static let asteroidPrefix = "asteroid"
    }

    func createContent() {

        backgroundColor = .yellow
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self

        asteroidTexture = SKTexture(imageNamed: ImageNames.asteroid)
        spaceship = createSpaceShip()
        spaceship?.position = CGPoint(x: frame.midX, y: 50)

        startWaves()

    }

    func createAsteroid() -> Asteroid {
        let asteroid = Asteroid(texture: asteroidTexture)
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship
        return asteroid
    }

    func createSpaceShip() -> Spaceship {
        let playerSpaceship = Spaceship(imageNamed: ImageNames.spaceship)
        playerSpaceship.damageDelegate = self
        playerSpaceship.name = NodeNames.spacehip
        playerSpaceship.physicsBody = SKPhysicsBody(rectangleOf: playerSpaceship.size)
        playerSpaceship.physicsBody?.isDynamic = true
        playerSpaceship.physicsBody?.usesPreciseCollisionDetection = true
        playerSpaceship.physicsBody?.categoryBitMask = PhysicsCategory.Spaceship
        playerSpaceship.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        playerSpaceship.physicsBody?.collisionBitMask = PhysicsCategory.None

        return playerSpaceship
    }

}

extension PlayScene: AsteroidsWave {

    func startWaves() {
        prepareNextWave(wave: 0)
        nextWave(wave: 0)
    }

    func stopWaves() {
        currentWave = 0
        remainingAsteroidsOnWave = maxNumberItemsPerWave
        removeAllChildren()
    }

    func prepareNextWave(wave: Int) {
        remainingAsteroidsOnWave = 15
    }

    func nextWave(wave: Int) {

        if currentWave == maxWaves {
            userDidFinishedLastWave()
            return
        }

        for index in 0 ..< maxNumberItemsPerWave {

            let asteroid = createAsteroid()
            asteroid.damageDelegate = self
            asteroid.name = NodeNames.asteroidPrefix + String(index)
            let randomX = CGFloat.random(lower: asteroid.size.width / 2,
                                         size.width - asteroid.size.width / 2)
            asteroid.position = CGPoint(x: randomX,
                                        y: size.height + asteroid.size.height * 4)
            let finalYPoint = asteroid.size.height / -2
            let time = CGFloat.random(lower: 3, 5)
            let waitUntil = CGFloat.random(lower: 0, 5)
            let waitAction = SKAction.wait(forDuration: TimeInterval(waitUntil))
            let moveAction = SKAction.moveTo(y: finalYPoint, duration: TimeInterval(time))
            let removeFromPantentAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([
                waitAction,
                moveAction,
                removeFromPantentAction
                ])
            asteroid.run(sequence, completion: {[weak self] in
                self?.asteroidIsOut(indexAsteroid: index)
                })

            addChild(asteroid)

        }

    }

    func asteroidIsOut(indexAsteroid: Int) {

        remainingAsteroidsOnWave -= 1

        if remainingAsteroidsOnWave == 0 {
            currentWave += 1
            if currentWave > maxWaves {
                userDidFinishedLastWave()
            }
            else {
                prepareNextWave(wave: currentWave)
                nextWave(wave: currentWave)
            }
        }

    }

    func userDidFinishedLastWave() {
        print("Finish")
    }

    func userLost() {
        print("Lost")
    }

}
