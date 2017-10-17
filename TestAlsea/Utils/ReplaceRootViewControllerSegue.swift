//
//  ReplaceRootViewControllerSegue.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import Foundation
import UIKit

class ReplaceRootViewControllerSegue: UIStoryboardSegue {
    
    override func perform() {
        //Get the current app delegate
        guard
            let window = UIApplication.shared.delegate?.window ?? nil
            else {
                return
        }
        
        //Set the current root controller and add the animation with a
        //UIView transition
        window.rootViewController = self.destination
        
        UIView.transition(with: window,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = self.destination } ,
                          completion: nil)
    }
    
}
