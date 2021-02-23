//
//  Cube.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import MetalKit

class Cube {
    
    // MARK: - props
    private var metalDevice: MTLDevice!
    private var vertexBuffer: MTLBuffer!
    private var cubeIndexBuffer: MTLBuffer!
    
    public var x: Float = 0.0
    public var z: Float = 0.0
    public var size: Float = 0.0
    public var color = simd_float4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
    
    private let cubeIndices: [UInt32] = [
        0, 1, 2, 2, 1, 3,
        4, 5, 6, 6, 5, 7,
        4, 0, 6, 6, 0, 2,
        5, 1, 7, 7, 1, 3,
        4, 0, 5, 5, 0, 1,
        6, 2, 7, 7, 2, 3
    ]
    
    private let meshIndices: [UInt32] = [
        0, 1, 1, 3, 3, 2, 2, 0,
        4, 5, 5, 7, 7, 6, 6, 4,
        0, 4, 1, 5, 3, 7, 2, 6
    ]
    
    // MARK: - ctor
    init(x: Float, z: Float, size: Float, color: SIMD4<Float>, device: MTLDevice) {
        self.x = x
        self.z = z
        self.size = size
        self.color = color
        self.metalDevice = device
        
        let vertexData: [Float] = [
            0.0, size, 0.0,
            0.0, size, size,
            size, size, 0.0,
            size, size, size,
            
            0.0, 0.0, 0.0,
            0.0, 0.0, size,
            size, 0.0, 0.0,
            size, 0.0, size
        ]
        
        var dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = metalDevice.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeShared)
        
        dataSize = cubeIndices.count * MemoryLayout.size(ofValue: cubeIndices[0])
        cubeIndexBuffer = metalDevice.makeBuffer(bytes: cubeIndices, length: dataSize, options: .storageModeShared)
    }
    
    // MARK: - public methods
    public func draw(renderEncoder: MTLRenderCommandEncoder) {
        /*
        if (vertexCount > 0) {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(vertexCount))
        }
        
        if (meshVertexCount > 0) {
            renderEncoder.setVertexBuffer(meshVertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: Int(meshVertexCount))
        }
        */
    }
    
    public func tearDown() {
        vertexBuffer = nil
        cubeIndexBuffer = nil
    }
}
