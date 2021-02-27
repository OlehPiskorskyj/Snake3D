//
//  UILabel+extensions.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 27/02/2021.
//

import UIKit

extension UILabel {
    public func pulseAnimation() {
        self.alpha = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.375, execute: { [weak self] in
            self?.layer.removeAllAnimations()
            self?.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.autoreverse, .repeat]) { [weak self] in
            self?.alpha = 1.0
        }
    }
}
