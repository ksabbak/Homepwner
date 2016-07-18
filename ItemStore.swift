//
//  ItemStore.swift
//  Homepwner
//
//  Created by k_sabbak on 3/23/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class ItemStore
{
    
    var allItems = [Item]()
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
//    init()
//    {
//        for _ in 0..<5
//        {
//            createItem()
//        }
//    }
    
    init()
    {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
    
    func createItem() -> Item
    {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item)
    {
        if let index = allItems.indexOf(item)
        {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int)
    {
        if fromIndex == toIndex
        {
            return
        }
        
        let movedItem = allItems[fromIndex]
        
        allItems.removeAtIndex(fromIndex)
        
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    
    func saveChanges() -> Bool
    {
        print("Saving item to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    
}
