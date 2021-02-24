//
//  Toolbox.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

class Toolbox {
    
    // MARK: - enums
    public enum Direction: Int {
        case up
        case down
        case left
        case right
    }
    
    // MARK: - methods
    public static func positionFromTerrainCell(i: Int, j: Int) -> CGPoint {
        let cellSize = Toolbox.terrainCellSize()
        let x = Float(i) * cellSize
        let y = Float(j) * cellSize
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    public static func gameObjectPosition(column: Int, row: Int) -> CGPoint {
        let cellSize = Toolbox.terrainCellSize()
        let scaledSize = cellSize * Float(AppConsts.SCALE_FACTOR_SEGMENT)
        let delta = (cellSize - scaledSize) / 2.0
        
        var position = Toolbox.positionFromTerrainCell(i: column, j: row)
        position.x += CGFloat(delta)
        position.y += CGFloat(delta)
        
        return position
    }
    
    public static func randomPositionOnTerrain() -> (x: Int, y: Int) {
        let i = arc4random() % 10
        let j = arc4random() % 10
        print(i, j)
        return (Int(i), Int(j))
    }
    
    public static func terrainCellSize() -> Float {
        return 1.0 / Float(AppConsts.MAP_SIZE - 1)
    }
}
