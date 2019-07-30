//
//  BlinkingLabel.swift
//  FirebaseCore
//
//  Created by Alejandro López Arroyo on 7/24/19.
//

import Foundation
import UIKit

public class BlinkingLabel : UILabel {
    public func startBlinking() {
        let options : UIView.AnimationOptions = .autoreverse
        UIView.animate(withDuration: 0.25, delay:0.0, options:options, animations: {
            self.alpha = 0
        }, completion: nil)
    }
    
    public func stopBlinking() {
        alpha = 1
        layer.removeAllAnimations()
    }
}
