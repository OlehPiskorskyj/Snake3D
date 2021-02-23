//
//  Toolbox.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

class Toolbox: NSObject {
    
    // MARK: - enums
    public enum Direction: Int {
        case up
        case down
        case left
        case right
    }
    
    // MARK: - methods
    public static func terrainCellSize() -> Float {
        return 1.0 / Float(AppConsts.MAP_SIZE - 1)
    }
}
