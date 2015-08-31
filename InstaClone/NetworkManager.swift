//
//  NetworkManager.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 8/25/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import Foundation

typealias ErrorCompletionHandler = (error: NSError?) -> ()
typealias ObjectsCompletionHandler = (objects: [AnyObject]!, error: NSError?) -> ()
typealias ImageCompletionHandler = (image: UIImage?, error: NSError?) -> ()

public class NetworkManager
{
    public class var sharedInstance:  NetworkManager
    {
        struct Singleton
        {
            static let instance = NetworkManager()
        }
        
        return Singleton.instance
    
    }
    
    
    
    func follow(user: PFUser!, completionHandler:(error: NSError?)-> () )
    {
        var relation = PFUser.currentUser()?.relationForKey("following")
        relation?.addObject(user)
        PFUser.currentUser()?.saveInBackgroundWithBlock{
            (success,error) -> Void in
            
            completionHandler(error: error)
        }
    }
    
    
    
    func fetchFeed(completionHandler: ObjectsCompletionHandler!)
    {
        var relation = PFUser.currentUser()!.relationForKey("following")
        var query = relation.query()
        query!.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            
            if (error != nil)
            {
                println("error fetching following")
                
                completionHandler(objects: nil, error: error!)
            }
            else
            {
                var postQuery = PFQuery(className: "Post")
                postQuery.whereKey("User", containedIn: objects!)
                postQuery.orderByDescending("createdAt")
                postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if (error != nil) {
                        println("error fetching feed posts")
                        completionHandler(objects: nil, error: error)
                    } else {
                        println("Success fetching feed posts \(objects)")
                        completionHandler(objects: objects!, error: nil)
                    }
                    
                })
            }
            
        }
    }
    
    
    
    func fetchImage(post: PFObject, completionHandler: ImageCompletionHandler)
    {
        var imageReference = post["Image"] as? PFFile
        imageReference?.getDataInBackgroundWithBlock{
                (data, error) -> Void in
                
                if (error != nil)
                {
                    println("Error fetching image \(error!.localizedDescription)")
                    completionHandler(image: nil, error: error)
                }
                else
                {
                    println(" we downloaded the image")
                    let image = UIImage(data: data!)
                    completionHandler(image:image, error: nil)
                }
            }
        }
    }
    
    
    


