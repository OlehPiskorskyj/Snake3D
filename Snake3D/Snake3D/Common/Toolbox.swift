//
//  Toolbox.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

// MARK: - enums
public enum Direction: Int {
    case up
    case down
    case left
    case right
}

class Toolbox {
    
    // MARK: - metal textures
    public static func aliasingTexture(texture: MTLTexture, device: MTLDevice, sampleCount: Int) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = texture.pixelFormat
        textureDescriptor.width = texture.width
        textureDescriptor.height = texture.height
        textureDescriptor.textureType = .type2DMultisample
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        textureDescriptor.sampleCount = sampleCount
        return device.makeTexture(descriptor: textureDescriptor)
    }
    
    public static func depthTexture(texture: MTLTexture, device: MTLDevice, sampleCount: Int) -> MTLTexture? {
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float, width: texture.width, height: texture.height, mipmapped: false)
        depthTextureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite, .pixelFormatView]
        depthTextureDescriptor.textureType = .type2DMultisample
        depthTextureDescriptor.storageMode = .private
        depthTextureDescriptor.resourceOptions = [.storageModePrivate]
        depthTextureDescriptor.sampleCount = sampleCount   //4
        return device.makeTexture(descriptor: depthTextureDescriptor)
    }
    
    // MARK: - other methods
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
    
    public static func randomPositionOnTerrainButNot(occupiedСells: [CGPoint]) -> (x: Int, y: Int) {
        let position = Toolbox.randomPositionOnTerrain()
        var ok = true
        
        for cell in occupiedСells {
            if (position.x == Int(cell.x) && position.y == Int(cell.y)) {
                ok = false
                break
            }
        }
        
        if (ok) {
            return position
        } else {
            print("was genareted value same with one of snake part")
            return Toolbox.randomPositionOnTerrainButNot(occupiedСells: occupiedСells)
        }
    }
    
    public static func randomPositionOnTerrain() -> (x: Int, y: Int) {
        let i = arc4random() % 10
        let j = arc4random() % 10
        return (Int(i), Int(j))
    }
    
    public static func terrainCellSize() -> Float {
        return 1.0 / Float(AppConsts.MAP_SIZE - 1)
    }
}
