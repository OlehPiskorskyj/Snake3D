//
//  UILabel+extensions.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 27/02/2021.
//

import UIKit

extension UILabel {
    public func pulseAnimation(repeatCount: Int) {
        self.alpha = 1.0
        
        let flashAnimation = CABasicAnimation(keyPath: "opacity")
        flashAnimation.fromValue = NSNumber(value: 0)
        flashAnimation.toValue = NSNumber(value: 1)
        flashAnimation.repeatCount = Float(repeatCount)
        flashAnimation.duration = 1.0
        flashAnimation.autoreverses = true
        self.layer.removeAnimation(forKey: "flashAnimation")
        self.layer.add(flashAnimation, forKey: "flashAnimation")
        self.layer.opacity = 0.0
    }
}
