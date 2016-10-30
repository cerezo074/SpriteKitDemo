//
//  Counter.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco on 10/28/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation
import SpriteKit

typealias CounterListener = () -> ()

@objc protocol Counter {
    var counter: Int { get set }
    var initalScale: CGFloat { get set }
    var finalScale: CGFloat { get set }
    var durationShrinkingAction: TimeInterval { get set }
    var durationForGrowingAction: TimeInterval { get set }
    var delayTime: TimeInterval { get set }
    func secondElapsed()
}

extension Counter where Self: SKLabelNode {

    func counterText() -> String {
        return String(counter)
    }

    func counterActions() -> SKAction {

        var actions = [SKAction]()

        for _ in 0 ..< counter {

            let growAction = SKAction.group([
                SKAction.scale(to: initalScale, duration: durationForGrowingAction),
                SKAction.fadeIn(withDuration: durationForGrowingAction)
                ])
            let shrinkAction = SKAction.group([
                SKAction.scale(to: finalScale, duration: durationShrinkingAction),
                SKAction.fadeOut(withDuration: durationShrinkingAction),
                SKAction.playSoundFileNamed("counter.mp3", waitForCompletion: false)
                ])

            let secondElapsedAction = SKAction.perform(#selector(Counter.secondElapsed), onTarget: self)
            actions.append(SKAction.sequence([
                growAction,
                shrinkAction,
                secondElapsedAction
                ]))

        }

        let dismiss = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ])

        actions.append(dismiss)

        return SKAction.sequence(actions)
    }

    func startCounter(completion: @escaping CounterListener) {
        let delayAction = SKAction.wait(forDuration: delayTime)
        let setTextAction = SKAction.run {[weak self] in
            self?.text = self?.counterText()
        }
        let sequence = SKAction.sequence([
            delayAction,
            setTextAction,
            counterActions()
            ])

        run(sequence, completion: completion)
    }

}
