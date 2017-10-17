//
//  ModAccessoryViewHeader.swift
//  LinioUIKit
//
//  Created by Danilo Souza on 07/08/17.
//  Copyright © 2017 Linio. All rights reserved.
//

import UIKit
import NibDesignable

public protocol ModAccessoryViewHeaderDelegate: class {
    func onTapSecondaryButton(mod: ModAccessoryViewHeader)
}

public class ModAccessoryViewHeader: NibDesignable {
    
    public weak var delegate: ModAccessoryViewHeaderDelegate?
    
    @IBOutlet weak var titleModal: Heading!
    @IBOutlet weak var secondButton: SimpleStylableButton!
    
    
    @IBInspectable var title: String = "" {
        didSet {
            titleModal.text = title
        }
    }
    
    @IBInspectable public var secondaryButtonTitle: String = "" {
        didSet {
            secondButton.setTitle(secondaryButtonTitle, for: .normal)
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
        secondButton.addTarget(self, action: #selector(onTapSecondaryButton), for: .touchUpInside)
    }
    
    func onTapSecondaryButton() {
        delegate?.onTapSecondaryButton(mod: self)
    }
    
}
