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
        static let ALERT_WIDTH: CGFloat = 240.0
        static let ALERT_HEIGHT: CGFloat = 150.0
    }
        
    // MARK: - props
    private weak var parentView: UIView? = nil
    private var window: UIWindow? = nil
    private var viewDialog = UIView()
    private var lblTitle = UILabel()
    private var lblMessage = UILabel()
    private var btnCancel = UIButton()
    private var btnOk = UIButton(type: .custom)
    
    private var message: String? = nil
    private var screenRect: CGRect = CGRect.zero
    
    public var cancelAction: (() -> ())? = nil
    public var okAction: (() -> ())? = nil
    
    // MARK: - ctors
    public init(parentView: UIView?, title: String, message: String, cancelTitle: String, okTitle: String) {
        super.init()
        
        self.parentView = parentView
        guard let parent = self.parentView else { return }
        
        self.viewDialog.translatesAutoresizingMaskIntoConstraints = false
        self.viewDialog.backgroundColor = UIColor.init(white: 0.2, alpha: 1.0)
        self.viewDialog.layer.borderColor = UIColor.white.cgColor
        self.viewDialog.layer.borderWidth = 0.5
        self.viewDialog.isHidden = true
        parent.addSubview(self.viewDialog)
        
        Toolbox.addConstraints2View(view: self.viewDialog, parentView: parent, template: .centerXcenterYwidthHeight, value1: 0.0, value2: 5.0, value3: Consts.ALERT_WIDTH, value4: Consts.ALERT_HEIGHT)
        
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.font = Toolbox.appFont(size: 24.0)
        self.lblTitle.textAlignment = .center
        self.lblTitle.textColor = .white
        self.lblTitle.text = title
        self.viewDialog.addSubview(self.lblTitle)
        
        Toolbox.addConstraints2View(view: self.lblTitle, parentView: self.viewDialog, template: .leftRightTopHeight, value1: 0.0, value2: 0.0, value3: 16.0, value4: 30.0)
        
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.font = Toolbox.appFont(size: 14.0)
        self.lblMessage.textAlignment = .center
        self.lblMessage.textColor = .lightGray
        self.lblMessage.text = message
        self.viewDialog.addSubview(self.lblMessage)
        
        Toolbox.addConstraints2View(view: self.lblMessage, parentView: self.viewDialog, template: .leftRightTopHeight, value1: 0.0, value2: 0.0, value3: 54.0, value4: 20.0)
        
        self.btnCancel.translatesAutoresizingMaskIntoConstraints = false
        self.btnCancel.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.btnCancel.titleLabel?.font = Toolbox.appFont(size: 18.0)
        self.btnCancel.setTitleColor(.red, for: .normal)
        self.btnCancel.setTitle(cancelTitle, for: .normal)
        self.btnCancel.backgroundColor = .clear
        self.viewDialog.addSubview(self.btnCancel)
        
        Toolbox.addConstraints2View(view: self.btnCancel, parentView: self.viewDialog, template: .leftBottomWidthHeight, value1: 0.0, value2: 0.0, value3: Consts.ALERT_WIDTH / 2.0, value4: 80.0)
        
        self.btnOk.translatesAutoresizingMaskIntoConstraints = false
        self.btnOk.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.btnOk.titleLabel?.font = Toolbox.appFont(size: 18.0)
        self.btnOk.setTitleColor(.green, for: .normal)
        self.btnOk.setTitle(okTitle, for: .normal)
        self.btnOk.backgroundColor = .clear
        self.viewDialog.addSubview(self.btnOk)
        
        Toolbox.addConstraints2View(view: self.btnOk, parentView: self.viewDialog, template: .rightBottomWidthHeight, value1: 0.0, value2: 0.0, value3: Consts.ALERT_WIDTH / 2.0, value4: 80.0)
        
        let viewDivider = UIView()
        viewDivider.translatesAutoresizingMaskIntoConstraints = false
        viewDivider.backgroundColor = .white
        self.viewDialog.addSubview(viewDivider)
        
        Toolbox.addConstraints2View(view: viewDivider, parentView: self.viewDialog, template: .topBottomCenterXwidth, value1: 90.0, value2: -10.0, value3: 0.0, value4: 1.0)
        
        parent.layoutIfNeeded()
    }
    
    // MARK: - events
    @objc func btnClick(sender: UIButton) {
        self.hide()
        
        if (sender == btnCancel) {
            self.cancelAction?()
        } else if (sender == btnOk) {
            self.okAction?()
        }
    }
    
    // MARK: - public methods
    public func show() {
        let transform = self.viewDialog.transform
        self.viewDialog.isHidden = false
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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.viewDialog.alpha = 0.0
        }, completion: { finished in
            self.viewDialog.isHidden = true
            self.viewDialog.removeFromSuperview()
        })
    }
}
