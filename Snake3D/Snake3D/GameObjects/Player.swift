//
//  Player.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 24/02/2021.
//

import MetalKit
import GLKit

class Player {
    
    // MARK: - props
    private var snake = Array<SnakePart>()
    private var direction: Direction = .left
    private var elapsedTime: Double = 0.0
    
    // MARK: - ctor
    init(column: Int, row: Int, device: MTLDevice) {
        for i in 0..<5 {
            let part = SnakePart(column: column + i, row: row, device: device)
            self.snake.append(part)
        }
    }
    
    // MARK: - public methods
    public func update(timeElapsed: Double) {
        elapsedTime += timeElapsed
        if (elapsedTime > AppConsts.MOVEMENT_DELAY) {
            elapsedTime = 0
            
            let head = snake[0]
            let tail = snake[snake.count - 1]
            
            switch direction {
            case .up:
                tail.setPosition(column: head.column, row: head.row - 1)
            case .down:
                tail.setPosition(column: head.column, row: head.row + 1)
            case .left:
                tail.setPosition(column: head.column - 1, row: head.row)
            case .right:
                tail.setPosition(column: head.column + 1, row: head.row)
            }
            
            snake.remove(at: snake.count - 1)
            snake.insert(tail, at: 0)
            
            self.eatAppleTest()
            self.collisionTest()
        }
    }

    public func draw(renderEncoder: MTLRenderCommandEncoder, lookAt: GLKMatrix4, sceneMatrices: inout SceneMatrices) {
        for part in self.snake {
            part.draw(renderEncoder: renderEncoder, lookAt: lookAt, sceneMatrices: &sceneMatrices)
        }
    }
    
    // MARK: - other methods
    private func collisionTest() {
        
    }
    
    private func eatAppleTest() {
        
    }
}
