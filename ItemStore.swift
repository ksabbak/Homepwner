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
    
    init()
    {
        for _ in 0..<5
        {
            createItem()
        }
    }
    
    
    func createItem() -> Item
    {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    
    
    
}
