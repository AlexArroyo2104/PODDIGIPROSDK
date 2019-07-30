//
//  UtilsF.swift
//  DGFmwrk
//
//  Created by Alejandro López Arroyo on 2/15/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation
import UIKit


class UtilsF: UIViewController {
    
    class func regexMatchesEmail(text: String) -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let validation = NSPredicate(format:"SELF MATCHES %@", regex)
        return validation.evaluate(with: text)
    }
    
    
    class func regexMatchesName(text: String) -> Bool{
        let regex = "(([a-zA-Z\\s])*)"
        let validation = NSPredicate(format:"SELF MATCHES %@", regex)
        return validation.evaluate(with: text)
    }
    
    class func regexMatchesNunmber(text: String) -> Bool{
        let regex = "\\d{2}?\\d{4}?\\d{4}"
        let validation = NSPredicate(format:"SELF MATCHES %@", regex)
        return validation.evaluate(with: text)
    }
    
    class func regexMatchesPassword(text: String) -> Bool{
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let validation = NSPredicate(format:"SELF MATCHES %@", regex)
        return validation.evaluate(with: text)
    }
    
    
    class func messageAlert(){
        
    }
    
    
}
