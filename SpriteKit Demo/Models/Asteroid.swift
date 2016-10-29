//
//  Asteroid.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class Asteroid: SKSpriteNode, DamageBody {

    weak var damageDelegate: DamageDelegate?
    var currentDamage: Int = 0
    var maxDamage: Int = 10

    func explote() {
    }

    func damageOnBody() {
    }

}
