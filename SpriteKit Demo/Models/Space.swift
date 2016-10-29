//
//  Space.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class Spaceship: SKSpriteNode, DamageBody {

    weak var damageDelegate: DamageDelegate?
    var currentDamage: Int = 0
    var maxDamage: Int = 2

    func explote() {

        let explosionAtlas = SKTextureAtlas(named: "explotion")
        let explotionAnimationAction = SKAction.animate(with: explosionAtlas.allTextures(), timePerFrame: 0.15)
        let explotionSoundAction = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)

        let explotionAction = SKAction.group([
            explotionAnimationAction,
            explotionSoundAction
            ])

        run(SKAction.sequence([
            explotionAction,
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ]))
    }

    func damageOnBody() {
        let damageSoundAction = SKAction.playSoundFileNamed("kick", waitForCompletion: true)
        run(damageSoundAction)
    }

}
