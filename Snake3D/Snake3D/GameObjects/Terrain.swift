//
//  Terrain.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import MetalKit

class Terrain {

    // MARK: - props
    private var metalDevice: MTLDevice!
    private var meshVertexBuffer: MTLBuffer!
    private var vertexBuffer: MTLBuffer!
    private var meshVertexCount: UInt32 = 0
    private var vertexCount: UInt32 = 0
    private var meshMaxVertexCount = 0
    private var maxVertexCount = 0
    private var cellWidth: Float = 0.0
    
    // MARK: - ctors
    init(device: MTLDevice) {
        self.metalDevice = device
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
    
    // MARK: - public methods
    public func draw(renderEncoder: MTLRenderCommandEncoder) {
        if (vertexCount > 0) {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Int(vertexCount))
        }
    }
    
    // MARK: - private methods
    func initialize() {
        maxVertexCount = AppConsts.MAP_SIZE * AppConsts.MAP_SIZE * 6
        
        /*
        glGenVertexArraysOES(1, &vertexArray);
        glBindVertexArrayOES(vertexArray);
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL);
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE,  6 * sizeof(GLfloat), (char *)12);
        
        glGenVertexArraysOES(1, &meshVertexArray);
        glBindVertexArrayOES(meshVertexArray);
        glGenBuffers(1, &meshVertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, meshVertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(meshVertexData), meshVertexData, GL_STATIC_DRAW);
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL);
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE,  6 * sizeof(GLfloat), (char *)12);
        
        // bind with nothing
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        */
        
        var verBuffer = Array<Vertex>(repeating: Vertex.zero(), count: maxVertexCount)
        var bufferSize = verBuffer.count * MemoryLayout<Vertex>.size
        vertexBuffer = metalDevice.makeBuffer(bytes: &verBuffer, length: bufferSize, options: .storageModeShared)
        
        /*
        var indBuffer = Array<UInt32>(repeating: 0, count: maxIndexCount)
        bufferSize = indBuffer.count * MemoryLayout<UInt32>.size
        indexBuffer = metalDevice.makeBuffer(bytes: &indBuffer, length: bufferSize, options: .storageModeShared)
        */
        
        self.createTerrain()
    }
    
    func createTerrain() {
        vertexCount = 0
        meshVertexCount = 0
        
        //let vertextCount = AppConsts.MAP_SIZE
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
                
                /*
                // change y and color for mesh
                v1.position.y = 0.01f;
                v2.position.y = 0.01f;
                v3.position.y = 0.01f;
                v4.position.y = 0.01f;
                
                v1.color = GLKVector3Make(1.0f, 1.0f, 1.0f);
                v2.color = GLKVector3Make(1.0f, 1.0f, 1.0f);
                v3.color = GLKVector3Make(1.0f, 1.0f, 1.0f);
                v4.color = GLKVector3Make(1.0f, 1.0f, 1.0f);
                
                // first triangle mesh
                addMeshVertex(&meshVertexArrayLength, v1);
                addMeshVertex(&meshVertexArrayLength, v2);
                
                //addMeshVertex(&meshVertexArrayLength, v2);
                //addMeshVertex(&meshVertexArrayLength, v3);
                
                addMeshVertex(&meshVertexArrayLength, v3);
                addMeshVertex(&meshVertexArrayLength, v1);
                
                // second triangle mesh
                addMeshVertex(&meshVertexArrayLength, v2);
                addMeshVertex(&meshVertexArrayLength, v4);
                
                addMeshVertex(&meshVertexArrayLength, v4);
                addMeshVertex(&meshVertexArrayLength, v3);
                
                //addMeshVertex(&meshVertexArrayLength, v3);
                //addMeshVertex(&meshVertexArrayLength, v2);
                */
            }
        }
    }


    
}

