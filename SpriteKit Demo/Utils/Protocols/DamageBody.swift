//
//  DamageBody.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco on 10/28/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation

protocol DamageBody {
    var damageDelegate: DamageDelegate? { get set }
    var currentDamage: Int { get set }
    var maxDamage: Int { get }
    func explote()
    func damageOnBody()
}

protocol DamageDelegate: class {
    func bodyWillExplote(on: DamageBody)
    func bodyWillReciveDamage(on: DamageBody)
}

extension DamageBody {

    mutating func increaseDamage() {

        currentDamage += 1

        if currentDamage == maxDamage {
            damageDelegate?.bodyWillExplote(on: self)
            explote()
        }

        if currentDamage < maxDamage {
            damageDelegate?.bodyWillReciveDamage(on: self)
            damageOnBody()
        }

    }

}
