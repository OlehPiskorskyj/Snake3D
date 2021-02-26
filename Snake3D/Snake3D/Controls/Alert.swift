//
//  Alert.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 26/02/2021.
//

import UIKit

class Alert: NSObject {
    
    // MARK: - constants
    public struct Consts {
        static let DIALOG_SIZE: CGFloat = 160.0
    }
        
    // MARK: - props
    private var window: UIWindow? = nil
    private var viewMain = UIView()
    private var viewContainer = UIView()
    private var viewDialog = UIView()
    
    private var currentOrientation: UIDeviceOrientation = .portrait
    private var message: String? = nil
    private var screenRect: CGRect = CGRect.zero
    private var isLandscape: Bool = false
    
    // MARK: - ctors
    public init(title: String) {
        super.init()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        if (width < height) {
            self.screenRect = CGRect.init(x: 0.0, y: 0.0, width: width, height: height)
        } else {
            self.screenRect = CGRect.init(x: 0.0, y: 0.0, width: height, height: width)
        }
        
        let windowScene = UIApplication.shared.connectedScenes.first
        if let windowScene = windowScene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            self.window?.frame = self.screenRect
            self.window?.tag = 1256
        }
        
        guard let window = self.window else { return }
        
        let viewBackground = UIView()
        viewBackground.frame = CGRect(x: 0.0, y: 0.0, width: window.frame.size.width, height: window.frame.size.height)
        viewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        window.addSubview(viewBackground)
        
        self.viewMain.frame = CGRect(x: 0.0, y: 0.0, width: window.frame.size.width, height: window.frame.size.height)
        self.viewMain.backgroundColor = UIColor.clear
        window.addSubview(self.viewMain)
        
        self.viewContainer.frame = CGRect(x: 0.0, y: 0.0, width: window.frame.size.width, height: window.frame.size.height)
        self.viewContainer.backgroundColor = UIColor.clear
        self.viewMain.addSubview(self.viewContainer)
        
        self.viewDialog.translatesAutoresizingMaskIntoConstraints = false
        self.viewDialog.frame = CGRect(x: 0.0, y: 0.0, width: Consts.DIALOG_SIZE, height: Consts.DIALOG_SIZE)
        self.viewDialog.backgroundColor = UIColor.init(white: 237.0 / 255.0, alpha: 1.0)
        self.viewDialog.layer.cornerRadius = 6.0
        self.viewContainer.addSubview(self.viewDialog)
        
        Toolbox.addConstraints2View(view: self.viewDialog, parentView: self.viewContainer, template: .centerXcenterYwidthHeight, value1: 0.0, value2: 0.0, value3: Consts.DIALOG_SIZE, value4: Consts.DIALOG_SIZE)
        
        self.viewContainer.layoutIfNeeded()
        
        /*
        if (Toolbox.deviceType() == .iPad) {
            self.rotate2Orientation(orientation: UIDevice.current.orientation)
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        */
    }
    
    // MARK: - events
    @objc func tap() {
        self.hide()
    }
    
    // MARK: - orientation
    @objc func deviceRotated(notification: NSNotification) {
        if (self.isLandscape) {
            return
        }
        
        let orientation = UIDevice.current.orientation
        if (orientation == self.currentOrientation) {
            return
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.rotate2Orientation(orientation: orientation)
        }, completion: nil)
    }
    
    private func rotate2Orientation(orientation: UIDeviceOrientation) {
        if (orientation == .portrait) {
            self.currentOrientation = orientation
            self.viewMain.transform = CGAffineTransform.identity
            self.viewMain.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.width, height: self.window!.frame.size.height)
            self.viewContainer.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.width, height: self.window!.frame.size.height)
            self.viewContainer.layoutIfNeeded()
        } else if (orientation == .landscapeLeft) {
            self.currentOrientation = orientation
            self.viewMain.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
            self.viewMain.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.width, height: self.window!.frame.size.height)
            self.viewContainer.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.height, height: self.window!.frame.size.width)
            self.viewContainer.layoutIfNeeded()
        } else if (orientation == .landscapeRight) {
            self.currentOrientation = orientation
            self.viewMain.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            self.viewMain.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.width, height: self.window!.frame.size.height)
            self.viewContainer.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.size.height, height: self.window!.frame.size.width)
            self.viewContainer.layoutIfNeeded()
        }
    }
    
    // MARK: - public methods
    public func rotateToLandscape() {
        self.isLandscape = true
        self.rotate2Orientation(orientation: .landscapeRight)
    }
    
    public func show() {
        
        self.window?.windowLevel = Toolbox.topWindowLevel()
        self.window?.makeKeyAndVisible()
        
        let transform = self.viewDialog.transform
        self.viewDialog.alpha = 0.0
        self.viewDialog.transform = transform.scaledBy(x: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.viewDialog.alpha = 1.0
            self.viewDialog.transform = transform.scaledBy(x: 1.1, y: 1.1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.08, delay: 0.0, options: .curveEaseInOut, animations: {
                self.viewDialog.transform = transform.scaledBy(x: 1.0, y: 1.0)
            }, completion: nil)
        })
    }
    
    public func hide() {
        //if (Toolbox.deviceType() == .iPad) {
        //    NotificationCenter.default.removeObserver(self)
        //}
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.window?.alpha = 0.0
        }, completion: { finished in
            self.window = nil
            UIApplication.shared.windows.first!.makeKeyAndVisible()
        })
    }
}
