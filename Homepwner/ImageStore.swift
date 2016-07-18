//
//  ImageStore.swift
//  Homepwner
//
//  Created by k_sabbak on 3/30/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class ImageStore
{
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String)
    {
        cache.setObject(image, forKey: key)
        
        let imageURL = imageURLForKey(key)
        
//        if let data = UIImageJPEGRepresentation(image, 0.5)
//        {
//            data.writeToURL(imageURL, atomically: true)
//        }
        
        if let data = UIImagePNGRepresentation(image)
        {
            data.writeToURL(imageURL, atomically: true)
            print(imageURL)
        }
        
    }
    
    func imageForKey(key: String) -> UIImage?
    {
        //return cache.objectForKey(key) as? UIImage
        
        if let existingImage = cache.objectForKey(key) as? UIImage
        {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key)
        //"guard is a conditional statement. The compiler will only continue past the guard statement if the condition within the guard is true" if not true, it will execute the else. So if the let fails then else, otherwise it ignores the else. (page 255 BNR iOS)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!)
            else
        {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String)
    {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        do
        {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch let deleteError
        {
            print("Error removing image from disk: \(deleteError)")
        }
    }
    
    func imageURLForKey(key: String) -> NSURL
    {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
}
