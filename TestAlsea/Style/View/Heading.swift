//
//  Heading.swift
//  TestStyling
//
//  Created by Danilo Souza on 10/05/17.
//  Copyright © 2017 Danilo Souza. All rights reserved.
//

import UIKit

@IBDesignable
public class Heading: UILabel, TextStylable {
    
    // Stylable protocol
    @IBInspectable public var styleName: String? = "" {
        didSet {
            self.styleNameDidSet()
        }
    }
    
    // TextStylable protocol
    public var textStyle: TextStyle? {
        didSet {
            applyStyle()
        }
    }
    
    override public var text: String? {
        didSet {
            applyStyle()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public func setupView() {
        applyStyle()
    }
    
    public func applyStyle() {
        applyBasicTextStyle()
    }
    
}
