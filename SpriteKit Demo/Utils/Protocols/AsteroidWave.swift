//
//  AsteroidWave.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco on 10/28/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation
import SpriteKit

protocol AsteroidsWave {
    var asteroidTexture: SKTexture { get set }
    var maxWaves: Int { get }
    var currentWave: Int { get set }
    var maxNumberItemsPerWave: Int { get }
    var remainingAsteroidsOnWave: Int { get }
    func asteroidIsOut(indexAsteroid: Int)
    func nextWave(wave: Int)
    func prepareNextWave(wave: Int)
    func userDidFinishedLastWave()
    func startWaves()
    func stopWaves()
    func createMessageLabel() -> CounterLabelNode
}

extension AsteroidsWave where Self: SKScene {

    func showMessageLabel(message: String, actionForMessageLabel: SKAction?) {
        let messageLabel = createMessageLabel()
        messageLabel.text = message
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        if let action = actionForMessageLabel {
            messageLabel.run(action)
        }

        addChild(messageLabel)
    }

    func showMessageLabel(message: String, actionForMessageLabel: SKAction?, completionBlockForAction: (() -> ())?) {
        let messageLabel = createMessageLabel()
        messageLabel.text = message
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        if let action = actionForMessageLabel,
            let completionBlock = completionBlockForAction {
            messageLabel.run(action, completion: completionBlock)
        }

        addChild(messageLabel)
    }

    func showCounterMessageLabel(message: String, completionBlockForAction: @escaping CounterListener) {
        let counterLabel = createMessageLabel()
        counterLabel.delayTime = 2.0
        counterLabel.text = message
        counterLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        counterLabel.startCounter(completion: completionBlockForAction)

        addChild(counterLabel)
    }

}
