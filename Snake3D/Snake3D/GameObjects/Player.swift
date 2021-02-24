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
    private var elapsedTime: Double = 0.0
    
    public var apple: Apple? = nil
    public var gameOver: (() -> ())? = nil

    private var mDirection: Direction = .left
    public var direction: Direction {
        get {
            return mDirection
        }
        set {
            if ((mDirection == .up && newValue == .down) ||
                    (mDirection == .down && newValue == .up) ||
                    (mDirection == .left && newValue == .right) ||
                    (mDirection == .right && newValue == .left)) {
                return
            } else {
                mDirection = newValue
            }
        }
    }
    
    // MARK: - ctor
    init(column: Int, row: Int) {
        for i in 0..<5 {
            let part = SnakePart(column: column + i, row: row)
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
            
            switch mDirection {
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
    
    public func cellsUnderSnake() -> [CGPoint] {
        var returnValue = Array<CGPoint>()
        for part in snake {
            returnValue.append(CGPoint(x: part.column, y: part.row))
        }
        return returnValue
    }
    
    // MARK: - other methods
    private func collisionTest() {
        let head = snake[0]
        
        // walls collision
        if (head.column > AppConsts.MAP_SIZE - 2 || head.column < 0
                || head.row > AppConsts.MAP_SIZE - 2 || head.row < 0) {
            self.gameOver?()
        }
        
        // self collision
        for i in 1..<snake.count {
            let part = snake[i]
            if (head.column == part.column && head.row == part.row) {
                self.gameOver?()
            }
        }
    }
    
    private func eatAppleTest() {
        guard let apple = self.apple else { return }
        
        let head = snake[0]
        let tail = snake[snake.count - 1]
        let preTail = snake[snake.count - 2]
        
        if (head.column == apple.column && head.row == apple.row) {
            let appleNewPosition = Toolbox.randomPositionOnTerrainButNot(occupiedСells: self.cellsUnderSnake())
            apple.setPosition(column: appleNewPosition.x, row: appleNewPosition.y)
            
            if (tail.column == preTail.column) {
                let part = SnakePart(column: tail.column, row: (tail.row > preTail.row) ? tail.row + 1 : tail.row - 1)
                snake.append(part)
            } else if (tail.row == preTail.row) {
                let part = SnakePart(column: (tail.column > preTail.column) ? tail.column + 1 : tail.column - 1, row: tail.row)
                snake.append(part)
            }
        }
    }
}
