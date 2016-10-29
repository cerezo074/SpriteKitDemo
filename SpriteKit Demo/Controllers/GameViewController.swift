//
//  GameViewController.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco Hoyos on 10/23/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let skView = view as? SKView else {
            print("Scene couldn't loaded")
            return
        }

        skView.showsFPS = true
        skView.showsDrawCount = true
        skView.showsNodeCount = true

        let introScene = IntroScene(size: view.bounds.size)
        skView.presentScene(introScene)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
