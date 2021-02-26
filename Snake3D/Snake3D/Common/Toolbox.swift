//
//  Toolbox.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

// MARK: - enums
public enum Direction: Int {
    case up
    case down
    case left
    case right
}

public enum ConstraintsTemplate: Int {
    case leftTopWidthHeight
    case leftBottomWidthHeight
    case rightTopWidthHeight
    case rightBottomWidthHeight
    case leftRightTopBottom
    case leftRightTopHeight
    case leftRightBottomHeight
    case leftTopBottomWidth
    case centerXcenterYwidthHeight
    case leftCenterYwidthHeight
    case rightCenterYwidthHeight
    case topBottomCenterXwidth
}

class Toolbox {
    
    // MARK: - constraints
    public static func addConstraints2View(view: UIView, parentView: UIView, template: ConstraintsTemplate, value1: CGFloat, value2: CGFloat, value3: CGFloat, value4: CGFloat) {
        _ = Toolbox.addConstraints2View(view: view, parentView: parentView, template: template, value1: value1, value2: value2, value3: value3, value4: value4, returnConstraints: false)
    }
    
    public static func addConstraints2View(view: UIView, parentView: UIView, template: ConstraintsTemplate) {
        _ = Toolbox.addConstraints2View(view: view, parentView: parentView, template: template, value1: 0.0, value2: 0.0, value3: 0.0, value4: 0.0, returnConstraints: false)
    }
    
    public static func addConstraints2View(view: UIView, parentView: UIView, template: ConstraintsTemplate, value1: CGFloat, value2: CGFloat, value3: CGFloat, value4: CGFloat, returnConstraints: Bool) -> [NSLayoutConstraint] {
        
        var constraints = Array<NSLayoutConstraint>()
        
        var constraint1: NSLayoutConstraint? = nil
        var constraint2: NSLayoutConstraint? = nil
        var constraint3: NSLayoutConstraint? = nil
        var constraint4: NSLayoutConstraint? = nil
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if (template == .leftTopWidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .rightTopWidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .leftBottomWidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .rightBottomWidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .leftRightTopBottom) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            parentView.addConstraint(constraint3!)
            parentView.addConstraint(constraint4!)
            
        } else if (template == .leftRightTopHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            parentView.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .leftRightBottomHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            parentView.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
        } else if (template == .leftTopBottomWidth) {
            constraint1 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            parentView.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .centerXcenterYwidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .leftCenterYwidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .rightCenterYwidthHeight) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            view.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else if (template == .topBottomCenterXwidth) {
            constraint1 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: value1)
            constraint2 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: value2)
            constraint3 = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1.0, constant: value3)
            constraint4 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value4)
            
            parentView.addConstraint(constraint1!)
            parentView.addConstraint(constraint2!)
            parentView.addConstraint(constraint3!)
            view.addConstraint(constraint4!)
            
        } else {
            
        }
        
        if (returnConstraints) {
            constraints.append(constraint1!)
            constraints.append(constraint2!)
            constraints.append(constraint3!)
            constraints.append(constraint4!)
        }
        
        return constraints
    }
    
    // MARK: - metal textures
    public static func aliasingTexture(texture: MTLTexture, device: MTLDevice, sampleCount: Int) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = texture.pixelFormat
        textureDescriptor.width = texture.width
        textureDescriptor.height = texture.height
        textureDescriptor.textureType = .type2DMultisample
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        textureDescriptor.sampleCount = sampleCount
        return device.makeTexture(descriptor: textureDescriptor)
    }
    
    public static func depthTexture(texture: MTLTexture, device: MTLDevice, sampleCount: Int) -> MTLTexture? {
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float, width: texture.width, height: texture.height, mipmapped: false)
        depthTextureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite, .pixelFormatView]
        depthTextureDescriptor.textureType = .type2DMultisample
        depthTextureDescriptor.storageMode = .private
        depthTextureDescriptor.resourceOptions = [.storageModePrivate]
        depthTextureDescriptor.sampleCount = sampleCount   //4
        return device.makeTexture(descriptor: depthTextureDescriptor)
    }
    
    // MARK: - other methods
    public static func positionFromTerrainCell(i: Int, j: Int) -> CGPoint {
        let cellSize = Toolbox.terrainCellSize()
        let x = Float(i) * cellSize
        let y = Float(j) * cellSize
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    public static func gameObjectPosition(column: Int, row: Int) -> CGPoint {
        let cellSize = Toolbox.terrainCellSize()
        let scaledSize = cellSize * Float(AppConsts.SCALE_FACTOR_SEGMENT)
        let delta = (cellSize - scaledSize) / 2.0
        
        var position = Toolbox.positionFromTerrainCell(i: column, j: row)
        position.x += CGFloat(delta)
        position.y += CGFloat(delta)
        
        return position
    }
    
    public static func randomPositionOnTerrainButNot(occupiedСells: [CGPoint]) -> (x: Int, y: Int) {
        let position = Toolbox.randomPositionOnTerrain()
        var ok = true
        
        for cell in occupiedСells {
            if (position.x == Int(cell.x) && position.y == Int(cell.y)) {
                ok = false
                break
            }
        }
        
        if (ok) {
            return position
        } else {
            print("was genareted value same with one of snake part")
            return Toolbox.randomPositionOnTerrainButNot(occupiedСells: occupiedСells)
        }
    }
    
    public static func randomPositionOnTerrain() -> (x: Int, y: Int) {
        let i = arc4random() % 10
        let j = arc4random() % 10
        return (Int(i), Int(j))
    }
    
    public static func terrainCellSize() -> Float {
        return 1.0 / Float(AppConsts.MAP_SIZE - 1)
    }
    
    static func topWindowLevel() -> UIWindow.Level {
        let windows = UIApplication.shared.windows
        let lastWindow = windows.last
        return lastWindow!.windowLevel + 1
    }
}
