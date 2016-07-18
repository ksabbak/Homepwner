//
//  ItemsTableViewController.swift
//  Homepwner
//
//  Created by k_sabbak on 3/23/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController
{
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewItem(sender: AnyObject)
    {
        itemStore.createItem()
        
        //Make a new index path for the 0th section, last row
        let lastRow = tableView.numberOfRowsInSection(0)
        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
        
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.reloadData()
    }
    

    //MARK: - TableView Delegate/DataSource 
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)"
            let message = "Are you sure you want to delete this item?"
            
            let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            
                self.itemStore.removeItem(item)
                self.imageStore.deleteImageForKey(item.itemKey)
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            presentViewController(deleteAlert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        
        
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath
    {
        if proposedDestinationIndexPath.row == itemStore.allItems.count
        {
            return sourceIndexPath
        }
        else
        {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if indexPath.row == itemStore.allItems.count
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if indexPath.row == itemStore.allItems.count
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemStore.allItems.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        if indexPath.row < itemStore.allItems.count
        {
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            if item.valueInDollars < 50
            {
                cell.valueLabel.textColor = UIColor.redColor()
            }
            else
            {
                cell.valueLabel.textColor = UIColor.greenColor()
            }
            
            cell.userInteractionEnabled = true
        }
        else
        {
            cell.nameLabel.text = "End of Item List"
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
            cell.userInteractionEnabled = false
        }
        
        return cell
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowItem"
        {
            if let row = tableView.indexPathForSelectedRow?.row
            {
                let item = itemStore.allItems[row]
                let dvc = segue.destinationViewController as! DetailViewController
                dvc.item = item
                dvc.imageStore = imageStore
            }
        }
    }
    
}
