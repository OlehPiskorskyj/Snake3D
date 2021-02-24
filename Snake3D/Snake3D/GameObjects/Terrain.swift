//
//  Terrain.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import MetalKit
import GLKit

class Terrain {

    // MARK: - props
    private var meshVertexBuffer: MTLBuffer!
    private var vertexBuffer: MTLBuffer!
    private var meshVertexCount: UInt32 = 0
    private var vertexCount: UInt32 = 0
    private var meshMaxVertexCount = 0
    private var maxVertexCount = 0
    private var cellWidth: Float = 0.0
    
    // MARK: - ctors
    init() {
        self.initialize()
    }
    
    // MARK: - vertex logic
    func addVertex(vertex: inout Vertex) {
        if (vertexCount < maxVertexCount) {
            let vertexSize = MemoryLayout<Vertex>.size
            memcpy(vertexBuffer.contents() + vertexSize * Int(vertexCount), &vertex, vertexSize)
            vertexCount += 1
        }
    }
    
    func addMeshVertex(vertex: inout Vertex) {
        if (meshVertexCount < meshMaxVertexCount) {
            let vertexSize = MemoryLayout<Vertex>.size
            memcpy(meshVertexBuffer.contents() + vertexSize * Int(meshVertexCount), &vertex, vertexSize)
            meshVertexCount += 1
        }
    }
    
    func prepareVertex4Mesh(vertex: inout Vertex) {
        vertex.y = 0.01
        vertex.r = 1.0
        vertex.g = 1.0
        vertex.b = 1.0
    }
    
    // MARK: - public methods
    public func draw(renderEncoder: MTLRenderCommandEncoder, lookAt: GLKMatrix4, sceneMatrices: inout SceneMatrices) {
        guard let metalDevice = Config.instance.metalDevice else { return }
        
        let modelView = GLKMatrix4Multiply(Config.scaleMatrixXZ(), GLKMatrix4MakeTranslation(-0.5, 0.0, -0.5))
        sceneMatrices.modelview = GLKMatrix4Multiply(lookAt, modelView)
        let uniformBufferSize = MemoryLayout.size(ofValue: sceneMatrices)
        let uniformBuffer = metalDevice.makeBuffer(bytes: &sceneMatrices, length: uniformBufferSize, options: .storageModeShared)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        if (vertexCount > 0) {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(vertexCount))
        }
        
        if (meshVertexCount > 0) {
            renderEncoder.setVertexBuffer(meshVertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: Int(meshVertexCount))
        }
    }
    
    public func tearDown() {
        meshVertexBuffer = nil
        vertexBuffer = nil
    }
    
    // MARK: - private methods
    func initialize() {
        maxVertexCount = AppConsts.MAP_SIZE * AppConsts.MAP_SIZE * 6
        meshMaxVertexCount = AppConsts.MAP_SIZE * AppConsts.MAP_SIZE * 8
        
        guard let metalDevice = Config.instance.metalDevice else { return }
        
        var verBuffer = Array<Vertex>(repeating: Vertex.zero(), count: maxVertexCount)
        var bufferSize = verBuffer.count * MemoryLayout<Vertex>.size
        vertexBuffer = metalDevice.makeBuffer(bytes: &verBuffer, length: bufferSize, options: .storageModeShared)
        
        var meshBuffer = Array<Vertex>(repeating: Vertex.zero(), count: meshMaxVertexCount)
        bufferSize = meshBuffer.count * MemoryLayout<Vertex>.size
        meshVertexBuffer = metalDevice.makeBuffer(bytes: &meshBuffer, length: bufferSize, options: .storageModeShared)
        
        self.createTerrain()
    }
    
    func createTerrain() {
        vertexCount = 0
        meshVertexCount = 0
        
        cellWidth = Toolbox.terrainCellSize()
        
        for i in 0..<(AppConsts.MAP_SIZE - 1) {
            for j in 0..<(AppConsts.MAP_SIZE - 1) {
                
                var v1 = Vertex(x: Float(j) * cellWidth, y: 0.0, z: Float(i + 1) * cellWidth, r: 0.2, g: 0.2, b: 0.2)
                var v2 = Vertex(x: Float(j) * cellWidth, y: 0.0, z: Float(i) * cellWidth, r: 0.2, g: 0.2, b: 0.2)
                var v3 = Vertex(x: Float(j + 1) * cellWidth, y: 0.0, z: Float(i + 1) * cellWidth, r: 0.2, g: 0.2, b: 0.2)
                var v4 = Vertex(x: Float(j + 1) * cellWidth, y: 0.0, z: Float(i) * cellWidth, r: 0.2, g: 0.2, b: 0.2)
                
                // first triangle
                self.addVertex(vertex: &v1)
                self.addVertex(vertex: &v2)
                self.addVertex(vertex: &v3)
                
                // second triangle
                self.addVertex(vertex: &v3)
                self.addVertex(vertex: &v2)
                self.addVertex(vertex: &v4)
                
                // change y and color for mesh
                self.prepareVertex4Mesh(vertex: &v1)
                self.prepareVertex4Mesh(vertex: &v2)
                self.prepareVertex4Mesh(vertex: &v3)
                self.prepareVertex4Mesh(vertex: &v4)
                
                // first triangle mesh
                self.addMeshVertex(vertex: &v1)
                self.addMeshVertex(vertex: &v2)
                self.addMeshVertex(vertex: &v3)
                self.addMeshVertex(vertex: &v1)
                
                // second triangle mesh
                self.addMeshVertex(vertex: &v2)
                self.addMeshVertex(vertex: &v4)
                self.addMeshVertex(vertex: &v4)
                self.addMeshVertex(vertex: &v3)
            }
        }
    }
}

