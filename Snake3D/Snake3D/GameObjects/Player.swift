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
            
            /*
            SnakePart *head = [mSnake objectAtIndex:0];
            SnakePart *tail = [mSnake objectAtIndex:[mSnake count] - 1];
            [tail retain];
            
            if (mDirection == Up)
                [tail setPositionWithColumn:[head getColumn] Row:[head getRow] - 1];
            else if (mDirection == Down)
                [tail setPositionWithColumn:[head getColumn] Row:[head getRow] + 1];
            else if (mDirection == Left)
                [tail setPositionWithColumn:[head getColumn] - 1 Row:[head getRow]];
            else if (mDirection == Right)
                [tail setPositionWithColumn:[head getColumn] + 1 Row:[head getRow]];
            
            [mSnake removeObjectAtIndex:[mSnake count] - 1];
            [mSnake insertObject:tail atIndex:0];
            [tail release];
            
            [self eatAppleTest];
            [self collisionTest];
            */
        }
    }

    public func draw(renderEncoder: MTLRenderCommandEncoder, lookAt: GLKMatrix4, sceneMatrices: inout SceneMatrices) {
        for part in self.snake {
            part.draw(renderEncoder: renderEncoder, lookAt: lookAt, sceneMatrices: &sceneMatrices)
        }
    }
}
