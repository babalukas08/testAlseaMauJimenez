//
//  ModTableViewCell.swift
//  Apps Mauricio Jimenez
//
//  Created by Mauricio Jimenez on 29/05/17.
//  Copyright © 2017 AlgoBonito. All rights reserved.
//

import UIKit

protocol ModTableCellCompatible {
    
    func setHighlighted(highlighted: Bool, animated: Bool)
    func setSelected(selected: Bool, animated: Bool)
}

public class ModTableViewCell<ModClass: UIView>: UITableViewCell {
    
    public var mod: ModClass?
    public var insets: UIEdgeInsets?
    var horizontalConstraints: [NSLayoutConstraint]?
    var verticalConstraints: [NSLayoutConstraint]?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mod = ModClass()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if let modTableCellCompatible = mod as? ModTableCellCompatible {
            modTableCellCompatible.setHighlighted(highlighted: highlighted, animated: animated)
        }
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let modTableCellCompatible = mod as? ModTableCellCompatible {
            modTableCellCompatible.setSelected(selected: selected, animated: animated)
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            self.setSelected(isSelected, animated: false)
        }
    }
    
}

public class ModTableViewControllerCell<ModClass: UIViewController>: UITableViewCell {
    
    public var mod: ModClass?
    public var insets: UIEdgeInsets?
    var horizontalConstraints: [NSLayoutConstraint]?
    var verticalConstraints: [NSLayoutConstraint]?
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mod = ModClass()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        mod = ModClass()
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(mod!.view)
        setupModConstraints()
    }
    
    func setupModConstraints() {
        mod?.view.translatesAutoresizingMaskIntoConstraints = false
        horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": mod!.view])
        contentView.addConstraints(horizontalConstraints!)
        
        verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": mod!.view])
        contentView.addConstraints(verticalConstraints!)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if let modTableCellCompatible = mod as? ModTableCellCompatible {
            modTableCellCompatible.setHighlighted(highlighted: highlighted, animated: animated)
        }
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let modTableCellCompatible = mod as? ModTableCellCompatible {
            modTableCellCompatible.setSelected(selected: selected, animated: animated)
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            self.setSelected(isSelected, animated: false)
        }
    }
    
}
