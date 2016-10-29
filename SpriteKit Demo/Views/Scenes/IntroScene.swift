//
//  IntroScene.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class IntroScene: SKScene {

    private(set) var contentCreated = false

    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }

}

private extension IntroScene {

    struct NodeNames {
        static let countLabelNode = "count"
    }

    func createContent() {

        backgroundColor = .black
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(createWelcomeLabel())

        let startButton = createStartButton(target: self, action: #selector(IntroScene.startCounterActions(sender:)))

        let buttonFrame = startButton.frame
        let newBounds = CGRect(x: 0,
                               y: 0,
                               width: buttonFrame.size.width * 1.35,
                               height: buttonFrame.size.height * 1.05)
        startButton.bounds = newBounds
        startButton.center = CGPoint(x: view!.frame.size.width / 2,
                                     y: (view!.frame.size.height / 2) * 1.25)

        view?.addSubview(startButton)

    }

    @objc func startCounterActions(sender: UIButton) {

        sender.removeFromSuperview()
        let counterLabel = createCountLabel()
        counterLabel.position = CGPoint(x: 0, y: 0.5 * frame.size.height / -2)
        addChild(counterLabel)

        let playScene = PlayScene(size: size)
        let transitionToPlayScene = SKTransition.reveal(with: .down, duration: 1)
        counterLabel.startCounter { [weak self] in
            self?.view?.presentScene(playScene, transition: transitionToPlayScene)
        }

    }

    func createWelcomeLabel() -> SKLabelNode {
        let welcomeLabel = SKLabelNode(text: "Welcome!!!")
        welcomeLabel.fontSize = 30
        return welcomeLabel
    }

    func createCountLabel() -> CounterLabelNode {
        let countLabel = CounterLabelNode(text: "3")
        countLabel.name = NodeNames.countLabelNode
        countLabel.fontSize = 40
        return countLabel
    }

    func createStartButton(target: Any, action: Selector) -> UIButton {

        let startButton = UIButton()
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(target,
                              action: action,
                              for: .touchUpInside)
        startButton.sizeToFit()
        startButton.layer.cornerRadius = 10
        startButton.backgroundColor = .white
        startButton.setTitleColor(.black, for: .normal)
        return startButton

    }

}
