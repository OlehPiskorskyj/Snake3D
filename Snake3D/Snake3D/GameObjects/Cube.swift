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
    }
    
    // MARK: - public methods
    public func draw(renderEncoder: MTLRenderCommandEncoder) {
        /*
        GLKMatrix4 lookAt = *([[SnakeCamera instance] getLookAtMatrix]);
        GLKMatrix4 modelView = GLKMatrix4Multiply([SnakeConfig scaleMatrixXYZ], GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-0.5f, 0.0f, -0.5f), GLKMatrix4MakeTranslation(mX, 0.002f, mZ)));
        */
        
        /*
        glBindVertexArrayOES(mVertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer);
        glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, cubeIndices);
        
        effect.constantColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        [effect prepareToDraw];
        glDrawElements(GL_LINES, 24, GL_UNSIGNED_BYTE, meshIndices);
        */
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: 36, indexType: .uint32, indexBuffer: cubeIndexBuffer, indexBufferOffset: 0)
    }
    
    public func tearDown() {
        vertexBuffer = nil
        cubeIndexBuffer = nil
    }
}
