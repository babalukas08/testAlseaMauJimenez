//
//  FeedListView.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//


import UIKit
import NibDesignable

protocol FeedListViewDelegate: class {
    func onTapTakePhoto(mod: FeedListView)
}

struct FeedListViewModel {
    public var model: FeaturesModel?
    public init() { }
}

@IBDesignable
class FeedListView: NibDesignable {
    weak  var delegate: FeedListViewDelegate?
    
    @IBOutlet var rootView: StylableView!
    @IBOutlet weak var magLabel: Heading!
    @IBOutlet weak var placeLabel: Heading!
    @IBOutlet weak var hourLabel: Heading!
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Config View
    func setupView() {
        
    }
    
    func setColorBackground(mag: Double) {
        if mag < 4 {
            rootView.styleName = ViewStyleSheet.primGreenView.rawValue
        }
        else if mag == 4 || mag < 7 {
            rootView.styleName = ViewStyleSheet.primAmberView.rawValue
        }
        else if mag == 6 || mag < 8 {
            rootView.styleName = ViewStyleSheet.primOrange.rawValue
        }
        else {
            rootView.styleName = ViewStyleSheet.redViewBG.rawValue
        }
    }
    
    public func configure(_ model: FeedListViewModel) {        
        if let modelFeature = model.model {
            if let properties = modelFeature.properties {
                magLabel.text = "\(properties.mag)"
                placeLabel.text = properties.place
                hourLabel.text = "\(properties.time)"
                self.setColorBackground(mag: properties.mag)
            }
        }
    }
}

