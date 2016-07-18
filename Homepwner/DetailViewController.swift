//
//  DetailViewController.swift
//  Homepwner
//
//  Created by k_sabbak on 3/28/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    @IBOutlet var nameField: BorderTextField!
    @IBOutlet var serialNumberField: BorderTextField!
    @IBOutlet var valueField: BorderTextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteImageButton: UIButton!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
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
        
        imageView.image = imageStore.imageForKey(item.itemKey)
        
        if imageView.image != nil
        {
            deleteImageButton.enabled = true
            deleteImageButton.hidden = false
        }
        else
        {
            deleteImageButton.enabled = false
            deleteImageButton.hidden = true
        }
    }
    
    //MARK: - Photo stuff
    
    @IBAction func takePhoto(sender: UIBarButtonItem)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        //IFF the device has a camera pull from camera else pull from library
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            imagePicker.sourceType = .Camera
        }
        else
        {
            imagePicker.sourceType = .PhotoLibrary
        }
    
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        print(info)
        
        imageStore.setImage(image, forKey: item.itemKey)
        
        imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onDeleteImageButtonTapped(sender: UIButton)
    {
        imageStore.deleteImageForKey(item.itemKey)
        imageView.image = imageStore.imageForKey(item.itemKey)
        sender.hidden = true
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
