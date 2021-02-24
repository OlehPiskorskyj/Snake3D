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
    
    public var apple: Apple? = nil
    public var gameOver: (() -> ())? = nil
    
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
            /*
            CGPoint appleNewPosition = [SnakeUtility randomPositionOnTerrainButNot:[self cellsUnderSnake]];
            [mApple setPositionWithColumn:appleNewPosition.x Row:appleNewPosition.y];
            
            if ([tail getColumn] == [preTail getColumn])
            {
                SnakePart *part = [[SnakePart alloc] initWithColumn:[tail getColumn] Row:([tail getRow] > [preTail getRow]) ? [tail getRow] + 1 : [tail getRow] - 1];
                [mSnake addObject:part];
                [part release];
            }
            else if ([tail getRow] == [preTail getRow])
            {
                SnakePart *part = [[SnakePart alloc] initWithColumn:([tail getColumn] > [preTail getColumn]) ? [tail getColumn] + 1 : [tail getColumn] - 1 Row:[tail getRow]];
                [mSnake addObject:part];
                [part release];
            }
            */
        }
    }
}
