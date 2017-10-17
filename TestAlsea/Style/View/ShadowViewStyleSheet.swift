//
//  ShadowViewStyleSheet.swift
//  LinioUIKit
//
//  Created by Mauricio Jimenez on 29/05/17.
//  Copyright © 2017 AlgoBonito. All rights reserved.

import UIKit

public enum ShadowViewStyleSheet: String {
    
    case cardRect
    case cardRound
    case loginWhiteRoundedInput
    
    public func getStyle() -> ShadowStyle {
        switch self {
        case .cardRect:
            var shadowStyle = ShadowStyle()
            shadowStyle.borderRadius = 0
            shadowStyle.shadowOffset = CGSize(width: 0, height: 2)
            shadowStyle.shadowOpacity = 0.2
            shadowStyle.shadowRadius = 5
            return shadowStyle
            
        case .cardRound:
            var shadowStyle = ShadowStyle()
            shadowStyle.borderRadius = 6
            shadowStyle.shadowOffset = CGSize(width: 0, height: 3)
            shadowStyle.shadowOpacity = 0.2
            shadowStyle.shadowRadius = 5
            return shadowStyle
        
        case .loginWhiteRoundedInput:
            var shadowStyle = ShadowStyle()
            shadowStyle.backgroundColor = UIColor.clear
            shadowStyle.shape = ViewStyle.ViewShape.round
            shadowStyle.borderColor = ColorPallete.gray600.asColor()
            shadowStyle.borderWidth = 2
            shadowStyle.shadowOffset = CGSize(width: 0, height: 0)
            shadowStyle.shadowOpacity = 0
            shadowStyle.shadowRadius = 0
            return shadowStyle
        }
    }
    
}
