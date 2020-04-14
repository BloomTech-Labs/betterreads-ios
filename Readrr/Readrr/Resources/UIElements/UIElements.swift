//
//  UIElements.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

@IBDesignable class ModernTextField: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { layer.cornerRadius = self.cornerRadius } }
    @IBInspectable var verticalInset: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    
    private func commoninit() {
        borderStyle = .none
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.insetBy(dx: verticalInset, dy: 0) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.insetBy(dx: verticalInset, dy: 0) }
    
}

@IBDesignable class ModernButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { layer.cornerRadius = self.cornerRadius } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    
    private func commoninit() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = .blue
        setTitleColor(.white, for: .normal)
    }
}

@IBDesignable class ModernView: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { layer.cornerRadius = self.cornerRadius }}
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2) { didSet { setupShadow() }}
    @IBInspectable var shadowRadius: CGFloat = 8 { didSet { setupShadow() }}
    @IBInspectable var shadowOpacity: Float = 0.4 { didSet { setupShadow() }}
    @IBInspectable var dropShadow: Bool = false { didSet { setupShadow() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    
    private func setupShadow() {
        if dropShadow {
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
        } else {
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    private func commoninit() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setupShadow()
    }
}
