//
//  Snake.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit
import MetalKit
import GLKit

struct Vertex {
    var x: Float
    var y: Float
    var z: Float
    var r: Float
    var g: Float
    var b: Float
    public static func zero() -> Vertex {
        return Vertex.init(x: 0, y: 0, z: 0, r: 0, g: 0, b: 0)
    }
}

struct SceneMatrices {
    var projection: GLKMatrix4 = GLKMatrix4Identity
    var modelview: GLKMatrix4 = GLKMatrix4Identity
}

class Snake: MTKView {
    
}
