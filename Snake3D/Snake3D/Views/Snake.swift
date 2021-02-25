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
    private var sceneMatrices = SceneMatrices()
    private var uniformBuffer: MTLBuffer!
    private var lookAt: GLKMatrix4 = GLKMatrix4Identity
    private var prevTime: TimeInterval = 0.0
    private var playerDead: Bool = false
    
    private var terrain: Terrain!
    private var player: Player!
    private var apple: Apple!
    
    public var scoreChanged: ((Int) -> ())? = nil
    public var gameOver: ((Int) -> ())? = nil
    public var zoom: Float = 0.0
    
    public var score: Int = 0 {
        didSet {
            self.scoreChanged?(score)
        }
    }
    
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
    
    // MARK: - events
    @objc func swipe(gr: UISwipeGestureRecognizer) {
        switch gr.direction {
        case .up:
            player.direction = .up
        case .down:
            player.direction = .down
        case .left:
            player.direction = .left
        case .right:
            player.direction = .right
        default:
            player.direction = .left
        }
    }
    
    // MARK: - game cycle
    func update(timeElapsed: Double) {
        if (playerDead) { return }
        player.update(timeElapsed: timeElapsed)
    }
    
    // MARK: - utilities
    func updateProjectionMatrix(aspectRatio: Float) {
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), fabsf(aspectRatio), 1.0, 100.0);
        sceneMatrices.projection = projectionMatrix
        textureDepth = nil
        texture = nil
    }
    
    func createRenderPassDescriptor(drawable: CAMetalDrawable) -> MTLRenderPassDescriptor {
        if (texture == nil) {
            texture = Toolbox.aliasingTexture(texture: drawable.texture, device: metalDevice, sampleCount: self.sampleCount)
        }
        
        if (textureDepth == nil) {
            textureDepth = Toolbox.depthTexture(texture: drawable.texture, device: metalDevice, sampleCount: self.sampleCount)
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
    
    // MARK: - public methods
    public func retry() {
        player = self.initPlayer()
        score = 0
        
        let appleStartPosition = Toolbox.randomPositionOnTerrainButNot(occupiedСells: player.cellsUnderSnake())
        apple.setPosition(column: appleStartPosition.x, row: appleStartPosition.y)
        
        player.apple = apple
        playerDead = false
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
        
        prevTime = Date().timeIntervalSince1970
        
        self.setupMetal()
        self.initGameObjects()
        self.addGestureRecognizers()
        
        self.delegate = self
    }
    
    func initGameObjects() {
        terrain = Terrain()
        player = self.initPlayer()
        
        let appleStartPosition = Toolbox.randomPositionOnTerrainButNot(occupiedСells: player.cellsUnderSnake())
        apple = Apple(column: appleStartPosition.x, row: appleStartPosition.y)
        
        player.apple = apple
    }
    
    func initPlayer() -> Player {
        let player = Player(column: 5, row: 5)
        player.appleEaten = { [weak self] in
            self?.score += 10
        }
        
        player.gameOver = { [weak self] in
            self?.gameOver?(self?.score ?? 0)
            self?.playerDead = true
        }
        return player
    }
    
    func setupMetal() {
        metalDevice = MTLCreateSystemDefaultDevice()
        commandQueue = metalDevice.makeCommandQueue()
        self.device = metalDevice
        
        lookAt = GLKMatrix4Multiply(GLKMatrix4MakeLookAt(0.0, 6.0, 6.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0), GLKMatrix4MakeTranslation(0.0, 0.0, -1.5))
        
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), fabsf(Float(self.bounds.width / self.bounds.height)), 1.0, 100.0);
        sceneMatrices.projection = projectionMatrix
        
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
        
        Config.instance.metalDevice = metalDevice
    }
    
    func tearDownMetal() {
        terrain.tearDown()
        //player.te
        apple.tearDown()
        
        textureDepth = nil
        texture = nil
    }
    
    func addGestureRecognizers() {
        let upGR = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gr:)))
        upGR.direction = .up
        self .addGestureRecognizer(upGR)
        
        let downGR = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gr:)))
        downGR.direction = .down
        self .addGestureRecognizer(downGR)
        
        let leftGR = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gr:)))
        leftGR.direction = .left
        self .addGestureRecognizer(leftGR)
        
        let rightGR = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gr:)))
        rightGR.direction = .right
        self .addGestureRecognizer(rightGR)
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
        
        let timeNow = Date().timeIntervalSince1970
        let timeElapsed = abs(prevTime - timeNow)
        prevTime = timeNow
        self.update(timeElapsed: timeElapsed)
        
        guard let drawable = view.currentDrawable else { return }
        let renderPassDescriptor = self.createRenderPassDescriptor(drawable: drawable)
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        //lookAt = GLKMatrix4Multiply(GLKMatrix4MakeLookAt(0.0, 6.0 - self.zoom, 6.0 - self.zoom, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0), GLKMatrix4MakeTranslation(0.0, 0.0, -1.5))
        
        terrain.draw(renderEncoder: renderEncoder, lookAt: lookAt, sceneMatrices: &sceneMatrices)
        player.draw(renderEncoder: renderEncoder, lookAt: lookAt, sceneMatrices: &sceneMatrices)
        apple.draw(renderEncoder: renderEncoder, lookAt: lookAt, sceneMatrices: &sceneMatrices)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        #endif
    }
}
