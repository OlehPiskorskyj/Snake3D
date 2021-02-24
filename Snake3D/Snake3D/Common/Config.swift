//
//  Config.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit
import GLKit

class Config {
    
    // MARK: - props
    public var metalDevice: MTLDevice? = nil
    
    // MARK: - singleton
    public static let instance = Config()
    private init() {
    }
    
    // MARK: - static methods
    public static func scaleMatrixXZ() -> GLKMatrix4 {
        return GLKMatrix4MakeScale(10.0, 1.0, 10.0)
    }
    
    public static func scaleMatrixXYZ() -> GLKMatrix4 {
        return GLKMatrix4MakeScale(10.0, 10.0, 10.0)
    }
}
