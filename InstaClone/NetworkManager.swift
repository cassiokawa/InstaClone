//
//  NetworkManager.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 8/25/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import Foundation

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
    
    
    
    func fetchFeed(completionHandler: (objects: [AnyObject]?, error: NSError?) -> ())
    {
        var relation = PFUser.currentUser()!.relationForKey("following")
        var query = relation.query()
        query!.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            
            if let constError = error
            {
                println("error fetching following")
                completionHandler(objects: nil, error: constError)
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
                        completionHandler(objects: objects, error: nil)
                    }
                    
                })
            }
            
        })
    }
}

