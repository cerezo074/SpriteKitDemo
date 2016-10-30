//
//  Sparkable.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/29/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation
import SpriteKit

protocol Sparkable {
    var sparkAtlas: SKTextureAtlas { get set }
    var collisionSound: SKAction { get set }
    var timePerFrameSparkAtlas: TimeInterval { get set }
    func sparksWillBeDessapear()
    func sparkNode() -> SKSpriteNode
}

extension Sparkable where Self: SKSpriteNode {

    func startSparks() {
        let node = sparkNode()
        addChild(node)
        node.run(sparksAnimations()) {[weak self] in
            self?.sparksWillBeDessapear()
        }
    }

    func sparksAnimations() -> SKAction {
        let group = SKAction.group([
            collisionSound,
            SKAction.animate(with: sparkAtlas.allTextures(), timePerFrame: 0.3)
            ])
        let sequence = SKAction.sequence([
            group,
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ])

        return sequence
    }

}
