//
//  Snake.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit
import MetalKit
import GLKit

struct Vertex {
    var x: Float
    var y: Float
    var z: Float
    var r: Float
    var g: Float
    var b: Float
    public static func zero() -> Vertex {
        return Vertex.init(x: 0, y: 0, z: 0, r: 0, g: 0, b: 0)
    }
}

struct SceneMatrices {
    var projection: GLKMatrix4 = GLKMatrix4Identity
    var modelview: GLKMatrix4 = GLKMatrix4Identity
}

class Snake: MTKView {
    
    // MARK: - props
    private var metalDevice: MTLDevice!
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var depthStencilState: MTLDepthStencilState!
    private var textureDepth: MTLTexture? = nil
    private var texture: MTLTexture? = nil
    
    public var sceneMatrices = SceneMatrices()
    public var uniformBuffer: MTLBuffer!
    public var lookAt: GLKMatrix4 = GLKMatrix4Identity
    
    public var vertexBuffer: MTLBuffer!
    public var indexBuffer: MTLBuffer!
    public var vertexCount: UInt32 = 0
    public var indexCount: UInt32 = 0
    public var maxVertexCount = 0
    public var maxIndexCount = 0
    
    public var zoom: Float = -5.0
    
    private var terrain: Terrain!
    
    // MARK: - ctors
    override public init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        self.internalInit()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        self.internalInit()
    }
    
    deinit {
        self.tearDownMetal()
    }
    
    // MARK: - other methods
    func internalInit() {
        //self.enableSetNeedsDisplay = true
        //self.isPaused = true
        self.framebufferOnly = false
        self.isOpaque = false
        
        self.colorPixelFormat = .bgra8Unorm
        self.sampleCount = 4
        self.depthStencilPixelFormat = .depth32Float
        
        self.setupMetal()
        
        terrain = Terrain(device: metalDevice)
        
        self.delegate = self
    }
    
    func setupMetal() {
        metalDevice = MTLCreateSystemDefaultDevice()
        commandQueue = metalDevice.makeCommandQueue()
        self.device = metalDevice
        
        lookAt = GLKMatrix4MakeLookAt(0.0, 2.0, 4.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
        
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), fabsf(Float(self.bounds.width / self.bounds.height)), 0.1, 100.0);
        sceneMatrices.projection = projectionMatrix
        
        /*
        var verBuffer = Array<Vertex>(repeating: Vertex.zero(), count: maxVertexCount)
        var bufferSize = verBuffer.count * MemoryLayout<Vertex>.size
        vertexBuffer = metalDevice.makeBuffer(bytes: &verBuffer, length: bufferSize, options: .storageModeShared)
        
        var indBuffer = Array<UInt32>(repeating: 0, count: maxIndexCount)
        bufferSize = indBuffer.count * MemoryLayout<UInt32>.size
        indexBuffer = metalDevice.makeBuffer(bytes: &indBuffer, length: bufferSize, options: .storageModeShared)
        */
        
        guard let defaultLibrary = metalDevice.makeDefaultLibrary() else { return }
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat
        //pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineStateDescriptor.sampleCount = self.sampleCount
        pipelineStateDescriptor.depthAttachmentPixelFormat = self.depthStencilPixelFormat
        
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        vertexCount = 0
        indexCount = 0
    }
    
    func tearDownMetal() {
        vertexBuffer = nil
        indexBuffer = nil
        textureDepth = nil
        texture = nil
    }
    
    // MARK: - utilities
    func updateProjectionMatrix(aspectRatio: Float) {
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), fabsf(aspectRatio), 0.1, 100.0);
        sceneMatrices.projection = projectionMatrix
        textureDepth = nil
        texture = nil
    }
    
    func createRenderPassDescriptor(drawable: CAMetalDrawable) -> MTLRenderPassDescriptor {
        if (texture == nil) {
            texture = self.createAliasingTexture(texture: drawable.texture)
        }
        
        if (textureDepth == nil) {
            textureDepth = self.createDepthTexture(texture: drawable.texture)
        }
        
        let depthAttachementTexureDescriptor = MTLRenderPassDepthAttachmentDescriptor()
        depthAttachementTexureDescriptor.clearDepth = 1.0
        depthAttachementTexureDescriptor.loadAction = .clear
        depthAttachementTexureDescriptor.storeAction = .dontCare
        depthAttachementTexureDescriptor.texture = textureDepth
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = texture
        renderPassDescriptor.colorAttachments[0].resolveTexture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .multisampleResolve
        renderPassDescriptor.depthAttachment = depthAttachementTexureDescriptor
        
        return renderPassDescriptor
    }
    
    func createAliasingTexture(texture: MTLTexture) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = texture.pixelFormat
        textureDescriptor.width = texture.width
        textureDescriptor.height = texture.height
        textureDescriptor.textureType = .type2DMultisample
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        textureDescriptor.sampleCount = self.sampleCount
        return metalDevice.makeTexture(descriptor: textureDescriptor)
    }
    
    func createDepthTexture(texture: MTLTexture) -> MTLTexture? {
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float, width: texture.width, height: texture.height, mipmapped: false)
        depthTextureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite, .pixelFormatView]
        depthTextureDescriptor.textureType = .type2DMultisample
        depthTextureDescriptor.storageMode = .private
        depthTextureDescriptor.resourceOptions = [.storageModePrivate]
        depthTextureDescriptor.sampleCount = 4
        return metalDevice.makeTexture(descriptor: depthTextureDescriptor)
    }
}

extension Snake: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.updateProjectionMatrix(aspectRatio: Float(view.frame.width / view.frame.height))
    }
    
    func draw(in view: MTKView) {
        #if targetEnvironment(simulator)
        return
        #else
        
        guard let drawable = view.currentDrawable else { return }
        let renderPassDescriptor = self.createRenderPassDescriptor(drawable: drawable)
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        lookAt = GLKMatrix4MakeLookAt(0.0, 2.0 - self.zoom, 4.0 - self.zoom, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
        
        var modelView = GLKMatrix4Multiply(GLKMatrix4MakeScale(10.0, 1.0, 10.0), GLKMatrix4MakeRotation(0.0, 0.0, 1.0, 0.0))
        modelView = GLKMatrix4Multiply(modelView, GLKMatrix4MakeTranslation(-0.5, 0.0, -0.5))
        sceneMatrices.modelview = GLKMatrix4Multiply(lookAt, modelView)
        let uniformBufferSize = MemoryLayout.size(ofValue: sceneMatrices)
        uniformBuffer = metalDevice.makeBuffer(bytes: &sceneMatrices, length: uniformBufferSize, options: .storageModeShared)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        terrain.draw(renderEncoder: renderEncoder)
        
        /*
        if (vertexCount > 0) {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawIndexedPrimitives(type: .line, indexCount: Int(indexCount), indexType: .uint32, indexBuffer: indexBuffer, indexBufferOffset: 0)
        }
        */
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        #endif
    }
}
