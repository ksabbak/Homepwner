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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @IBAction func addNewItem(sender: AnyObject)
    {
        let newItem = itemStore.createItem()
        
        //Make a new index path for the 0th section, last row
        let lastRow = tableView.numberOfRowsInSection(0)
        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
        
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.reloadData()
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject)
    {
        if editing
        {
            sender.setTitle("Edit", forState: .Normal)
            
            setEditing(false, animated: true)
        }
        else
        {
            sender.setTitle("Done", forState: .Normal)
            
            setEditing(true, animated: true)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
        
        
        if indexPath.row < itemStore.allItems.count
        {
            let item = itemStore.allItems[indexPath.row]
            
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        }
        else
        {
            cell.textLabel?.text = "End of Item List"
            cell.detailTextLabel?.text = ""
        }
        
        
        return cell
    }


}
