//
//  CounterLabelNode.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco on 10/28/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class CounterLabelNode: SKLabelNode {

    var counter: Int = 3 {
        didSet {
            text = counterText()
        }
    }
    var initalScale: CGFloat = 3.0
    var finalScale: CGFloat = 1.0
    var durationShrinkingAction: TimeInterval = 1.0
    var durationForGrowingAction: TimeInterval = 0.2
    var delayTime: TimeInterval = 0.0

}

extension CounterLabelNode: Counter {

    func secondElapsed() {
        counter -= 1
    }

}
