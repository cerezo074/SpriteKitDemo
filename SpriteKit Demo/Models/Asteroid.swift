//
//  Asteroid.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class Asteroid: SKSpriteNode, DamageBody, Sparkable {

    struct DataKeys {
        static let index: NSString = "index"
    }

    weak var damageDelegate: DamageDelegate?
    var currentDamage: Int = 0
    var maxDamage: Int = 2

    var sparkAtlas: SKTextureAtlas = SKTextureAtlas(named: "spark")
    var collisionSound: SKAction = SKAction.playSoundFileNamed("asteroid_explosion", waitForCompletion: false)
    var timePerFrameSparkAtlas: TimeInterval = 0.15

    func explote() {
        removeAllActions()
        run(sparksAnimations())
    }

    func damageOnBody() {
        startSparks()
    }

    func sparksWillBeDessapear() {
        print("Update the score")
    }

    func sparkNode() -> SKSpriteNode {
        return SKSpriteNode(imageNamed: "spark1")
    }

}
