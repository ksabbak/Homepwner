//
//  BorderTextField.swift
//  Homepwner
//
//  Created by k_sabbak on 3/30/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class BorderTextField: UITextField
{
    override func becomeFirstResponder() -> Bool
    {
        super.becomeFirstResponder()
        
        self.borderStyle = .Bezel
        
        return true
    }
    
    override func resignFirstResponder() -> Bool
    {
        super.resignFirstResponder()
        
        self.borderStyle = .RoundedRect
        
        return true
    }
}
