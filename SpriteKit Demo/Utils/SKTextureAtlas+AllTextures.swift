//
//  SKTextureAtlas+AllTextures.swift
//  SpriteKit Demo
//
//  Created by Eli Pacheco on 10/28/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTextureAtlas {

    func allTextures() -> [SKTexture] {
        var textures = [SKTexture]()
        for textureName in textureNames {
            textures.append(textureNamed(textureName))
        }
        return textures

    }

}
