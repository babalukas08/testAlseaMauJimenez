//
//  Sizes.swift
//  TestStyling
//
//  Created by Mauricio Jimenez on 29/05/17.
//  Copyright © 2017 AlgoBonito. All rights reserved.

import Foundation
import UIKit

public enum SizesPallete {
    
    public enum TextSize: Int {
        case txtBold30 = 30
        case txtBase15 = 15
        case txtBase21 = 21
        case txtBase20 = 20
        case textEmptyCopupon = 40
        case textXXXL = 28
        case textXXL = 22
        case textXL = 18
        case textL = 16
        case textM = 14
        case textSS = 13
        case textS = 12
        case textXS = 11
        case textxxs = 9
    }
    
    public enum IconSize {
        case verySmall
        case medium
        
        public func getSize() -> CGSize {
            switch self {
            case .verySmall:
                return CGSize(width: 20, height: 20)
            default:
                return CGSize(width: 20, height: 20)
            }
        }
    }
    
    public enum ButtonSize: Int {
        case btnPrimary = 48
        case btnSecondary = 40
        case horizontaInset = 24
        case searchButton = 19
    }

}
