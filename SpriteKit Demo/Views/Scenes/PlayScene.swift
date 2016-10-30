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

    var maxWaves: Int = 5
    var currentWave: Int = 0
    var maxNumberItemsPerWave: Int = 15
    var remainingAsteroidsOnWave: Int = 15
    var asteroidTexture = SKTexture(imageNamed: "asteroid")

    var shoots: Int = -1
    var missileTexture = SKTexture(imageNamed: "missile")
    var timeToAnimateMissile: TimeInterval = 2
    var lauchMissileForEverActionKey: String {
        return "loopmissile"
    }
    var timeIntervalForLaunchMissiles: TimeInterval = 2

    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
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
        let spaceship = createSpaceShip()
        spaceship.position = CGPoint(x: frame.midX, y: 50)
        addChild(spaceship)

        self.spaceship = spaceship
        startWaves()
        launchMissileForever()

    }

    func createAsteroid() -> Asteroid {
        let asteroid = Asteroid(texture: asteroidTexture)
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.isDynamic = false
        asteroid.physicsBody?.usesPreciseCollisionDetection = true
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship | PhysicsCategory.Missile
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

// MARK: Contact Methods

extension PlayScene: SKPhysicsContactDelegate {

    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let All: UInt32 = UInt32.max
        static let Asteroid: UInt32 = 0b1
        static let Spaceship: UInt32 = 0b10
        static let Missile: UInt32 = 0b11
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

        if var spaceship = secondBody.node as? DamageBody,
            (firstBody.categoryBitMask & PhysicsCategory.Asteroid == PhysicsCategory.Asteroid) &&
            (secondBody.categoryBitMask & PhysicsCategory.Spaceship == PhysicsCategory.Spaceship) {
            spaceship.increaseDamage()
        }

        if var asteroid = firstBody.node as? DamageBody,
            let missile = secondBody.node as? SKSpriteNode,
            (firstBody.categoryBitMask & PhysicsCategory.Asteroid == PhysicsCategory.Asteroid) &&
            (secondBody.categoryBitMask & PhysicsCategory.Missile == PhysicsCategory.Missile) {
            asteroid.increaseDamage()
            self.missileDidImpactWithAsteroid(missile: missile)
        }

    }

}

// MARK: User Input Methods

extension PlayScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            guard let nodeTouched = nodes(at: location).first, spaceship == nodeTouched else {
                return
            }
            isSpaceshipTouched = true
            spaceship?.position = location
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
        }
    }

}

// MARK: DamageBody Delegate Methods

extension PlayScene: DamageDelegate {

    func bodyWillReciveDamage(on: DamageBody) {
        guard let node = on as? SKSpriteNode else {
            return
        }
        print("body will recive damage \(node.name)")
    }

    func bodyWillExplote(on: DamageBody) {
        if let asteroid = on as? Asteroid,
            let asteroidIndex = asteroid.userData?.object(forKey: Asteroid.DataKeys.index) as? Int,
            self.responds(to: #selector(PlayScene.asteroidIsOut(indexAsteroid:))) {
            asteroidIsOut(indexAsteroid: asteroidIndex)
        }
    }

}

// MARK: Shooter Protocol

extension PlayScene: Shooter {

    func originForMissile() -> CGPoint {
        if let spaceship = spaceship {
            return spaceship.position
        }

        return CGPoint.zero
    }

    func destinationForMissile() -> CGPoint {

        if let spaceship = spaceship {
            return CGPoint(x: spaceship.position.x, y: size.height + missileTexture.size().height / 2)
        }

        return CGPoint.zero
    }

    func createMissile() -> SKSpriteNode {
        let missile = SKSpriteNode(texture: missileTexture)
        missile.name = "missile"
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = true
        missile.physicsBody?.usesPreciseCollisionDetection = true
        missile.physicsBody?.categoryBitMask = PlayScene.PhysicsCategory.Missile
        missile.physicsBody?.contactTestBitMask = PlayScene.PhysicsCategory.Asteroid
        missile.physicsBody?.collisionBitMask = PlayScene.PhysicsCategory.None

        return missile
    }

    func launchMissileAction() -> SKAction {

        let laserSoundAction = SKAction.playSoundFileNamed("laser", waitForCompletion: true)
        let moveToTarget = SKAction.move(to: destinationForMissile(), duration: timeToAnimateMissile)
        let sequence = SKAction.sequence([
            moveToTarget,
            SKAction.removeFromParent()
            ])
        let group = SKAction.group([
            laserSoundAction,
            sequence
            ])

        return group
    }

    func missileWasRemoved() {

    }

    func missileDidImpactWithAsteroid(missile: SKSpriteNode) {
        missile.removeAllActions()
        missile.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.15),
            SKAction.removeFromParent()
            ]))
    }

}

// MARK: Asteroid Protocol

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
            let dataDict = NSMutableDictionary(capacity: 1)
            dataDict.setObject(index, forKey: Asteroid.DataKeys.index)
            asteroid.userData = dataDict
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
            let activatePhysicBody = SKAction.run {[weak asteroid] in
                asteroid?.physicsBody?.isDynamic = true
            }
            let moveAction = SKAction.moveTo(y: finalYPoint, duration: TimeInterval(time))
            let removeFromPantentAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([
                waitAction,
                activatePhysicBody,
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
