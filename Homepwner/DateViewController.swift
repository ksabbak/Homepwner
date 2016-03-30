//
//  DateViewController.swift
//  Homepwner
//
//  Created by k_sabbak on 3/30/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item! {
        didSet{
            navigationItem.title = item.name
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        datePicker.setDate(item.dateCreated, animated: true)
        datePicker.datePickerMode = UIDatePickerMode.Date
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        item.dateCreated = datePicker.date
        
        super.viewWillDisappear(animated)
    }
    

    
}
