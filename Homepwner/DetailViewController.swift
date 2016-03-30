//
//  DetailViewController.swift
//  Homepwner
//
//  Created by k_sabbak on 3/28/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet var nameField: BorderTextField!
    @IBOutlet var serialNumberField: BorderTextField!
    @IBOutlet var valueField: BorderTextField!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        return formatter
    }()
    
    //MARK: - View loading methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = "\(numberFormatter.stringFromNumber(item.valueInDollars)!)"
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
    }
    
    
    //MARK: - Text Field Stuff
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    
    //MARK: - View leaving methods
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText)
        {
            item.valueInDollars = value.integerValue
        }
        else
        {
            item.valueInDollars = 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "DatePicker"
        {
            let dvc = segue.destinationViewController as! DateViewController
            dvc.item = item
        }
    }
    
}
