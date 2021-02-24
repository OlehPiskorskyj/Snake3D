//
//  Config.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit
import GLKit

class Config {
    
    public static func scaleMatrixXZ() -> GLKMatrix4 {
        return GLKMatrix4MakeScale(10.0, 1.0, 10.0)
    }
    
    public static func scaleMatrixXYZ() -> GLKMatrix4 {
        return GLKMatrix4MakeScale(10.0, 10.0, 10.0)
    }
}
