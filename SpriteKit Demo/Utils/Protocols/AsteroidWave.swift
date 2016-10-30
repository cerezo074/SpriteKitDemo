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
}
