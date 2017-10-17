//
//  StylableShadowView.swift
//  LinioUIKit
//
//  Created by Danilo Souza on 10/08/17.
//  Copyright © 2017 Linio. All rights reserved.
//

import UIKit

@IBDesignable
public class StylableShadowView: UIView, ShadowStylable {
    
    public var borderLayer: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable public var borderWidth: Int = 0 {
        didSet {
            self.layer.borderWidth = CGFloat(borderWidth)
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var cornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
            setNeedsLayout()
        }
    }
    
    public var viewCorners: ViewStyle.ViewCorners? = .left {
        didSet {
            resizeCornersBySide()
        }
    }
    
    @IBInspectable public var styleName: String? {
        didSet {
            styleNameDidSet()
        }
    }
    
    public var shadowStyle: ShadowStyle? {
        didSet {
            applyStyle()
        }
    }
    
    @IBInspectable public var borderRadius: CGFloat = 0 {
        didSet {
            self.setupShadow()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            self.setupShadow()
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0.2 {
        didSet {
            self.setupShadow()
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 5 {
        didSet {
            self.setupShadow()
        }
    }
    
    @IBInspectable public var viewShapeName: String? {
        didSet {
            viewShapeNameDidSet()
        }
    }
    
    @IBInspectable public var backColor: UIColor? = ColorPallete.white.asColor() {
        didSet {
            backgroundColor = backColor
        }
    }
    
//    if let bgColor = viewStyle.backgroundColor {
//        backgroundColor = bgColor
//    }
    
    public var viewShape: ViewStyle.ViewShape? = .rect {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            self.setupShadow()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        setupShadow()
    }
    
    func applyStyle() {
        if let shadowStyle = self.shadowStyle {
            self.borderRadius = shadowStyle.borderRadius
            self.shadowOffset = shadowStyle.shadowOffset
            self.shadowOpacity = shadowStyle.shadowOpacity
            self.shadowRadius = shadowStyle.shadowRadius
            self.viewShape = shadowStyle.shape
            self.backColor = shadowStyle.backgroundColor ?? UIColor.clear
            self.borderWidth = shadowStyle.borderWidth ?? 0
            self.borderColor = shadowStyle.borderColor ?? UIColor.clear
        }
        
        setupShadow()
    }
    
    private func setupShadow() {
        //self.layer.cornerRadius = self.borderRadius
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = Float(self.shadowOpacity)
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(
                width: self.borderRadius,
                height: self.borderRadius)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        applyCorners()
    }
    
}
