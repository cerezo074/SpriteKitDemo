//
//  Shooter.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/29/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation
import SpriteKit

protocol Shooter {
    var missileTexture: SKTexture { get set }
    var timeToAnimateMissile: TimeInterval { get set }
    var lauchMissileForEverActionKey: String { get }
    var timeIntervalForLaunchMissiles: TimeInterval { get set }
    func createMissile() -> SKSpriteNode
    func launchMissileAction() -> SKAction
    func destinationForMissile() -> CGPoint
    func originForMissile() -> CGPoint
    func missileWasRemoved()
    func missileDidImpactWithAsteroid(missile: SKSpriteNode)
}

extension Shooter where Self: SKNode {

    func lauchMissile() {
        let missile = createMissile()
        missile.position = originForMissile()
        missile.run(launchMissileAction()) {[weak self] in
            self?.missileWasRemoved()
        }
        addChild(missile)
    }

    func launchMissileForever() {

        let sequence = SKAction.sequence([
            SKAction.wait(forDuration: timeIntervalForLaunchMissiles),
            SKAction.run { [weak self] in
                self?.lauchMissile()
            }
            ])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: lauchMissileForEverActionKey)

    }

}
