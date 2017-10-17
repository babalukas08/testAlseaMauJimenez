//
//  ModTableViewHeaderFooter.swift
//  Apps Mauricio Jimenez
//
//  Created by Mauricio Jimenez on 29/05/17.
//  Copyright © 2017 AlgoBonito. All rights reserved.
//

import UIKit

public class ModTableViewHeaderFooter<ModClass: UIView>: UITableViewHeaderFooterView {
    
    public var mod: ModClass?
    var horizontalConstraints: [NSLayoutConstraint]?
    var verticalConstraints: [NSLayoutConstraint]?
    
    public override init(reuseIdentifier: String?) {
        mod = ModClass()
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        mod = ModClass()
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(mod!)
        setupModConstraints()
    }
    
    func setupModConstraints() {
        mod?.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": mod!])
        contentView.addConstraints(horizontalConstraints!)
        
        verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": mod!])
        contentView.addConstraints(verticalConstraints!)
    }

    
}
