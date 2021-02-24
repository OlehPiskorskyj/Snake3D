//
//  SnakePart.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 24/02/2021.
//

import MetalKit

class SnakePart: Cube {
    
    // MARK: - props
    public var column: Int = 0
    public var row: Int = 0
    
    // MARK: - ctor
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
        
        let position = Toolbox.gameObjectPosition(column: column, row: row)
        super.init(x: Float(position.x), z: Float(position.y), size: Toolbox.terrainCellSize() * AppConsts.SCALE_FACTOR_SEGMENT, color: simd_float4(0.0, 1.0, 0.0, 1.0))
    }
    
    // MARK: - public methods
    public func setPosition(column: Int, row: Int) {
        self.column = column
        self.row = row
        
        let position = Toolbox.gameObjectPosition(column: column, row: row)
        super.setPosition(x: Float(position.x), z: Float(position.y))
    }
    
}
