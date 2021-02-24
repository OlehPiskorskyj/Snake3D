//
//  Cube.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import MetalKit
import GLKit

class Cube {
    
    // MARK: - props
    private var metalDevice: MTLDevice!
    private var vertexBuffer: MTLBuffer!
    private var meshVertexBuffer: MTLBuffer!
    private var cubeIndexBuffer: MTLBuffer!
    private var meshIndexBuffer: MTLBuffer!
    
    public var x: Float = 0.0
    public var z: Float = 0.0
    public var size: Float = 0.0
    
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
        self.metalDevice = device
        
        let vertexData: [Float] = [
            0.0, size, 0.0, color.x, color.y, color.z,
            0.0, size, size, color.x, color.y, color.z,
            size, size, 0.0, color.x, color.y, color.z,
            size, size, size, color.x, color.y, color.z,
            
            0.0, 0.0, 0.0, color.x, color.y, color.z,
            0.0, 0.0, size, color.x, color.y, color.z,
            size, 0.0, 0.0, color.x, color.y, color.z,
            size, 0.0, size, color.x, color.y, color.z
        ]
        
        var dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = metalDevice.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeShared)
        
        dataSize = cubeIndices.count * MemoryLayout.size(ofValue: cubeIndices[0])
        cubeIndexBuffer = metalDevice.makeBuffer(bytes: cubeIndices, length: dataSize, options: .storageModeShared)
        
        let meshVertexData: [Float] = [
            0.0, size, 0.0, 0.0, 0.0, 0.0,
            0.0, size, size, 0.0, 0.0, 0.0,
            size, size, 0.0, 0.0, 0.0, 0.0,
            size, size, size, 0.0, 0.0, 0.0,
            
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, size, 0.0, 0.0, 0.0,
            size, 0.0, 0.0, 0.0, 0.0, 0.0,
            size, 0.0, size, 0.0, 0.0, 0.0,
        ]
        
        dataSize = meshVertexData.count * MemoryLayout.size(ofValue: meshVertexData[0])
        meshVertexBuffer = metalDevice.makeBuffer(bytes: meshVertexData, length: dataSize, options: .storageModeShared)
        
        dataSize = meshIndices.count * MemoryLayout.size(ofValue: meshIndices[0])
        meshIndexBuffer = metalDevice.makeBuffer(bytes: meshIndices, length: dataSize, options: .storageModeShared)
    }
    
    // MARK: - public methods
    public func draw(renderEncoder: MTLRenderCommandEncoder, lookAt: GLKMatrix4, sceneMatrices: inout SceneMatrices) {
        let modelView = GLKMatrix4Multiply(Config.scaleMatrixXYZ(), GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-0.5, 0.0, -0.5), GLKMatrix4MakeTranslation(x, 0.002, z)))
        sceneMatrices.modelview = GLKMatrix4Multiply(lookAt, modelView)
        let uniformBufferSize = MemoryLayout.size(ofValue: sceneMatrices)
        let uniformBuffer = metalDevice.makeBuffer(bytes: &sceneMatrices, length: uniformBufferSize, options: .storageModeShared)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: 36, indexType: .uint32, indexBuffer: cubeIndexBuffer, indexBufferOffset: 0)
        
        renderEncoder.setVertexBuffer(meshVertexBuffer, offset: 0, index: 0)
        renderEncoder.drawIndexedPrimitives(type: .line, indexCount: 24, indexType: .uint32, indexBuffer: meshIndexBuffer, indexBufferOffset: 0)
    }
    
    public func tearDown() {
        meshVertexBuffer = nil
        vertexBuffer = nil
        meshIndexBuffer = nil
        cubeIndexBuffer = nil
    }
}
